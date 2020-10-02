FROM ghul/llc:stable
COPY installer/ghul.run .
RUN \
    mkdir /tmp/lcache && \
    chmod 1777 /tmp/lcache && \
    bash ./ghul.run -- -D
VOLUME /home/dev/source/
USER dev:dev
ENTRYPOINT ["fixuid"]
