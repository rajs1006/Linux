#!/bin/bash

mkdir -p $HOME/logs/dd

current_time3=$(date +%s)

echo "------------------" >> $HOME/logs/dd/dd_$current_time3.log
while [ $(date +%s) -lt $(($current_time3 + 15)) ]
do
        dd_out=$(dd if=/dev/zero of=/tmp/test2 bs=100M count=1 oflag=direct 2>&1)
        echo "$(date +%Y/%m/%d_%H:%M:%S)" >> $HOME/logs/dd/dd_$current_time3.log
        echo "dd check" >> $HOME/logs/dd/dd_$current_time3.log
        echo "$dd_out" >> $HOME/logs/dd/dd_$current_time3.log
        echo "####################" >> $HOME/logs/dd/dd_$current_time3.log
done