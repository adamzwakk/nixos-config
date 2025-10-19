if systemctl --user is-active --quiet hypridle.service; then
    systemctl --user stop hypridle.service
else
    systemctl --user start hypridle.service
fi

# Force Waybar to refresh this module immediately
pkill -RTMIN+9 waybar