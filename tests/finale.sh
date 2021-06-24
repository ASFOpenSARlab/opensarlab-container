#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

cd /etc/jupyter-hooks

# TODO remove "bash sar.sh" if not using it
bash sar.sh

# TODO add "bash <image_namespace>.sh
