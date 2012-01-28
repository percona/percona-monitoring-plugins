#summary How to create new templates or graphs

<wiki:toc max_depth="1" />

= Introduction =

This document explains how to create Cacti templates simply and reliably.  For this example, we'll assume you are going to add a new set of graphs into the ss_get_by_ssh.php file.  This means you're going to write a command to SSH to a server and collect some data, parsing code to turn that into a list of named values to graph, and graphs to display the result.

This example will show a fairly complex set of graphs.  If you understand the example, you should be ready to create quite complex graphs yourself.  We're going to collect data from /proc/diskstats on Linux and graph it.

= Collecting and Parsing the Data =

Getting the data is quite simple.  You will simply going to SSH to the server we're graphing and `cat /proc/diskstats`.  Then you'll parse the result into name-value pairs.

Start by writing tests against sample files, before we write any code.  This is the single most important part of creating reliable graphing code.  Collect several samples of /proc/diskstats from different sources so you get a variety of cases.  For example, it's best to collect samples from different kernel versions or distributions.  Save these into files such as `t/samples/diskstats-001.txt` as test samples.

Next, write the tests.  Open up t/get_by_ssh.php and add is_deeply() calls to the bottom to test each sample.  You're going to test a function called `diskstats_parse()`.  (But don't write the function yet!)  The name of this function is important, as we'll see a bit later.  The naming convention is how the PHP script will find and execute the function.  It needs to be SOMETHING_parse, where SOMETHING is the command-line argument given to the script's `--type` option.  In this case, "diskstats" seems like a good name: the command-line will eventually be something like `php ss_get_by_ssh.php --type diskstats ....` which is reasonable.

Each call to the function will return information about one disk device, so you'll need to add a `--device` option to the PHP script eventually.  For right now, all you need to know is that the prototype of `diskstats_parse()` is an array and a string of text.  The array is command-line options, and the text is the contents of `/proc/diskstats`.  The call will look like this:

{{{
diskstats_parse( array('device' => 'hda1'), "<contents of /proc/diskstats....>" );
}}}

Refer to documentation as needed and hand-interpret the sample file, then write out the values you expect to be returned in the test.  This should be a name-value list with *meaningful names*.  This is quite important.  The names you choose here will be used in many different places, including as text on the graphs we'll eventually create.  Separate words with underscores and use all lowercase letters.  Choose a unique 4-letter uppercase prefix for the name.  For example,

{{{
is_deeply(
   diskstats_parse( array('device' => 'hda1'), file_get_contents('samples/diskstats-001.txt') ),
   array(
      'DISK_reads'              => '12043',
      'DISK_reads_merged'       => '387',
      'DISK_sectors_read'       => '300113',
      'DISK_time_spent_reading' => '6472',
      'DISK_writes'             => '12737',
      'DISK_writes_merged'      => '21340',
      'DISK_sectors_written'    => '272616',
      'DISK_time_spent_writing' => '22360',
      'DISK_io_ops_in_progress' => '0',
      'DISK_io_time'            => '12368',
      'DISK_io_time_weighted'   => '28832'
   ),
   'samples/diskstats-001.txt'
);
}}}

Make sure that you plan to output integers, not floating-point numbers, for counters that will increase as time passes.  Later on you'll find that floating-point numbers cannot be stored into COUNTER and DERIVE values in RRD files.

Once you have the test written, execute the test file and ensure the test fails!  If it doesn't fail, you have no reliable indicator that a passing test really means success:

{{{
mysql-cacti-templates/t$ php get_by_ssh.php
}}}

