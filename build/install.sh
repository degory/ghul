#!/bin/bash
docker run --rm -v /tmp:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` ghul/compiler:stable /bin/sh -c "cp /usr/bin/ghul /home/dev/source; cp -r /usr/lib/ghul /home/dev/src/lib"
sudo -- sh -c "mv /tmp/ghul /usr/bin ; chown root:root /usr/bin/ghul ; mkdir -p /usb/lib/ghul ; mv /tmp/ghul.ghul /usb/lib/ghul ; chown root:root /usr/lib/ghul/ghul.ghul"
