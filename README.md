# youtube-dl-webui

修复2个错误，支持youtube-dl所支持的全部网站了！

# Screenshot

![screenshot1](https://github.com/oldiy/youtubedl-webui/raw/master/screen_shot/1.gif)

# Install

To install youtube-dl-webui, you have to firstly install [youtube-dl][1] and
[Flask][3], then simply execute the following command:

    python setup.py install

# How to use

Defaultly, youtube-dl-webui will find the configuration file in `/etc`
directory named `youtube-dl-webui.conf`. The configuration file, however,
need not to be always placed in such a place. Instead, the `-c` option is
used to point out the configuration file.

Configuration file is __json__ formatted. An example configuration file
can be found in the root directory of project.

Currently, not to much options available, use `-h` to find out all of them.

After everything is ready, simply execute:

    youtube-dl-webui -c CONFIGURATION_FILE

A server will be started locally. The default port is **5000**.

**Note**, you have to remove proxy configuration option in your config file. I
write it here for illustrating all valid config options.

# Docker image
[Docker](https://hub.docker.com/r/oldiy/youtube-downloader)

---

[1]: https://github.com/rg3/youtube-dl
[2]: https://github.com/avignat/Youtube-dl-WebUI
[3]: https://github.com/pallets/flask