You should see a fatal error that the function `diskstats_parse()` doesn't exist.  Great.  Now it's time to write it.  Open up `scripts/ss_get_by_ssh.php`.  Go all the way to the bottom of the file.  Scroll upwards three functions.  Those three functions should be the three magically named functions for some other parsing process.  Take a look at them and use them as a reference for writing your own function.  Copy the block comment header (don't worry much about its contents for right now), and start your own function.  It should look like this:

{{{
function diskstats_parse ( $options, $output ) {
   $result = array();
   # write some code here
   return $result;
}
}}}

The returned value should be the array that you're testing for.  Write until your test passes, and then write similar tests for the other two sample files.  Now you're done with the parsing code!

= Writing the Command Line =

Once you've gotten this far, you've collected sample data, and written well-tested code to parse it.  This code lives in a function called `diskstats_parse()`, which follows a specific naming convention.  You need two more functions that follow the same naming convention, and the command-line option that'll cause these functions to be executed.

The first function specifies a cache filename.  Caching is an efficiency feature that helps work around a flaw in Cacti's design.  The filename needs to be unique for every different host and device you want to graph, so we're going to need to include the --host and the --device command-line options in the filename.  The second function creates the command line that'll gather the data from /proc/diskstats over SSH.  The functions can be quite simple.

{{{
function diskstats_cachefile ( $options ) {
   $sanitized_host
       = str_replace(array(":", "/"), array("", "_"), $options['host']);
   $sanitized_dev
       = str_replace(array(":", "/"), array("", "_"), $options['device']);
   return "${sanitized_host}_diskstats_${sanitized_dev}";
}

function diskstats_cmdline ( $options ) {
   return "cat /proc/diskstats";
}
}}}

Now you need to let the user know how to execute these functions.  This is done via the `--type` command-line option to the PHP script.  The argument to this option can be free-form text, so all you need to do is add the text to the `--help` output.  Here's a diff to show what to change:

{{{
@@ -197,7 +198,7 @@
    --server    The server (DNS name or IP address) from which to fetch the
                desired data after SSHing.  Default is 'localhost' for HTTP stats
                and --host for memcached stats.
-   --type      One of apache, nginx, proc_stat, w, memory, memcached
+   --type      One of apache, nginx, proc_stat, w, memory, memcached, diskstats
                (more are TODO)
    --url       The url, such as /server-status, where server status lives
    --use-ssh   Whether to connect via SSH to gather info (default yes).
}}}

Hopefully that's clear.

There is one final detail, which is necessary because this is a rather advanced graphing task: we need to add a `--device` command-line option so the PHP code can figure out which disk device the user is interested in graphing.  This should be added in two places: a) the command-line `--help` output we just saw, and b) in the `validate_options()` function.  Here's another diff:

