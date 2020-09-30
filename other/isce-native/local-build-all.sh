
set -e

export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub
export STAGE_MATURITY=test

bash build.sh
