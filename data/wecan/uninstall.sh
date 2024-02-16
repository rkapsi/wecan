#!/bin/bash

#
# This uninstall script simply deletes the Symlinks. It does check
# that the to be deleted file is a Symlink but it doesn't check if
# it belongs to us. There is certainly a little danger that we delete
# somebody else's Symlink.
#

SYS_LOCAL_BIN_DIR="/usr/local/bin"
SYS_CAN_SET_RATE_FILE="${SYS_LOCAL_BIN_DIR}/can-set-rate"

SYS_DATA_DIR="/data"
SYS_RC_LOCAL_FILE="${SYS_DATA_DIR}/rc.local"

uninstall() {
    if [ -f $1 ] && [ -L $1 ]; then
        echo "Removing Symlink: ${1}"
        rm $1

        if [ $? -ne 0 ]; then
            echo "Failed to remove Symlink: ${1}"
            exit 1
        fi
    fi
}

uninstall $SYS_CAN_SET_RATE_FILE
uninstall $SYS_RC_LOCAL_FILE

exit 0