{{{
@@ -160,7 +160,7 @@
 function validate_options($options) {
    debug($options);
    $opts = array('host', 'port', 'items', 'nocache', 'type', 'url', 'http-user',
-                 'file', 'http-password', 'server', 'port2', 'use-ssh');
+                 'file', 'http-password', 'server', 'port2', 'use-ssh', 'device');
    # Required command-line options
    foreach ( array('host', 'items', 'type') as $option ) {
       if ( !isset($options[$option]) || !$options[$option] ) {
}}}

Now you can specify `--device sda1` or similar, and the code can access that through `$options['device']`, as you've seen in the examples above.

== Adding a Custom Getter Function ==

ss_get_by_ssh.php assumes you're going to write an XXX_cmdline() function that will return the commandline to be executed via SSH.  However, it's actually possible to bypass this functionality and provide your own code to execute directly, instead of fetching data over SSH.  To do this, create a function called XXX_get() that returns the data directly.  You can see an example of this in r424, where sockets are used to get Redis status directly instead of via SSH.

= Specifying a Short-Name Mapping =

You already created long, descriptive names for the data values you're going to graph.  Unfortunately, due to another Cacti limitation, these names can't be used safely everywhere.  In most Cacti templates, the script returns a key:value string to Cacti, like this:

{{{
Name_of_data_value:1234 Name_of_another_data_value:5678
}}}

That's nice, but when you get a few dozen values back from a single call, Cacti starts losing data because it has a fixed-length buffer it reads these things into.  And due to yet another Cacti design flaw, for efficiency it really is important to return all the values at once.  So we need short names, and a mapping between the long and the short names.  It would be a hassle to keep track of all this, but the system you're working in centralizes that all and makes it much easier for you.

The mapping is defined in an array in the PHP script, which -- and this is important -- is one big paragraph of text (no empty lines) preceded by the magic word MAGIC_VARS_DEFINITIONS.  You need to append your data variables to this array and give each name a unique abbreviation.  For example,

{{{
   # Define the variables to output.  I use shortened variable names so maybe
   # it'll all fit in 1024 bytes for Cactid and Spine's benefit.  This list must
   # come right after the word MAGIC_VARS_DEFINITIONS.  The Perl script parses
   # it and uses it as a Perl variable.
   $keys = array(
      # ............. <previous entries omitted> ............
      # Diskstats stuff
      'DISK_reads'              => 'bj',
      'DISK_reads_merged'       => 'bk',
      'DISK_sectors_read'       => 'bl',
      'DISK_time_spent_reading' => 'bm',
      'DISK_writes'             => 'bn',
      'DISK_writes_merged'      => 'bo',
      'DISK_sectors_written'    => 'bp',
      'DISK_time_spent_writing' => 'bq',
      'DISK_io_ops_in_progress' => 'br',
      'DISK_io_time'            => 'bs',
      'DISK_io_time_weighted'   => 'bt',
   );
}}}

The convention is two-letter abbreviations, beginning at a0, a1, and so on.  Just append to the list and continue the convention.  Separate your entries with a short comment, such as `Diskstats stuff` as shown above.

Now you can see why the uppercase DISK identifier chosen earlier (during the test phase) is necessary.  This makes the names unique.  Otherwise you might end up with two items in this array with the key 'writes' and you'd have a problem.

The short names go into the `--items` command-line argument.  This argument can take any combination of short names.  Now that you know what your short names are going to be, go back to the comment header right above the `diskstats_cachefile()` function, and write a sample command-line users can use to test the functionality you're creating, such as:

{{{
# ============================================================================
# Get and parse stats from /proc/diskstats
# You can test it like this, as root:
# su - cacti -c 'env -i php /var/www/cacti/scripts/ss_get_by_ssh.php --type diskstats --host 127.0.0.1 --items bj,bk,bl,bm,bn,bo,bp'
# ============================================================================
function diskstats_cachefile ( $options ) {
}}}

Notice that the `--items` argument is simply a comma-separated list of the short names you defined in the mapping array.

= Write Another Test =

At this point, you're finished with everything PHP'ish, except for one last thing: write another test case.  Write your final test case to test the integration of all the code you've written, and ensure that it all works right together.  Look in the test file for tests against the `ss_get_by_ssh()` function, and emulate that.  For example,

{{{
is(
   ss_get_by_ssh( array(
      'file'    => 'samples/diskstats-001.txt',
      'type'    => 'diskstats',
      'host'    => 'localhost',
      'items'   => 'bj,bk,bl,bm,bn,bo,bp,bq,br,bs,bt',
      'device'  => 'hda1'
   )),
   'bj:12043 bk:387 bl:300113 bm:6.472 bn:12737 bo:21340 bp:272616 bq:22.36 '
      . 'br:0 bs:12.368 bt:28.832',
   'main(samples/diskstats-001.txt)'
);
}}}

Now you're really done, and you can go on to defining the graphs.

= How the Graph System Works =

Cacti's templating system is really difficult to understand and work with.  It uses cryptic values, has redundant data all over the place (so you can't tell what's meaningful and what's just accidentally duplicated data), and uses randomly generated hashes as unique identifiers for things.  The typical Cacti template is defined within Cacti and then exported, which results in an unholy mess for anyone who tries to import that template.  All sorts of nastiness results.  And to top it off, creating nice consistent templates is tedious.  You could easily spend several days doing it, one click at a time.  I know, because before I wrote this automatic templating system, I spent several weeks trying to whip someone else's templates into a shape that I considered usable and wouldn't sabotage my Cacti installation.

All that is behind us now.  The system you're about to see might look a little cryptic, but that's because it is a highly compressed definition of the template system that Cacti uses.  This system cuts out redundancy, and follows a certain set of conventions to eliminate a lot of work (and a lot of errors).  Without this, it would be just as cryptic -- but it would be an order of magnitude bigger and harder to understand.

In this system, there is a fairly simple relationship between the moving parts in the system.  If you're familiar with Cacti, the following might help you understand:

  # An input is defined only once, instead of being defined over and over for every different graph.  This means that all the graphs for a related set of data draw their data from a common command.  The input is defined by a command-line that executes it, command-line arguments it accepts, and values it outputs.
  # Each graph is associated with one graph template.
  # Each graph template has a corresponding data template, which has exactly the inputs and outputs that the graph needs, no more, no less.  Data templates are not shared across several graph templates or vice versa; there is a strict one-to-one relationship.
  # Each RRD file definition maps exactly to one graph template and therefore to one data template, again in a one-to-one relationship.
  # The above one-to-one relationships prevent a lot of duplicated data being polled, retrieved, and stored in RRD files (which can get pretty big).
  # The graph templates, data templates, and RRD definitions are named the same way, but with a distinguishing suffix automatically added by the template generation tools.  This makes it easy to know what you're looking at!
  # The random hash identifiers are defined once and only once in the system, and are hard-coded into the definition file.  They never change, and that makes a lot of things work better.  Hard-coding removes the randomness and eliminates chaos.  The hashes are written in an abstract form in the definition file, to eliminate problems such as version dependencies (which typically prevent templates exported from a new version of Cacti being imported on an older version).

The summary of the above is "don't repeat yourself."  Cacti repeats itself a lot; this template system cuts all that out and simplifies things by creating a one-to-one-to-one relationship from the data collection all the way through to the graph definition.

Now that you know this, you're probably interested to learn about the definition file!

= Structure of the Definition File =

The definition file is basically one big Perl variable containing nested data structures.  It could have been YAML or JSON or XML or any of a number of other things. But it's not, it's Perl.

The relationship amongst the various types of data looks like this:

  # There is one top-level template.
  # The template contains some properties such as name and version.
  # The template contains two major sections: graphs and inputs.
    # The graph section is an array of graph template definitions.  Because of the one-to-one-to-one relationship amongst them, each graph template definition implicitly defines a corresponding data template and an RRD file definition.
    # The input section is an array of input definitions.  Each one defines the data that flows between the PHP script you wrote above, and the graph templates.

I'll explain more later, as I go through the steps of creating a new set of graphs from the data we're newly able to collect.

Before we go on, though, you need to understand about hashes.  If you open up the definition file, you'll see some things that look like this:

{{{
               task   => 'hash_09_VER_e2a72b5aa0b06ad05dcd368ae0a131cf',
               ... snipped ....
               hashes => [
                  'hash_10_VER_3eae0c8f769939bb30c407d4edcee0c0',
                  'hash_10_VER_25aaadab40c1c8e12c45ce61693099b7',
                  'hash_10_VER_43f90f7f26a7c6b3ca41c7219afaa50c',
                  'hash_10_VER_df9555d08c88c6c0336fe37ffe2ad74a'
}}}

Those hex digits are hashes.  You're going to have to create unique hashes so Cacti doesn't get all confused.  You're going to need a lot of them, too!  Don't worry about it.  Just follow these simple steps and you'll be fine:

  # Always create your template definitions by copying and pasting whatever you're working on.  If you're creating a new input, copy and paste an old one.
  # Always copy and paste downwards in the file.  Never take something from the file and copy/paste it higher up in the file.

Copying and pasting will create duplicate hashes.  It doesn't matter.  There is a tool to detect these and randomly generate new ones that aren't duplicates.  This works great, as long as you don't copy/paste higher in the file.  If you do that, the pre-existing hashes will get overwritten with newer ones, which is bad.  Later I'll tell you to check for this, just in case.

= Defining an Input =

The first step is to define your input.  You created a whole new group of data, which you can get with `--type diskstats`.  Create a new input for that.  Let's copy/paste the input called "Get Proc Stats".  Copy the whole thing:

{{{
      'Get Proc Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_b8d0468c0737dcd0863f2a181484f878',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type proc_stat --items <items>',
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_509a24f84c924e9252be9a82c6674a6f',
               name        => 'hostname'
            },
         ],
         outputs => {
            STAT_interrupts       => 'hash_07_VER_cf50d22f8b5814fbb9e42d1b46612679',
            STAT_context_switches => 'hash_07_VER_49aa057a3935a96fb25fb511b16a75fa',
            STAT_forks            => 'hash_07_VER_d5e03c6e39717cc6a58e85e5f25608c6',
            STAT_CPU_user         => 'hash_07_VER_edfd4ac62e1e43ec35b3f5dc10ae2510',
            STAT_CPU_nice         => 'hash_07_VER_474ae20e35b85ca08645c018bd4c29c4',
            STAT_CPU_system       => 'hash_07_VER_89c1f51e8cbf6df135e4446e9c656e9b',
            STAT_CPU_idle         => 'hash_07_VER_f8ad00b68144973373281261a5100656',
            STAT_CPU_iowait       => 'hash_07_VER_e2d5a3ef480bb8ed8546fe48c3496717',
            STAT_CPU_irq          => 'hash_07_VER_a8ff7438a031f05bd223e5a016d443b2',
            STAT_CPU_softirq      => 'hash_07_VER_b7055f7e8e745ab6c0c7bbd85f7aff03',
            STAT_CPU_steal        => 'hash_07_VER_5686b4b2d255e674f46932ae60da92af',
            STAT_CPU_guest        => 'hash_07_VER_367fbfbb15a0bbd73fae5366d02e0c9b',
         },
      },
}}}

