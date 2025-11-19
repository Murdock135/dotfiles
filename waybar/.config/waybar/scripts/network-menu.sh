#!/usr/bin/env bash
# Network Control Panel Script for Waybar
# Provides quick access to network settings

# Define options
toggle_wifi="  Toggle WiFi"
select_network="󰖩  Select Network"
show_status="  Network Status"

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "Network" \
        -theme-str 'window {width: 350px; padding: 12px;}' \
        -theme-str 'listview {lines: 3;}' \
        -theme-str 'element {padding: 8px; border-radius: 8px;}' \
        -theme-str 'element selected {background-color: #98c379; text-color: #0f0f1a;}'
}

# Get WiFi status
get_wifi_status() {
    if nmcli radio wifi | grep -q "enabled"; then
        echo "on"
    else
        echo "off"
    fi
}

# Toggle WiFi
toggle_wifi_func() {
    if [ "$(get_wifi_status)" = "on" ]; then
        nmcli radio wifi off
        notify-send "Network" "WiFi turned off" -i network-wireless-disabled
    else
        nmcli radio wifi on
        notify-send "Network" "WiFi turned on" -i network-wireless-enabled
    fi
}

# Select network
select_network_func() {
    # Launch network manager applet or nm-connection-editor
    if command -v nm-connection-editor &> /dev/null; then
        nm-connection-editor
    elif command -v nmtui &> /dev/null; then
        alacritty -e nmtui
    else
        notify-send "Error" "No network manager GUI found"
    fi
}

# Show network status
show_status_func() {
    # Get current connection info
    status=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active)
    ip=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)

    if [ -z "$status" ]; then
        notify-send "Network Status" "No active connection" -i network-offline
    else
        notify-send "Network Status" "Active: $status\nIP: $ip" -i network-wired
    fi
}

# Main menu
main() {
    choice=$(echo -e "$toggle_wifi\n$select_network\n$show_status" | rofi_cmd)

    case $choice in
        "$toggle_wifi")
            toggle_wifi_func
            ;;
        "$select_network")
            select_network_func
            ;;
        "$show_status")
            show_status_func
            ;;
    esac
}

# Check if NetworkManager is available
if command -v nmcli &> /dev/null; then
    main
else
    notify-send "Error" "NetworkManager (nmcli) not found"
fi
