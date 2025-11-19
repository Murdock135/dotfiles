# Waybar Configuration for MangoWM

A clean, GTK3-compatible Waybar configuration for MangoWM window manager with Catppuccin-inspired colors.

## Features

- **MangoWM Integration**: Uses `ext/workspaces` and `dwl/window` modules
- **GTK3 Compatible**: Only uses CSS properties supported by GTK3
- **Clean Design**: Transparent background with rounded corners
- **Color-Coded Modules**: Easy-to-read status indicators
- **Interactive Scripts**: Power, bluetooth, network, volume, and brightness controls

## Module Layout

### Left Side
- Arch Linux icon (application launcher)
- Workspace indicators (clickable numbers)

### Center
- Window title

### Right Side
- Clock (date + time)
- Bluetooth status
- Network status
- Volume control
- Brightness control
- Power menu

## Installation

### Dependencies

```bash
# Required packages (Arch Linux)
sudo pacman -S waybar rofi brightnessctl networkmanager pulseaudio bluez bluez-utils

# IMPORTANT: Waybar 0.14.0+ required for ext/workspaces support
waybar --version

# Optional but recommended
sudo pacman -S pavucontrol blueman nm-connection-editor
sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome-6
```

### Setup

1. Ensure scripts are executable:
```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

2. Add to MangoWM autostart (`~/.config/mango/autostart.sh`):
```bash
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
```

3. Restart Waybar:
```bash
pkill waybar && waybar &
```

## Customization

### Colors

The config uses Catppuccin Mocha colors. Edit `style.css`:

```css
/* Main background */
window#waybar {
    background-color: rgba(30, 30, 46, 0.9);  /* Dark with transparency */
}

/* Active workspace */
#ext/workspaces button.active {
    background-color: #42f5dd;  /* MangoWM cyan */
}
```

### Compositor Blur

For glassmorphic effect, enable blur in MangoWM config (`~/.config/mango/config.conf`):

```conf
blur=1
blur_layer=1
blur_params_radius = 5
```

### Workspace Module

If using older Waybar (< 0.14.0), switch to legacy `dwl/tags` module:

```json
"modules-left": [
    "custom/arch",
    "dwl/tags"  // Instead of ext/workspaces
],
```

### Scripts

Control panel scripts in `scripts/` directory:
- `power-menu.sh` - Shutdown/reboot/suspend/logout/lock
- `bluetooth-menu.sh` - Bluetooth device management
- `network-menu.sh` - Network connection controls
- `volume-menu.sh` - Audio output and volume control
- `brightness-menu.sh` - Screen brightness presets

## Troubleshooting

### Waybar doesn't start
```bash
# Check logs
waybar --log-level debug

# Verify config syntax
jsonlint config.jsonc
```

### Workspaces not showing
- Requires Waybar 0.14.0+ for `ext/workspaces`
- Check version: `waybar --version`
- Fallback: Use `dwl/tags` module (see Customization)

### Icons not displaying
```bash
# Install Nerd Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome-6

# Verify font installation
fc-list | grep -i "jetbrains"
```

### Scripts not working
```bash
# Make executable
chmod +x ~/.config/waybar/scripts/*.sh

# Check dependencies
which rofi brightnessctl nmcli pactl bluetoothctl
```

## GTK CSS Limitations

GTK3's CSS parser has limitations compared to web browsers. This config uses **only supported properties**:

✅ Supported:
- `color`, `background-color`, `opacity`
- `font-family`, `font-size`, `font-weight`
- `padding`, `margin`, `border`, `border-radius`
- `min-width`, `min-height`, `max-width`, `max-height`

❌ Not supported (removed from this config):
- `backdrop-filter` - Use compositor blur instead
- `transform` - Scale/translate/rotate effects
- `@keyframes` / `animation` - Can cause parsing errors

## Files

```
waybar/
├── config.jsonc       # Main configuration
├── style.css          # GTK3-compatible styling
├── scripts/
│   ├── power-menu.sh
│   ├── bluetooth-menu.sh
│   ├── network-menu.sh
│   ├── volume-menu.sh
│   └── brightness-menu.sh
└── README.md
```

## Credits

- Colors inspired by [Catppuccin](https://github.com/catppuccin/catppuccin)
- MangoWM focus color (#42f5dd)
- GTK3-compatible CSS design

## License

MIT
