#!/usr/bin/env python2.7
"""MongoDB Nagios check script

This program is part of $PROJECT_NAME$
License: GPL License (see COPYING)

Author David Murphy
Copyright 2014-2015 Percona LLC and/or its affiliates
"""

import sys
import time
import optparse
import os
import stat
import pickle
import traceback
import pprint

from types import FunctionType
# Not yet implemented
# import DeepDiff

try:
    import pymongo
except ImportError, e:
    print e
    sys.exit(2)

# As of pymongo v 1.9 the SON API is part of the BSON package, therefore attempt
# to import from there and fall back to pymongo in cases of older pymongo
if pymongo.version >= "1.9":
    import bson.son as son
else:
    import pymongo.son as son


# Adding special behavior for optparse
class OptionParsingError(RuntimeError):
    def __init__(self, msg):
        self.msg = msg


class ModifiedOptionParser(optparse.OptionParser):
    def error(self, msg):
        raise OptionParsingError(msg)

def unicode_truncate(s, length, encoding='utf-8'):
    encoded = s.encode(encoding)[:length]
    return encoded.decode(encoding, 'ignore')

def parse_options(args):
    funcList = []
    for item_name, item_type in NagiosMongoChecks.__dict__.items():
        if type(item_type) is FunctionType and item_name.startswith("check_") and item_name is not 'check_levels':
            funcList.append(item_name)
    p = ModifiedOptionParser()

    p.add_option('-H', '--host', action='store', type='string', dest='host', default='127.0.0.1', help='The hostname you want to connect to')
    p.add_option('-P', '--port', action='store', type='int', dest='port', default=27017, help='The port mongodb is running on')
    p.add_option('-u', '--user', action='store', type='string', dest='user', default=None, help='The username you want to login as')
    p.add_option('-p', '--password', action='store', type='string', dest='passwd', default=None, help='The password you want to use for that user')
    p.add_option('-W', '--warning', action='store', dest='warning', default=None, help='The warning threshold you want to set')
    p.add_option('-C', '--critical', action='store', dest='critical', default=None, help='The critical threshold you want to set')
    p.add_option('-A', '--action', action='store', type='choice', dest='action', default='check_connect',
                 choices=funcList, help="The action you want to take. Valid choices are (%s) Default: %s" % (", ".join(funcList), 'check_connect'))
    p.add_option('-s', '--ssl', dest='ssl', default=False, help='Connect using SSL')
    p.add_option('-r', '--replicaset', dest='replicaset', default=None, help='Connect to replicaset')
    p.add_option('-c', '--collection', action='store', dest='collection', default='foo', help='Specify the collection in check_cannary_test')
    p.add_option('-d', '--database', action='store', dest='database', default='tmp', help='Specify the database in check_cannary_test')
    p.add_option('-q', '--query', action='store', dest='query', default='{"_id":1}', help='Specify the query     in check_cannary_test')
    p.add_option('--statusfile', action='store', dest='status_filename', default='status.dat', help='File to current store state data in for delta checks')
    p.add_option('--backup-statusfile', action='store', dest='status_filename_backup', default='status_backup.dat',
                 help='File to previous store state data in for delta checks')
    p.add_option('--max-stale', action='store', dest='max_stale', type='int', default=60, help='Age of status file to make new checks (seconds)')
    # Add options for output stat file
    try:
        result = p.parse_args()
    except OptionParsingError, e:
        if 'no such option' in e.msg:
            sys.exit("UNKNOWN - No such options of %s" % e.msg.split(":")[1])
        if 'invalid choice' in e.msg:
            error_item = e.msg.split(":")[2].split("'")[1]
            sys.exit('UNKNOWN - No such action of %s found!' % error_item)
    return result


def return_result(result_type, message):
    if result_type == "ok":
        print "OK - " + message
        sys.exit(0)
    elif result_type == "critical":
        print "CRITICAL - " + message
        sys.exit(2)
    elif result_type == "warning":
        print "WARNING - " + message
        sys.exit(1)
    else:
        print "UNKNOWN - " + message
        sys.exit(2)


def main(argv):
    options, arguments = parse_options(argv)
    check(options, options.action)


def check(args, check_name):
    try:
        checksObj = globals()['NagiosMongoChecks'](args)
        run_check = getattr(checksObj, check_name)
        result_type, message = run_check(args, args.warning, args.critical)
    except Exception, e:
        raise
        print(traceback.extract_tb(sys.exc_info()[-1], 1))
        return_result("critical", str(e))
    return_result(result_type, message)


