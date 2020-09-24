

terhub

if [ ! -d GIAnT ] ; then
    aws s3 sync --exclude '*' --include 'GIAnT.zip' s3://asf-jupyter-software/ . --profile=$PROFILE
    unzip GIAnT.zip
fi
if [ ! -f prepdataxml.py ] ; then
    aws s3 sync --exclude '*' --include 'prepdataxml.py' s3://asf-jupyter-software/ . --profile=$PROFILE
fi 

# Build
time docker build -f dockerfile -t giant-stage:test --target giant-stage-test .
time docker build -f dockerfile -t giant-stage:$STAGE_VERSION --target giant-stage .

# Push image to registry
