
set -e

#DOCKER_REGISTRY=localhost:5000 AWS_PROFILE=jupyterhub STAGE_MATURITY=test
export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub
export STAGE_MATURITY=test

for j in \
    base \
    start \
    aria \
    finale \
    giant \
    isce \
    mapready \
    mintpy \
    snap \
    train
do 
    bash build.sh $j
done
