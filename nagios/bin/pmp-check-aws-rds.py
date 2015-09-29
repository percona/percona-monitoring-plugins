#!/usr/bin/env python
"""Nagios plugin for Amazon RDS monitoring.

This program is part of $PROJECT_NAME$
License: GPL License (see COPYING)

Author Roman Vynar
Copyright 2014-2015 Percona LLC and/or its affiliates
"""

import boto
import boto.rds
import boto.ec2.cloudwatch
import datetime
import optparse
import pprint
import sys


def get_rds_info(region, identifier=None):
    """Function for fetching RDS details"""
    
    if region.lower() == 'all':
        regions_list = [ region.name for region in boto.rds.regions() ]
    else:
        regions_list = [ region ]
    
    info = []
    
    for region in regions_list:
        rds = boto.rds.connect_to_region(region)
        try:
            # rds.get_all_dbinstances(None) is the same as rds.get_all_dbinstances()
            info.extend(rds.get_all_dbinstances(identifier))
        except (boto.exception.BotoServerError, AttributeError):
            pass
    
    if identifier: return info[0] if len(info) > 0 else None
    
    return info


def get_rds_stats(region, identifier, metric, start_time, end_time, step):
    """Function for fetching RDS statistics from CloudWatch"""
    cw = boto.ec2.cloudwatch.connect_to_region(region)
    result = cw.get_metric_statistics(
        step,
        start_time,
        end_time,
        metric,
        'AWS/RDS',
        'Average',
        dimensions={'DBInstanceIdentifier': [identifier]}
    )
    if result:
        if len(result) > 1:
            # Get the last point
            result = sorted(result, key=lambda k: k['Timestamp'])
            result.reverse()
        result = float('%.2f' % result[0]['Average'])
    return result


