
set -e



if [ ! -d ARIA-tools ] ; then
    git clone -b v1.1.1 --single-branch https://github.com/aria-tools/ARIA-tools.git ARIA-tools
fi
if [ ! -d ARIA-tools-docs ] ; then
    git clone -b master --single-branch https://github.com/aria-tools/ARIA-tools-docs.git ARIA-tools-docs
fi

# Build
time docker build -f dockerfile -t aria-stage:test --target aria-stage-test .
time docker build -f dockerfile -t aria-stage:$STAGE_VERSION --target aria-stage .

# Push image to registry