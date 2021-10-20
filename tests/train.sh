#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

python3.9 /usr/local/TRAIN/src/aps_weather_model.py -h
