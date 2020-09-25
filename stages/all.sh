
cd isce-native
STAGE_VERSION=1.0 PROFILE=jupyterhub bash build.sh
cd ..

cd base-stage
STAGE_VERSION=1.0 PROFILE=jupyterhub bash build.sh
cd ..

for j in \
    start \
    aria \
    finale \
    giant \
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
