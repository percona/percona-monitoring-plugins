#!/bin/bash

set -e
set -u
set -x

VERSION=`head -n 5 Changelog | grep version | head -n 1 | cut -d ' ' -f 3`;
DISTDIR=better-cacti-templates-$VERSION

if test -d $DISTDIR ; then rm -rf $DISTDIR ; fi
mkdir -p $DISTDIR/{scripts,templates,tools,definitions,misc}
cp -a Changelog COPYING README $DISTDIR
cp -a tools/*.pl $DISTDIR/tools
cp -a scripts/*.php $DISTDIR/scripts
cp -a definitions/*.pl $DISTDIR/definitions
cp -a misc/*.* $DISTDIR/misc

# Build the template.xml files...
for file in definitions/*.pl; do
   # Ensure that there's no duplicated hashes
   tools/unique-hashes.pl ${file} > tmp
   if ! diff -q ${file} tmp; then
      echo "${file} has duplicated hashes!"
      rm tmp
      exit 1
   fi
   rm tmp
   SCRIPT=`grep Autobuild $file | cut -d ' ' -f 3`;
   NAME=`basename $file | sed -e s'/_definitions.pl//'`;
   FILE="$DISTDIR/templates/cacti_host_template_x_${NAME}_server_ht_0.8.6i-sver${VERSION}.xml"
   perl tools/make-template.pl --script scripts/$SCRIPT $file > "${FILE}"
   MD5=`md5sum "${FILE}" | awk '{print $1}'`
   sed -i -e s/CUSTOMIZED_XML_TEMPLATE/${MD5}/ "${FILE}"
   grep Checksum "${FILE}" | sed -e 's/^.*<name>//' -e 's/<.name>//'  >> md5sums
done

tar czf $DISTDIR.tar.gz $DISTDIR
rm -rf $DISTDIR

set +x
echo "{{{"
cat md5sums
echo "}}}"
rm md5sums
