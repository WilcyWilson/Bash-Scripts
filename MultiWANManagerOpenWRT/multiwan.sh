#!/bin/sh
#
# This file is interpreted as shell script.
# Put your custom mwan3 action here, they will
# be executed with each netifd hotplug interface event
# on interfaces for which mwan3 is enabled.
#
# There are three main environment variables that are passed to this script.
#
# $ACTION
#      <ifup>         Is called by netifd and mwan3track.
#      <ifdown>       Is called by netifd and mwan3track.
#      <connected>    Is only called by mwan3track if tracking was successful.
#      <disconnected> Is only called by mwan3track if tracking has failed.
# $INTERFACE	Name of the interface an action relates to (e.g. "wan" or "wwan").
# $DEVICE	Physical device name of the interface the action relates to (e.g. "eth0" or "wwan0").
#               Note: On an ifdown event, $DEVICE is not available, use $INTERFACE instead.
#
# Further documentation can be found here:
# https://openwrt.org/docs/guide-user/network/wan/multiwan/mwan3#alertsnotifications
VIANET="Vianet is down"
CLASSIC="ClassicTech is down"
VIANETUP="Vianet is up"
CLASSICUP="ClassicTech is up"
MESSAGE=$(date '+%Y-%m-%d %H:%M:%S')
MESSAGEUP=$(date '+%Y-%m-%d %H:%M:%S')
PRIORITY=5
URL="http://192.168.1.102:8080/message?token=AAojMjR8qjx_l3V"
if [ "${INTERFACE}" = "wan" ] || [ "${INTERFACE}" = "wanb" ]; then
	if [ "${ACTION}" = "connected" ] || [ "${ACTION}" = "disconnected" ] ; then
		#/bin/sleep 5;
		
		if [ "${ACTION}" = "disconnected" ] && [ "${INTERFACE}" = "wan" ] ; then
			service https-dns-proxy restart
                        curl -s -S --data '{"message": "'"${MESSAGE}"'", "title": "'"${CLASSIC}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
                elif [ "${ACTION}" = "disconnected" ] && [ "${INTERFACE}" = "wanb" ] ; then
                        service https-dns-proxy restart
                        curl -s -S --data '{"message": "'"${MESSAGE}"'", "title": "'"${VIANET}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
                elif [ "${ACTION}" = "connected" ] && [ "${INTERFACE}" = "wan" ] ; then
                        curl -s -S --data '{"message": "'"${MESSAGEUP}"'", "title": "'"${CLASSICUP}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
                 elif [ "${ACTION}" = "connected" ] && [ "${INTERFACE}" = "wanb" ] ; then
                        curl -s -S --data '{"message": "'"${MESSAGEUP}"'", "title": "'"${VIANETUP}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
                fi
          fi
fi
