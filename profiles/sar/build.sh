
set -ex

if [ "$STAGE_FORCE_BUILD" = 'true' ]; then

    [ -e download.sh ] && bash download.sh

    cp dockerfile dockerfile.build

    SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$PROFILE_MATURITY|g"
    sed -i -r $SED_STR dockerfile.build

    mkdir -p tests
    cp -r ../../tests/* tests/

    BUILD_TAG=$(date +"%F-%H-%M-%S")

    time docker build -f dockerfile.build --target testing .
    time docker build -f dockerfile.build -t $DOCKER_REGISTRY/sar:$BUILD_TAG -t $DOCKER_REGISTRY/sar:$PROFILE_MATURITY --target release .

    # Push to registry
    docker push $DOCKER_REGISTRY/sar:$BUILD_TAG
    docker push $DOCKER_REGISTRY/sar:$PROFILE_MATURITY

fi
