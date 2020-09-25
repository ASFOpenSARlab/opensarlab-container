
set -e

time docker build -f dockerfile -t general_cpu:test --target general_cpu-test .
time docker build -f dockerfile -t general_cpu:$STAGE_VERSION --target general_cpu .

# Push to registry
