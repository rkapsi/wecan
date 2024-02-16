#!/bin/bash

#
# This uninstall script simply deletes the Symlinks. It does check
# that the to be deleted file is a Symlink but it doesn't check if
# it belongs to us. There is certainly a little danger that we delete
# somebody else's Symlink.
#

SYS_DATA_DIR="/data"
SYS_RC_LOCAL_FILE="${SYS_DATA_DIR}/rc.local"

SYS_LOCAL_BIN_DIR="/usr/local/bin"
SYS_CAN_SET_RATE_FILE="${SYS_LOCAL_BIN_DIR}/can-set-rate"

WECAN_DIR="${SYS_DATA_DIR}/wecan"

uninstall() {
    local link=$1
    if [ -f $link ] && [ -L $link ]; then

        # Making sure the Symlink is pointint to wecan and not somebody else's scripts.
        local fq_dir=$(dirname $(realpath "$link"))
        if [ $WECAN_DIR = $fq_dir ]; then
            echo "Removing Symlink: ${link}"
            rm $link

            if [ $? -ne 0 ]; then
                echo "Failed to remove Symlink: ${link}"
                exit 1
            fi
        else
            echo "Skipping Symlink ${link} because it's not pointing to ${WECAN_DIR}"
        fi
    fi
}

# Uninstall the rc.local Symlink first. It's very unlikly to fail
# and prevents wecan from re-installing itself.
uninstall $SYS_RC_LOCAL_FILE

# Remove the can-set-rate Symlink
uninstall $SYS_CAN_SET_RATE_FILE

exit 0