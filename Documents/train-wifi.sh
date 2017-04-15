#!/bin/sh
# The MIT License (MIT)
#
# Copyright (c) 2017 Adar Nimrod <nimrod@shore.co.il>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Logs in to the Israeli train's wifi.
# Requires: cURL, sh, awk, logger, nmcli.
# To install run:
# sudo cp --preserve=mode train-wifi.sh /etc/NetworkManager/dispatcher.d/90trainwifi

set -eu

die () {
    logger -p user.err $@
    exit 1
}

iswifi () {
    # TODO: Check if a network interface is passed.
    [ "$(nmcli --terse --fields GENERAL.TYPE device show $1 | awk -F: '{print $2}')" = 'wifi' ]
}

wifi_connection () {
    nmcli --terse --fields GENERAL.CONNECTION device show $1 | awk -F: '{print $2}'
}

if [ $# -ne 2 ]
then
    echo "Usage: $0 interface action"
    exit 1
else
    interface="$1"
    action="$2"
fi

which curl > /dev/null || die "Can't login to the train wifi, cURL is not installed."
which awk > /dev/null || die "Can't login to the train wifi, awk is not installed."
which logger > /dev/null || die "Can't login to the train wifi, logger is not installed."
which nmcli > /dev/null || die "Can't login to the train wifi, nmcli is not installed."

[ "$action" = 'up' ] || die "Can't login to the train wifi, action $action isn't up."
iswifi "$interface" || die "Can't login to the train wifi, interface $interface isn't wifi."
connection="$(wifi_connection $interface)"
[ "$connection" = "ISRAEL-RAILWAYS" ] || die "Can't login to the train wifi, wifi network $connection isn't ISRAEL-RAILWAYS."

redirect_url="$(curl --output /dev/null --silent --write-out '%{redirect_url}' http://google.com/)"
logger -p user.debug "Train wifi redirect url: $redirect_url"
login_ip="$(echo "$redirect_url" | grep --only-matching '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*')" || die "Can't login to the train wifi, redirect URL doesn't contain an IP."
logger -p user.debug "Train wifi login IP: $ip"
login_url="http://$ip/loginHandler.php?allowAccess=true"
logger -p user.debug "Train wifi login URL: $login_url"
http_code="$(curl --output /dev/null --silent --write-out '%{http_code}' "$login_url")"
logger -p user.debug "Train wifi login HTTP code: $http_code"
