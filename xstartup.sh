#!/bin/bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

xset -dpms &
xset s noblank &
xset s off &

dconf load / < /mateconfig

exec mate-session &

. /software-start-up.sh