def main():
    """Main function"""

    # Nagios status codes
    OK = 0
    WARNING = 1
    CRITICAL = 2
    UNKNOWN = 3
    short_status = {
        OK: 'OK',
        WARNING: 'WARN',
        CRITICAL: 'CRIT',
        UNKNOWN: 'UNK'
    }

    # DB instance classes as listed on
    # http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
    db_classes = {
        'db.t1.micro': 0.615,
        'db.m1.small': 1.7,
        'db.m3.medium': 3.75,
        'db.m3.large': 7.5,
        'db.m3.xlarge': 15,
        'db.m3.2xlarge': 30,
        'db.r3.large': 15,
        'db.r3.xlarge': 30.5,
        'db.r3.2xlarge': 61,
        'db.r3.4xlarge': 122,
        'db.r3.8xlarge': 244,
        'db.t2.micro': 1,
        'db.t2.small': 2,
        'db.t2.medium': 4,
        'db.m2.xlarge': 17.1,
        'db.m2.2xlarge': 34.2,
        'db.m2.4xlarge': 68.4,
        'db.cr1.8xlarge': 244,
        'db.m1.medium': 3.75,
        'db.m1.large': 7.5,
        'db.m1.xlarge': 15
    }

    # RDS metrics as listed on
    # http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/rds-metricscollected.html
    metrics = {
        'status': 'RDS availability',
        'load': 'CPUUtilization',
        'memory': 'FreeableMemory',
        'storage': 'FreeStorageSpace'
    }

    units = ('percent', 'GB')

    # Parse options
    parser = optparse.OptionParser()
    parser.add_option('-l', '--list', help='list of all DB instances',
                      action='store_true', default=False, dest='db_list')
    parser.add_option('-r', '--region', help='AWS region. Default: us-east-1',
                      default='us-east-1')
    parser.add_option('-i', '--ident', help='DB instance identifier')
    parser.add_option('-p', '--print', help='print status and other details for a given DB instance',
                      action='store_true', default=False, dest='info')
    parser.add_option('-m', '--metric', help='metric to check: [%s]' % ', '.join(metrics.keys()))
    parser.add_option('-w', '--warn', help='warning threshold')
    parser.add_option('-c', '--crit', help='critical threshold')
    parser.add_option('-u', '--unit', help='unit of thresholds for "storage" and "memory" metrics: [%s]. '
                      'Default: percent' % ', '.join(units), default='percent')
    parser.add_option('-t', '--time', help='time period in minutes to query. Default: 5',
                      type='int', default=5)
    parser.add_option('-a', '--avg', help='time average in minutes to request. Default: 1',
                      type='int', default=1)
    parser.add_option('-d', '--debug', help='enable debug output',
                      action='store_true', default=False)
    options, args = parser.parse_args()

    if options.debug:
        boto.set_stream_logger('boto')

    # Check args
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit()
    elif options.db_list:
        info = get_rds_info(options.region)
        print 'List of all DB instances:'
        pprint.pprint(info)
        sys.exit()
    elif not options.ident:
        parser.print_help()
        parser.error('DB identifier is not set.')
    elif options.info:
        info = get_rds_info(options.region, options.ident)
        if info:
            pprint.pprint(vars(info))
        else:
            print 'No DB instance "%s" found on your AWS account.' % options.ident
        sys.exit()
    elif not options.metric or options.metric not in metrics.keys():
        parser.print_help()
        parser.error('Metric is not set or not valid.')
    elif not options.warn and options.metric != 'status':
        parser.print_help()
        parser.error('Warning threshold is not set.')
    elif not options.crit and options.metric != 'status':
        parser.print_help()
        parser.error('Critical threshold is not set.')
    elif options.avg <= 0 and options.metric != 'status':
        parser.print_help()
        parser.error('Average must be greater than zero.')
    elif options.time <= 0 and options.metric != 'status':
        parser.print_help()
        parser.error('Time must be greater than zero.')

    now = datetime.datetime.utcnow()
    status = None
    note = ''
    perf_data = None

    # RDS Status
    if options.metric == 'status':
        info = get_rds_info(options.region, options.ident)
        if not info:
            status = UNKNOWN
            note = 'Unable to get RDS instance'
        else:
            status = OK
            try:
                version = info.EngineVersion
            except:
                version = info.engine_version
            note = '%s %s. Status: %s' % (info.engine, version, info.status)

    # RDS Load Average
    elif options.metric == 'load':
        # Check thresholds
        try:
            warns = [float(x) for x in options.warn.split(',')]
            crits = [float(x) for x in options.crit.split(',')]
            fail = len(warns) + len(crits)
        except:
            fail = 0
        if fail != 6:
            parser.error('Warning and critical thresholds should be 3 comma separated numbers, e.g. 20,15,10')

        loads = []
        fail = False
        j = 0
        perf_data = []
        for i in [1, 5, 15]:
            if i == 1:
                # Some stats are delaying to update on CloudWatch.
                # Let's pick a few points for 1-min load avg and get the last point.
                n = 5
            else:
                n = i
            load = get_rds_stats(options.region, options.ident, metrics[options.metric],
                                 now - datetime.timedelta(seconds=n * 60), now, i * 60)
            if not load:
                status = UNKNOWN
                note = 'Unable to get RDS statistics'
                perf_data = None
                break
            loads.append(str(load))
            perf_data.append('load%s=%s;%s;%s;0;100' % (i, load, warns[j], crits[j]))

            # Compare thresholds
            if not fail:
                if warns[j] > crits[j]:
                    parser.error('Parameter inconsistency: warning threshold is greater than critical.')
                elif load >= crits[j]:
                    status = CRITICAL
                    fail = True
                elif load >= warns[j]:
                    status = WARNING
            j = j + 1

        if status != UNKNOWN:
            if status is None:
                status = OK
            note = 'Load average: %s%%' % '%, '.join(loads)
            perf_data = ' '.join(perf_data)

    # RDS Free Storage
    # RDS Free Memory
    elif options.metric in ['storage', 'memory']:
        # Check thresholds
        try:
            warn = float(options.warn)
            crit = float(options.crit)
        except:
            parser.error('Warning and critical thresholds should be integers.')
        if crit > warn:
            parser.error('Parameter inconsistency: critical threshold is greater than warning.')
        if options.unit not in units:
            parser.print_help()
            parser.error('Unit is not valid.')

        info = get_rds_info(options.region, options.ident)
        free = get_rds_stats(options.region, options.ident, metrics[options.metric],
                             now - datetime.timedelta(seconds=options.time * 60), now, options.avg * 60)
        if not info or not free:
            status = UNKNOWN
            note = 'Unable to get RDS details and statistics'
        else:
            if options.metric == 'storage':
                storage = float(info.allocated_storage)
            elif options.metric == 'memory':
                try:
                    storage = db_classes[info.instance_class]
                except:
                    print 'Unknown DB instance class "%s"' % info.instance_class
                    sys.exit(CRITICAL)
            free = '%.2f' % (free / 1024 ** 3)
            free_pct = '%.2f' % (float(free) / storage * 100)
            if options.unit == 'percent':
                val = float(free_pct)
                val_max = 100
            elif options.unit == 'GB':
                val = float(free)
                val_max = storage

            # Compare thresholds
            if val <= crit:
                status = CRITICAL
            elif val <= warn:
                status = WARNING

            if status is None:
                status = OK
            note = 'Free %s: %s GB (%.0f%%) of %s GB' % (options.metric, free, float(free_pct), storage)
            perf_data = 'free_%s=%s;%s;%s;0;%s' % (options.metric, val, warn, crit, val_max)

    # Final output
    if status != UNKNOWN and perf_data:
        print '%s %s | %s' % (short_status[status], note, perf_data)
    else:
        print '%s %s' % (short_status[status], note)
    sys.exit(status)


