#!/usr/bin/env bash
# Brightness Control Menu Script for Waybar
# Provides brightness slider and presets

# Define options
brightness_max="  100% Brightness"
brightness_high="  75% Brightness"
brightness_medium="  50% Brightness"
brightness_low="  25% Brightness"
brightness_min="  10% Brightness"

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "Brightness" \
        -theme-str 'window {width: 350px; padding: 12px;}' \
        -theme-str 'listview {lines: 5;}' \
        -theme-str 'element {padding: 8px; border-radius: 8px;}' \
        -theme-str 'element selected {background-color: #e5c07b; text-color: #0f0f1a;}'
}

# Set brightness
set_brightness() {
    local value=$1
    brightnessctl set "${value}%"
    notify-send "Brightness" "Set to ${value}%" -i display-brightness-symbolic
}

# Main menu
main() {
    # Get current brightness
    current=$(brightnessctl get)
    max=$(brightnessctl max)
    percent=$((current * 100 / max))

    choice=$(echo -e "$brightness_max\n$brightness_high\n$brightness_medium\n$brightness_low\n$brightness_min" | rofi_cmd)

    case $choice in
        "$brightness_max")
            set_brightness 100
            ;;
        "$brightness_high")
            set_brightness 75
            ;;
        "$brightness_medium")
            set_brightness 50
            ;;
        "$brightness_low")
            set_brightness 25
            ;;
        "$brightness_min")
            set_brightness 10
            ;;
    esac
}

# Check if brightnessctl is available
if command -v brightnessctl &> /dev/null; then
    main
else
    notify-send "Error" "brightnessctl not found"
fi
