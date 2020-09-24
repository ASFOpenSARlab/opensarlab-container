
VERSION=1.0
profile=jupyterhub

if [ ! -d GIAnT ] ; then
    aws s3 sync --exclude '*' --include 'GIAnT.zip' s3://asf-jupyter-software/ . --profile=$profile
    unzip GIAnT.zip
fi
if [ ! -f prepdataxml.py ] ; then
    aws s3 sync --exclude '*' --include 'prepdataxml.py' s3://asf-jupyter-software/ . --profile=$profile
fi 

# Build
time docker build -f dockerfile -t giant-stage:test --target giant-stage-test .
time docker build -f dockerfile -t giant-stage:$VERSION --target giant-stage .

# Push image to registry
