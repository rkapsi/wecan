#!/bin/bash

#
# This is the install script that simply creates Symlinks at the
# right places and it doubles as the rc.local script that restores
# functionality across firmware upgrades. It should be safe as it
# doesn't override anything but care needs to be taked if there
# is an existing rc.local script.
#

WECAN_DIR="/data/wecan"
WECAN_SCRIPT_FILE="${WECAN_DIR}/wecan.sh"
WECAN_RC_LOCAL_FILE="${WECAN_DIR}/install.sh"

SYS_LOCAL_BIN_DIR="/usr/local/bin"
SYS_CAN_SET_RATE_FILE="${SYS_LOCAL_BIN_DIR}/can-set-rate"

SYS_DATA_DIR="/data"
SYS_RC_LOCAL_FILE="${SYS_DATA_DIR}/rc.local"

install() {
    if [ ! -f $1 ]; then
        echo "File does not exist: ${1}"
        exit 1
    fi

    if [ ! -x $1 ]; then
        echo "File is not executable: ${1}"
        exit 1
    fi

    if [ ! -f $2 ]; then
        local dst_path=$(dirname $2)
        if [ ! -d $dst_path ]; then
            echo "Creating path: ${dst_path}"
            mkdir -p $dst_path
        fi

        echo "Symlink: ${2} -> ${1}"
        ln -s $1 $2
    fi
}

# Symlink the wecan.sh script
install $WECAN_SCRIPT_FILE $SYS_CAN_SET_RATE_FILE

# Symlink the rc.local script
install $WECAN_RC_LOCAL_FILE $SYS_RC_LOCAL_FILE

exit 0