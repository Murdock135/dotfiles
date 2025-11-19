#!/usr/bin/env bash
# Volume Control Menu Script for Waybar
# Provides volume slider and output device selection

# Define options
output_devices="  Output Devices"
mute_toggle="󰖁  Toggle Mute"
volume_up="  Increase Volume"
volume_down="  Decrease Volume"

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -i \
        -p "Volume" \
        -theme-str 'window {width: 350px; padding: 12px;}' \
        -theme-str 'listview {lines: 4;}' \
        -theme-str 'element {padding: 8px; border-radius: 8px;}' \
        -theme-str 'element selected {background-color: #fac863; text-color: #0f0f1a;}'
}

# Toggle mute
toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
        notify-send "Volume" "Muted" -i audio-volume-muted
    else
        volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
        notify-send "Volume" "Unmuted ($volume)" -i audio-volume-high
    fi
}

# Increase volume
increase_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
    notify-send "Volume" "Increased to $volume" -i audio-volume-high
}

# Decrease volume
decrease_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
    notify-send "Volume" "Decreased to $volume" -i audio-volume-low
}

# Show output devices
show_outputs() {
    if command -v pavucontrol &> /dev/null; then
        pavucontrol &
    else
        notify-send "Error" "pavucontrol not found"
    fi
}

# Main menu
main() {
    choice=$(echo -e "$mute_toggle\n$volume_up\n$volume_down\n$output_devices" | rofi_cmd)

    case $choice in
        "$mute_toggle")
            toggle_mute
            ;;
        "$volume_up")
            increase_volume
            ;;
        "$volume_down")
            decrease_volume
            ;;
        "$output_devices")
            show_outputs
            ;;
    esac
}

# Check if PulseAudio/PipeWire is available
if command -v pactl &> /dev/null; then
    main
else
    notify-send "Error" "PulseAudio/PipeWire (pactl) not found"
fi
