#!/bin/bash

set -e
set -u

# This script makes a tarball of all of the source code and documentation for
# both the Cacti templates and the Nagios plugins.  Call it with these
# arguments:
#
# 1. Version of the release, e.g. 1.0.0.

# This will be replaced into the $RELEASE$ macro.
VERSION="${1:-}"
if [ -z "${VERSION}" ]; then
   echo "Specify a release version"
   exit 1
fi

# This will be replaced into the $PROJECT_NAME$ macro.
PROJECT_NAME="Percona Monitoring Plugins"

# This md5 function works on Linux and Mac.
function _md5() {
   if test -x /usr/bin/md5sum; then
      # Linux
      md5sum "$1" | awk '{print $1}'
   else
      # Mac
      md5 -q "$1"
   fi
}

# Set up a temp file.
TEMPFILE=$(mktemp /tmp/${0##*/}.XXXX)
trap 'rm -rf "$TEMPFILE"' EXIT

# Set up the release directory.  Copy things into the directory so
# we can alter them without messing with stuff that is under source control.
rm -rf release release-docs
mkdir release
cp -R nagios release
cp -R docs release-docs
mkdir -p release/cacti/templates
cp -R cacti/scripts cacti/definitions cacti/tools cacti/misc release/cacti
rm -rf release/nagios/t
cp COPYING release

# Update the version number and other important macros in the temporary
# directory.
YEAR=$(date +%Y)
for f in release/nagios/pmp* release-docs/config/conf.py release/cacti/scripts/ss* ; do
   sed -e "s/\\\$PROJECT_NAME\\\$/$PROJECT_NAME/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
   sed -e "s/\\\$VERSION\\\$/$VERSION/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
   sed -e "s/\\\$CURRENT_YEAR\\\$/${YEAR}/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
   sed -e "s/${YEAR}-${YEAR}/${YEAR}/g" "$f" > "${TEMPFILE}"
   mv "${TEMPFILE}" "$f"
done

# Build the XML files for the Cacti templates.  Each XML file is built by
# looking in the definitions file for the PHP script that it uses, then calling
# make-template.pl with that script, and saving the resulting XML into a file
# that's appropriately named.  After that, we substitute the script's MD5 sum
# into the template, so that it will inject an appropriate variable into Cacti.
# This lets us see whether the PHP file on disk has been modified relative to
# the one that was shipped with the templates.  Finally, we update the
# documentation to add the MD5 sums there too, which is useful for upgrades; it
# lets us see whether we need to merge any customizations when upgrading the
# templates.
if ! grep "^Version ${VERSION}$" release-docs/cacti/upgrading-templates.rst >/dev/null; then
   echo "There doesn't appear to be a changelog entry for $VERSION in " \
        "docs/cacti/upgrading-templates.rst"
   exit 1
fi
for file in cacti/definitions/*.pl; do
   # Get the name of the thing we're building an XML file for.
   NAME="${file##*/}"
   NAME="${NAME%%_definitions.pl}"
   # Ensure that there's no duplicated hashes
   cacti/tools/unique-hashes.pl "${file}" > "${TEMPFILE}"
   if ! diff -q "${file}" "${TEMPFILE}"; then
      echo "${file} has duplicated hashes!"
      exit 1
   fi
   SCRIPT=$(awk '/Autobuild/{ print $NF; exit }' "$file");
   FILE="release/cacti/templates/cacti_host_template_percona_${NAME}_server_ht_0.8.6i-sver${VERSION}.xml"
   perl cacti/tools/make-template.pl --script release/cacti/scripts/$SCRIPT "$file" > "${FILE}"
   MD5=$(_md5 "${FILE}")
   sed -e "s/CUSTOMIZED_XML_TEMPLATE/${MD5}/" "${FILE}" > "${TEMPFILE}"
   mv "${TEMPFILE}" "${FILE}"
done
echo >> release-docs/cacti/upgrading-templates.rst
grep Checksum release/cacti/templates/*.xml \
   | sed -e 's/^.*<name>//' -e 's/<.name>//' -e 's/^/   /' \
   >> release-docs/cacti/upgrading-templates.rst

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
      > "release-docs/nagios/${f##*/}.rst";
done

# Make the Sphinx documentation into HTML format.
sphinx-build -N -W -c release-docs/config/ -b html release-docs/ release-docs/html

# Make the release tarball

NAME="percona-monitoring-plugins-${VERSION}"
mv release "${NAME}"
tar zcf "${NAME}.tar.gz" "${NAME}"

echo "The documentation is complete in HTML format."
echo "It is in the release-docs/html directory."
echo "The release is in ${NAME}.tar.gz"
