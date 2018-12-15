FROM ghul/llc:stable
COPY ghul /usr/bin/
COPY libLLVM-5.0.so.1 /usr/lib/
COPY libLLVM-6.0.so.1 /usr/lib/
COPY libLLVM-7.0.so.1 /usr/lib/
COPY libLLVM-8.0.so.1 /usr/lib/
RUN ln -fs /usr/lib/libLLVM-5.0.so.1 /usr/lib/libLLVM-5.0.so
RUN ln -fs /usr/lib/libLLVM-6.0.so.1 /usr/lib/libLLVM-6.0.so
RUN ln -fs /usr/lib/libLLVM-7.0.so.1 /usr/lib/libLLVM-7.0.so
RUN ln -fs /usr/lib/libLLVM-8.0.so.1 /usr/lib/libLLVM-8.0.so
COPY lib/ /usr/lib/ghul/
RUN mkdir /tmp/lcache && chmod 1777 /tmp/lcache
VOLUME /tmp/lcache/
VOLUME /home/dev/source/
USER dev:dev
ENTRYPOINT ["fixuid"]
