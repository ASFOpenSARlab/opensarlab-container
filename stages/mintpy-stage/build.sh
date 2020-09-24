VERSION=1.0

if [ ! -d MintPy ] ; then
    git clone -b v1.2.2 --single-branch https://github.com/insarlab/MintPy.git
fi
if [ ! -d PyAPS ] ; then
    git clone -b master --single-branch https://github.com/yunjunz/pyaps3.git PyAPS
fi

# Build
time docker build -f dockerfile -t mintpy-stage:test --target mintpy-stage-test .
time docker build -f dockerfile -t mintpy-stage:$VERSION --target mintpy-stage .

# Push image to registry
