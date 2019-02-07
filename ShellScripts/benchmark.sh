#!/bin/bash

mkdir -p $CC/logs/lin
mkdir -p $CC/logs/mem
mkdir -p $CC/logs/fio
mkdir -p $CC/logs/nginx
mkdir -p $CC/logs/fork

IP=$1
totalCount=49

sleep_fun(){
	if [ $i -ne $totalCount ]; then
		sleep 180
	fi
}	

#LINPACK.SH
linpack_func(){
	current_time1=$(date +%s)

	echo "------------------" >> $CC/logs/lin/lin_$current_time1.log
	i=1
	while [ $i -le $totalCount ]
	do
		count=0;
		sumT=0.0;
		cur_time1=$(date +%s)
		while [ $(date +%s) -lt $(($cur_time1 + 300)) ]
		do
			lin_out=$($CC/linpack.sh)
			time=$(echo "$lin_out" | grep 'KFLOPS' | awk '{print $(NF-1)}')
			sumT=`echo $sumT + $time | bc`
			count=$(( $count + 1 ))
		done
		div=`echo $sumT / $count | bc`
		echo "$cur_time1 , $div , $count" >> $CC/logs/lin/lin_$current_time1.log
		sleep_fun;
		i=$(( $i + 1 ))
	done
}

#MEMSWEEP.SH
memsweep_func(){
	current_time2=$(date +%s)
	echo "------------------" >> $CC/logs/mem/mem_$current_time2.log
	i=1
	while [ $i -le $totalCount ]
	do
		count=0;
		sumT=0.0;
		cur_time2=$(date +%s)
		while [ $(date +%s) -lt $(($cur_time2 + 120)) ]
		do
			mem_out=$($CC/memsweep.sh)
			time=$(echo "$mem_out" | grep 'seconds' | awk '{print $(NF)}')
			sumT=`echo $sumT + $time | bc`
			count=$(( $count + 1 ))
		done
		div=`echo $sumT / $count | bc`
		echo "$cur_time2 , $div , $count" >> $CC/logs/mem/mem_$current_time2.log
		sleep_fun;
		i=$(( $i + 1 ))
	done
}

#fio
fio_func(){
	
	current_time3=$(date +%s)
	i=1
	while [ $i -le $totalCount ]
	do
		echo "------------------" >> $CC/logs/fio/fio_$current_time3.log
		fio_out=$(sudo fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=100M --readwrite=randrw --rwmixread=75 |& tee -a fio.log)
		echo "$(date +%Y/%m/%d_%H:%M:%S)" >> $CC/logs/fio/fio_$current_time3.log
		sleep_fun;
		i=$(( $i + 1 ))
	done
}

nginx_func(){
	current_time4=$(date +%s)
	i=1
	while [ $i -le $totalCount ]
	do
		cur_time4=$(date +%s)
		nginx_out=$($CC/Nginx_benchmarking.sh $1)
		time=$(echo "$nginx_out" | grep 'seconds' | awk '{print $(NF-1)}')
		count=$(echo "$nginx_out" | grep 'THREADS' | awk '{print $(NF)}')
		timeT=0;
		for t in $time;
		do
		 timeT=$(( $timeT + $t ))
		done
		avgTime=`echo $timeT / $count | bc`
		echo "$cur_time4 , $avgTime"  >> $CC/logs/nginx/nginx_$current_time4.log
		sleep_fun;
		i=$(( $i + 1 ))
	done

}

forksum_func(){
	current_time1=$(date +%s)

	echo "------------------" >> $CC/logs/fork/fork_$current_time1.log
	i=1
	while [ $i -le $totalCount ]
	do
		count=0;
		sumT=0.0;
		cur_time1=$(date +%s)
		while [ $(date +%s) -lt $(($cur_time1 + 60)) ]
		do
			fork_out=$($CC/forksum.sh $1 $2)
			echo "$fork_out"
			time=$(echo "$fork_out" | grep 'SUM' | cut -d ":" -f 2 | awk '{print $(NF - 1)}')
			sumT=`echo $sumT + $time | bc`
			count=$(( $count + 1 ))
		done
		div=`echo $sumT / $count | bc`
		echo "$cur_time1 , $div , $count" >> $CC/logs/fork/fork_$current_time1.log
		sleep_fun;
		i=$(( $i + 1 ))
	done
}

#for i in {1..4}
for i in {5..5}
do 
	if [ $i -eq 1 ]; then 
		linpack_func &	
	elif [ $i -eq 2 ]; then
		memsweep_func & 
	elif [ $i -eq 3 ]; then
		fio_func & 
	elif [ $i -eq 4 ]; then
		nginx_func "$IP" &
	elif [ $i -eq 5 ]; then
		forksum_func 1 99999 &
	fi
done
