
set -e 

if [ ! -d GIAnT ] ; then
    aws s3 sync --exclude '*' --include 'GIAnT.zip' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
    unzip GIAnT.zip
fi
if [ ! -f prepdataxml.py ] ; then
    aws s3 sync --exclude '*' --include 'prepdataxml.py' s3://asf-jupyter-software/ . --profile=$AWS_PROFILE
fi 
