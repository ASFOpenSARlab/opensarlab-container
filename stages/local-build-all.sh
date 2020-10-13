
set -e

export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub
export STAGE_MATURITY=test
export STAGE_REMOTE_PUSH=false
export STAGE_COMPARE_LATEST=true
export STAGE_FORCE_BUILD=false

if [ "$#" -gt 0 ]; then
    STAGE_LIST=( "$@" )
else
    STAGE_LIST=( 'base' 'aria' 'finale' 'isce' 'mapready' 'mintpy' 'snap' 'train' )
fi

for j in "${STAGE_LIST[@]}"; do 
    bash build.sh $j
done
