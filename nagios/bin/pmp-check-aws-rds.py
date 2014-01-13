#!/usr/bin/env python
"""
Nagios plugin for Amazon RDS monitoring.

This program is part of $PROJECT_NAME$
License: GPL License (see COPYING)

Author Roman Vynar
Copyright 2014 Percona LLC and/or its affiliates
"""

import boto
import datetime
import optparse
import pprint
import sys

def get_rds_info(indentifier=None):
    """Function for fetching RDS details"""
    rds = boto.connect_rds()
    try:
        if indentifier:
            info = rds.get_all_dbinstances(indentifier)[0]
        else:
            info = rds.get_all_dbinstances()
    except boto.exception.BotoServerError:
        info = None
    return info

def get_rds_stats(step, start_time, end_time, metric, indentifier):
    """Function for fetching RDS statistics from CloudWatch"""
    cw = boto.connect_cloudwatch()
    result = cw.get_metric_statistics(step,
        start_time,
        end_time,
        metric,
        'AWS/RDS',
        'Average',
        dimensions={'DBInstanceIdentifier': [indentifier]})
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
    short_status = {OK: 'OK',
                    WARNING: 'WARN',
                    CRITICAL: 'CRIT',
                    UNKNOWN: 'UNK'}

    # DB instance classes as listed on http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
    db_classes = {'db.t1.micro': 0.61,
                  'db.m1.small': 1.7,
                  'db.m1.medium': 3.75,
                  'db.m1.large': 7.5,
                  'db.m1.xlarge': 15,
                  'db.m2.xlarge': 17.1,
                  'db.m2.2xlarge': 34,
                  'db.m2.4xlarge': 68,
                  'db.cr1.8xlarge': 244}

    # RDS metrics as listed on http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/rds-metricscollected.html
    metrics = {'status': 'RDS availability',
               'load': 'CPUUtilization',
               'memory': 'FreeableMemory',
               'storage': 'FreeStorageSpace'}

    units = ('percent', 'GB')

    # Parse options
    parser = optparse.OptionParser()
    parser.add_option('-l', '--list', help='list of all DB instances',
                      action='store_true', default=False, dest='db_list')
    parser.add_option('-i', '--ident', help='DB instance identifier')
    parser.add_option('-p', '--print', help='print status and other details for a given DB instance',
                      action='store_true', default=False, dest='info')
    parser.add_option('-m', '--metric', help='metric to check: [%s]' % ', '.join(metrics.keys()))
    parser.add_option('-w', '--warn', help='warning threshold')
    parser.add_option('-c', '--crit', help='critical threshold')
    parser.add_option('-u', '--unit', help='unit of thresholds for "storage" and "memory" metrics: [%s]. Default: percent' % ', '.join(units),
                      default='percent')
    options, args = parser.parse_args()

    # Check args
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit()
    elif options.db_list:
        info = get_rds_info()
        print 'List of all DB instances:'
        pprint.pprint(info)
        sys.exit()
    elif not options.ident:
        parser.print_help()
        parser.error('DB identifier is not set.')
    elif options.info:
        info = get_rds_info(options.ident)
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

    tm = datetime.datetime.utcnow()
    status = None
    note = ''
    perf_data = None

    # RDS Status
    if options.metric == 'status':
        info = get_rds_info(options.ident)
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
            load = get_rds_stats(i * 60, tm - datetime.timedelta(seconds=n * 60), tm,
                                 metrics[options.metric], options.ident)
            if not load:
                status = UNKNOWN
                note = 'Unable to get RDS statistics'
                perf_data = None
                break
            loads.append(str(load))
            perf_data.append('load%s=%s;%s;%s;0;' % (i, load, warns[j], crits[j]))

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

        info = get_rds_info(options.ident)
        free = get_rds_stats(60, tm - datetime.timedelta(seconds=60), tm,
                             metrics[options.metric], options.ident)
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
    -i IDENT, --ident=IDENT
                          DB instance identifier
    -p, --print           print status and other details for a given DB instance
    -m METRIC, --metric=METRIC
                          metric to check: [status, load, storage, memory]
    -w WARN, --warn=WARN  warning threshold
    -c CRIT, --crit=CRIT  critical threshold
    -u UNIT, --unit=UNIT  unit of thresholds for "storage" and "memory" metrics:
                          [percent, GB]. Default: percent

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
  [root@centos6 ~]# chown nagios /etc/boto.cfg
  [root@centos6 ~]# chmod 600 /etc/boto.cfg

=head1 DESCRIPTION

The plugin provides 4 checks and some options to list and print RDS details:

* RDS Status
* RDS Load Average
* RDS Free Storage
* RDS Free Memory

To get the list of all RDS instances under AWS account:

  # ./aws-rds-nagios-check.py -l

To get the detailed status of RDS instance identified as C<blackbox>: 

  # ./aws-rds-nagios-check.py -i blackbox -p

Nagios check for the overall status. Useful if you want to set the rest
of the checks dependent from this one:

  # ./aws-rds-nagios-check.py -i blackbox -m status
  OK mysql 5.1.63. Status: available

Nagios check for CPU utilization, specify thresholds as percentage of
1-min., 5-min., 15-min. average accordingly: 

  # ./aws-rds-nagios-check.py -i blackbox -m load -w 90,85,80 -c 98,95,90
  OK Load average: 28.27%, 34.65%, 30.53% | load1=28.27;90.0;98.0;0; load5=34.65;85.0;95.0;0; load15=30.53;80.0;90.0;0;

Nagios check for the free memory, specify thresholds as percentage:

  # ./aws-rds-nagios-check.py -i blackbox -m memory -w 10 -c 5
  WARN Free memory: 6.51 GB (10%) of 68 GB | free_memory=9.57;10.0;5.0;0;100

Nagios check for the free storage space, specify thresholds as percentage: 

  # ./aws-rds-nagios-check.py -i blackbox -m storage -w 10 -c 5
  OK Free storage: 161.69 GB (32%) of 500.0 GB | free_storage=32.34;10.0;5.0;0;100

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
