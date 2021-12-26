#!/bin/bash

# based on https://github.com/shervinsahba/polybar-vpn-controller

VPN_NAME="vicber"

NMCLI="/usr/bin/nmcli"
VPN_CONNECT="$NMCLI con up id $VPN_NAME"
VPN_DISCONNECT="$NMCLI con down id $VPN_NAME"
VPN_GET_STATUS="$NMCLI -f GENERAL.STATE con show $VPN_NAME"

## [Set colors] (set each variable to nothing for default color)
COLOR_CONNECTED="#00CC66"
COLOR_DISCONNECTED="#FF3300"

vpn_status() {
	$VPN_GET_STATUS | grep -Eio 'activated'
}

vpn_report() {
# continually reports connection status
	if [ "$(vpn_status)" ]; then
		echo "%{F$COLOR_CONNECTED}connected%{F-}"
	else
		echo "%{F$COLOR_DISCONNECTED}No VPN%{F-}"
	fi
}


vpn_toggle_connection() {
# connects or disconnects vpn
	if [ "$(vpn_status)" ]; then
		$VPN_DISCONNECT
		notify-send "VPN disconnected"
	else
		$VPN_CONNECT
		notify-send "VPN connected"
	fi
}


# cases for polybar user_module.ini
case "$1" in
	--toggle-connection) vpn_toggle_connection ;;
	*) vpn_report ;;
esac
