#!/bin/bash

#
# This is the install script that simply creates Symlinks at the
# right places and it doubles as the rc.local script that restores
# functionality across firmware upgrades. It should be safe as it
# doesn't override anything but care needs to be taked if there
# is an existing rc.local script.
#

SYS_DATA_DIR="/data"
SYS_RC_LOCAL_FILE="${SYS_DATA_DIR}/rc.local"

SYS_LOCAL_BIN_DIR="/usr/local/bin"
SYS_CAN_SET_RATE_FILE="${SYS_LOCAL_BIN_DIR}/can-set-rate"

WECAN_DIR="/${SYS_DATA_DIR}/wecan"
WECAN_SCRIPT_FILE="${WECAN_DIR}/wecan.sh"
WECAN_RC_LOCAL_FILE="${WECAN_DIR}/install.sh"

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

            # Can happen if the filesystem is still in ro mode!
            if [ $? -ne 0 ]; then
                echo "Failed to create path: ${dst_path}"
                exit 1
            fi
        fi

        echo "Symlink: ${2} -> ${1}"
        ln -s $1 $2

        # Can happen if the filesystem is still in ro mode!
        if [ $? -ne 0 ]; then
            echo "Failed to create Symlink: ${2} -> ${1}"
            exit 1
        fi
    fi
}

# Symlink the rc.local script. 
#     NOTE: Do this first so that it can 'fix' itself after a
#       firmware upgrade because symlinking the wecan.sh script
#       will most likely fail due to timing issues (see README).
install $WECAN_RC_LOCAL_FILE $SYS_RC_LOCAL_FILE

# Symlink the wecan.sh script
install $WECAN_SCRIPT_FILE $SYS_CAN_SET_RATE_FILE

exit 0