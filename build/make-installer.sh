#!/bin/bash
cd installer
wget https://github.com/megastep/makeself/releases/download/release-2.4.2/makeself-2.4.2.run
bash ./makeself-2.4.2.run
rm -rf root 2>/dev/null
mkdir root
pushd root 2>/dev/null
tar xvzf ../root.tar.gz
popd 2>/dev/null
cp -av ../lib/dotnet ../lib/lang root/usr/lib/ghul
cp ../ghul root/usr/bin
cp install.sh root
bash ./makeself-2.4.2/makeself.sh root ghul.run "ghūl compiler" ./install.sh
rm -rf root