What does all that mean?  The name of the input is going to be called "Get Proc Stats".  It is of type 1, which is a PHP script.  It has a hash -- don't worry about that, but that's its unique identifier.  It has an input_string, which is really its command-line.  You can see some special things in angle-brackets, which is Cacti's replacement variable notation.

Next it has inputs.  (I know, it's confusing).  There is only one input, the hostname.  This is a placeholder for Cacti to insert the hostname into the script's command-line arguments when it executes the PHP.  If you're wondering what gets put into the `<items>` argument placeholder in the input_string, that's taken care of automatically by the template generation system.

Finally, the input has outputs.  (Yes, I know...)  These are the values that the PHP script will return when you call it.  However, for sanity, they are mentioned here in their long form.  As I said before, the short-to-long mapping is defined only once, in the PHP file.  Everywhere else you will use the long form of the names, and the template generation system will take care of translating that to the short form where needed.

You need to copy and paste the text, and just update it to make a new input definition.  You'll end up with something like this:

{{{
      'Get Disk Stats' => {
         type_id      => 1,
         hash         => 'hash_03_VER_da6fa9ee8283a483d4dea777fd69c629',
         input_string => '<path_php_binary> -q <path_cacti>/scripts/ss_get_by_ssh.php '
                       . '--host <hostname> --type diskstats --items <items> '
                       . '--device <device>',
         prompt_title => 1,
         inputs => [
            {  allow_nulls => '',
               hash        => 'hash_07_VER_280cd9c759c52b2477b972334210f920',
               name        => 'hostname'
            },
            {  allow_nulls => '',
               hash        => 'hash_07_VER_e89872554729dcd0695528adec190dd2',
               name        => 'device',
               override    => 1,
            },
         ],
         outputs => {
            DISK_reads              => 'hash_07_VER_00e4dd20a4e29c673a4471b2ee173ac9',
            DISK_reads_merged       => 'hash_07_VER_8af205c19a7439e83cee53059096b8e3',
            DISK_sectors_read       => 'hash_07_VER_9c5a554f4d62343e5aaaf9f0d784ada0',
            DISK_time_spent_reading => 'hash_07_VER_e8fd959febe8cdd5b20b8282ba340f19',
            DISK_writes             => 'hash_07_VER_1384e83ff216c0377a5f213f9a88c6fa',
            DISK_writes_merged      => 'hash_07_VER_c9cb7f45fa6ad943c377efb3ba2e661d',
            DISK_sectors_written    => 'hash_07_VER_43f100a2f54d5b18c3cdc5e8b8a02293',
            DISK_time_spent_writing => 'hash_07_VER_e1886d79cfa3c526c899de03db6e07ee',
            DISK_io_time            => 'hash_07_VER_cad0f7e9d765ba4e9341de72c0366575',
            DISK_io_time_weighted   => 'hash_07_VER_d7ebd195f6d9048b8e1e84114e8a0b6d',
         },
      },
}}}

That should look familiar to you from the work you've done already.  The name is "Get Disk Stats".  The outputs are what you chose in your first test case.

Although I've shown newly generated hashes here, don't worry about it.  Copy/paste the hashes from the other input definition.  As long as you paste *below*, generating new hashes is easy.

The only things really special here are because disk statistics have to know what device they're graphing:

  # You need to add a command-line option for `--device`.
  # You need to tell Cacti that this command-line option can't be left null: `allow_nulls => '',`.
  # You need to tell Cacti to ask the user for the device every time the data template is applied to a graph: `override    => 1,`.  This is equivalent to checking the checkbox "Use Per-Graph Value (Ignore this Value)" on the data template in the Cacti interface.
  # You need to tell Cacti to prompt the user to customize the graph title when creating graphs: `prompt_title => 1,`.

The result is that Cacti will permit data entry for --device, it will require it, and it will ask for it to be provided for every graph.  (Yes, it's complicated.)

= Defining the Graph =

Now that you have the definition of the input that you're going to graph, you need to specify the graph itself -- how that data should be presented visually.

Again, begin by copy/pasting another definition, but copy above, paste below.  To keep it brief, this time I'm not going to the origin of the copy/paste -- I'll only show the final result.  Actually, here's the result, with a few things snipped for brevity:

{{{
      {  name       => 'Disk Sectors Read/Written',
         base_value => '1024',
         hash       => 'hash_00_VER_9fad7377daacfd611dae46b14cc4f67e',
         override   => { 'title' => 1 },
         dt         => {
            hash       => 'hash_01_VER_67811065b100a543ddeadf7464ae017c',
            input      => 'Get Disk Stats',
            ... snipped! ...
         },
         items => [
            ... snipped! ...
         ],
      },
}}}

Ignoring the snipped sections for right now, here's what that means:

  * *name* is pretty self-explanatory.  This name will be used in all the redundant places that Cacti wants it: in the graph template, in the graphs themselves, and so on, including the graph title.
  * *base_value* is usually 1000 or 1024.  Use 1000 except for things where you'd expect a unit of 1024, such as when the things graphed are measured in bytes.  Here we're using 1024 because we're talking about sectors read and written, and sectors are a power-of-two of bytes.
  * *hash* is just a hash.  Just copy/paste and let the uniquifying process take care of that.
  * *override* does not need to be used for most graphs.  Specifying an element here is equivalent to checking "Use Per-Graph Value (Ignore this Value)" next to that item on the graph template page inside of Cacti.  It means that this item won't be taken straight from the template for each graph; when you create the graph you'll be prompted to supply a value for the item.  We need to use it for this graph because we want to modify the graph's title to include the device or partition we're graphing in this graph.  When you create a graph, you'll be prompted for the device to graph, and you'll be able to customize the graph title so you can see that device easily.
  * *dt* defines things that are specific to the data template (remember, one graph template == one data template).  You need a hash (again, copy/paste for now), and you need to specify which input the data comes from.  Then, following this, you'll specify a varying number of sections, one for each item you want to graph from that input.
  * *items* includes a varying number of sections, too -- also one per thing you want to graph.

Here's what I've snipped out of those sections.  First, the sections that say what data to get out of the input:

{{{
            DISK_sectors_read             => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_80929ee708f7755d09443d3d930a29cc',
            },
            DISK_sectors_written          => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_f5d85616af1e03a679042978c938a7ee',
            },
}}}

