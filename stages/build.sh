set -ex

STAGE_NAME=$1

COMMIT_HEAD=$(git rev-parse --short HEAD)

#if [ "$STAGE_COMPARE_MERGES" != 'false' ]; then
#    GIT_MERGE_HASHES=( $(git log --merges --first-parent ${COMMIT_HEAD} --pretty=format:"%h") )
#else
    GIT_MERGE_HASHES=( ${COMMIT_HEAD} )  
#fi

BUILD_TAG=${GIT_MERGE_HASHES[0]}
#MERGE_CHANGES_ARRAY=$(git diff --name-only ${GIT_MERGE_HASHES[1]} ${GIT_MERGE_HASHES[0]})
#echo "Changes in files: ${MERGE_CHANGES_ARRAY[@]}"

#if [[ " ${MERGE_CHANGES_ARRAY[@]} " =~ $STAGE_NAME-stage ]]; then

    echo "Building '$DOCKER_REGISTRY/$STAGE_NAME' with tags '$BUILD_TAG' and '$STAGE_MATURITY' for location '$STAGE_LOCATION' "

    cd $STAGE_NAME-stage
    [ -e download.sh ] && bash download.sh

    cp dockerfile dockerfile.build
    sed -i "s|base-stage:|$DOCKER_REGISTRY/base-stage:$STAGE_MATURITY|g" dockerfile.build

    SED_STR="s|--from=(.*):|--from=$DOCKER_REGISTRY/\1:$STAGE_MATURITY|g"
    sed -i -r $SED_STR dockerfile.build

    time docker build -f dockerfile.build --target $STAGE_NAME-stage-test .
    time docker build -f dockerfile.build -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG -t $DOCKER_REGISTRY/$STAGE_NAME-stage:$STAGE_MATURITY --target $STAGE_NAME-stage --no-cache .

    # Push image to registry
    if [ "$STAGE_REMOTE_PUSH" != 'false' ]; then
        docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$BUILD_TAG
        docker push $DOCKER_REGISTRY/$STAGE_NAME-stage:$STAGE_MATURITY
    fi
#fi
