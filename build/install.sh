#!/bin/bash
sudo -- sh -c "rm -r /tmp/ghul /tmp/lib" 2>/dev/null
docker run --rm -v /tmp:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` ghul/compiler:stable /bin/bash -c "cp /usr/bin/ghul /home/dev/source; cp -r /usr/lib/ghul /home/dev/source/lib"
sudo -- sh -c "mv /tmp/ghul /usr/bin ; chown root:root /usr/bin/ghul ; mkdir -p /usr/lib/ghul ; rm -r /usr/lib/ghul/* 2>/dev/null ; cp -r /tmp/lib/* /usr/lib/ghul/ ; chown -R root:root /usr/lib/ghul/ ; rm -r /tmp/lib"
