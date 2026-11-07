#!/usr/bin/env bash
set -e

PYSITE=$(python3 -c "import site; print(site.getsitepackages()[0])")

# Stable caelestia-shell 2.5.0 has no built-in video wallpapers or transitions
if ! grep -qs wallpaperTransition /usr/lib/qt6/qml/Caelestia/Config/caelestia-config.qmltypes; then
    echo "This setup needs a caelestia-shell with video wallpapers: install caelestia-shell-git from the AUR, then re-run." >&2
    exit 1
fi

# ── MP4 Wallpaper Patch ───────────────────────────────────────────────────────

echo "Installing wallpaper dependencies..."
sudo pacman -S --needed ffmpeg

# Applies diffs (not whole files) so a Caelestia update that changes them fails loudly
./apply-video-patches.sh

mkdir -p ~/.config/caelestia ~/.cache/caelestia/video-thumbs
cp cli.json ~/.config/caelestia/cli.json

# Enable the shell's wallpaper and built-in wipe, keeping any existing shell.json settings
python3 - <<'PY'
import json, os
p = os.path.expanduser("~/.config/caelestia/shell.json")
cfg = json.load(open(p)) if os.path.exists(p) else {}
bg = cfg.setdefault("background", {})
bg.update(enabled=True, wallpaperEnabled=True, wallpaperTransition="DirectionalWipe")
json.dump(cfg, open(p, "w"), indent=4)
PY

# Install Thunar and essential plugins
echo "Installing Thunar file manager..."
sudo pacman -S --needed thunar thunar-archive-plugin thunar-volman gvfs

# ── GTK / Thunar Theme ────────────────────────────────────────────────────────

echo "Installing GTK and Thunar theme..."
mkdir -p ~/.config/gtk-3.0
cp gtk/gtk.css ~/.config/gtk-3.0/gtk.css
cp gtk/thunar.css ~/.config/gtk-3.0/thunar.css

# ── Caelestia Templates (persistent dark theme) ───────────────────────────────

echo "Patching Caelestia GTK templates..."
TMPL_DIR="$PYSITE/caelestia/data/templates"
sudo cp "$TMPL_DIR/gtk.css" "$TMPL_DIR/gtk.css.bak.$(date +%s)"
sudo cp "$TMPL_DIR/thunar.css" "$TMPL_DIR/thunar.css.bak.$(date +%s)"
sudo cp caelestia-templates/gtk.css "$TMPL_DIR/gtk.css"
sudo cp caelestia-templates/thunar.css "$TMPL_DIR/thunar.css"

# ── Hyprland Config ───────────────────────────────────────────────────────────

echo ""
echo "NOTE: hypr/hyprland.lua is available but NOT auto-copied."
echo "Edit it to match your monitor setup first, then copy manually:"
echo "  cp hypr/hyprland.lua ~/.config/hypr/hyprland.lua"
echo ""
echo "Done! Restart caelestia shell or your Hyprland session to apply."
