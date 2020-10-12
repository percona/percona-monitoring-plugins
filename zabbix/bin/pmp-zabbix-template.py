#!/usr/bin/python
"""
This script creates Zabbix template and agent config from the existing
Perl definitions for Cacti and triggers if defined.

License: GPL License (see COPYING)
Copyright: 2013 Percona
Authors: Roman Vynar
"""
import dict2xml
import getopt
import re
import sys
import time
import yaml

VERSION = float("%d.%d" % (sys.version_info[0], sys.version_info[1]))
if VERSION < 2.6:
    sys.stderr.write("ERROR: python 2.6+ required. Your version %s is too ancient.\n" % VERSION)
    sys.exit(1)

# Constants
ZABBIX_VERSION = '2.0'
ZABBIX_SCRIPT_PATH = '/var/lib/zabbix/percona/scripts'
DEFINITION = 'cacti/definitions/mysql.def'
PHP_SCRIPT = 'cacti/scripts/ss_get_mysql_stats.php'
TRIGGERS = 'zabbix/triggers/mysql.yml'

item_types = {'Zabbix agent': 0,
              'Zabbix agent (active)': 7,
              'Simple check': 3,
              'SNMPv1': 1,
              'SNMPv2': 4,
              'SNMPv3': 6,
              'SNMP Trap': 17,
              'Zabbix Internal': 5,
              'Zabbix Trapper': 2,
              'Zabbix Aggregate': 8,
              'External check ': 10,
              'Database monitor': 11,
              'IPMI agent': 12,
              'SSH agent': 13,
              'TELNET agent': 14,
              'JMX agent': 16,
              'Calculated': 15}

item_value_types = {'Numeric (unsigned)': 3,
                    'Numeric (float)': 0,
                    'Character': 1,
                    'Log': 2,
                    'Text': 4}

# Cacti to Zabbix relation
item_store_values = {1: 0,  # GAUGE == As is
                     2: 1,  # COUNTER == Delta (speed per second)
                     3: 1}  # DERIVE == Delta (speed per second)
# Others: Delta (simple change) 2

graph_types = {'Normal': 0,
               'Stacked': 1,
               'Pie': 2,
               'Exploded': 3}

graph_item_functions = {'all': 7,
                        'min': 1,
                        'avg': 2,
                        'max': 4}

# Cacti to Zabbix relation
graph_item_draw_styles = {'LINE1': 0,  # Line
                          'LINE2': 2,  # Bold line
                          'AREA':  1,  # Filled region
                          'STACK': 0}  # Line
# Others: Dot 3, Dashed line 4, Gradient line 5

graph_y_axis_sides = {'Left': 0,
                      'Right': 1}

trigger_severities = {'Not_classified ': 0,
                      'Information': 1,
                      'Warning': 2,
                      'Average': 3,
                      'High': 4,
                      'Disaster': 5}

# Parse args
usage = """
    -h, --help                    Prints this menu and exits
    -o, --output [xml|config]     Type of the output, default - xml.
"""
try:
    opts, args = getopt.getopt(sys.argv[1:], "ho:v", ["help", "output="])
except getopt.GetoptError as err:
    sys.stderr.write('%s\n%s' % (err, usage))
    sys.exit(2)
# Defaults
output = 'xml'
verbose = False
for o, a in opts:
    if o == "-v":
        verbose = True
    elif o in ("-h", "--help"):
        print usage
        sys.exit()
    elif o in ("-o", "--output"):
        output = a
        if output not in ['xml', 'config']:
            sys.stderr.write('invalid output type\n%s' % usage)
            sys.exit(2)
    else:
        assert False, "unhandled option"

# Read Cacti template definition file and load as YAML
dfile = open(DEFINITION, 'r')
data = []
for line in dfile.readlines():
    if not line.strip().startswith('#'):
        data.append(line.replace('=>', ':'))
data = yaml.safe_load(' '.join(data))

