FROM ghul/llc:stable
COPY ghul /usr/bin/
COPY lib/ /usr/lib/ghul/
RUN mkdir /tmp/lcache && chmod 1777 /tmp/lcache
VOLUME /tmp/lcache/
VOLUME /home/dev/source/
USER dev:dev
ENTRYPOINT ["fixuid"]
