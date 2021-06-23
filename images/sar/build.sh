
set -ex

if [ "$STAGE_FORCE_BUILD" = 'true' ]; then

    cp dockerfile dockerfile.build

    SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$IMAGE_TAG|g"
    sed -i -r $SED_STR dockerfile.build

    mkdir -p tests
    cp -r ../../tests/* tests/

    BUILD_TAG=$(date +"%F-%H-%M-%S")
    COMMIT_HEAD=$(git rev-parse --short HEAD)

    time docker build -f dockerfile.build --target testing .

    # TODO Change 3 $DOCKER_REGISTRY namespaces from "sar" to your image namespace
    time docker build -f dockerfile.build \
        -t $DOCKER_REGISTRY/sar:$BUILD_TAG \
        -t $DOCKER_REGISTRY/sar:$IMAGE_TAG \
        -t $DOCKER_REGISTRY/sar:$COMMIT_HEAD \
        --target release .

    # Push to registry
    # TODO Change 3 $DOCKER_REGISTRY namespaces from "sar" to your image namespace
    docker push $DOCKER_REGISTRY/sar:$BUILD_TAG
    docker push $DOCKER_REGISTRY/sar:$IMAGE_TAG
    docker push $DOCKER_REGISTRY/sar:$COMMIT_HEAD

fi