# Define the base of Zabbix template
tmpl = dict()
app_name = data['name'].split()[0]
tmpl_name = 'Percona %s Template' % data['name']
tmpl['version'] = ZABBIX_VERSION
tmpl['date'] = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime())
tmpl['groups'] = {'group': {'name': 'Percona Templates'}}
tmpl['screens'] = {'screen': {'name': '%s Graphs' % app_name,
                              'hsize': 2,
                              'vsize': int(round(len(data['graphs']) / 2.0)),
                              'screen_items': {'screen_item': []}}}
tmpl['templates'] = {'template': {'template': tmpl_name,
                                  'name': tmpl_name,
                                  'groups': tmpl['groups'],
                                  'applications': {'application': {'name': app_name }},
                                  'items': {'item': []},
                                  'macros': ''}}
tmpl['graphs'] = {'graph': []}
tmpl['triggers'] = ''

def format_item(f_item):
    """Underscore makes an agent to throw away the support for item
    """
    return '%s.%s' % (app_name, f_item.replace('_', '-'))

# Parse definition
all_item_keys = set()
x = y = 0
for graph in data['graphs']:
    # Populate graph
    z_graph = {'name': graph['name'],
               'width': 900,
               'height': 200,
               'graphtype': graph_types['Normal'],
               'show_legend': 1,
               'show_work_period': 1,
               'show_triggers': 1,
               'ymin_type': 0,  # Calculated
               'ymax_type': 0,  # Calculated
               'ymin_item_1': 0,
               'ymax_item_1': 0,
               'show_3d': 0,
               'percent_left': '0.00',
               'percent_right': '0.00',
               'graph_items': {'graph_item': []}}

    # Populate graph items
    multipliers = dict()
    i = 0
    for item in graph['items']:
        if item not in ['hash', 'task']:
            draw_type = item['type']
            if draw_type not in graph_item_draw_styles.keys():
                sys.stderr.write("ERROR: Cacti graph item type %s is not supported for item %s.\n" % (draw_type, item['item']))
                sys.exit(1)
            cdef = item.get('cdef')
            if cdef == 'Negate':
                multipliers[item['item']] = (1, -1)
            elif cdef == 'Turn Into Bits':
                multipliers[item['item']] = (1, 8)
            elif cdef:
                sys.stderr.write("ERROR: CDEF %s is not supported for item %s.\n" % (cdef, item['item']))
                sys.exit(1)
            else:
                multipliers[item['item']] = (0, 1)
            z_graph_item = {'item': {'key': format_item(item['item']),
                                     'host': tmpl_name},
                            'calc_fnc': graph_item_functions['avg'],
                            'drawtype': graph_item_draw_styles[draw_type],
                            'yaxisside': graph_y_axis_sides['Left'],
                            'color': item['color'],
                            'sortorder': i,
                            'type': 0}
            z_graph['graph_items']['graph_item'].append(z_graph_item)
            i = i + 1
    tmpl['graphs']['graph'].append(z_graph)

    # Add graph to the screen
    z_screen_item = {'resourcetype': 0,  # Graph
                     'width': 500,
                     'height': 120,
                     'valign': 1,  # Middle
                     'halign': 0,  # Center
                     'colspan': 1,
                     'rowspan': 1,
                     'x': x,
                     'y': y,
                     'dynamic': 1,
                     'resource': {'name': graph['name'],
                                  'host': tmpl_name}}
    tmpl['screens']['screen']['screen_items']['screen_item'].append(z_screen_item)
    tmpl['templates']['template']['screens'] = tmpl['screens']
    if x == 0:
        x = 1
    else:
        x = 0
        y = y + 1

    # Populate items
    for item in graph['dt'].keys():
        if item not in ['hash', 'input']:
            ds_type = int(graph['dt'][item]['data_source_type_id'])
            if ds_type == 4:
                sys.stderr.write("ERROR: Cacti DS type ABSOLUTE is not supported for item %s.\n" % item)
                sys.exit(1)
            name = item.replace('_', ' ').title()
            name = re.sub(r'^[A-Z]{4,} ', '', name)
            base_value = int(graph['base_value'])
            if base_value == 1000:
                unit = ''
            elif base_value == 1024:
                unit = 'B'
            else:
                sys.stderr.write("ERROR: base_value %s is not supported for item %s.\n" % (base_value, item))
                sys.exit(1)
            z_item = {'name': name,
                      'type': item_types['Zabbix agent'],
                      'key': format_item(item),
                      'value_type': item_value_types['Numeric (float)'],
                      'data_type': 0,  # Decimal the above is Numeric (unsigned)
                      'units': unit,
                      'delay': 300,  # Update interval (in sec)
                      'history': 90,
                      'trends': 365,
                      'delta': item_store_values[ds_type],
                      'applications': {'application': {'name': app_name }},
                      'description': '%s %s' % (app_name, name),
                      'multiplier': multipliers[item][0],
                      'formula': multipliers[item][1],
                      'status': 0}
            tmpl['templates']['template']['items']['item'].append(z_item)
            all_item_keys.add(item)

