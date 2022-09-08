#!/bin/sh
#
# Copyright (C) 2014 OpenWrt.org
#

MA35D1_BOARD_NAME=
MA35D1_MODEL=

ma35d1_board_detect() {
	local machine
	local name

	machine=$(cat /proc/device-tree/model)

	case "$machine" in
	"Nuvoton MA35D1-SOM")
		if dmesg | grep "mem=2"
		then
			name="som-256m"
		elif dmesg | grep "mem=5"
		then
			name="som-512m"
		else
			name="som-1g"
		fi
		;;
	"Nuvoton MA35D1-IoT")
		if dmesg | grep "mem=1"
		then
			name="iot-128m"
		else
			name="iot-512m"
		fi
		;;
	*)
		name="generic"
		;;
	esac

	[ -z "$MA35D1_BOARD_NAME" ] && MA35D1_BOARD_NAME="$name"
	[ -z "$MA35D1_MODEL" ] && MA35D1_MODEL="$machine"

	[ -e "/tmp/sysinfo/" ] || mkdir -p "/tmp/sysinfo/"

	echo "$MA35D1_BOARD_NAME" > /tmp/sysinfo/board_name
	echo "$MA35D1_MODEL" > /tmp/sysinfo/model
}

ma35d1_board_name() {
	local name

	[ -f /tmp/sysinfo/board_name ] && name=$(cat /tmp/sysinfo/board_name)
	[ -n "$name" ] || name="unknown"

	echo "$name"
}

