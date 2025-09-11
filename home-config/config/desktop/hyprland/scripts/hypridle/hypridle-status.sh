status=$(systemctl --user is-active hypridle.service)

if [ "$status" = "active" ]; then
    echo '{"text":"󰒱","tooltip":"Hypridle enabled","class":"on"}'
else
    echo '{"text":"󰒲","tooltip":"Hypridle disabled","class":"off"}'
fi