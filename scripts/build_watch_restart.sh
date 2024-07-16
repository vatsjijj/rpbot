#!/bin/bash

./build.sh
pkill watcher.sh
pkill rpbot
./watcher.sh &