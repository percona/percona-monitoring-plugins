#summary Helper tools for making graphs

Aside from the tools documented elsewhere, there are the following tools:

= tools/graph_defs.pl =

This tool helps you make boilerplate text to plug into a definitions file.  If you create the definitions file and add the data input as suggested in CreatingGraphs, then you can take the input items and copy them into a new file.  Then group them into paragraphs in the order you want the graphs to be created.  Leave one blank line between each paragraph.  For example,

{{{
            OPVZ_kmemsize_held        => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_kmemsize_failcnt     => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',

            OPVZ_lockedpages_held     => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_lockedpages_failcnt  => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_privvmpages_held     => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_privvmpages_failcnt  => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_shmpages_held        => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_shmpages_failcnt     => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_physpages_held       => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_physpages_failcnt    => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_vmguarpages_held     => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_vmguarpages_failcnt  => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_oomguarpages_held    => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
            OPVZ_oomguarpages_failcnt => 'hash_07_VER_2442551920abf4f05121043fe4cd51d7',
}}}

That's a sample of a snippet I used to create the OpenVZ graphs.  That'll create boilerplate for two graphs.

Then run this script with that file as input.  The output will be generic text that's ready to paste into the `graphs` section of your definitions file.  You'll need to go through and edit all of the things like the data input name, the name of each file, the colors, data types, and so on.  But this can be a fast way to get started.

When you're done, make sure you generate new hashes for everything, or you'll re-use hashes from another template.  The best way to do this is to run tools/unique-hashes.pl with the `--refresh` option on that to generate all new hashes.