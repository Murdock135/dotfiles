#!/usr/bin/env bash
# Power Menu Script for Waybar
# macOS-inspired power menu using rofi

# Define options
shutdown="󰐥  Shutdown"
reboot="󰑓  Reboot"
suspend="󰒲  Suspend"
logout="󰍃  Logout"
lock="  Lock"

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "Power Menu" \
        -theme-str 'window {width: 300px; padding: 12px;}' \
        -theme-str 'listview {lines: 5;}' \
        -theme-str 'element {padding: 8px; border-radius: 8px;}' \
        -theme-str 'element selected {background-color: #42f5dd; text-color: #0f0f1a;}'
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    case $1 in
        --shutdown)
            systemctl poweroff
            ;;
        --reboot)
            systemctl reboot
            ;;
        --suspend)
            systemctl suspend
            ;;
        --logout)
            # MangoWM quit command (adjust based on your WM)
            # For MangoWM, you might need to use a specific command
            pkill -KILL -u "$USER"
            ;;
        --lock)
            # Use swaylock, hyprlock, or another locker
            if command -v hyprlock &> /dev/null; then
                hyprlock
            elif command -v swaylock &> /dev/null; then
                swaylock -f
            else
                notify-send "Lock Error" "No lock screen application found"
            fi
            ;;
    esac
}

# Show rofi menu and get choice
chosen="$(run_rofi)"

# Run command based on choice
case ${chosen} in
    "$shutdown")
        run_cmd --shutdown
        ;;
    "$reboot")
        run_cmd --reboot
        ;;
    "$suspend")
        run_cmd --suspend
        ;;
    "$logout")
        run_cmd --logout
        ;;
    "$lock")
        run_cmd --lock
        ;;
esac