class NagiosMongoChecks:
    # need to initialize variables and such still
    def __init__(self, args):
        # setup inital values from optParse
        self.host = '127.0.0.1'
        self.port = 27017
        self.user = None
        self.password = None
        self.warning = None
        self.critical = None
        self.action = 'check_connect'
        self.ssl = False
        self.replicaset = None
        self.collection = 'foo'
        self.database = 'tmp'
        self.query = '{"_id":1}'
        self.status_filename = 'status.dat'
        self.status_filename_backup = 'status_backup.dat'
        self.max_stale = 60

        for option in vars(args):
            setattr(self, option, getattr(args, option))

        # Fix filepaths to be relative
        if not self.status_filename.startswith("/") or not self.status_filename.startswith(".."):
            self.status_filename_backup = "%s/%s" % (os.curdir, self.status_filename_backup)
            self.status_filename = "%s/%s" % (os.curdir, self.status_filename)

        # ammend known intenal values we will need
        self.current_status = {}
        self.last_status = {}
        self.connection = None
        self.connection_time = None
        self.pyMongoError = None

        self.connect()

        if self.file_age(self.status_filename) <= self.max_stale:
            # Save status_file contents status as current_status
            self.get_last_status(True)
            # Save status_filename_backup contents as last_status
            self.get_last_status(False, self.status_filename_backup)
        else:
            if self.connection is None:
                raise pymongo.errors.ConnectionFailure(self.pyMongoError or "No connection Found, did connect fail?")
            # Get fresh current_status from server
            self.current_status = self.sanatize(self.get_server_status())
	    # user last status_filename contents as last_status
            self.get_last_status(False, self.status_filename)
        # Not yet implemented
        # self.compute_deltas()

        # get last status
        # check if needs refresh, refresh if needed
        # set last/current to self.current_status
        pass

    def get_last_status(self, returnAsCurrent, forceFile=None):
        # Open file using self.file
        try:
            file_name = forceFile if forceFile is not None else self.status_filename
            fileObject = open(file_name, 'r')
            if returnAsCurrent is None or returnAsCurrent is False:
                self.last_status = pickle.load(fileObject)
            else:
                self.current_status = pickle.load(fileObject)
        except Exception:
                return False
        return True

    def get_server_status(self):
        try:
            data = self.connection['admin'].command(pymongo.son_manipulator.SON([('serverStatus', 1)]))
        except:
            try:
		data = self.connection['admin'].command(son.SON([('serverStatus', 1)]))
	    except Exception, e:
		if type(e).__name__ == "OperationFailure":
		    sys.exit("UNKNOWN - Not authorized!")
		else:
		    sys.exit("UNKNOWN - Unable to run serverStatus: %s::%s" % (type(e).__name__, unicode_truncate(e.message, 45)))

        if self.current_status is None:
            self.current_status = data

        return data

    # figure out how to use this one later
    def rotate_files(self):
        # 1)this needs to rename  self.status_filename to status_filename_backup
        # 2) Save current_status to  self.status_filename ( new file )
        if self.last_status == {}:
            # Build the last status file for future deltas from current data
            self.save_file(self.status_filename_backup, self.current_status)
            # Set the current status file to empty to set the aging clock
            self.save_file(self.status_filename, {})
            sys.exit("UNKNOWN - No status data present, please try again in %s seconds" % self.max_stale)
	else:
	    self.save_file(self.status_filename_backup, self.last_status)
	    self.save_file(self.status_filename, self.current_status)


    def save_file(self, filename, contents):
            try:
                pickle.dump(contents, open(filename, "wb"))
            except Exception, e:
                sys.exit("UNKNOWN - Error saving stat file %s: %s" % (filename, e.message))

    # TODO - Fill in all check defaults
    def get_default(self, key, level):

        defaults = {
            'check_connections':    {'warning': 15000,   'critical': 19000},
            'check_connect':        {'warning': 50,      'critical': 100},
            'check_queues':         {'warning': 30,      'critical': 100},
            'check_lock_pct':       {'warning': 30,      'critical': 50},
            'check_repl_lag':       {'warning': 200,     'critical': 500},
            # 'check_flushing':       {'warning':XX,       'critical': XX},
            'check_total_indexes':  {'warning': 100,     'critical': 300},
            'check_cannary_test':   {'warning': 30,      'critical': 50},
            'check_oplog':          {'warning': 36,      'critical': 24},
            'check_index_ratio':    {'warning': .9,      'critical': .8},
        }
        try:
            return defaults[key][level]
        except KeyError:
            sys.exit("UNKNOWN - Missing defaults found for %s please use -w and -c" % key)

    # Not yet implemented
    # def compute_deltas(self):
    #    deltas = []
    #    for item in DeepDiff(self.last_status, self.current_status)['values_changed']:
    #        name = item.split(":")[0].split("root")[1].replace("['", "").replace("']", ".")[:-1]
    #        if 'time' not in item.lower():
    #            values = item.split(":")[1]
    #            print(values)
    #            old, new = values.split("===>")
    #            print("%s: %s - %s = %s" % (name, new, old, float(new)-float(old)))
    #            deltas[name] = float(new) - float(old)
    #    self.delta_data = deltas
    #    return True

    def file_age(self, filename):
        try:
            age = time.time() - os.stat(filename)[stat.ST_CTIME]
        except OSError:
            age = 999999
        return age

    # TODO - Add meat to this if needed, here for future planning
    def sanatize(self, status_output):
        return status_output

    def connect(self):
        start_time = time.time()
        try:
            # ssl connection for pymongo > 2.3
            if self.replicaset is None:
                con = pymongo.MongoClient(self.host, self.port, ssl=self.ssl, serverSelectionTimeoutMS=2500)
            else:
                con = pymongo.MongoClient(self.host, self.port, ssl=self.ssl, replicaSet=self.replicaset, serverSelectionTimeoutMS=2500)
            if (self.user and self.passwd) and not con['admin'].authenticate(self.user, self.passwd):
                sys.exit("CRITICAL - Username and password incorrect")
        except Exception, e:
            raise
            if isinstance(e, pymongo.errors.AutoReconnect) and str(e).find(" is an arbiter") != -1:
                # We got a pymongo AutoReconnect exception that tells us we connected to an Arbiter Server
                # This means: Arbiter is reachable and can answer requests/votes - this is all we need to know from an arbiter
                print "OK - State: 7 (Arbiter)"
                sys.exit(0)
            con = None
            self.pyMongoError = str(e)
        if con is not None:
	    try:
                con['admin'].command(pymongo.son_manipulator.SON([('ping', 1)]))
            except Exception, e:
                sys.exit("UNKNOWN - Unable to run commands, possible auth issue: %s" % e.message)
            self.connection_time = round(time.time() - start_time, 2)
            version = con.server_info()['version'].split('.')
            self.mongo_version = (version[0], version[1], version[2])
            self.connection = con

    def check_levels(self, check_result, warning_level, critical_level, message):
        if check_result < warning_level:
            return "ok", message
        elif check_result > critical_level:
            return "critical", message
        elif check_result > warning_level and check_result < critical_level:
            return "warning", message
        else:
            return "unknown", "Unable to parse %s into a result" % check_result

    def check_connect(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_connect', 'warning')
        critical_level = critical_level or self.get_default('check_connect', 'critical')
        con_time = self.connection_time
        message = "Connection time %.2f ms" % con_time
        return self.check_levels(float(con_time), float(warning_level), float(critical_level), message)

    def check_connections(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_connections', 'warning')
        critical_level = critical_level or self.get_default('check_connections', 'critical')
        connections = self.current_status['connections']
        connections['total'] = connections['available'] + connections['current']
        used_percent = int((connections['current'] / connections['total']) * 100)
        message = "%i%% connections used ( %d of %d )" % (used_percent, connections['current'], connections['total'])
        return self.check_levels(float(used_percent), int(warning_level), int(critical_level), message)

    def check_lock_pct(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_lock_pct', 'warning')
        critical_level = critical_level or self.get_default('check_lock_pct', 'critical')
        if self.mongo_version >= ('2', '7', '0'):
            return "ok",  "Mongo 3.0 and above do not have lock %"
        lockTime = self.current_status['globalLock']['lockTime'] - self.last_status['globalLock']['lockTime']
        totalTime = self.current_status['globalLock']['totalTime'] - self.last_status['globalLock']['totalTime']
        lock_percent = int((lockTime / totalTime) * 100)
        message = "%i%% locking found (over 100%% is possible)" % (lock_percent)
        return self.check_levels(lock_percent, warning_level, critical_level, message)

    def check_flushing(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_flushing', 'warning')
        critical_level = critical_level or self.get_default('check_flushing', 'critical')
        flushData = self.current_status['backgroundFlushing']
        if args.average:
            flush_time = flushData['average_ms']
            stat_type = "Average"
        else:
            flush_time = flushData['last_ms']
            stat_type = "Last"

        message = "%s Flush Time: %.2fms" % (stat_type, flush_time)
        return self.check_levels(flush_time, warning_level, critical_level, message)

    def check_index_ratio(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_index_ratio', 'warning')
        critical_level = critical_level or self.get_default('check_index_ratio', 'critical')
        message = None

        indexCounters = self.current_status['indexCounters']
        if 'note' in indexCounters:
            ratio = 1.0
            message = "not supported defaulting to 1.0 ratio"
        elif self.mongo_version >= ('2', '4', '0'):
            ratio = indexCounters['missRatio']
        else:
            ratio = indexCounters['btree']['missRatio']
        if message is None:
            message = "Miss Ratio: %.2f" % ratio
        return self.check_levels(ratio, warning_level, critical_level, message)

    def check_have_primary(self, args, warning_level, critical_level):
        replset_status = self.connection['admin'].command("replSetGetStatus")
        for member in replset_status['members']:
            if member['state'] == 1:
                return "ok", "Cluster has primary"
        return "critical", "Cluster has no primary!"

    def check_total_indexes(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_total_indexes', 'warning')
        critical_level = critical_level or self.get_default('check_total_indexes', 'critical')
        index_count = 0
        database_count = 0
        for database in self.connection.database_names():
            if database not in ["admin", "local"]:
                database_count += 1
                self.connection[database]['system.indexes'].count()
                index_count += self.connection[database]['system.indexes'].count()
        message = "Found %d indexes in %d databases" % (index_count, database_count)
        return self.check_levels(index_count, warning_level, critical_level, message)

    def check_queues(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_queues', 'warning')
        critical_level = critical_level or self.get_default('check_queues', 'critical')
	currentQueue = self.current_status['globalLock']['currentQueue']
        currentQueue['total'] = currentQueue['readers'] + currentQueue['writers']
        message = "Queue Sizes:  read (%d)  write(%d) total (%d)" % (currentQueue['readers'], currentQueue['writers'], currentQueue['total'])
        return self.check_levels(currentQueue['total'], warning_level, critical_level, message)

    def check_oplog(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_oplog', 'warning')
        critical_level = critical_level or self.get_default('check_oplog', 'critical')
        if 'local' not in self.connection.database_names() or 'oplog.rs' not in self.connection['local'].collection_names():
            return "critical", "We do not seem to be in a replset!"
        oplog = self.connection['local']['oplog.rs']
        first_ts = oplog.find().sort("$natural", pymongo.ASCENDING).limit(1)[0]['ts']
        last_ts = oplog.find().sort("$natural", pymongo.DESCENDING).limit(1)[0]['ts']
        oplog_range = (last_ts.as_datetime() - first_ts.as_datetime())
        oplog_range_hours = oplog_range.total_seconds() / 60 / 60
        message = "Oplog Time is %d hours" % (oplog_range_hours)
        return self.check_levels(int(oplog_range_hours), warning_level, critical_level, message)

    def check_election(self, args, warning_level, critical_level):
        replset_status = self.connection['admin'].command("replSetGetStatus")
        for member in replset_status['members']:
            if member['stateStr'] == "PRIMARY":
                #last_primary = member.name
                last_primary = member['name']
        for member in replset_status['members']:
            if member['stateStr'] == "PRIMARY":
                current_primary = member['name']
        message = "Old PRI: %s New PRI: %s" % (last_primary, current_primary)
        if current_primary == last_primary:
            return "ok", message
        else:
            return "critical", message

    def is_balanced(self):
        chunks = {}

        # Loop through each of the chunks, tallying things up
        for chunk in self.connection["config"]["chunks"].find():
            namespace = chunk['ns']
            shard = chunk['shard']
            if namespace not in chunks:
                chunks[namespace] = {'shards': {}, 'total': 0}
            if shard not in chunks[namespace]['shards']:
                chunks[namespace]['shards'][shard] = 0
            chunks[namespace]['shards'][shard] += 1
            chunks[namespace]['total'] += 1

        shardsCount = self.connection["config"]["shards"].count()
        chunksCount = self.connection["config"]["chunks"].count()

        # Different migration thresholds depending on cluster size
        # http://docs.mongodb.org/manual/core/sharding-internals/#sharding-migration-thresholds
        if chunksCount < 20:
            threshold = 2
        elif chunksCount < 80 and chunksCount > 21:
            threshold = 4
        else:
            threshold = 8

        # Default to balanced state, any failure will then mark it as False forevermore
        isBalanced = True
        # Loop through each ns and determine if it's balanced or not
        for ns in chunks:
            balanced = chunks[ns]['total'] / shardsCount
            for shard in chunks[ns]['shards']:
                if shard > balanced - threshold and shard < balanced + threshold:
                    pass
                else:
                    isBalanced = False

        return isBalanced

    def check_balance(self, args, warning_level, critical_level):
        if self.is_balanced() is True:
            return "ok", "Shards are balanced by chunk counts"
        else:
            return "critcal", "Shards are not balanced by chunk and need review"

    def check_cannary_test(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_cannary_test', 'warning')
        critical_level = critical_level or self.get_default('check_cannary_test', 'critical')
        # this does not check for a timeout, we assume NRPE or Nagios will alert on that timeout.
        try:
            start = time.time()
            self.connection[self.database][self.collection].find_one(self.query)
            time_range = (time.time() - start).total_seconds
            message = "Collection %s.%s  query took: %d s" % (self.database, self.collection, time_range)
            return self.check_levels(time_range, warning_level, critical_level, message)
        except Exception, e:
            message = "Collection %s.%s  query FAILED: %s" % (self.database, self.collection, e)
            return "critical", message

    def check_repl_lag(self, args, warning_level, critical_level):
        warning_level = warning_level or self.get_default('check_repl_lag', 'warning')
        critical_level = critical_level or self.get_default('check_repl_lag', 'critical')

        # make a write incase the client is not writing, but us an update to avoid wasting space
        self.connection['test']['lag_check'].update({"_id":1}, {"_id": 1, "x": 1})
        # get a  fresh status for the replset
        try:
            replset_status = self.connection['admin'].command("replSetGetStatus")
        except Exception, e:
            return "critical", "Are your running with --replset? -  %s" % (e)

        for member in replset_status['members']:
            if member['stateStr'] == "PRIMARY":
                primary = member
            if 'self' in member and member['self'] is True:
                hostOptimeDate = member['optimeDate']

        if primary is not None:
            highest_optimeDate = primary['optimeDate']
            highest_name = primary['name']
        else:
            # find the most current secondary as there is not primary
            highest_optimeDate = time.gmtime(0)
            for member in replset_status['members']:
                if member['optimeDate'] > highest_optimeDate:
                    highest_optimeDate = member['optimeDate']
                    highest_name = member['name']

        rep_lag_seconds = (highest_optimeDate - hostOptimeDate).seconds
        rep_lag_hours = round(rep_lag_seconds/60/60, 4)
        message = "Lagging %s by %.4f hours" % (highest_name, rep_lag_hours)
        return self.check_levels(rep_lag_hours, warning_level, critical_level, message)

#
# main app
#
if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

# ############################################################################
# Documentation
# ############################################################################
"""
=pod

=head1 NAME

pmp-check-mongo.py - MongoDB Nagios check script.

=head1 SYNOPSIS

  Usage: pmp-check-mongo.py [options]

  Options:
    -h, --help            show this help message and exit
    -H HOST, --host=HOST  The hostname you want to connect to
    -P PORT, --port=PORT  The port mongodb is running on
    -u USER, --user=USER  The username you want to login as
    -p PASSWD, --password=PASSWD
                          The password you want to use for that user
    -W WARNING, --warning=WARNING
                          The warning threshold you want to set
    -C CRITICAL, --critical=CRITICAL
                          The critical threshold you want to set
    -A ACTION, --action=ACTION
                          The action you want to take. Valid choices are
                          (check_connections, check_election, check_lock_pct,
                          check_repl_lag, check_flushing, check_total_indexes,
                          check_balance, check_queues, check_cannary_test,
                          check_have_primary, check_oplog, check_index_ratio,
                          check_connect) Default: check_connect
    -s SSL, --ssl=SSL     Connect using SSL
    -r REPLICASET, --replicaset=REPLICASET
                          Connect to replicaset
    -c COLLECTION, --collection=COLLECTION
                          Specify the collection in check_cannary_test
    -d DATABASE, --database=DATABASE
                          Specify the database in check_cannary_test
    -q QUERY, --query=QUERY
                          Specify the query     in check_cannary_test
    --statusfile=STATUS_FILENAME
                          File to current store state data in for delta checks
    --backup-statusfile=STATUS_FILENAME_BACKUP
                          File to previous store state data in for delta checks
    --max-stale=MAX_STALE
                          Age of status file to make new checks (seconds)

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

$PROJECT_NAME$ pmp-check-mongo.py $VERSION$

=cut

"""
