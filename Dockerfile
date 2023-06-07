FROM ubuntu:jammy

RUN apt-get update && apt-get install -y ca-certificates jq skopeo

WORKDIR /root
RUN mkdir ubuntu
RUN skopeo copy docker://ubuntu:jammy dir:ubuntu

WORKDIR ubuntu/chroot
RUN tar xf ../$(jq .layers[].digest -r ../manifest.json | cut -d: -f2)

RUN cp /etc/resolv.conf etc
CMD chroot . \
    apt-get --allow-unauthenticated --allow-insecure-repositories update && \
    apt-get -y install cowsay && \
    /usr/games/cowsay hello chroot
