
set -x

time docker build -f general_cpu.dockerfile -t general_cpu:test --target general_cpu-stage-test .
time docker build -f general_cpu.dockerfile -t general_cpu:$STAGE_VERSION --target general_cpu-stage .

# Push to registry
