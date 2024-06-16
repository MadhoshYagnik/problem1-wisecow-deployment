FROM ubuntu:latest
RUN apt-get update \
    && apt-get install -y \
        bash \
        cowsay \
        fortune-mod \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/usr/games:${PATH}"
COPY wisecow.sh /
RUN chmod +x /wisecow.sh
CMD ["./wisecow.sh"]