That's two items.  Each one basically says "graph this, and here's the type and hash for it."  The thing to graph needs to be one of the data items that comes from the input.  The hash you should leave copy/pasted for now.  The *data_source_type_id* can have a few different values.  These map directly to [http://oss.oetiker.ch/rrdtool/doc/rrdcreate.en.html#IDS_ds_name_DST_dst_arguments RRDTool data types]:

  * The value 1 means a GAUGE.
  * The value 2 means a COUNTER (increasing, with overflow checks).
  * The value 3 means DERIVE (no overflow checks).  Prefer DERIVE with a minimum value of 0 over COUNTER (see issue 41).

Generally, I use DERIVE or GAUGE.  Anything that's a steadily increasing counter is a DERIVE, as in the example above.  Remember that DERIVE (and COUNTER) cannot accept floating-point numbers, so make sure that the data is converted to integers somehow.

Here's the next section I've stripped out of the code sample above.  This one contains the items that will appear on the graph itself:

{{{
            {  item   => 'DISK_sectors_read',
               color  => '542437',
               task   => 'hash_09_VER_38f255216fd118d6d88a46d42357323c',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_7fe10cf273b9917b2bd9d4185c95c17d',
                  'hash_10_VER_bf9926c2b2141684183bf54c53024c67',
                  'hash_10_VER_93929e0d701da516c2c00b2a986f4afb',
                  'hash_10_VER_61e3158871ff83b947fa61dd55bf0e62'
               ],
            },
            {  item   => 'DISK_sectors_written',
               color  => '53777A',
               task   => 'hash_09_VER_b5085578cca9a7fa280edef3196bbf53',
               type   => 'AREA',
               cdef   => 'Negate',
               hashes => [
                  'hash_10_VER_f1b8a498e6aa39016e875946005468ca',
                  'hash_10_VER_53f05855224d069625ee58c490ed1fb3',
                  'hash_10_VER_4ac5653988f3493af2e4fa9550546a86',
                  'hash_10_VER_43ca42b3dcd41d7cf16e2ef109931a0c'
               ],
            },
}}}

