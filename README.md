# youtube-dl-webui

修复2个错误，支持youtube-dl所支持的全部网站了！

**issues** are welcomed!

# Screenshot

![screenshot1](screen_shot/1.gif)

# Prerequisite

This project is writen under the **python 3.6**, I haven't test the codes in
any other python versions. So, I hightly recommend you to use python 3.6 to
avoid any troubles.

Also, we need **[ffmpeg](https://www.ffmpeg.org/download.html)** for post
processing. Lack of ffmpeg may case some funtions not working.

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


---

[1]: https://github.com/rg3/youtube-dl
[2]: https://github.com/avignat/Youtube-dl-WebUI
[3]: https://github.com/pallets/flask
[4]: https://hub.docker.com/r/d0u9/youtube-dl-webui/

