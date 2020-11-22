FROM xeffyr/termux:latest

COPY ./src fuzzydl/src

RUN echo -e "216.58.201.174 youtube.com\n216.58.209.78 youtube-ui.l.google.com\n216.58.211.238 www.youtube.com\n172.217.168.164 googlevideo.com" \
    >> /system/etc/hosts
RUN echo -e "\n\n# YouTube DNS resolution:\n\nyoutube.com\nyoutube-ui.l.google.com\nwww.youtube.com\ngooglevideo.com\n\n" \
    >> /system/etc/static-dns-hosts.txt
RUN /system/bin/update-static-dns

RUN login && apt-get update -y && apt-get upgrade -y && apt-get install -y zsh && chsh ${user} -s zsh

ENV SHELL=/bin/zsh

ENTRYPOINT [ "/data/data/com.termux/files/usr/bin/login", "fuzzydl/src/lib/fuzzydl_bootstrap.sh" ]

CMD [ "login" ]