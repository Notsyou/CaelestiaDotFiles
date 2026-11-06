#!/usr/bin/env bash
# Applies the MP4 wallpaper patch to caelestia-cli (first-frame colours). Re-run after package updates.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")/patches"
PYSITE=$(python3 -c "import site; print(site.getsitepackages()[0])")
for p in *.patch; do
    target=$(head -1 "$p" | sed 's/^--- //;s/\t.*//')
    target="${target/\/usr\/lib\/python3.14\/site-packages/$PYSITE}"
    if sudo patch -R --dry-run -s -f "$target" < "$p" >/dev/null 2>&1; then
        echo "already patched: $target"
    elif sudo patch --dry-run -s -f "$target" < "$p" >/dev/null; then
        sudo cp "$target" "$target.bak.$(date +%s)"
        sudo patch -s "$target" < "$p" && echo "patched: $target"
    else
        echo "FAILED (upstream changed, patch needs porting): $target" >&2; exit 1
    fi
done
mkdir -p ~/.cache/caelestia/video-thumbs
