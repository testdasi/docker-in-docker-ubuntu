ARG FRM='testdasi/docker-in-docker-ubuntu-base'
ARG TAG='latest'
ARG DEBIAN_FRONTEND='noninteractive'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

ENV DOCKER_TCP 2375
ENV DOCKER_TCP_TLS 2376

EXPOSE ${DOCKER_TCP}/tcp \
    ${DOCKER_TCP_TLS}/tcp


## build note ##
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM}:${TAG}" >> /build.info

## install static codes ##
RUN rm -Rf /testdasi \
    && mkdir -p /temp \
    && cd /temp \
    && curl -sL "https://github.com/testdasi/static-ubuntu/archive/main.zip" -o /temp/temp.zip \
    && unzip /temp/temp.zip \
    && rm -f /temp/temp.zip \
    && mv /temp/static-ubuntu-main /testdasi \
    && rm -Rf /testdasi/deprecated

## execute execute execute ##
RUN /bin/bash /testdasi/scripts-install/install-docker-in-docker-ubuntu.sh

## debug mode (comment to disable) ##
#RUN /bin/bash /testdasi/scripts-install/install-debug-mode.sh
#ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

## Final clean up ##
RUN rm -Rf /testdasi

## VEH ##
VOLUME ["/config"]
ENTRYPOINT ["tini", "--", "/static-ubuntu/dindu/entrypoint.sh"]
HEALTHCHECK CMD /static-ubuntu/dindu/healthcheck.sh
