#!/bin/sh
# PMP package build script
#
# Required packages: rpm-build dpkg fakeroot php perl-Time-HiRes

set -e

TARGET=/opt/PKGS
WORK_DIR=/tmp/pkgbuild-`date +%s`

if [ -n "${JOB_NAME}${BUILD_NUMBER}${WORKSPACE}" ]; then
    # Build from Jenkins
    SOURCE=$WORKSPACE
    RELEASE=$BUILD_NUMBER
elif [ "$#" = 2 ]; then
    # Manual build
    SOURCE=$1
    RELEASE=$2
else
    echo "USAGE: use Jenkins or give args: sh build.sh <source_path> <build_number>"
    exit 1
fi

# Prepare the source code and docs
mkdir -p $WORK_DIR $TARGET
cp -pr $SOURCE $WORK_DIR/source_code
cd $WORK_DIR/source_code
./make.sh nodocs > /dev/null
VERSION="$(cat VERSION)"
FINAL_CODE=source_code/release/percona-monitoring-plugins-$VERSION
mv release/percona-monitoring-plugins-$VERSION.tar.gz $TARGET
echo "Tarball created: $TARGET/percona-monitoring-plugins-$VERSION.tar.gz"

build_rpm() {
    PROJECT=$1
    NAME=$PROJECT-$VERSION
    ARCH=noarch

    mkdir -p $WORK_DIR/rpm/{BUILD,BUILDROOT,RPMS,SOURCES,SRPMS}
    cp -r $WORK_DIR/$FINAL_CODE $WORK_DIR/rpm/SOURCES/$NAME
    cd $WORK_DIR/rpm/SOURCES/
    tar czf $NAME.tar.gz $NAME/
    cd ..

    rpmbuild --quiet -ba $SOURCE/build/rpm/$PROJECT.spec \
             --define "_topdir $WORK_DIR/rpm" \
             --define "version $VERSION" \
             --define "release $RELEASE"
    PKG=$NAME-$RELEASE.$ARCH.rpm
    mv RPMS/$ARCH/$PKG $TARGET 
    rm -rf $WORK_DIR/rpm

    if [ "$DEBUG" = 1 ]; then
        rpm -qpil $TARGET/$PKG
        echo
    fi
    echo "Package created: $TARGET/$PKG"
}

build_deb() {
    PROJECT=$1
    NAME=${PROJECT}_$VERSION
    ARCH=all

    mkdir -p $WORK_DIR/deb/$NAME/DEBIAN
    cd $WORK_DIR/deb
    cp $SOURCE/build/deb/$PROJECT/* $WORK_DIR/deb/$NAME/DEBIAN/
    sed -i "s/%{version}/$VERSION-$RELEASE/" $WORK_DIR/deb/$NAME/DEBIAN/control
    $SOURCE/build/deb/$PROJECT/files $WORK_DIR/$FINAL_CODE $WORK_DIR/deb/$NAME

    fakeroot dpkg --build $NAME > /dev/null
    PKG=${NAME}-${RELEASE}_${ARCH}.deb
    mv $NAME.deb $TARGET/$PKG
    rm -rf $WORK_DIR/deb

    if [ "$DEBUG" = 1 ]; then
        echo
        dpkg -I $TARGET/$PKG
        dpkg -c $TARGET/$PKG
        echo
    fi
    echo "Package created: $TARGET/$PKG"
}

build_rpm percona-nagios-plugins
build_rpm percona-cacti-templates
build_deb percona-nagios-plugins
build_deb percona-cacti-templates

rm -rf $WORK_DIR
exit 0