# Generate output
if output == 'xml':
    # Add extra items required by triggers
    extra_items = [{'name': 'Total number of mysqld processes',
                    'key': 'proc.num[mysqld]'},
                   {'name': 'MySQL running slave',
                    'key': format_item('running-slave')}]
    for item in extra_items:
        z_item = {'name': item['name'],
                  'key': item['key'],
                  'type': item_types['Zabbix agent'],
                  'value_type': item_value_types['Numeric (unsigned)'],
                  'data_type': 0,
                  'delay': 60,  # Update interval (in sec)
                  'history': 90,
                  'trends': 365,
                  'delta': 0,  # As is
                  'applications': {'application': {'name': app_name }},
                  'description': item['name'],
                  'status': 0}
        tmpl['templates']['template']['items']['item'].append(z_item)

    # Read triggers from YAML file
    dfile = open(TRIGGERS, 'r')
    data = yaml.safe_load(dfile)

    # Populate triggers
    trigger_refs = dict((t['name'], t['expression'].replace('TEMPLATE', tmpl_name)) for t in data)
    if trigger_refs:
        tmpl['triggers'] = {'trigger': []}
    for trigger in data:
        z_trigger = {'name': trigger['name'],
                     'expression': trigger['expression'].replace('TEMPLATE', tmpl_name),
                     'priority': trigger_severities[trigger.get('severity', 'Not_classified')],
                     'status': 0,  # Enabled
                     'dependencies': ''}
        # Populate trigger dependencies
        if trigger.get('dependencies'):
            z_trigger['dependencies'] = {'dependency': []}
            for dep in trigger['dependencies']:
                exp = trigger_refs.get(dep)
                if not exp:
                    sys.stderr.write("ERROR: Dependency trigger '%s' is not defined for trigger '%s'.\n" % (dep, trigger['name']))
                    sys.exit(1)
                z_trigger_dep = {'name': dep,
                                 'expression': exp}
                z_trigger['dependencies']['dependency'].append(z_trigger_dep)
        tmpl['triggers']['trigger'].append(z_trigger)

    # Convert and write XML
    xml = dict2xml.Converter(wrap='zabbix_export', indent='  ').build(tmpl)
    print '<?xml version="1.0" encoding="UTF-8"?>\n%s' % xml

elif output == 'config':
    # Read Perl hash aka MAGIC_VARS_DEFINITIONS from Cacti PHP script
    dfile = open(PHP_SCRIPT, 'r')
    data = []
    store = 0
    for line in dfile.readlines():
        line = line.strip()
        if not line.startswith('#'):
            if store == 1:
                if line == ');':
                    break
                data.append(line.replace('=>', ':'))
            elif line == '$keys = array(':
                store = 1
    data = yaml.safe_load('{%s}' % ' '.join(data))

    # Write Zabbix agent config
    for item in all_item_keys:
        print "UserParameter=%s,%s/get_mysql_stats_wrapper.sh %s" % (format_item(item), ZABBIX_SCRIPT_PATH, data[item])

    # Write extra items
    print "UserParameter=%s,%s/get_mysql_stats_wrapper.sh running-slave" % (format_item('running-slave'), ZABBIX_SCRIPT_PATH)
