#!/bin/bash

ARG=$1

set -e
set -u

# This script makes a tarball of all of the source code and documentation for
# both the Cacti templates and the Nagios plugins.

# This will be replaced into the $RELEASE$ macro.
VERSION="$(cat VERSION)"
echo "Building version $VERSION"

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

# Set up the release directory.  Copy things into the directory so
# we can alter them without messing with stuff that is under source control.
rm -rf release
mkdir -p release/{docs/html,code/cacti/templates}
cp -R nagios release/code/nagios
cp -R docs/* release/docs
cp -R cacti/scripts cacti/definitions cacti/bin cacti/misc release/code/cacti
cp COPYING Changelog release/code
cp Changelog release/docs/changelog.rst

# Remove bazaar tilde files (backup ones after revert)
find release/ -name "*.~1~" -exec rm -f {} \;

# Update the version number and other important macros in the temporary
# directory.
YEAR=$(date +%Y)
for f in release/code/nagios/bin/pmp* release/docs/config/conf.py release/code/cacti/scripts/ss* release/code/cacti/definitions/*.def ; do
   sed -i "s/\\\$PROJECT_NAME\\\$/$PROJECT_NAME/g" "$f"
   sed -i "s/\\\$VERSION\\\$/$VERSION/g" "$f"
   sed -i "s/\\\$CURRENT_YEAR\\\$/${YEAR}/g" "$f"
   sed -i "s/${YEAR}-${YEAR}/${YEAR}/g" "$f"
done

# Build the XML files for the Cacti templates.  Each XML file is built by
# looking in the definitions file for the PHP script that it uses, then calling
# pmp-cacti-template with that script, and saving the resulting XML into a file
# that's appropriately named.  After that, we substitute the script's MD5 sum
# into the template, so that it will inject an appropriate variable into Cacti.
# This lets us see whether the PHP file on disk has been modified relative to
# the one that was shipped with the templates.  Finally, we update the
# documentation to add the MD5 sums there too, which is useful for upgrades; it
# lets us see whether we need to merge any customizations when upgrading the
# templates.
if ! grep "^2[^:]*: version ${VERSION}$" release/code/Changelog >/dev/null; then
   echo "There doesn't appear to be a changelog entry for $VERSION"
   exit 1
fi
for file in release/code/cacti/definitions/*.def; do
   # Get the name of the thing we're building an XML file for.
   NAME="${file##*/}"
   NAME="${NAME%%.def}"
   # Ensure that there's no duplicated hashes
   cacti/bin/pmp-cacti-make-hashes "${file}" > "${TEMPFILE}"
   if ! diff -q "${file}" "${TEMPFILE}"; then
      echo "${file} has duplicated hashes!"
      exit 1
   fi
   SCRIPT=$(awk '/Autobuild/{ print $NF; exit }' "$file");
   FILE="release/code/cacti/templates/cacti_host_template_percona_${NAME}_server_ht_0.8.6i-sver${VERSION}.xml"
   perl cacti/bin/pmp-cacti-template --script release/code/cacti/scripts/$SCRIPT "$file" > "${FILE}"
   MD5=$(_md5 "${FILE}")
   sed -i "s/CUSTOMIZED_XML_TEMPLATE/${MD5}/" "${FILE}"
done

# Make the Nagios documentation into Sphinx .rst format.  The Cacti docs are
# already in Sphinx format.
for f in release/code/nagios/bin/pmp-check-*; do
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

if [ "$ARG" != "nodocs" ]; then
   # Downloads latest percona-theme
   echo "Downloading percona-theme..."
   cd release/docs/config/
   wget -q -O percona-theme.tar.gz http://percona.com/docs/theme/percona-monitoring-plugins/
   rm -rf percona-theme
   echo "Extracting theme..."
   tar -zxf percona-theme.tar.gz
   rm percona-theme.tar.gz
   cd ../../../

   # Make the Sphinx documentation into HTML and PDF formats.
   sphinx-build -q -N -W -c release/docs/config/ -b html \
      release/docs/ release/docs/html
   if [ "$ARG" != "nopdf" ]; then
      sphinx-build -q -N -W -c release/docs/config/ -b latex \
         release/docs/ release/docs/latex
      make -C release/docs/latex all-pdf
      mkdir release/docs/pdf
      mv release/docs/latex/*.pdf release/docs/pdf
   fi

   echo "The documentation is complete in HTML format."
   echo "It is in the release/docs/html directory."
fi

# Make certain everything that's supposed to be executable is.
chmod +x release/code/{cacti,nagios}/bin/*

# Make the release tarball
NAME="percona-monitoring-plugins-${VERSION}"
mv release/code "release/${NAME}"
cd release
tar zcf "${NAME}.tar.gz" "${NAME}"
cd ..

echo "The release is in release/${NAME}.tar.gz"
