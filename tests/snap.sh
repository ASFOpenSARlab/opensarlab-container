#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

/usr/local/snap/bin/gpt -h
#snap --help && [ $? -gt 2 ] && true
