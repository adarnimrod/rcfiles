#!/bin/sh
set -eu

# Logs in to the Israeli train's wifi.
# To install run:
# sudo cp --preserve=mode "$HOME/Documents/train-wifi.sh" "/etc/NetworkManager/dispatcher.d/90trainwifi"

interface="$1"
status="$2"

if [ "$interface" = "ISRAEL-RAILWAYS" ] && [ "$status" = "up" ]
then
    curl http://10.5.4.1/loginHandler.php?allowAccess=true
fi
