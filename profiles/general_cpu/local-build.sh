set -e

# DOCKER_REGISTRY=localhost:5000 AWS_PROFILE=jupyterhub STAGE_MATURITY=test
export DOCKER_REGISTRY=localhost:5000
export AWS_PROFILE=jupyterhub
export PROFILE_MATURITY=test

bash build.sh