if __name__ == '__main__':
    main()

# ############################################################################
# Documentation
# ############################################################################
"""
=pod

=head1 NAME

pmp-check-aws-rds.py - Check Amazon RDS metrics.

=head1 SYNOPSIS

  Usage: pmp-check-aws-rds.py [options]

  Options:
    -h, --help            show this help message and exit
    -l, --list            list of all DB instances
    -r REGION, --region=REGION
                          AWS region. Can use 'all' to search in all regions. 
                          Default: us-east-1
    -i IDENT, --ident=IDENT
                          DB instance identifier
    -p, --print           print status and other details for a given DB instance
    -m METRIC, --metric=METRIC
                          metric to check: [status, load, storage, memory]
    -w WARN, --warn=WARN  warning threshold
    -c CRIT, --crit=CRIT  critical threshold
    -u UNIT, --unit=UNIT  unit of thresholds for "storage" and "memory" metrics:
                          [percent, GB]. Default: percent
    -t TIME, --time=TIME  time period (prior to now) to query, in minutes.
                          Default: 5
    -a AVG, --avg=AVG     period to request an average over, in minutes.
                          Default: 1
    -d DEBUG, --debug=DEBUG
                          enable debugging level

=head1 REQUIREMENTS

This plugin is written on Python and utilizes the module C<boto> (Python interface
to Amazon Web Services) to get various RDS metrics from CloudWatch and compare
them against the thresholds.

* Install the package: C<yum install python-boto> or C<apt-get install python-boto>
* Create a config /etc/boto.cfg or ~nagios/.boto with your AWS API credentials.
  See http://code.google.com/p/boto/wiki/BotoConfig

This plugin that is supposed to be run by Nagios, i.e. under ``nagios`` user,
should have permissions to read the config /etc/boto.cfg or ~nagios/.boto.

Example:

  [root@centos6 ~]# cat /etc/boto.cfg
  [Credentials]
  aws_access_key_id = THISISATESTKEY
  aws_secret_access_key = thisisatestawssecretaccesskey

If you do not use this config with other tools such as our Cacti script,
you can secure this file the following way:

  [root@centos6 ~]# chown nagios /etc/boto.cfg
  [root@centos6 ~]# chmod 600 /etc/boto.cfg

=head1 DESCRIPTION

The plugin provides 4 checks and some options to list and print RDS details:

* RDS Status
* RDS Load Average
* RDS Free Storage
* RDS Free Memory

To get the list of all RDS instances under AWS account:

  # ./pmp-check-aws-rds.py -l

To get the detailed status of RDS instance identified as C<blackbox>:

  # ./pmp-check-aws-rds.py -i blackbox -p

Nagios check for the overall status. Useful if you want to set the rest
of the checks dependent from this one:

  # ./pmp-check-aws-rds.py -i blackbox -m status
  OK mysql 5.1.63. Status: available

Nagios check for CPU utilization, specify thresholds as percentage of
1-min., 5-min., 15-min. average accordingly:

  # ./pmp-check-aws-rds.py -i blackbox -m load -w 90,85,80 -c 98,95,90
  OK Load average: 18.36%, 18.51%, 15.95% | load1=18.36;90.0;98.0;0;100 load5=18.51;85.0;95.0;0;100 load15=15.95;80.0;90.0;0;100

Nagios check for the free memory, specify thresholds as percentage:

  # ./pmp-check-aws-rds.py -i blackbox -m memory -w 5 -c 2
  OK Free memory: 5.90 GB (9%) of 68 GB | free_memory=8.68;5.0;2.0;0;100
  # ./pmp-check-aws-rds.py -i blackbox -m memory -u GB -w 4 -c 2
  OK Free memory: 5.90 GB (9%) of 68 GB | free_memory=5.9;4.0;2.0;0;68

Nagios check for the free storage space, specify thresholds as percentage or GB:

  # ./pmp-check-aws-rds.py -i blackbox -m storage -w 10 -c 5
  OK Free storage: 162.55 GB (33%) of 500.0 GB | free_storage=32.51;10.0;5.0;0;100
  # ./pmp-check-aws-rds.py -i blackbox -m storage -u GB -w 10 -c 5
  OK Free storage: 162.55 GB (33%) of 500.0 GB | free_storage=162.55;10.0;5.0;0;500.0

=head1 CONFIGURATION

Here is the excerpt of potential Nagios config:

  define host{
        use                             mysql-host
        host_name                       blackbox
        alias                           blackbox
        address                         blackbox.abcdefgh.us-east-1.rds.amazonaws.com
        }

  define servicedependency{
        host_name                       blackbox
        service_description             RDS Status
        dependent_service_description   RDS Load Average, RDS Free Storage, RDS Free Memory
        execution_failure_criteria      w,c,u,p
        notification_failure_criteria   w,c,u,p
        }

  define service{
        use                             active-service
        host_name                       blackbox
        service_description             RDS Status
        check_command                   check_rds!status!0!0
        }

  define service{
        use                             active-service
        host_name                       blackbox
        service_description             RDS Load Average
        check_command                   check_rds!load!90,85,80!98,95,90
        }

  define service{
        use                             active-service
        host_name                       blackbox
        service_description             RDS Free Storage
        check_command                   check_rds!storage!10!5
        }

  define service{
        use                             active-service
        host_name                       blackbox
        service_description             RDS Free Memory
        check_command                   check_rds!memory!5!2
        }

  define command{
        command_name    check_rds
        command_line    $USER1$/pmp-check-aws-rds.py -i $HOSTALIAS$ -m $ARG1$ -w $ARG2$ -c $ARG3$
        }

=head1 COPYRIGHT, LICENSE, AND WARRANTY

This program is copyright 2014 Percona LLC and/or its affiliates.
Feedback and improvements are welcome.

THIS PROGRAM IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 2.  You should have received a copy of the GNU General
Public License along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.

=head1 VERSION

$PROJECT_NAME$ pmp-check-aws-rds.py $VERSION$

=cut

"""
