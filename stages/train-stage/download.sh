
set -e 

if [ ! -d TRAIN ] ; then
    git clone -b OpenSARlab --single-branch https://github.com/asfadmin/hyp3-TRAIN.git TRAIN
fi
