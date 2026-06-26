#!/usr/bin/env bash
set -e

PYSITE=$(python3 -c "import site; print(site.getsitepackages()[0])")
WALL_PY="$PYSITE/caelestia/utils/wallpaper.py"

# ── MP4 Wallpaper Patch ───────────────────────────────────────────────────────

echo "Backing up and patching $WALL_PY"
sudo cp "$WALL_PY" "$WALL_PY.bak.$(date +%s)"
sudo cp patches/wallpaper.py "$WALL_PY"

QML_DIR="/etc/xdg/quickshell/caelestia"
for f in services/Wallpapers.qml modules/launcher/items/WallpaperItem.qml modules/background/Wallpaper.qml; do
  echo "Patching $QML_DIR/$f"
  sudo cp "$QML_DIR/$f" "$QML_DIR/$f.bak.$(date +%s)"
  sudo cp "patches/$(basename "$f")" "$QML_DIR/$f"
done

mkdir -p ~/.config/caelestia ~/.local/bin ~/.cache/caelestia/video-thumbs
cp cli.json ~/.config/caelestia/cli.json
cp caelestia-gen-video-thumbs ~/.local/bin/
chmod +x ~/.local/bin/caelestia-gen-video-thumbs

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

# ── Clipboard Bridge Script ───────────────────────────────────────────────────

echo "Installing clipboard bridge script..."
cp scripts/xwayland-clip-bridge.sh ~/.local/bin/
chmod +x ~/.local/bin/xwayland-clip-bridge.sh

# ── Hyprland Config ───────────────────────────────────────────────────────────

echo ""
echo "NOTE: hypr/hyprland.lua is available but NOT auto-copied."
echo "Edit it to match your monitor setup first, then copy manually:"
echo "  cp hypr/hyprland.lua ~/.config/hypr/hyprland.lua"
echo ""
echo "Done! Restart caelestia shell or your Hyprland session to apply."
echo "Run ~/.local/bin/caelestia-gen-video-thumbs to generate thumbnails for existing videos."
