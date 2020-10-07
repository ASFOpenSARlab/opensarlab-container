
set -e

#DOCKER_REGISTRY=localhost:5000 AWS_PROFILE=jupyterhub STAGE_MATURITY=test STAGE_REMOTE_PUSH=false STAGE_COMPARE_MERGES=false
export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub
export STAGE_MATURITY=test
export STAGE_REMOTE_PUSH=false
export STAGE_COMPARE_MERGES=false

for j in \
    base \
    aria \
    finale \
    isce \
    mapready \
    mintpy \
    snap \
    train  # giant
do 
    bash build.sh $j
done
