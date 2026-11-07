# CaelestiaDotFiles

My personal dotfiles for CachyOS + Hyprland + Caelestia shell. Includes MP4 wallpaper support, Hyprland config, and GTK/Thunar theming.

## What's included

### MP4/Video Wallpaper Support
Uses `caelestia-shell-git`'s built-in video wallpapers and wallpaper transitions (set to `DirectionalWipe`). A small `caelestia-cli` patch lets it take colours from a video's first frame.

### Hyprland Config (`hypr/hyprland.lua`)
- Monitor set to the laptop's eDP-1 @ 144hz; change it to match your displays
- Catppuccin Mocha border colors
- Custom keybindings
- Autostart for waybar, caelestia shell, wl-clip-persist

### GTK/Thunar Theme (`gtk/`)
- Dark theme matching Caelestia's Catppuccin Mocha colors
- Custom Thunar file manager styling
- Dark context menus, toolbars, and dropdowns

### Caelestia Templates (`caelestia-templates/`)
- Patched `gtk.css` and `thunar.css` templates so dark theme persists after Caelestia regenerates them

---

## Requirements

- `caelestia-cli` and `caelestia-shell-git` (AUR). The stable `caelestia-shell` 2.5.0 has no video wallpapers or `wallpaperTransition`, and `install.sh` stops if it finds it
- `ffmpeg`
- `thunar`
- `tumbler` + `ffmpegthumbnailer` (for thumbnails)
- `wl-clip-persist`
- `wtype` (for the `Super + W` wallpaper picker)

```bash
sudo pacman -S --needed ffmpeg thunar tumbler ffmpegthumbnailer wl-clip-persist wtype
```

---

## Install

```bash
git clone https://github.com/Notsyou/CaelestiaDotFiles.git
cd CaelestiaDotFiles
./install.sh
```

This will:
- Back up and patch `caelestia-cli` (via `apply-video-patches.sh`)
- Install `~/.config/caelestia/cli.json`
- Install `scripts/open-wallpaper.sh` to `~/.local/bin`
- Turn on `background.enabled` and `background.wallpaperEnabled`, and set `background.wallpaperTransition`, in `~/.config/caelestia/shell.json`

### Manual steps after install

**Hyprland config:**
Edit the `hl.monitor` lines first: the file is set to a laptop's `eDP-1`, so copying it unchanged will misconfigure other displays. Then:
```bash
cp hypr/hyprland.lua ~/.config/hypr/hyprland.lua
```

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
| `Super + W` | Caelestia launcher in `>wallpaper` mode |
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

Or pick from the `>wallpaper` launcher (`Super + W`).

### How it works
- `caelestia-shell` plays videos and runs the transition itself. To change the effect, set `background.wallpaperTransition` in `~/.config/caelestia/shell.json` (for example `Iris`, `Smoke` or `Crossfade`).
- `patches/cli-wallpaper.py.patch` is a unified diff against `caelestia-cli` 1.1.3. It accepts video files and uses the first frame for colour generation.

---

## Notes

- Caelestia package updates will overwrite patched files — re-run `./apply-video-patches.sh` (safe to re-run; skips already-patched files) and re-copy caelestia templates after updates. If it reports `FAILED`, upstream changed that file and the patch needs porting.
- Monitor config in `hyprland.lua` is set for a laptop's `eDP-1`, adjust to yours.
- GTK theme uses Caelestia's Catppuccin Mocha color variables.

### Clipboard
Hyprland syncs the clipboard between Wayland and XWayland apps natively; `wl-clip-persist` keeps it alive after the source app closes. Don't run extra sync tools (`clipboard-sync`, polling `xclip`/`wl-copy` bridges) — they fight each other and wipe or strip the clipboard.
