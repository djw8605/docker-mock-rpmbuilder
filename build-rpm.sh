#!/bin/bash
# exit when any command fails
set -ex

SPEC_FILE=$1
MOCK_CONFIG=$2

# Search through the spec file to find the sources
SOURCES=$(rpmspec -P $SPEC_FILE | grep -i  Source0 | cut -d ':' -f 2- | xargs basename)
if [[ $SOURCES == *.tar.gz ]]; then
        # Get the directory name
        dirname=${SOURCES%.tar.gz}
        set +e
        tar --transform="s/^\./$dirname/" -czf $SOURCES .
        set -e
fi

yum-builddep -y $SPEC_FILE

mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cp $SOURCES ~/rpmbuild/SOURCES
rpmbuild -ba $SPEC_FILE
