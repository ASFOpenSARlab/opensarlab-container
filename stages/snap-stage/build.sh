
terhub

if [ ! -f esa-snap_sentinel_unix_7_0.sh ] ; then
    aws s3 sync --exclude '*' --include 'esa-snap_sentinel_unix_7_0.sh' s3://asf-jupyter-software/ . --profile=$PROFILE
fi
if [ ! -f snap_install_7_0.varfile ] ; then
    aws s3 sync --exclude '*' --include 'snap_install_7_0.varfile' s3://asf-jupyter-software/ . --profile=$PROFILE
fi
if [ ! -f gpt.vmoptions ] ; then
    aws s3 sync --exclude '*' --include 'gpt.vmoptions' s3://asf-jupyter-software/ . --profile=$PROFILE
fi

# Build
time docker build -f dockerfile -t snap-stage:test --target snap-stage-test .
time docker build -f dockerfile -t snap-stage:$STAGE_VERSION --target snap-stage .

# Push image to registry
