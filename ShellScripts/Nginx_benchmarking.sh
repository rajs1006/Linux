#!/bin/bash

mkdir -p $CC/logs/nginx

current_time_nginx=$(date +%s)

URL=http://$1:8080/ubuntu.zip
THREAD=$2

wget_func(){
  START=$(date +%s)

  wget "$1" -O /dev/null

  END=$(date +%s)  
  echo "Total time taken $(($END - $START)) seconds" >> $CC/logs/nginx/nginx_$((current_time_nginx)).log
}

 
for i in `seq 1 $THREAD`
do
        wget_func "$URL" &
done
 
wait
echo "All threads are finished."
