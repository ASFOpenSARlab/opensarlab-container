VERSION=1.0

# Build
time docker build -f dockerfile -t finale-stage:test --target finale-stage-test .
time docker build -f dockerfile -t finale-stage:$VERSION --target finale-stage .

# Push image to registry
