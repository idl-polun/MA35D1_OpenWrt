#
# Copyright (C) 2010 OpenWrt.org
#

. /lib/ma35d1.sh

PART_NAME="firmware"

platform_check_image() {
	return 0
}

platform_pre_upgrade() {
        local board=$(ma35d1_board_name)

        case "$board" in
        *som* | *iot*)
                ;;
        esac
}

