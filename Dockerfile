FROM python:3.6-slim

# install ffmpeg
ENV FFMPEG_URL 'http://nas.oldiy.top/%E5%B7%A5%E5%85%B7/ffmpeg-release-amd64-static.tar.xz'
#ENV FFMPEG_URL 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz'
RUN : \
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
	&& wget -O youtube-dl-webui.zip https://github.com/oldiy/youtubedl-webui/archive/0.3.zip \
	&& unzip youtube-dl-webui.zip \
	&& cd youtubedl-webui*/ \
	&& cp -r ./* $YOUTUBE_DL_WEBUI_SOURCE/ \
	&& ln -s $YOUTUBE_DL_WEBUI_SOURCE/example_config.json /etc/youtube-dl-webui.json \
	&& cd .. && rm -rf youtubedl-webui* \
	&& apt-get purge -y --auto-remove wget unzip dirmngr \
	&& rm -fr /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin
COPY default_config.json /config.json

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5555

VOLUME ["/youtube_dl"]

CMD ["python", "-m", "youtube_dl_webui"]
