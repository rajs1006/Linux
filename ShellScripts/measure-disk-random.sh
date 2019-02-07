#!/bin/bash

mkdir -p $HOME/logs/fio

current_time4=$(date +%s)

echo "------------------" >> $HOME/newlogs/fio/fio_$current_time4.log
fio_out=$(sudo fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=100M --readwrite=randrw --rwmixread=75 | tee -a new_fio.log)
echo "$(date +%Y/%m/%d_%H:%M:%S)" >> $HOME/newlogs/fio/fio_$current_time4.log