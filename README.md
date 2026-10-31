# CaelestiaDotFiles

My personal dotfiles for CachyOS + Hyprland + Caelestia shell. Includes MP4 wallpaper support, Hyprland config, and GTK/Thunar theming.

## What's included

### MP4/Video Wallpaper Support
Patches Caelestia to accept video files as wallpapers using `mpvpaper`, with an `awww` wipe transition on every wallpaper change (seamless from whatever frame is currently playing).

### Hyprland Config (`hypr/hyprland.lua`)
- Dual monitor setup (DP-3 @ 180hz + HDMI-A-1 @ 144hz portrait)
- Catppuccin Mocha border colors
- Custom keybindings
- Autostart for waybar, mpvpaper, caelestia shell, wl-clip-persist

### GTK/Thunar Theme (`gtk/`)
- Dark theme matching Caelestia's Catppuccin Mocha colors
- Custom Thunar file manager styling
- Dark context menus, toolbars, and dropdowns

### Caelestia Templates (`caelestia-templates/`)
- Patched `gtk.css` and `thunar.css` templates so dark theme persists after Caelestia regenerates them

---

## Requirements

- `caelestia-cli` and `caelestia-shell`
- `mpvpaper`
- `awww` (formerly `swww`)
- `socat`
- `ffmpeg`
- `thunar`
- `tumbler` + `ffmpegthumbnailer` (for thumbnails)
- `wl-clip-persist`

```bash
sudo pacman -S --needed mpvpaper awww socat ffmpeg thunar tumbler ffmpegthumbnailer wl-clip-persist
```

---

## Install

```bash
git clone https://github.com/Notsyou/CaelestiaDotFiles.git
cd CaelestiaDotFiles
./install.sh
```

This will:
- Back up and patch the relevant Caelestia files (via `apply-video-patches.sh`)
- Install `~/.config/caelestia/cli.json`
- Install `~/.local/bin/caelestia-wallpaper-hook` (transition + mpvpaper, run by Caelestia's `postHook`)

### Manual steps after install

**Hyprland config:**
```bash
cp hypr/hyprland.lua ~/.config/hypr/hyprland.lua
```
> Edit the monitor lines to match your setup before using.

**GTK/Thunar theme:**
```bash
cp gtk/gtk.css ~/.config/gtk-3.0/gtk.css
cp gtk/thunar.css ~/.config/gtk-3.0/thunar.css
```

**Caelestia templates (persistent dark theme):**
```bash
sudo cp caelestia-templates/gtk.css /usr/lib/python3.14/site-packages/caelestia/data/templates/gtk.css
sudo cp caelestia-templates/thunar.css /usr/lib/python3.14/site-packages/caelestia/data/templates/thunar.css
```
> Re-run after `caelestia-cli` updates since package updates overwrite these.

---

## Keybindings

| Keybind | Action |
|---|---|
| `Super + Return` | Terminal (kitty) |
| `Super + E` | File manager (thunar) |
| `Super + R` | App launcher (hyprlauncher) |
| `Super + B` | Firefox |
| `Super + D` | Caelestia launcher |
| `Super + W` | Wallpaper picker |
| `Super + Q` | Close window |
| `Super + M` | Shutdown |
| `Super + V` | Toggle float |
| `Super + P` | Pseudo tile |
| `Super + J` | Toggle split |
| `Super + S` | Scratchpad |
| `Super + Shift + S` | Move to scratchpad |
| `Super + Alt + S` | Screenshot selection → clipboard |
| `Super + Alt + F` | Screenshot → ~/Pictures |
| `Super + Arrow keys` | Move focus |
| `Super + 1-10` | Switch workspace |
| `Super + Shift + 1-10` | Move window to workspace |

---

## Video Wallpapers

```bash
caelestia wallpaper -f /path/to/video.mp4
```

Or pick from the `>wallpaper` launcher (`Super + W`). Picker thumbnails are generated automatically the first time a video is set.

### How it works
- `patches/*.patch` are unified diffs against `caelestia-shell` 2.5.0 / `caelestia-cli` 1.1.3. They add video files to the picker, video thumbnails, skip drawing videos in Caelestia's own background, and use the first frame for colour generation.
- `caelestia-wallpaper-hook` pauses each monitor's mpvpaper, grabs the exact current frame (`playback-time` over IPC + `ffmpeg -ss`), shows it on `awww`, wipes to the new wallpaper (`--transition-type wipe --transition-angle 225 --transition-step 90`), then starts one mpvpaper per monitor if the new wallpaper is a video.

---

## Notes

- Caelestia package updates will overwrite patched files — re-run `./apply-video-patches.sh` (safe to re-run; skips already-patched files) and re-copy caelestia templates after updates. If it reports `FAILED`, upstream changed that file and the patch needs porting.
- Monitor config in `hyprland.lua` is specific to my setup, adjust to yours.
- GTK theme uses Caelestia's Catppuccin Mocha color variables.

### Clipboard
Hyprland syncs the clipboard between Wayland and XWayland apps natively; `wl-clip-persist` keeps it alive after the source app closes. Don't run extra sync tools (`clipboard-sync`, polling `xclip`/`wl-copy` bridges) — they fight each other and wipe or strip the clipboard.
