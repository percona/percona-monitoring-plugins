#!/bin/bash

# This script makes a tarball of all of the source code and documentation for
# both the Cacti templates and the Nagios plugins.  Call it with these
# arguments:
#
# 1. Version of the release, e.g. 1.0.0

VERSION="$1"
[ "${VERSION}" ] || echo "Specify a release version" && exit 1

# Make the Nagios documentation into Sphinx format
for f in nagios/pmp-check-*; do
   pod2rst --infile "$f" --outfile "docs/nagios/${f##*/}.rst";
done

# TODO: check that there is an entry for the new version in the Nagios and Cacti changelogs
