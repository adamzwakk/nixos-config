URL=$(wl-paste)

# Simple check for http(s) URLs
if [[ "$URL" =~ ^https?:// ]]; then
    mpv "$URL"
else
    notify-send "mpv-clipboard" "No valid URL in clipboard"
fi