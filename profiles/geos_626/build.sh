
set -ex

if [ "$STAGE_FORCE_BUILD" = 'true' ]; then

    cp dockerfile dockerfile.build
    sed -i "s|base-stage:|$DOCKER_REGISTRY/base-stage:$PROFILE_MATURITY|g" dockerfile.build
    SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$PROFILE_MATURITY|g"
    sed -i -r $SED_STR dockerfile.build

    BUILD_TAG=$(date +"%F-%H-%M-%S")

    time docker build -f dockerfile.build --target build -t geos_626:build .
    RUN_HASH=$(docker run -d geos_626:build)
    docker cp $RUN_HASH:/envs/all.env all.env
    docker stop $RUN_HASH
    sed -i "s|^|ENV |g;s|=| |g" all.env
    sed "s|#PLEASE_ADD_ENVS_HERE|$(< all.env tr '\n' '@')|" dockerfile.build | tr '@' '\n' > dockerfile.release

    time docker build -f dockerfile.release --target testing .
    time docker build -f dockerfile.release -t $DOCKER_REGISTRY/geos_626:$BUILD_TAG -t $DOCKER_REGISTRY/geos_626:$PROFILE_MATURITY --target release .

    # Push to registry
    docker push $DOCKER_REGISTRY/geos_626:$BUILD_TAG
    docker push $DOCKER_REGISTRY/geos_626:$PROFILE_MATURITY

fi
