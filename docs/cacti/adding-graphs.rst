.. _cacti_adding_graphs:

Adding Graphs
=============

This document shows you how to add graphs to an existing template.  Much of the technical background is covered in :ref:`_cacti_creating_graphs`, so you can treat this page as a quick-reference.

Here's what to do:

#. Make sure there is a blueprint, so the work is identified and tracked.
#. Do whatever's necessary to return the data items from the script (usually as integers, not floats, unless you're using ``GAUGE``).
#. Add the data items to the magic array.
#. Write tests as appropriate.
#. Ensure all existing tests still pass.
#. Add a new graph definition in the ``definitions/`` Perl file.
#. Add the new data items to the end of the ``definitions/`` Perl file, in the input.
#. Make the hashes unique.
#. Test the graphs.  Don't forget to upgrade the PHP script!
#. Update the documentation.  Add new samples and explanatory text.
