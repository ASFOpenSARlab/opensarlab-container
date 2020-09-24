

# Build
time docker build -f dockerfile -t start-stage:test --target start-stage-test .
time docker build -f dockerfile -t start-stage:$STAGE_VERSION --target start-stage .

# Push image to registry
