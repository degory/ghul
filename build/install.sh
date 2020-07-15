#!/bin/bash
docker run --rm -v /tmp:/home/dev/source/ -w /home/dev/source -u `id -u`:`id -g` ghul/compiler:stable /bin/bash -c "cp /usr/bin/ghul /usr/lib/ghul/ghul.ghul /home/dev/source"
sudo -- sh -c "mv /tmp/ghul /usr/bin ; chown root:root /usr/bin/ghul ; mkdir -p /usb/lib/ghul ; mv /tmp/ghul.ghul /usb/lib/ghul ; chown root:root /usr/lib/ghul/ghul.ghul"
