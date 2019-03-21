# ASF Jupyter Container

This repo contains

- `dockerfile` which builds a jupyter server image
- `software/download.sh` a script which downloads all needed third-party code from s3://asf-jupyter-software
- `buildspec.yml` which is used by AWS to create the image from the dockerfile and push to a docker repository

It's important to note that the proper sequence of development is

- Do development with a local docker engine
- Push to `master` a ready build. AWS will automatically build and deploy.
- Testing should actually be within a Jupyter Hub test enviroment seperately from the repo.
- Build numbers will be used to keep track of build maturity
