

export DOCKER_REGISTRY=localhost:5000  #CONTAINER_REPO=553778890976.dkr.ecr.us-east-1.amazonaws.com/asf-franz-labs
export AWS_PROFILE=jupyterhub
export STAGE_MATURITY=test
export STAGE_LOCATION=remote
export FORCED_LIST=()

STAGES_PATH_LIST=(aria base finale giant isce mapready mintpy snap train )
PROFILES_PATH_LIST=( general_cpu )
OTHERS_PATH_LIST=( isce-native )

CHANGES=$(git diff --name-only HEAD~ HEAD)
echo "Changes made:" 
echo "$CHANGES"

TOP_DIR=$(pwd)
echo ""
echo "Current directory contents:"
ls $TOP_DIR
echo ""

for THIS_PATH in ${OTHERS_PATH_LIST[@]};
do
    cd $TOP_DIR
    echo "Checking $THIS_PATH in others..."
    if [[ " ${CHANGES[@]} " =~ others/$THIS_PATH ]]
    then
        if [ -d "others/$THIS_PATH" ]
        then
            cd others/$THIS_PATH
            bash build.sh
        else
            echo "No path named others/$THIS_PATH"
        fi
    fi
done

for THIS_STAGE in ${STAGES_PATH_LIST[@]};
do
    cd $TOP_DIR
    echo "Checking $THIS_STAGE in stages..."
    if [[ " ${CHANGES[@]} " =~ stages/$THIS_STAGE-stage ]]
    then 
        if [ -d "stages/$THIS_STAGE-stage" ]
        then
            cd stages
            bash build.sh $THIS_STAGE
        else
            echo "No path named stages/$THIS_STAGE"
        fi
    fi
done

for THIS_PATH in ${PROFILES_PATH_LIST[@]};
do
    cd $TOP_DIR
    echo "Checking $THIS_PATH in profiles..."
    if [[ " ${CHANGES[@]} " =~ profiles/$THIS_PATH ]]
    then
        if [ -d "profiles/$THIS_PATH" ]
        then
            cd profiles/$THIS_PATH
            bash build.sh
        else
            echo "No path named profiles/$THIS_PATH"
        fi
    fi 
done
