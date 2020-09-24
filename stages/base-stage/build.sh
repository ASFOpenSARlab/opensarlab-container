    VERSION=1.0

    time docker build -f dockerfile -t base-stage:test --target base-stage-test .
    time docker build -f dockerfile -t base-stage:$VERSION --target base-stage .

    # Push image to registry
