
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
    bash build.sh
    cd ..
done
