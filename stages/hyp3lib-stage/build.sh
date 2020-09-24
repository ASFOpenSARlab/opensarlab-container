VERSION=1.0

time docker build -f dockerfile -t hyp3lib-stage:test --target hyp3lib-stage-test .
time docker build -f dockerfile -t hyp3lib-stage:$VERSION --target hyp3lib-stage .

# Push to registry
