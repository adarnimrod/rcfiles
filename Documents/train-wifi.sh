#!/bin/sh
set -eu
# The MIT License (MIT)
#
# Copyright (c) 2016 Adar Nimrod <nimrod@shore.co.il>
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
# Requires: cURL, sh, awk, logger.
# To install run:
# sudo cp --preserve=mode train-wifi.sh /etc/NetworkManager/dispatcher.d/90trainwifi

die () {
    echo $@ | logger
    exit 1
}

debug () {
    [ -n ${DEBUG:+x} ] && echo $@ | logger
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
which logger > /dev/null || dir "Can't login to the train wifi, logger is not installed."

if [ "$interface" = "ISRAEL-RAILWAYS" ] && [ "$action" = "up" ]
then
    redirect_url="$(curl --output /dev/null --silent --write-out '%{redirect_url}' http://google.com/)"
    debug "Train wifi redirect url: $redirect_url"
    login_url="$(echo "$redirect_url" | awk -F\? '{printf("%s?allowAccess=true", $1)}' )"
    debug "Train wifi login url: $login_url"
    curl "$login_url"
else
    debug "Interface isn't ISRAEL-RAILWAYS or action isn't up, not signing in to the train wifi."
fi
