#!/bin/bash
while true; do
  NEW=$(DISPLAY=:1 xclip -selection clipboard -o 2>/dev/null)
  if [ "$NEW" != "$LAST" ] && [ -n "$NEW" ]; then
    LAST="$NEW"
    echo -n "$NEW" | wl-copy
  fi
  sleep 0.5
done
