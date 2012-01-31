#!/bin/bash

# This script makes a tarball of all of the source code and documentation for
# both the Cacti templates and the Nagios plugins.  Call it with these
# arguments:
#
# 1. Version of the release, e.g. 1.0.0.

# This will be replaced into the $RELEASE$ macro.
VERSION="$1"
if [ -z "${VERSION}" ]; then
   echo "Specify a release version"
   exit 1
fi

# This will be replaced into the $PROJECT_NAME$ macro.
PROJECT_NAME="Percona Monitoring Plugins"

# Set up the temporary directory.  Copy things into the temporary directory so
# we can alter them without messing with stuff that is under source control.
rm -rf release
# mkdir -p release/{docs/,}{nagios,cacti}
mkdir release
cp -R nagios/ docs/ release/
rm -rf release/nagios/t/

# Update the version number and other important macros in the temporary
# directory.
sed -i'' -e "s/\\\$VERSION\\\$/$VERSION/" \
         -e "s/\\\$PROJECT_NAME\\\$/$PROJECT_NAME/" \
         release/nagios/pmp* release/cacti/scripts/ss*

# Make the Nagios documentation into Sphinx format
for f in release/nagios/pmp-check-*; do
   pod2rst --infile "$f" --outfile "release/docs/nagios/${f##*/}.rst";
done

# TODO: check that there is an entry for the new version in the Nagios and Cacti changelogs
