set -e

# DOCKER_REGISTRY=localhost:5000 AWS_PROFILE=jupyterhub STAGE_MATURITY=test
export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub
export PROFILE_MATURITY=test
export STAGE_FORCE_BUILD=true

bash build.sh
