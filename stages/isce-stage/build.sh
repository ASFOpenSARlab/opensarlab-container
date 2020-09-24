

# Build
time docker build -f dockerfile -t isce-stage:test --target isce-stage-test .
time docker build -f dockerfile -t isce-stage:$STAGE_VERSION --target isce-stage .

# Push image to registry
