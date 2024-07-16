#!/bin/bash

count=0

echo "Watching process!"

cd ..
until (./rpbot > log.txt 2>&1); do
	((i++))
	echo "Process died with exit code $?. Respawning." >&2
	cd ..
	mv log.txt ../logs/log$i.txt
	cd scripts
	sleep 1
done
cd scripts