# Caelestia MP4 Wallpapers

Adds MP4/video wallpaper support to the Caelestia dotfiles (CachyOS + Hyprland +
Quickshell/Caelestia shell + caelestia-cli), using `mpvpaper` to render the
video and patching the CLI/shell so videos behave like normal wallpapers in
the `>wallpaper` picker (including thumbnails).

## Requirements

- `caelestia-cli` and `caelestia-shell` (already installed)
- `mpvpaper`
- `ffmpeg`

Install missing deps:

```bash
sudo pacman -S --needed mpvpaper ffmpeg
```

## What this does

- Patches `caelestia.utils.wallpaper` (python) to accept video files
  (`.mp4`, `.mkv`, `.webm`, `.mov`, `.m4v`) in `caelestia wallpaper -f`,
  generating a first-frame thumbnail for the colour scheme.
- Sets a `postHook` in `~/.config/caelestia/cli.json` that launches
  `mpvpaper` (looping, muted, hw-decoded) on the selected video, and
  auto-generates a `~/.cache/caelestia/video-thumbs/<filename>.jpg`
  preview thumbnail.
- Patches the Quickshell `Wallpapers.qml` file model to list video files,
  not just images.
- Patches `WallpaperItem.qml` (picker grid) to show the generated thumbnail
  for videos, falling back to a movie icon if none exists yet.
- Patches `Wallpaper.qml` (background renderer) to skip trying to load
  video files as static images, letting `mpvpaper`'s layer show through.

## Install

```bash
git clone https://github.com/Notsyou/CaelestiaDotFiles.git
cd CaelestiaDotFiles
./install.sh
```

This will:
- Back up and patch the relevant files (with timestamped `.bak` copies)
- Install `~/.config/caelestia/cli.json`
- Install `~/.local/bin/caelestia-gen-video-thumbs`

Then restart Hyprland / the Caelestia shell (or run `caelestia shell`
after killing the running instance) to apply the QML changes.

## Generating thumbnails for existing videos

New videos get a thumbnail generated automatically the first time you
select them as wallpaper. To pre-generate thumbnails for everything in
`~/Pictures/Wallpapers/` at once:

```bash
~/.local/bin/caelestia-gen-video-thumbs
```

If you rename a video file, its old thumbnail will not match the new name —
rerun the script above to regenerate.

## Usage

```bash
caelestia wallpaper -f /path/to/video.mp4
```

or pick it from the `>wallpaper` launcher like any other wallpaper.

## Notes / caveats

- `caelestia-cli` / `caelestia-shell` package updates will overwrite the
  patched files in `/usr/lib/python3.*/site-packages/caelestia` and
  `/etc/xdg/quickshell/caelestia`. Re-run `./install.sh` after such updates.
- Video extensions supported: `.mp4`, `.mkv`, `.webm`, `.mov`, `.m4v`.
  Add more by editing `patches/wallpaper.py` (`VIDEO_EXTS`),
  `patches/Wallpapers.qml` (`nameFilters`), and
  `patches/WallpaperItem.qml` / `patches/Wallpaper.qml` (`isVideo` arrays).
