FROM python:3.6-slim as prepare

# install ffmpeg
#ENV FFMPEG_URL 'http://nas.oldiy.top/%E5%B7%A5%E5%85%B7/ffmpeg-release-amd64-static.tar.xz'
ENV FFMPEG_URL 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz'
RUN : \
        && set -x \
        && buildDeps=' \
                unzip \
                ca-certificates \
                dirmngr \
                wget \
                xz-utils \
                gpg \
                gpg-agent' \
        && apt-get update \
        && apt-get install -y --no-install-recommends $buildDeps \
        && mkdir -p /tmp/ffmpeg \
        && cd /tmp/ffmpeg \
        && wget -O ffmpeg.tar.xz "$FFMPEG_URL" \
        && tar -xf ffmpeg.tar.xz -C . --strip-components 1 \
        && cp ffmpeg ffprobe qt-faststart /usr/bin \
        && cd .. \
        && rm -fr /tmp/ffmpeg

# install youtube-dl-webui
ENV YOUTUBE_DL_WEBUI_SOURCE /usr/src/youtube_dl_webui
WORKDIR $YOUTUBE_DL_WEBUI_SOURCE

RUN : \
        && pip install --no-cache-dir youtube-dl flask \
        && wget -O youtube-dl-webui.zip https://github.com/sultan8252/youtube-dl-webui/archive/master.zip \
        && unzip youtube-dl-webui.zip \
        && cd youtube-dl-webui*/ \
        && cp -r ./* $YOUTUBE_DL_WEBUI_SOURCE/ \
        && ln -s $YOUTUBE_DL_WEBUI_SOURCE/example_config.json /etc/youtube-dl-webui.json \
        && cd .. && rm -rf youtubedl-webui* \
        && apt-get purge -y --auto-remove wget unzip dirmngr \
        && rm -fr /var/lib/apt/lists/*

FROM python:3.6-slim as youtube-dl-webui
# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11
RUN set -x \
        && buildDeps=' \
                ca-certificates \
                dirmngr \
                wget \
                gpg \
                gpg-agent' \
        && apt-get update && apt-get install -y --no-install-recommends $buildDeps \
        && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
        && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
        && export GNUPGHOME="$(mktemp -d)" \
        && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
        && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
        && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu \
        && gosu nobody true

COPY --from=prepare /usr/bin/ffmpeg /usr/bin
COPY --from=prepare /usr/bin/ffprobe /usr/bin
COPY --from=prepare /usr/bin/qt-faststart /usr/bin

COPY docker-entrypoint.sh /usr/local/bin
COPY default_config.json /config.json

ARG YOUTUBE_DL_WEBUI_SOURCE=/usr/src/youtube_dl_webui
WORKDIR ${YOUTUBE_DL_WEBUI_SOURCE}

COPY --from=prepare ${YOUTUBE_DL_WEBUI_SOURCE}/* ${YOUTUBE_DL_WEBUI_SOURCE}/

RUN : \
        && pip install --no-cache-dir youtube-dl flask \
        && chmod +x /usr/local/bin/docker-entrypoint.sh \
        && ln -s $YOUTUBE_DL_WEBUI_SOURCE/example_config.json /etc/youtube-dl-webui.json \
        && chmod +x /usr/bin/ffmpeg \
        && chmod +x /usr/bin/ffprobe \
        && chmod +x /usr/bin/qt-faststart


EXPOSE 5555
VOLUME ["/youtube_dl"]

ENTRYPOINT ["docker-entrypoint.sh"]