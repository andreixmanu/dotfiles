!bin/bash

waybar_pid=$(pgrep -f waybar)
if [ -n "$waybar_pid" ]; then
    kill "$waybar_pid"
fi

waybar &
