#!/usr/bin/env python
"""Cacti script for polling Amazon RDS stats.

This program is part of $PROJECT_NAME$
License: GPL License (see COPYING)

Author Roman Vynar
Copyright 2014-2015 Percona LLC and/or its affiliates

$version = '$VERSION$';
"""

import datetime
import optparse
import pprint
import sys

import boto
import boto.rds
import boto.ec2.cloudwatch


class RDS(object):

    """RDS connection class"""

    def __init__(self, region, profile=None, identifier=None):
        """Get RDS instance details"""
        self.region = region
        self.profile = profile
        self.identifier = identifier

        if self.region == 'all':
            self.regions_list = [reg.name for reg in boto.rds.regions()]
        else:
            self.regions_list = [self.region]

        self.info = None
        if self.identifier:
            for reg in self.regions_list:
                try:
                    rds = boto.rds.connect_to_region(reg, profile_name=self.profile)
                    self.info = rds.get_all_dbinstances(self.identifier)
                except (boto.provider.ProfileNotFoundError, boto.exception.BotoServerError) as msg:
                    debug(msg)
                else:
                    # Exit on the first region and identifier match
                    self.region = reg
                    break

    def get_info(self):
        """Get RDS instance info"""
        if not self.info:
            print 'No DB instance "%s" found on your AWS account or %s region(s).' % (options.ident, options.region)
            sys.exit(1)

        return self.info[0]

    def get_list(self):
        """Get list of available instances by region(s)"""
        result = dict()
        for reg in self.regions_list:
            try:
                rds = boto.rds.connect_to_region(reg, profile_name=self.profile)
                result[reg] = rds.get_all_dbinstances()
            except (boto.provider.ProfileNotFoundError, boto.exception.BotoServerError) as msg:
                debug(msg)

        return result

    def get_metric(self, metric):
        """Get RDS metric from CloudWatch"""
        cw_conn = boto.ec2.cloudwatch.connect_to_region(self.region, profile_name=self.profile)
        result = cw_conn.get_metric_statistics(
            300,
            datetime.datetime.utcnow() - datetime.timedelta(seconds=300),
            datetime.datetime.utcnow(),
            metric,
            'AWS/RDS',
            'Average',
            dimensions={'DBInstanceIdentifier': [self.identifier]}
        )
        debug('Result: %s' % result)
        if result:
            if metric in ('ReadLatency', 'WriteLatency'):
                # Transform into miliseconds
                result = '%.2f' % float(result[0]['Average'] * 1000)
            else:
                result = '%.2f' % float(result[0]['Average'])

        elif metric == 'ReplicaLag':
            # This metric can be missed
            result = 0
        else:
            print 'Unable to get RDS statistics'
            sys.exit(1)

        return float(result)


def debug(val):
    """Debugging output"""
    global options
    if options.debug:
        print 'DEBUG: %s' % val


