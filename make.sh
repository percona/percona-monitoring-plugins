#!/bin/bash

set -e
set -u

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

# Set up a temp file.
TEMPFILE=$(mktemp /tmp/${0##*/}.XXXX)
trap 'rm -rf "$TEMPFILE"' EXIT

# Set up the temporary directory.  Copy things into the temporary directory so
# we can alter them without messing with stuff that is under source control.
rm -rf release
# mkdir -p release/{docs/,}{nagios,cacti}
mkdir release
cp -R nagios docs release
mkdir release/cacti
cp -R cacti/scripts release/cacti
rm -rf release/nagios/t

# Update the version number and other important macros in the temporary
# directory.
YEAR=$(date +%Y)
for f in release/nagios/pmp* release/docs/config/conf.py release/cacti/scripts/ss* ; do
   sed -e "s/\\\$PROJECT_NAME\\\$/$PROJECT_NAME/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
   sed -e "s/\\\$VERSION\\\$/$VERSION/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
   sed -e "s/\\\$CURRENT_YEAR\\\$/${YEAR}/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
   sed -e "s/${YEAR}-${YEAR}/${YEAR}/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
done

# Make the Nagios documentation into Sphinx .rst format.  The Cacti docs are
# already in Sphinx format.
for f in release/nagios/pmp-check-*; do
   # The documents have all =head1 sections, which is fine for man pages, but is
   # not what we want for a hierarchical series of documents; we want the
   # program's NAME to be a head1 and the rest to be head2.  This will break if
   # any other heading name starts with N.  Also, we want to replace NAME with
   # the name of the check plugin.
   sed -e '/=head1 [^N]/s/head1/head2/' -e "s/=head1 NAME/=head1 ${f##*/}/" "$f" \
      | util/pod2rst > "${TEMPFILE}"
   # Also remove the license section.
   sed -e '/COPYRIGHT, LICENSE/,/Temple Place/d' "${TEMPFILE}" \
      > "release/docs/nagios/${f##*/}.rst";
done

# Make the Sphinx documentation into HTML format.
sphinx-build -N -W -c release/docs/config/ -b html release/docs/ release/html

# TODO: check that there is an entry for the new version in the Nagios and Cacti changelogs
