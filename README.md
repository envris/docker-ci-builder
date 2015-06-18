###CI Builder
The **ci-builder** is a docker container image used for building images with
CI utilities such as Jenkins. It's a very simple image that installs docker-in-docker
and then can be passed environment variables used with a volume mount to produce
a built docker container as the output.


####Usage
After building the docker image with a command like:

```
docker build --rm=true -t your-registry/ci-builder:latest .
```

You then use the following sinppet (or similar) in your Jenkins (or the like) CI project as a build step.

Simply set the `REGISTRY_HOST` variable and execute the following code in your Jenkins build.

```
REGISTRY_HOST=""

docker pull ${REGISTRY_HOST}/ci-builder:latest
PCWD=`pwd`
docker run --rm -t --privileged -v ${PCWD}:/builder -e DOCKER_REG_PREFIX=${REGISTRY_HOST} \
  -e DOCKER_BUILDER_OPTS="--dns x.x.x.x" -e GIT_COMMIT="${GIT_COMMIT}" -e BUILD_NUMBER="${BUILD_NUMBER}" \
  [-e DOCKER_BASE_IMG=""] ${REGISTRY_HOST}/ci-builder:latest /builder/ci-builder/jenkins-build.sh
```

Note. all the environment variables are optional, however, view their usage in our example scripts
under the `examples` directory in this repo.


####Requirements
You must have a build script that contains your build steps, (eg. jenkins-build.sh) and it must reside
within your apps codebase. It's location is passed in as the CMD at the end of the docker run line.
The build script is where the included environment variables are made use of. We have some examples in
the `Usage` section above, which relate to our example script in the `examples` directory of this repo.
