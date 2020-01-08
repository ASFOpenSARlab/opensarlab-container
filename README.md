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

To build, develop, and test locally, do the following. Note that not all notebook features (like pulling from specfic S3 buckets) will work.

```
# Download external software to be installed into image
cd ./software && bash download.sh && cd ..

# Build image
docker build -t jupyter-container:latest -f dockerfile .

# Look at docker image sizes
docker image ls

# To shell into image. The running container will be ran as user root (not jovyan) and deleted on exit.
docker run -it --rm -p 80:8888 -u root jupyter-container:latest bash

# After shelling, import notebooks and run notebook server on http://localhost/?token=....
#> git clone https://github.com/asfadmin/asf-jupyter-notebooks.git ~/notebooks
#> jupyter-notebook --allow-root
```
