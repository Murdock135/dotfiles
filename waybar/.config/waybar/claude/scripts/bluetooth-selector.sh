#!/usr/bin/env bash
# Bluetooth Selector Script with device pairing and connection
# Uses rofi and bluetoothctl

# Check if bluetoothctl is available
if ! command -v bluetoothctl &> /dev/null; then
    notify-send "Bluetooth Error" "bluetoothctl not found"
    exit 1
fi

# Check if rofi is available
if ! command -v rofi &> /dev/null; then
    notify-send "Bluetooth Error" "rofi not found"
    exit 1
fi

# Rofi theme
rofi_cmd() {
    rofi -dmenu -i -p "Bluetooth" \
        -theme-str 'window {width: 450px;}' \
        -theme-str 'listview {lines: 8;}' \
        -theme-str 'element selected {background-color: #89b4fa; text-color: #000000;}'
}

# Get Bluetooth power status
get_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "on"
    else
        echo "off"
    fi
}

# Toggle Bluetooth power
toggle_bluetooth() {
    if [ "$(get_status)" = "on" ]; then
        bluetoothctl power off
        notify-send "Bluetooth" "Bluetooth turned off" -i bluetooth-disabled
    else
        bluetoothctl power on
        notify-send "Bluetooth" "Bluetooth turned on" -i bluetooth-active
    fi
}

# Get paired devices
get_paired_devices() {
    bluetoothctl devices Paired | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | cut -d' ' -f3-)

        # Check if connected
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            echo "󰂱  $name  [Connected]  $mac"
        else
            echo "  $name  [Paired]  $mac"
        fi
    done
}

# Scan for new devices
scan_devices() {
    notify-send "Bluetooth" "Scanning for devices..." -i bluetooth-active

    # Start scanning
    bluetoothctl --timeout 10 scan on &>/dev/null &
    scan_pid=$!

    sleep 10
    kill $scan_pid 2>/dev/null

    # Get discovered devices (not paired)
    bluetoothctl devices | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')

        # Skip if already paired
        if bluetoothctl devices Paired | grep -q "$mac"; then
            continue
        fi

        name=$(echo "$line" | cut -d' ' -f3-)
        echo "  $name  [New]  $mac"
    done
}

# Connect to device
connect_device() {
    local mac=$1
    local name=$2

    notify-send "Bluetooth" "Connecting to $name..." -i bluetooth-active

    if bluetoothctl connect "$mac"; then
        notify-send "Bluetooth" "Connected to $name" -i bluetooth-active
    else
        notify-send "Bluetooth Error" "Failed to connect to $name" -i bluetooth-disabled
    fi
}

# Disconnect device
disconnect_device() {
    local mac=$1
    local name=$2

    if bluetoothctl disconnect "$mac"; then
        notify-send "Bluetooth" "Disconnected from $name" -i bluetooth-disabled
    else
        notify-send "Bluetooth Error" "Failed to disconnect from $name"
    fi
}

# Pair new device
pair_device() {
    local mac=$1
    local name=$2

    notify-send "Bluetooth" "Pairing with $name..." -i bluetooth-active

    # Pair
    if bluetoothctl pair "$mac"; then
        # Trust the device
        bluetoothctl trust "$mac"
        # Try to connect
        if bluetoothctl connect "$mac"; then
            notify-send "Bluetooth" "Paired and connected to $name" -i bluetooth-active
        else
            notify-send "Bluetooth" "Paired but failed to connect to $name" -i bluetooth-active
        fi
    else
        notify-send "Bluetooth Error" "Failed to pair with $name" -i bluetooth-disabled
    fi
}

# Remove device
remove_device() {
    local mac=$1
    local name=$2

    if bluetoothctl remove "$mac"; then
        notify-send "Bluetooth" "Removed $name" -i bluetooth-disabled
    else
        notify-send "Bluetooth Error" "Failed to remove $name"
    fi
}

# Main menu
main_menu() {
    # Build menu
    menu="󰂱  Toggle Bluetooth ($(get_status))\n"
    menu+="󰐊  Scan for New Devices\n"
    menu+="---\n"

    # Add paired devices
    paired=$(get_paired_devices)
    if [ -n "$paired" ]; then
        menu+="$paired\n"
    fi

    # Show menu
    selected=$(echo -e "$menu" | rofi_cmd)

    if [ -z "$selected" ]; then
        exit 0
    fi

    # Handle toggle
    if echo "$selected" | grep -q "Toggle Bluetooth"; then
        toggle_bluetooth
        exit 0
    fi

    # Handle scan
    if echo "$selected" | grep -q "Scan for New"; then
        # Scan and show new devices
        new_devices=$(scan_devices)

        if [ -z "$new_devices" ]; then
            notify-send "Bluetooth" "No new devices found"
            exit 0
        fi

        # Show new devices
        device=$(echo -e "$new_devices" | rofi_cmd)

        if [ -n "$device" ]; then
            mac=$(echo "$device" | awk '{print $NF}')
            name=$(echo "$device" | awk '{for(i=2;i<NF-1;i++) printf $i" "; print ""}' | sed 's/ $//')
            pair_device "$mac" "$name"
        fi
        exit 0
    fi

    # Handle device selection
    if echo "$selected" | grep -q "---"; then
        exit 0
    fi

    # Extract MAC address
    mac=$(echo "$selected" | awk '{print $NF}')
    name=$(echo "$selected" | awk '{for(i=2;i<NF-1;i++) printf $i" "; print ""}' | sed 's/ $//')

    # Show device actions
    if echo "$selected" | grep -q "Connected"; then
        action=$(echo -e "󰆧  Disconnect\n  Remove Device" | rofi_cmd)

        if echo "$action" | grep -q "Disconnect"; then
            disconnect_device "$mac" "$name"
        elif echo "$action" | grep -q "Remove"; then
            disconnect_device "$mac" "$name"
            sleep 1
            remove_device "$mac" "$name"
        fi
    else
        action=$(echo -e "󰂱  Connect\n  Remove Device" | rofi_cmd)

        if echo "$action" | grep -q "Connect"; then
            connect_device "$mac" "$name"
        elif echo "$action" | grep -q "Remove"; then
            remove_device "$mac" "$name"
        fi
    fi
}

# Check if Bluetooth is available
if [ "$(get_status)" = "off" ]; then
    choice=$(echo -e "󰂱  Turn On Bluetooth\n  Cancel" | rofi_cmd)
    if echo "$choice" | grep -q "Turn On"; then
        toggle_bluetooth
        sleep 1
        main_menu
    fi
else
    main_menu
fi
