#!/bin/bash

set -ex
# The idiom "&& [ $? -gt 2 ] && true" ignores warnings from the previous command

asf_mapready -version
asf_geocode -version
