.. _cacti_overview:

Percona Monitoring Plugins for Cacti
====================================

Many Cacti templates you'll find online are often poor quality and have many
problems.  Cacti's design can also cause inefficiency if you don't know how to
use it correctly, and most templates don't avoid those inefficiencies.  The
Percona's Cacti templates alleviate these problems, which are common in other
templates:

*  No duplicated data in RRD files.
*  No unused data in RRD files.
*  No wasted polling for the same data, which can cause timeouts and increased load

These templates offer the following improvements:

* Versioning and backwards compatibility.
* Good documentation.
* Much more data is collected and graphed than you'll typically find.
* Graphs have attractive colors and consistent formatting.  Metrics are printed as well as graphed, so you can read the numbers as well as look at the picture.
* Support for the newest versions of MySQL and InnoDB.
* Integration with other Percona software, such as Percona Server and Percona Toolkit.
* Easy to install and configure.
* Easy and safe to upgrade, with support for a configuration file so you can upgrade the scripts without losing your configuration.
* Debugging features to help find and solve problems.
* Templates don't conflict with your existing Cacti installation; they don't use anything pre-defined in Cacti.  That means you can import them without fear of overwriting your customized settings.
* Real software engineering!  There is a test suite, to keep the code high quality.

In addition, the software supports a much easier way to generate graphs and
templates than you will find elsewhere, so you can create your own custom graphs
of anything you desire.  If you need help with this, Percona can also assist
with that.
