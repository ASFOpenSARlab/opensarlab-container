
set -ex

export DOCKER_REGISTRY=localhost:5000
export STAGE_MATURITY=test

IMAGE_NAME=$1

#\[ -e /etc/jupyter-hooks/$IMAGE_NAME.sh \] && bash /etc/jupyter-hooks/$IMAGE_NAME.sh; jupyter notebook;

docker run -p 80:8888 -u root $DOCKER_REGISTRY/$IMAGE_NAME:$STAGE_MATURITY
