#!/bin/bash

echo "DOCKER_OPTS=\"${DOCKER_BUILDER_OPTS}\"" >> /etc/default/docker

# Start the docker daemon
/etc/init.d/docker start

sleep 6s

# Pull latest base images (purely for cache, naming does not matter, just hashes)
docker pull ${DOCKER_REG_PREFIX}/your-app:latest

# cd and cont.
cd /builder/docker/your-app
echo -e "ENV BUILD_DETAILS ${GIT_COMMIT}_${BUILD_NUMBER}" >> ./Dockerfile
echo -e "BUILD_DETAILS:\n  GIT_COMMIT: ${GIT_COMMIT}\n  BUILD_NUMBER: ${BUILD_NUMBER}\n" > ./BUILD_DETAILS
echo -e "ADD ./BUILD_DETAILS /etc/BUILD_DETAILS" >> ./Dockerfile
if [ "${DOCKER_BASE_IMG}" != "" ] ; then
  sed -i "s;.*FROM .*;FROM ${DOCKER_BASE_IMG};" ./Dockerfile
fi

# BUild the new app server
docker build -t app/your-app:latest . 

LATEST_IMG=`docker images | grep "app/your-app" | grep "latest" | awk '{print $3}'`

if [ "${LATEST_IMG}" != "" ] ; then
  docker tag app/your-app:latest ${DOCKER_REG_PREFIX}/your-app:${GIT_COMMIT}_${BUILD_NUMBER}
  docker tag -f app/your-app:latest ${DOCKER_REG_PREFIX}/your-app:latest
  docker push ${DOCKER_REG_PREFIX}/your-app:${GIT_COMMIT}_${BUILD_NUMBER}
  docker push ${DOCKER_REG_PREFIX}/your-app:latest
fi
