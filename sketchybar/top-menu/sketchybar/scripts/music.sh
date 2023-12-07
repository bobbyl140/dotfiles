#!/usr/bin/env bash

# FIXME: Running an osascript on an application target opens that app
# This sleep is needed to try and ensure that theres enough time to
# quit the app before the next osascript command is called. I assume 
# com.apple.iTunes.playerInfo fires off an event when the player quits
# so it imediately runs before the process is killed
sleep 1

APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then 
    sketchybar --set music-song label.string="Not playing."
    sketchybar --set music-artist drawing=0
    sketchybar --set music-icon icon="􀊆"
    exit 0
fi

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE == "stopped" ]]; then
    sketchybar --set music-song label.string="Not playing."
    sketchybar --set music-artist drawing=0
    sketchybar --set music-icon icon="􀊆"
    exit 0
fi

title=$(osascript -e 'tell application "Music" to get name of current track')
artist=$(osascript -e 'tell application "Music" to get artist of current track')
album=$(osascript -e 'tell application "Music" to get album of current track')
loved=$(osascript -l JavaScript -e "Application('Music').currentTrack().favorited()")
#if [[ $loved ]]; then
#    icon="􀋃"
#fi

if [[ $PLAYER_STATE == "paused" ]]; then
    icon="􀊆"
    sketchybar --set music-icon icon.padding_left=3 icon.padding_right=5
fi

if [[ $PLAYER_STATE == "playing" ]]; then
    icon="􀊄"
    sketchybar --set music-icon icon.padding_left=3 icon.padding_right=3
fi

#if [[ ${#title} -gt 20 ]]; then
#TITLE=$(printf "$(echo $title | cut -c 1-20)…")
#fi

#if [[ ${#artist} -gt 15 ]]; then
#ARTIST=$(printf "$(echo $artist | cut -c 1-15)…")
#fi

#if [[ ${#album} -gt 12 ]]; then
#ALBUM=$(printf "$(echo $album | cut -c 1-12)…")
#fi

sketchybar --set music-icon icon="${icon}"
sketchybar --set music-song label="${title} // ${artist}"
sketchybar --set music-artist label="// ${artist}"
