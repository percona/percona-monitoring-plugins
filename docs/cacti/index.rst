#summary Advantages and features of these templates

Cacti templates you'll find online are often poor quality and have many problems.  Cacti's design can also cause inefficiency if you don't know how to use it correctly, and most templates don't avoid those inefficiencies.  The templates offered by this project should work around all of these problems, which are pretty common in other templates:

  *  No duplicated data in RRD files.
  *  No unused data in RRD files.
  *  No wasted polling for the same data over and over, so your Cacti installation won't start timing out.

This project offers the following improvements:

  * Real software engineering!  There is a test suite, to keep the code high quality.
  * Versioning and backwards compatibility.
  * Great documentation.
  * Much more data is collected and graphed.
  * Graphs have attractive colors and consistent formatting.  Metrics are printed as well as graphed, so you can read the numbers as well as look at the picture.
  * Integration with Maatkit.
  * Fixed many problems with math on 32-bit platforms, etc.
  * Support for Oracle's new InnoDB plugin as well as the built-in InnoDB.
  * Easy to install and configure; no need to fill in username and password for every graph.  Support for an external config file so you can upgrade the scripts without losing your configuration.
  * Debugging features to help find and solve problems.
  * Templates don't conflict with your existing Cacti; they don't use anything pre-defined in Cacti.  That means you can import them without fear of overwriting your customized settings.