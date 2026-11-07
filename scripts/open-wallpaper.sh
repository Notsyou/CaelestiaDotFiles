#!/usr/bin/env bash
# Opens the Caelestia launcher in wallpaper mode. The shell has no IPC to prefill the search, so type it.
if [ "$(caelestia shell drawers isOpen launcher)" = "1" ]; then
    caelestia shell drawers toggle launcher
    exit
fi
caelestia shell drawers toggle launcher
sleep 0.2
wtype ">wallpaper "
