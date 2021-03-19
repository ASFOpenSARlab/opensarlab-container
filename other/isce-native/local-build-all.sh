
set -e

export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=osl-e
export STAGE_MATURITY=latest
export STAGE_FORCE_BUILD=true

bash build.sh
