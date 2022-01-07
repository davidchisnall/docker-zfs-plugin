ARG PACKAGE_NAME=docker-zfs-plugin
ARG PACKAGE_VERSION=0.1-1

FROM golang:1.17.6-alpine AS build

WORKDIR $GOPATH/src/github.com/csachs/docker-zfs-plugin

COPY . .

ARG CGO_ENABLED=0

RUN go mod edit -replace github.com/apetresc/docker-zfs-plugin=$GOPATH/src/github.com/csachs/docker-zfs-plugin && \
    cat go.mod && \
    go build -o /docker-zfs-plugin

FROM scratch as plain

LABEL maintainer="sachs.christian@gmail.com"

COPY --from=build /docker-zfs-plugin /docker-zfs-plugin

ENTRYPOINT ["/docker-zfs-plugin"]

# build debian package

FROM ubuntu:20.04 as package_build

ARG PACKAGE_NAME
ARG PACKAGE_VERSION

ENV PACKAGE_NAME=$PACKAGE_NAME PACKAGE_VERSION=$PACKAGE_VERSION

COPY --from=build /docker-zfs-plugin /tmp

RUN \
    mkdir -p /workspace && \
    mkdir -p /workspace/${PACKAGE_NAME}_${PACKAGE_VERSION}/DEBIAN && \
    mkdir -p /workspace/${PACKAGE_NAME}_${PACKAGE_VERSION}/usr/bin && \
    echo "Writing control file" && \
        cd /workspace/${PACKAGE_NAME}_${PACKAGE_VERSION}/DEBIAN/ && \
        echo "Package: ${PACKAGE_NAME}" >> control && \
        echo "Version: ${PACKAGE_VERSION}" >> control && \
        echo "Section: admin" >> control && \
        echo "Priority: optional" >> control && \
        echo "Architecture: amd64" >> control && \
        echo "Maintainer: Christian Sachs <sachs.christian@gmail.com>" >> control && \
        echo "Description: Packaged version of github.com/csachs/docker-zfs-plugin" >> control && \
    echo "Done"

COPY --from=build /docker-zfs-plugin /workspace/${PACKAGE_NAME}_${PACKAGE_VERSION}/usr/bin/
COPY etc/ /workspace/${PACKAGE_NAME}_${PACKAGE_VERSION}/etc

WORKDIR /workspace 
RUN dpkg-deb --build ${PACKAGE_NAME}_${PACKAGE_VERSION}

FROM scratch

ARG PACKAGE_NAME
ARG PACKAGE_VERSION

COPY --from=package_build /workspace/${PACKAGE_NAME}_${PACKAGE_VERSION}.deb /${PACKAGE_NAME}_${PACKAGE_VERSION}.deb
COPY --from=build /docker-zfs-plugin /docker-zfs-plugin

ENTRYPOINT ["/docker-zfs-plugin"]
