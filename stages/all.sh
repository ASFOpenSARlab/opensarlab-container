
for j in \
    base \
    start \
    aria \
    finale \
    giant \
    hyp3lib \
    isce \
    mapready \
    mintpy \
    snap \
    train
do 
    cd $j-stage
    STAGE_VERSION=1.0 PROFILE=jupyterhub bash build.sh
    cd ..
done

cd isce-native
STAGE_VERSION=1.0 PROFILE=jupyterhub bash build.sh
cd ..