# Waybar Configuration for MangoWM

A macOS-inspired glassmorphic Waybar configuration designed specifically for MangoWM window manager.

## Features

- **Glassmorphic Design**: Modern, translucent UI with blur effects
- **Workspace Indicators**: Numbered circles (1-9) with contrasting colors
- **Interactive Control Panels**: Click-to-open menus for system controls
- **Smooth Animations**: macOS-style transitions and hover effects
- **MangoWM Integration**: Native support for MangoWM tags/workspaces

## Module Layout

### Left Side
- **Arch Linux Icon**: Application launcher (opens rofi)
- **Workspace Tags**: 9 circular numbered indicators

### Center
- **Window Title**: Shows active window name (icon only)

### Center-Right
- **Clock**: Date and time with calendar popup

### Right Side
- **Bluetooth**: Connection status with control menu
- **Network**: WiFi/Ethernet/Disconnected status with network menu
- **Volume**: Audio control with slider and device selection
- **Brightness**: Screen brightness control with presets
- **Power Menu**: Shutdown/Reboot/Suspend/Logout/Lock options

## Installation

### Dependencies

Required packages:
```bash
# Arch Linux / Manjaro
sudo pacman -S waybar rofi brightnessctl networkmanager pulseaudio bluez bluez-utils

# IMPORTANT: Waybar 0.14.0+ required for ext/workspaces module support
# Check version: waybar --version

# Optional but recommended
sudo pacman -S pavucontrol blueman nm-connection-editor
sudo pacman -S ttf-font-awesome ttf-jetbrains-mono-nerd
```

### Setup

1. Copy configuration to your home directory:
```bash
cp -r ~/.config/waybar ~/path/to/dotfiles/waybar/.config/waybar
```

2. Ensure scripts are executable:
```bash
chmod +x ~/.config/waybar/scripts/*.sh
```

3. Add to MangoWM autostart (already configured):
```bash
# In ~/.config/mango/autostart.sh
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
```

4. Restart Waybar:
```bash
pkill waybar && waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
```

## Customization

### Colors

The color scheme uses MangoWM's cyan focus color (`#42f5dd`). Edit `style.css` to customize:

```css
/* Active workspace color */
#ext-workspaces button.focused {
    background: linear-gradient(135deg, #42f5dd 0%, #36c9b5 100%);
}

/* Main window background */
window#waybar {
    background: rgba(20, 20, 30, 0.85);
}
```

### Workspace Module

MangoWM uses the `ext/workspaces` module (requires Waybar 0.14.0+) for workspace management. If you're using an older version of Waybar or experience issues, you can alternatively use:

- `dwl/tags` - Legacy DWL module for tags (built into MangoWM)
- `wlr/workspaces` - Generic wlroots support (may have limited functionality)

Edit `config.jsonc`:
```json
// Option 1: ext/workspaces (recommended, requires Waybar 0.14.0+)
"modules-left": [
    "custom/arch",
    "ext/workspaces"
],

// Option 2: dwl/tags (legacy, works with older Waybar versions)
"modules-left": [
    "custom/arch",
    "dwl/tags"
],
```

For the window title module, use `dwl/window`:
```json
"modules-center": [
    "dwl/window"
],
```

### Scripts

All control panel scripts are located in `scripts/` directory:

- `power-menu.sh`: Power management options
- `bluetooth-menu.sh`: Bluetooth device control
- `network-menu.sh`: Network connection management
- `volume-menu.sh`: Audio output and volume control
- `brightness-menu.sh`: Screen brightness presets

Customize these scripts to match your system's specific tools and preferences.

## Troubleshooting

### Waybar doesn't start
- Check Waybar logs: `journalctl --user -u waybar`
- Verify config syntax: `waybar -c ~/.config/waybar/config.jsonc --log-level debug`

### Workspaces not showing
- MangoWM uses `ext/workspaces` module which requires Waybar 0.14.0+
- Check Waybar version: `waybar --version`
- If using older Waybar, switch to `dwl/tags` module (see Customization section)
- Alternatively, use `wlr/workspaces` for generic wlroots support

### Icons not displaying
- Install Nerd Fonts: `sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome`
- Verify font configuration in `style.css`

### Scripts not working
- Ensure scripts have execute permissions: `chmod +x ~/.config/waybar/scripts/*.sh`
- Check dependencies (rofi, brightnessctl, nmcli, pactl, bluetoothctl)

### Lock screen command
The power menu uses `hyprlock` or `swaylock`. Adjust in `scripts/power-menu.sh`:
```bash
# For different lock screens:
swaylock -f          # Swaylock
hyprlock             # Hyprlock
gtklock              # GTKLock
```

## Configuration Files

```
waybar/
├── config.jsonc          # Main configuration
├── style.css            # Glassmorphic styling
├── scripts/
│   ├── power-menu.sh
│   ├── bluetooth-menu.sh
│   ├── network-menu.sh
│   ├── volume-menu.sh
│   └── brightness-menu.sh
└── README.md
```

## Keyboard Shortcuts

Configure in MangoWM config (`~/.config/mango/config.conf`):

```conf
# Example: Toggle Waybar visibility
bind=SUPER,b,exec,pkill -SIGUSR1 waybar
```

## Credits

Design inspired by:
- macOS Big Sur menu bar
- [mrinmoyin's dotfiles](https://gitlab.com/mrinmoyin/dotfiles)
- [woioeow's Hyprland dotfiles](https://github.com/woioeow/hyprland-dotfiles)

## License

MIT License - Feel free to customize and share!
