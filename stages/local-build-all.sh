
set -e

export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub

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