def main():
    """Main function"""
    global options

    # DB instance classes as listed on
    # http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
    db_classes = {
        'db.t1.micro': 0.615,
        'db.m1.small': 1.7,
        'db.m1.medium': 3.75,
        'db.m1.large': 7.5,
        'db.m1.xlarge': 15,
        'db.m4.large': 8,
        'db.m4.xlarge': 16,
        'db.m4.2xlarge': 32,
        'db.m4.4xlarge': 64,
        'db.m4.10xlarge': 160,
        'db.r3.large': 15,
        'db.r3.xlarge': 30.5,
        'db.r3.2xlarge': 61,
        'db.r3.4xlarge': 122,
        'db.r3.8xlarge': 244,
        'db.t2.micro': 1,
        'db.t2.small': 2,
        'db.t2.medium': 4,
        'db.t2.large': 8,
        'db.m3.medium': 3.75,
        'db.m3.large': 7.5,
        'db.m3.xlarge': 15,
        'db.m3.2xlarge': 30,
        'db.m2.xlarge': 17.1,
        'db.m2.2xlarge': 34.2,
        'db.m2.4xlarge': 68.4,
        'db.cr1.8xlarge': 244,
    }

    # RDS metrics http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/rds-metricscollected.html
    metrics = {
        'BinLogDiskUsage': 'binlog_disk_usage',  # The amount of disk space occupied by binary logs on the master.  Units: Bytes
        'CPUUtilization': 'utilization',  # The percentage of CPU utilization.  Units: Percent
        'DatabaseConnections': 'connections',  # The number of database connections in use.  Units: Count
        'DiskQueueDepth': 'disk_queue_depth',  # The number of outstanding IOs (read/write requests) waiting to access the disk.  Units: Count
        'ReplicaLag': 'replica_lag',  # The amount of time a Read Replica DB Instance lags behind the source DB Instance.  Units: Seconds
        'SwapUsage': 'swap_usage',  # The amount of swap space used on the DB Instance.  Units: Bytes
        'FreeableMemory': 'used_memory',  # The amount of available random access memory.  Units: Bytes
        'FreeStorageSpace': 'used_space',  # The amount of available storage space.  Units: Bytes
        'ReadIOPS': 'read_iops',  # The average number of disk I/O operations per second.  Units: Count/Second
        'WriteIOPS': 'write_iops',  # The average number of disk I/O operations per second.  Units: Count/Second
        'ReadLatency': 'read_latency',  # The average amount of time taken per disk I/O operation.  Units: Seconds
        'WriteLatency': 'write_latency',  # The average amount of time taken per disk I/O operation.  Units: Seconds
        'ReadThroughput': 'read_throughput',  # The average number of bytes read from disk per second.  Units: Bytes/Second
        'WriteThroughput': 'write_throughput',  # The average number of bytes written to disk per second.  Units: Bytes/Second
    }

    # Parse options
    parser = optparse.OptionParser()
    parser.add_option('-l', '--list', help='list DB instances',
                      action='store_true', default=False, dest='db_list')
    parser.add_option('-n', '--profile', default=None,
                      help='AWS profile from ~/.boto or /etc/boto.cfg. Default: None, fallbacks to "[Credentials]".')
    parser.add_option('-r', '--region', default='us-east-1',
                      help='AWS region. Default: us-east-1. If set to "all", we try to detect the instance region '
                           'across all of them, note this will be slower than if you specify the region explicitly.')
    parser.add_option('-i', '--ident', help='DB instance identifier')
    parser.add_option('-p', '--print', help='print status and other details for a given DB instance',
                      action='store_true', default=False, dest='printinfo')
    parser.add_option('-m', '--metric', help='metrics to retrive separated by comma: [%s]' % ', '.join(metrics.keys()))
    parser.add_option('-d', '--debug', help='enable debugging',
                      action='store_true', default=False)
    options, _ = parser.parse_args()

    # Strip a prefix _ which is sent by Cacti, so an empty argument is interpreted correctly.
    # Than set defaults if argument is supposed to be empty.
    options.region = options.region.lstrip('_')
    options.profile = options.profile.lstrip('_')
    if not options.region:
        options.region = 'us-east-1'

    if not options.profile:
        options.profile = None

    if options.debug:
        boto.set_stream_logger('boto')

    rds = RDS(region=options.region, profile=options.profile, identifier=options.ident)

    # Check args
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit()
    elif options.db_list:
        info = rds.get_list()
        print 'List of all DB instances in %s region(s):' % (options.region,)
        pprint.pprint(info)
        sys.exit()
    elif not options.ident:
        parser.print_help()
        parser.error('DB identifier is not set.')
    elif options.printinfo:
        info = rds.get_info()
        pprint.pprint(vars(info))
        sys.exit()
    elif not options.metric:
        parser.print_help()
        parser.error('Metric is not set.')

    selected_metrics = options.metric.split(',')
    for metric in selected_metrics:
        if metric not in metrics.keys():
            parser.print_help()
            parser.error('Invalid metric.')

    # Do not remove the empty lines in the start and end of this docstring
    perl_magic_vars = """

    # Define the variables to output.  I use shortened variable names so maybe
    # it'll all fit in 1024 bytes for Cactid and Spine's benefit.  Strings must
    # have some non-hex characters (non a-f0-9) to avoid a Cacti bug.  This list
    # must come right after the word MAGIC_VARS_DEFINITIONS.  The Perl script
    # parses it and uses it as a Perl variable.
    $keys = array(
       'binlog_disk_usage'       =>  'gg',
       'utilization'             =>  'gh',
       'connections'             =>  'gi',
       'disk_queue_depth'        =>  'gj',
       'replica_lag'             =>  'gk',
       'swap_usage'              =>  'gl',
       'used_memory'             =>  'gm',
       'total_memory'            =>  'gn',
       'used_space'              =>  'go',
       'total_space'             =>  'gp',
       'read_iops'               =>  'gq',
       'write_iops'              =>  'gr',
       'read_latency'            =>  'gs',
       'write_latency'           =>  'gt',
       'read_throughput'         =>  'gu',
       'write_throughput'        =>  'gv',
    );

    """
    output = dict()
    for row in perl_magic_vars.split('\n'):
        if row.find('=>') >= 0:
            k = row.split(' => ')[0].strip().replace("'", '')
            v = row.split(' => ')[1].strip().replace("'", '').replace(',', '')
            output[k] = v

    debug('Perl magic vars: %s' % output)
    debug('Metric associations: %s' % dict((k, output[v]) for (k, v) in metrics.iteritems()))

    # Handle metrics
    results = []
    for metric in selected_metrics:
        stats = rds.get_metric(metric)
        if metric == 'FreeableMemory':
            info = rds.get_info()
            try:
                memory = db_classes[info.instance_class] * 1024 ** 3
            except IndexError:
                print 'Unknown DB instance class "%s"' % info.instance_class
                sys.exit(1)

            results.append('%s:%.0f' % (output['used_memory'], memory - stats))
            results.append('%s:%.0f' % (output['total_memory'], memory))
        elif metric == 'FreeStorageSpace':
            info = rds.get_info()
            storage = float(info.allocated_storage) * 1024 ** 3
            results.append('%s:%.0f' % (output['used_space'], storage - stats))
            results.append('%s:%.0f' % (output['total_space'], storage))
        else:
            short_var = output.get(metrics[metric])
            if not short_var:
                print 'Chosen metric does not have a correspondent entry in perl magic vars'
                sys.exit(1)

            results.append('%s:%s' % (short_var, stats))

    print ' '.join(results)


if __name__ == '__main__':
    main()
