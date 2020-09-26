
set -e

if [ ! -d MintPy ] ; then
    git clone -b v1.2.2 --single-branch https://github.com/insarlab/MintPy.git
fi
if [ ! -d PyAPS ] ; then
    git clone -b master --single-branch https://github.com/yunjunz/pyaps3.git PyAPS
fi
