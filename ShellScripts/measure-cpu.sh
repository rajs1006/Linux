#!/bin/bash

mkdir -p $HOME/logs/lin
current_time1=$(date +%s)

echo "------------------" >> $HOME/logs/lin/lin_$current_time1.log
lin_out=$($HOME/linpack.sh)
echo "$(date +%Y/%m/%d_%H:%M:%S)" >> $HOME/logs/lin/lin_$current_time1.log
echo "CPU check" >> $HOME/logs/lin/lin_$current_time1.log
echo "$lin_out" >> $HOME/logs/lin/lin_$current_time1.log
echo "######################" >> $HOME/logs/lin/lin_$current_time1.log
