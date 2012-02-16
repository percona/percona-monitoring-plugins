Percona Monitoring Plugins
==========================

The Percona Monitoring Plugins are high-quality components to add
enterprise-grade MySQL capabilities to your existing in-house, on-premises
monitoring solutions.  The components are designed to integrate seamlessly with
widely deployed solutions such as Nagios and Cacti, and are delivered in the
form of templates, plugins, and scripts.

At Percona, our experience helping customers with emergencies informs our
monitoring strategies. We have analyzed a large database of emergency issues,
and used that to determine the best conditions to monitor.  You can read about
our suggested approaches to monitoring in our `white papers
<http://www.percona.com/about-us/white-papers/>`_.

Monitoring generally takes two forms:

#. Fault detection.

   Fault detection notifies you when systems become unhealthy or unavailable.
   In general, fault detection monitoring tends to fail because of false alarms,
   which cause personnel to ignore the alerts or not notice when the monitoring
   system itself fails.  As a result, it is very important to choose very
   carefully when you monitor for faults: monitor only on actionable conditions
   that are not prone to false positives, and definitely indicate a problem, but
   do not duplicate other information or tell you something you already know.
   The classic example of a poor-quality check is a cache hit ratio, or a
   threshold such as the number of sort merges per second.

#. Metrics collection and graphing.

   By contrast to fault detection, it is a good idea to collect and store as
   much performance and status information about the systems as possible, for as
   long as possible, and to have a means of visualizing it as graphs or charts.
   These are good to glance at periodically, but they are really most useful
   when you are trying to diagnose a condition whose existence you have already
   identified.  For example, if you see a period of degraded service on one
   chart, you might look at other charts to try to determine what changed during
   that period.

In summary, you should alert as much as you need, no more no less, and prefer
fewer alerts on broader conditions. You should never ignore an alert.  But you
should collect as many metrics as possible, and ignore most of them until you
need them.

We make our monitoring components freely available under the GNU GPL. If you
would like help setting up the components, integrating them into your
environment, choosing alerts, or any other task, Percona consulting and support
staff can help.

You can download the Percona Monitoring Plugins from the `Percona Software
Downloads <http://www.percona.com/downloads/>`_ directory, including our APT and
Yum repositories.  For specific installation instructions, read the detailed
documentation on each type of components below.

Plugins for Nagios
==================

Nagios is the most widely-used open-source fault-detection system, with advanced
features such as escalation, dependencies, and flexible notification rules.

.. toctree::
   :maxdepth: 2

   nagios/index

Plugins for Cacti
=================

Cacti is a popular PHP- and MySQL-based web front-end to RRDTool, providing
intuitive point-and-click configuration and browsing of graphs and metrics.

.. toctree::
   :maxdepth: 1

   cacti/index
   cacti/faq
   cacti/installing-templates
   cacti/customizing-templates
   cacti/upgrading-templates
   cacti/mysql-templates
   cacti/ssh-based-templates
   cacti/developer-documentation

Changelog
=========

.. toctree::
   :maxdepth: 2

   changelog
