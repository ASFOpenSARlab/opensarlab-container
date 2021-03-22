#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

cd /etc/jupyter-hooks
bash sar.sh
