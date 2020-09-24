

if [ ! -d TRAIN ] ; then
    git clone -b OpenSARlab --single-branch https://github.com/asfadmin/hyp3-TRAIN.git TRAIN
fi

# Build
time docker build -f dockerfile -t train-stage:test --target train-stage-test .
time docker build -f dockerfile -t train-stage:$STAGE_VERSION --target train-stage .

# Push image to registry
