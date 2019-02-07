#!/bin/bash

mkdir -p $HOME/logs/mem

current_time2=$(date +%s)

echo "------------------" >> $HOME/logs/mem/mem_$current_time2.log
mem_out=$($HOME/memsweep.sh)
echo "$(date +%Y/%m/%d_%H:%M:%S)" >> $HOME/logs/mem/mem_$current_time2.log
echo "Memory check" >> $HOME/logs/mem/mem_$current_time2.log
echo "$mem_out" >> $HOME/logs/mem/mem_$current_time2.log
echo "##################" >> $HOME/logs/mem/mem_$current_time2.log