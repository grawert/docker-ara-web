FROM node:10
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ARG VERSION
ENV VERSION ${VERSION:-1.0.0}

ENV DEBIAN_FRONTEND noninteractive

COPY files/run.sh /run.sh

RUN useradd -m ara-web \
    && npm install -g serve

USER ara-web

WORKDIR /home/ara-web
RUN git clone https://github.com/ansible-community/ara-web

WORKDIR /home/ara-web/ara-web
RUN if [ $VERSION != "latest" ]; then git checkout tags/$VERSION; fi \
    && npm install \
    && npm audit fix \
    && npm run build

EXPOSE 3000

CMD ["/run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:3000/ || exit 1