You can see there's a one-to-one mapping between the items we're getting from the data source and the items we're putting onto the graph.  In some special cases this isn't true, but it generally is; more on that in a minute.  Each item has the following properties:

    * *item* is the name of the data item to graph, as above.
    * *color* is a hex color code.  Try looking at http://www.colourlovers.com/palettes/top for some good ideas.  Picking good colors is much harder than it seems.
    * *task* is a hash; just copy/paste for now.
    * *type* is the RRD display type, such as LINE1 or AREA or STACK.
    * *cdef* is the optional name of a CDEF.  'Negate' is going to be the most frequent one you'll see.  This flips something across the Y axis.  You can see I have part of the graph going up, and part of it going down, here.
    * *hashes* is an array of hashes.  Each hash will result in a bit of the caption being added to the graph.  Depending on how many hashes are in the array, the graph will get varying bits of text below the picture.  If you want a standard graph that has the label, current, average, maximum, and minimum value, put five hashes here.  If you have only four, you'll get the label, current, average, and maximum; and so on.

Back to the special case I mentioned.  Sometimes I'll draw an item with an AREA in a light color, and then I'll add a LINE1 with a darker color to give it a nice defined border.  In this case I'd add the item with the AREA as in the examples above.  After that I'd add the item again as a LINE1 and not give it any hashes (so it doesn't get text captions on the graph).  This is the only case I've ever used where there isn't a one-to-one correspondence between the items coming from the data input and the items displayed on the graph.

If we put it all together, we'll get the full graph definition:

{{{
      {  name       => 'Disk Sectors Read/Written',
         base_value => '1024',
         hash       => 'hash_00_VER_9fad7377daacfd611dae46b14cc4f67e',
         override   => { 'title' => 1 },
         dt         => {
            hash       => 'hash_01_VER_67811065b100a543ddeadf7464ae017c',
            input      => 'Get Disk Stats',
            DISK_sectors_read             => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_80929ee708f7755d09443d3d930a29cc',
            },
            DISK_sectors_written          => {
               data_source_type_id => '3',
               hash => 'hash_08_VER_f5d85616af1e03a679042978c938a7ee',
            },
         },
         items => [
            # Colors from
            # http://www.colourlovers.com/palette/694737/Thought_Provoking
            {  item   => 'DISK_sectors_read',
               color  => '542437',
               task   => 'hash_09_VER_38f255216fd118d6d88a46d42357323c',
               type   => 'AREA',
               hashes => [
                  'hash_10_VER_7fe10cf273b9917b2bd9d4185c95c17d',
                  'hash_10_VER_bf9926c2b2141684183bf54c53024c67',
                  'hash_10_VER_93929e0d701da516c2c00b2a986f4afb',
                  'hash_10_VER_61e3158871ff83b947fa61dd55bf0e62'
               ],
            },
            {  item   => 'DISK_sectors_written',
               color  => '53777A',
               task   => 'hash_09_VER_b5085578cca9a7fa280edef3196bbf53',
               type   => 'AREA',
               cdef   => 'Negate',
               hashes => [
                  'hash_10_VER_f1b8a498e6aa39016e875946005468ca',
                  'hash_10_VER_53f05855224d069625ee58c490ed1fb3',
                  'hash_10_VER_4ac5653988f3493af2e4fa9550546a86',
                  'hash_10_VER_43ca42b3dcd41d7cf16e2ef109931a0c'
               ],
            },
         ],
      },
}}}

