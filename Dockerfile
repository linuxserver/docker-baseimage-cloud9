FROM lsiobase/alpine:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"
ARG NPM_CONFIG_UNSAFE_PERM=true

# add local files
COPY /root /

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	g++ \
	gcc \
	git \
	libgcc \
	libxml2-dev \
	make \
	nodejs \
	openssl-dev \
	python \
	tmux
RUN \
 echo "**** Compile Cloud9 from source ****" && \
 git clone --depth 1 \
	https://github.com/c9/core.git c9sdk && \
 cd c9sdk && \
 sed -i \
	's/node-pty-prebuilt/node-pty/g' \
	plugins/node_modules/vfs-local/localfs.js && \
 mkdir -p /c9bins && \
 sed -i \
	'/$URL/c\bash /install.sh' \
	scripts/install-sdk.sh && \
 HOME=/c9bins scripts/install-sdk.sh
RUN \
 echo "**** Restructure files for copy ****" && \
 mkdir -p \
	/buildout && \
 rm -Rf \
	/c9bins/.c9/tmp && \
 mv \
	/c9bins \
	/buildout/c9bins && \
 mv \
	/c9sdk \
	/buildout/
