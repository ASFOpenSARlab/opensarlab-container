#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

python --version 
python3.10 --version