That's it! The hard work is over!

= Fix Your Hashes =

After you're done with the above steps, you have everything you need to create templates. But one small thing remains: you need to resolve the duplication you created by copy/pasting hash values all over the place.  There's a tool to do this.  Run it like this:

{{{
$ tools/unique-hashes.pl definitions/gnu_linux_definitions.pl > temp.pl
}}}

Now examine the generated file `temp.pl` and make sure it looks OK.  What I usually do is `vimdiff` that file and the original definitions file.  Among other things, I'm looking to make sure that I always pasted my hashes *below* where I copied them from.  *Hashes of the definition elements that pre-dated your work should never be changed!*  If they are, they can mess up people's Cacti installations.  The `diff` or `vimdiff` should reveal that new lines were added, but no old lines were changed.  After you verify that, you can replace the original file with the `temp.pl` file.

If you are creating a new definitions file based on an existing one, you can use the `--refresh` option to replace all hashes.

= Generate Templates =

Now you're ready to generate templates from your definition file!  Here's how:

{{{
$ tools/make-template.pl --script <data input script> <definition file> > template.xml
}}}

Now the generated template file should be ready to import and use! If you have any errors, bring that up on the mailing list and let's talk and make this document better!

= Real-Life Examples =

Here are some real examples of how to add graphs:

  * See r390 for the example I worked through above.
  * See r171 for an example of how to add something new to the MySQL graphs.  In this case, this shows how to add graphs for the Handler variables.

= Optional Template Elements =

Skip this unless you're an advanced user.

You can define these as children of the top level in the template definition:

  * gprints -- Custom sprintf formats.  You don't need to modify these.
  * rras -- these are just some custom RRA definitions so you can keep more than the usual amount of data.
  * cdefs -- these are custom CDEF sections, which generally don't need to be modified.

If you don't define these, built-in defaults are used.  They're kept in the tools/make-template.pl script.

= Suggestions =

Here are some suggestions for meaningful, good-quality graphs.

  # Don't mix things with different units onto a single graph.  Just because some values are generally about the same kind of thing doesn't mean they belong together on a graph!  For example, if you have data about the number of disk reads performed, and data about the number of bytes read -- don't mix them.  One has a unit of bytes, and the other has a unit of reads.  If you graph them together they'll scale and skew badly.
  # Pick colors carefully.  Again, I prefer to use http://www.colourlovers.com/palettes/top.