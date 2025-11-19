#!/usr/bin/env bash
# WiFi Selector Script with SSID selection and authentication
# Uses rofi and NetworkManager

# Check if NetworkManager is available
if ! command -v nmcli &> /dev/null; then
    notify-send "WiFi Error" "NetworkManager (nmcli) not found"
    exit 1
fi

# Check if rofi is available
if ! command -v rofi &> /dev/null; then
    notify-send "WiFi Error" "rofi not found"
    exit 1
fi

# Get WiFi status
wifi_status=$(nmcli radio wifi)

# Toggle WiFi or scan for networks
toggle_wifi() {
    if [ "$wifi_status" = "enabled" ]; then
        nmcli radio wifi off
        notify-send "WiFi" "WiFi turned off" -i network-wireless-disabled
    else
        nmcli radio wifi on
        notify-send "WiFi" "WiFi turned on" -i network-wireless-enabled
    fi
}

# Scan and select WiFi network
select_wifi() {
    # Rescan for networks
    nmcli device wifi rescan 2>/dev/null
    sleep 2

    # Get list of available networks
    # Format: SSID Signal Security
    networks=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2 | \
        awk '{
            ssid = $1;
            signal = $2;
            security = "";
            for(i=3; i<=NF; i++) security = security $i " ";

            # Determine icon based on signal strength
            if (signal >= 80) icon = "󰤨";
            else if (signal >= 60) icon = "󰤥";
            else if (signal >= 40) icon = "󰤢";
            else if (signal >= 20) icon = "󰤟";
            else icon = "󰤯";

            # Security icon
            if (security ~ /WPA/) sec_icon = "";
            else if (security == " ") sec_icon = "󰞀";
            else sec_icon = "";

            printf "%s  %s  %s%%  %s\n", icon, ssid, signal, sec_icon
        }' | sort -rn -k3)

    # Add option to toggle WiFi
    options="󰖩  Toggle WiFi (currently $wifi_status)\n$networks"

    # Show rofi menu
    selected=$(echo -e "$options" | rofi -dmenu -i -p "Select WiFi Network" \
        -theme-str 'window {width: 500px;}' \
        -theme-str 'listview {lines: 10;}' \
        -theme-str 'element selected {background-color: #cba6f7; text-color: #000000;}')

    if [ -z "$selected" ]; then
        exit 0
    fi

    # Handle toggle option
    if echo "$selected" | grep -q "Toggle WiFi"; then
        toggle_wifi
        exit 0
    fi

    # Extract SSID from selection (second field)
    ssid=$(echo "$selected" | awk '{print $2}')

    # Check if network requires password
    security=$(nmcli -f SSID,SECURITY device wifi list | grep "^$ssid" | awk '{print $2}')

    if [ "$security" = "--" ] || [ -z "$security" ]; then
        # Open network, connect directly
        nmcli device wifi connect "$ssid" && \
            notify-send "WiFi" "Connected to $ssid" -i network-wireless-connected || \
            notify-send "WiFi Error" "Failed to connect to $ssid" -i network-wireless-disconnected
    else
        # Secured network, ask for password
        password=$(rofi -dmenu -p "Password for $ssid" -password \
            -theme-str 'window {width: 400px;}')

        if [ -n "$password" ]; then
            nmcli device wifi connect "$ssid" password "$password" && \
                notify-send "WiFi" "Connected to $ssid" -i network-wireless-connected || \
                notify-send "WiFi Error" "Failed to connect to $ssid. Check password." -i network-wireless-disconnected
        fi
    fi
}

# Main
if [ "$wifi_status" = "enabled" ]; then
    select_wifi
else
    # WiFi is off, ask to turn it on
    choice=$(echo -e "󰖩  Turn On WiFi\n  Cancel" | rofi -dmenu -i -p "WiFi is OFF")
    if echo "$choice" | grep -q "Turn On"; then
        toggle_wifi
        sleep 1
        select_wifi
    fi
fi
