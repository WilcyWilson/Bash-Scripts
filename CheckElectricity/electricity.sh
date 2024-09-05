#!/bin/bash
ELECTRICITY="Electricity is down"
ELECTRICITYUP="Electricity is up"
MESSAGE=$(date '+%Y-%m-%d %H:%M:%S')
PRIORITY=5
URL="http://192.168.1.102:8080/message?token=A1hUZtU1CMJv3bk"
read internet_was_up_before </home/orangepi/scripts/internet_was_up_before.txt
read was_internet_down </home/orangepi/scripts/was_internet_down.txt
read count_fails </home/orangepi/scripts/count_fails.txt
if ping -c 1 192.168.1.2 &>/dev/null; then
    echo "success: $MESSAGE"
    if $was_internet_down; then
        curl -s -S --data '{"message": "'"${MESSAGE}"'", "title": "'"${ELECTRICITYUP}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
        internet_was_up_before=true
        was_internet_down=false
        echo $was_internet_down >/home/orangepi/scripts/was_internet_down.txt
        echo $internet_was_up_before >/home/orangepi/scripts/internet_was_up_before.txt
    fi
    if [ $count_fails -ne 0 ]; then
        count_fails=0
        echo $count_fails >/home/orangepi/scripts/count_fails.txt
    fi
else
    echo "error: $MESSAGE"
    count_fails=$((count_fails + 1))
    echo $count_fails >/home/orangepi/scripts/count_fails.txt
    if $internet_was_up_before && [ $count_fails -eq 2 ]; then
        curl -s -S --data '{"message": "'"${MESSAGE}"'", "title": "'"${ELECTRICITY}"'", "priority":'"${PRIORITY}"', "extras": {"client::display": {"contentType": "text/markdown"}}}' -H 'Content-Type: application/json' "$URL"
        was_internet_down=true
        internet_was_up_before=false
        count_fails=0
        echo $was_internet_down >/home/orangepi/scripts/was_internet_down.txt
        echo $internet_was_up_before >/home/orangepi/scripts/internet_was_up_before.txt
        echo $count_fails >/home/orangepi/scripts/count_fails.txt
    fi
    if [ $count_fails -gt 2 ]; then
        count_fails=0
        echo $count_fails >/home/orangepi/scripts/count_fails.txt
    fi
fi
