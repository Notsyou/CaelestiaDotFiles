#!/usr/bin/env bash
set -e

PYSITE=$(python3 -c "import site; print(site.getsitepackages()[0])")
WALL_PY="$PYSITE/caelestia/utils/wallpaper.py"

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

echo "Done. Restart caelestia shell (or your Hyprland session) to apply."
echo "Run ~/.local/bin/caelestia-gen-video-thumbs to generate thumbnails for existing videos."
