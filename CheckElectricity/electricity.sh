#!/bin/bash
ELECTRICITY="Electricity is down"
ELECTRICITYUP="Electricity is up"
MESSAGE=$(date '+%Y-%m-%d %H:%M:%S')
PRIORITY=5
FAILCOUNTER=2 #Count fails for redundancy
URL="http://192.168.1.102:8080/message?token=A1hUZtU1CMJv3bk" #Locally hosted Gotify Server URL
read internet_was_up_before </home/orangepi/scripts/internet_was_up_before.txt
read was_internet_down </home/orangepi/scripts/was_internet_down.txt
read count_fails </home/orangepi/scripts/count_fails.txt
ping -c 20 192.168.1.2 # Try once.
rc=$?
ping -c 20 192.168.1.3 # Try once.
mc=$?
if [ "$rc" -eq 0 ] || [ "$mc" -eq 0 ]; then #Pings two routers for redundancy
    echo "success: $MESSAGE"
    if $was_internet_down; then
        curl -s -S --data '{"message": "'"${MESSAGE}"'", "title": "'"${ELECTRICITYUP}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
        internet_was_up_before=true
        was_internet_down=false
        echo $was_internet_down >/home/orangepi/scripts/was_internet_down.txt
        echo $internet_was_up_before >/home/orangepi/scripts/internet_was_up_before.txt
    fi
else
    echo "error: $MESSAGE"
    if ! $was_internet_down; then #Prevents Fail Counter from increasing once failed
        count_fails=$((count_fails + 1))
        echo $count_fails >/home/orangepi/scripts/count_fails.txt
    fi
    if $internet_was_up_before && [ $count_fails -eq $FAILCOUNTER ]; then
        curl -s -S --data '{"message": "'"${MESSAGE}"'", "title": "'"${ELECTRICITY}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
        was_internet_down=true
        internet_was_up_before=false
        count_fails=0 #Reset Fail Counter after fail
        echo $was_internet_down >/home/orangepi/scripts/was_internet_down.txt
        echo $internet_was_up_before >/home/orangepi/scripts/internet_was_up_before.txt
        echo $count_fails >/home/orangepi/scripts/count_fails.txt
    fi
fi
