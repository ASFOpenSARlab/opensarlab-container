
set -e

export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=osl-e
export STAGE_MATURITY=test
export STAGE_REMOTE_PUSH=false
export STAGE_COMPARE_LATEST=false
export STAGE_FORCE_BUILD=true

if [ "$#" -gt 0 ]; then
    STAGE_LIST=( "$@" )
else
    STAGE_LIST=( 'base' 'finale' )
fi

for j in "${STAGE_LIST[@]}"; do 
    bash build.sh $j
done
