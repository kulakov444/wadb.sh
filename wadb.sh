#!/bin/sh

# SPDX-FileCopyrightText: NONE
#
# SPDX-License-Identifier: Unlicense

PREFIX=/data/data/com.termux/files/usr

[ -f $PREFIX/etc/wadb.sh ] || return
. $PREFIX/etc/wadb.sh

query_wake_lock(){
	! termux-notification-list | grep -A2 '    "packageName": "com.termux",$' | grep 'wake lock held'
}

query_wake_lock
WAKELOCK=$?

[ $WAKELOCK = 0 ] && termux-wake-lock

set_wadb() {
	PACKAGE=name.kulakov444.wadbswitch
	am broadcast               \
		-a $PACKAGE.SWITCH \
		--es flag $FLAG    \
		--ei value $1      \
		$PACKAGE           \
	
	unset PACKAGE
}

is_wifi_allowed() {
	termux-wifi-connectioninfo | grep '^  "supplicant_state": "COMPLETED"$' || return 1
	[ -z "$ALLOWED_NETWORKS" ] && return 0
	for n in $ALLOWED_NETWORKS; do
		termux-wifi-connectioninfo | grep '^  "bssid' | grep $n && return 0
	done
	return 1
}

start_adbd() {
	echo | adb shell 2>&1 && return
	adb disconnect
	if is_wifi_allowed; then
		set_wadb 1
		PORTS=$(nmap localhost -p 30000-50000 | grep '^[0-9]' | awk '{print $1}' | cut -d '/' -f1)
		for p in $PORTS; do
			adb connect localhost:$p | grep failed && adb disconnect localhost:$p || PORT=$p
		done
	fi
	echo | adb shell 2>&1
}

notify() {
	termux-notification-list | grep -B4 '    "packageName": "com.termux",$' | grep '13944' ||
		termux-notification -t 'Allow wireless debugging' --button1 'Cancel' --button1-action "$PREFIX/libexec/wadb_cancel.sh" -i 13944
}

keep_trying() {
	[ "$NOTIFY" = 1 ] || return
	notify

	BREAK=0
	for i in awk 'BEGIN { i = 0; while (i < 5) { print i; i++ } exit; }'; do
		if [ $BREAK = 0 ]; then
			start_adbd                               &&
				termux-notification-remove 13944 &&
				BREAK=1                          ||
				sleep 60
		fi
	done
	unset BREAK
}

if is_wifi_allowed; then
	start_adbd || keep_trying
fi

sleep 1
printf %s "$CMD" | adb shell && termux-job-scheduler --cancel --job-id 34221

if [ "$DISCONNECT" = 1 ]; then
	adb disconnect localhost:$PORT
	set_wadb 0
fi

[ $WAKELOCK = 0 ] && termux-wake-unlock
