#!/bin/bash

count=0

until ./run.sh; do
	((i++))
	echo "Process died with exit code $?. Respawning." >&2
	cd ..
	mv log.txt ../logs/log$i.txt
	cd scripts
	sleep 1
done