# Waybar Installation Guide for MangoWM

## Required Packages

### Core Packages (Official Repos)
```bash
sudo pacman -S \
  waybar \
  rofi \
  networkmanager \
  bluez \
  bluez-utils \
  pulseaudio \
  pavucontrol \
  brightnessctl \
  libnotify \
  fastfetch
```

### Optional GUI Tools (Official Repos)
```bash
sudo pacman -S \
  nm-connection-editor \
  blueman \
  swaync
```

### OSD (On-Screen Display) for Sliders

Choose **ONE** of these options:

#### Option 1: SwayOSD (Recommended - from AUR)
Beautiful popup sliders with animations:
```bash
yay -S swayosd-git
# or
paru -S swayosd-git
```

#### Option 2: wob (Simpler - Official Repos)
Minimal overlay bars:
```bash
sudo pacman -S wob
```

If using wob instead of swayosd, you'll need to set it up differently (see wob setup section below).

## Enable Services

### Bluetooth
```bash
sudo systemctl enable --now bluetooth.service
```

### SwayNC (Notifications)
Already starts with autostart.sh, but you can configure it:
```bash
# Default config location
~/.config/swaync/
```

## MangoWM Autostart

The autostart script should already include:
```bash
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
swaybg -i "/home/zayan/dotfiles/backgrounds/Mojave Night.jpg" >/dev/null 2>&1 &
swaync &
swayosd-server &  # For visual sliders
```

## Features & Usage

### 🌐 WiFi Selector
- **Left-click network module**: Opens WiFi selector
  - See all available networks with signal strength
  - Connect to secured networks (password prompt)
  - Toggle WiFi on/off
- **Right-click**: Open nm-connection-editor (advanced settings)

### 📱 Bluetooth Selector
- **Left-click bluetooth module**: Opens Bluetooth selector
  - List paired devices
  - Scan for new devices
  - Pair/Connect/Disconnect
  - Remove devices
- **Right-click**: Open blueman-manager (advanced settings)

### 🔊 Volume Control
- **Scroll up/down** on volume module: Shows slider popup
- **Left-click**: Open pavucontrol (mixer)
- **Right-click**: Mute/unmute toggle

### 🔆 Brightness Control
- **Scroll up/down** on brightness module: Shows slider popup

### 🚀 Pinned Apps (Quicklinks)
- **Firefox** 󰈹
- **Alacritty** 🐟
- **Dolphin** 󰉋
- **Rofi**
- **Obsidian** 󱓷

### 🔔 Notifications
- **Left-click notification icon**: Toggle notification panel
- **Right-click**: Toggle Do Not Disturb mode

### 💻 System Info
- **Click Arch icon**: Opens terminal with fastfetch

## Troubleshooting

### Bluetooth module not showing
```bash
# Check if bluetooth service is running
systemctl status bluetooth

# If not running
sudo systemctl start bluetooth

# Enable permanently
sudo systemctl enable bluetooth
```

### No visual sliders for volume/brightness
```bash
# Check if swayosd-server is running
pgrep swayosd-server

# If not, start it
swayosd-server &

# Or add to autostart.sh (already done)
```

### WiFi selector not working
```bash
# Ensure NetworkManager is running
systemctl status NetworkManager

# Ensure script is executable
chmod +x ~/.config/waybar/scripts/wifi-selector.sh
```

### Bluetooth selector not working
```bash
# Ensure bluetooth service is running
sudo systemctl start bluetooth

# Ensure script is executable
chmod +x ~/.config/waybar/scripts/bluetooth-selector.sh
```

### Notifications not working
```bash
# Install swaync
sudo pacman -S swaync

# Start it
swaync &
```

## Alternative: Using wob Instead of SwayOSD

If you prefer wob (simpler, in official repos):

1. Install wob:
```bash
sudo pacman -S wob
```

2. Create wob config:
```bash
mkdir -p ~/.config/wob
echo "#cba6f7" > ~/.config/wob/wob.ini  # Catppuccin purple
```

3. Start wob in autostart.sh:
```bash
# Replace swayosd-server with:
tail -f "$SWAYSOCK.wob" | wob &
mkfifo "$SWAYSOCK.wob"
```

4. Update waybar config to use wob:
```jsonc
// For volume
"on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | tr -d '%' > $SWAYSOCK.wob",
"on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | tr -d '%' > $SWAYSOCK.wob",

// For brightness
"on-scroll-up": "brightnessctl set 5%+ | grep -oP '\\d+(?=%)' > $SWAYSOCK.wob",
"on-scroll-down": "brightnessctl set 5%- | grep -oP '\\d+(?=%)' > $SWAYSOCK.wob"
```

## Font Requirements

Ensure you have Nerd Fonts installed for icons:
```bash
sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome-6
```

## Restart Waybar

After installation:
```bash
pkill waybar && waybar &
```

Or restart MangoWM to reload autostart.sh.
