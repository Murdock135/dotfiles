#!/usr/bin/env bash
# Bluetooth Control Panel Script for Waybar
# Provides quick access to bluetooth controls

# Check if bluetooth is available
if ! command -v bluetoothctl &> /dev/null; then
    notify-send "Bluetooth Error" "bluetoothctl not found"
    exit 1
fi

# Define options
toggle="  Toggle Bluetooth"
devices="  Show Devices"
scan="  Scan for Devices"

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "Bluetooth" \
        -theme-str 'window {width: 350px; padding: 12px;}' \
        -theme-str 'listview {lines: 3;}' \
        -theme-str 'element {padding: 8px; border-radius: 8px;}' \
        -theme-str 'element selected {background-color: #61afef; text-color: #0f0f1a;}'
}

# Get bluetooth status
get_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo "on"
    else
        echo "off"
    fi
}

# Toggle bluetooth
toggle_bluetooth() {
    if [ "$(get_status)" = "on" ]; then
        bluetoothctl power off
        notify-send "Bluetooth" "Bluetooth turned off" -i bluetooth-disabled
    else
        bluetoothctl power on
        notify-send "Bluetooth" "Bluetooth turned on" -i bluetooth-active
    fi
}

# Show connected devices
show_devices() {
    devices=$(bluetoothctl devices | cut -d' ' -f3-)
    if [ -z "$devices" ]; then
        notify-send "Bluetooth" "No devices paired"
    else
        notify-send "Bluetooth Devices" "$devices"
    fi
}

# Scan for devices
scan_devices() {
    notify-send "Bluetooth" "Scanning for devices..." -i bluetooth-active
    bluetoothctl scan on &
    sleep 5
    bluetoothctl scan off
    notify-send "Bluetooth" "Scan complete"
}

# Main menu
main() {
    choice=$(echo -e "$toggle\n$devices\n$scan" | rofi_cmd)

    case $choice in
        "$toggle")
            toggle_bluetooth
            ;;
        "$devices")
            show_devices
            ;;
        "$scan")
            scan_devices
            ;;
    esac
}

# Check if rofi is installed, fallback to blueman if available
if command -v rofi &> /dev/null; then
    main
elif command -v blueman-manager &> /dev/null; then
    blueman-manager
else
    notify-send "Error" "Neither rofi nor blueman-manager found"
fi
