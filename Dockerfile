FROM ubuntu:vivid
MAINTAINER Aaron Nicoli <aaronnicoli@gmail.com>


# Install Docker from Docker Inc. repositories.
RUN apt-get update && apt-get install -y apt-transport-https iptables ca-certificates lxc git
RUN echo "deb https://get.docker.io/ubuntu docker main" >> /etc/apt/sources.list.d/docker.list
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys A88D21E9 && \
    gpg --armor --export A88D21E9 | apt-key add -

VOLUME ["/var/lib/docker"]

RUN apt-get update && apt-get install -y lxc-docker

RUN rm -f /etc/default/docker

CMD ["/builder/ci-builder/jenkins-build.sh"]
