#!/usr/bin/env bash

# Muestra info del reproductor activo (Spotify, YouTube, etc.)
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)

    if [ -n "$artist" ] && [ -n "$title" ]; then
        echo "$artist - $title"
    else
        echo "🎵 Playing"
    fi
else
    echo ""
fi
