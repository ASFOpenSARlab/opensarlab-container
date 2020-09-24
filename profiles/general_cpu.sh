
set -x

VERSION=1.0

time docker build -f general_cpu.dockerfile -t general_cpu:test --target general_cpu-stage-test .
time docker build -f general_cpu.dockerfile -t general_cpu:$VERSION --target general_cpu-stage .

# Push to registry
