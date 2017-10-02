FROM ghul/llc:latest
COPY ghul /usr/bin/
COPY lib/ /usr/lib/ghul/
RUN mkdir /tmp/lcache && chmod 1777 /tmp/lcache
VOLUME /tmp/lcache/

