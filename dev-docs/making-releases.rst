.. _cacti_making_releases:

Making Releases
===============

Here's how to create a release:

* Make sure the Changelog is up to date and check the issue list.
* Make a note of any changes that will require special upgrade instructions.
* Update the $version in the script files.
* Update the version in the definitions files.
* Make sure $debug, $cache_dir, $debug_log are set correctly in the script files.
* run `./make.sh` in the top level.
* Update the upgrade instructions.
* Update each template's documentation to include any changes and update the version number of the release.

Packages required for development and building:
php perl-Time-HiRes python-sphinx-doc texlive-latex
