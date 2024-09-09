#!/bin/bash
LINECOUNTER=1000
if [[ $(wc -l <electricity.log) -ge $LINECOUNTER ]]; then
    sed -i '1,100d' electricity.log
    echo "success"
else
    echo "fail"
fi
