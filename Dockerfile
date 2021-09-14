# inspired by docker hub justb4/docker-jmeter git https://github.com/justb4/docker-jmeter and 
# egaillardon/jmeter git https://github.com/egaillardon/jmeter
FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine
LABEL maintainer="rafaelbbonfim@gmail.com"

STOPSIGNAL SIGKILL

# ENV MIRROR https://www-eu.apache.org/dist/jmeter/binaries
ARG JMETER_VERSION="5.4.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN	${JMETER_HOME}/bin
ENV JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV ALPN_VERSION 8.1.13.v20181017
ENV PATH ${JMETER_BIN}:$PATH
COPY entrypoint.sh /usr/local/bin/

ARG TZ="America/Sao_Paulo"
ENV TZ ${TZ}

RUN chmod +x /usr/local/bin/entrypoint.sh \
 && apk add --no-cache \
    curl \
    fontconfig \
    libxext \
    libxi \
    libxrender \
    libxtst \
    net-tools \
    shadow \
    su-exec \
    tcpdump  \
    ttf-dejavu \
   && apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

WORKDIR	${JMETER_HOME}
COPY lib lib/

# Required for HTTP2 plugins
ENV JVM_ARGS -Xbootclasspath/p:/opt/alpn-boot-${ALPN_VERSION}.jar
WORKDIR /jmeter
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["jmeter", "--?"]