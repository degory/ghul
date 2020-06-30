copy source/build.ghul.template source/build.ghul
docker volume create lcache
$workspace=(pwd).path
docker run --rm -e LFLAGS="-FB -FN" -v lcache:/tmp/lcache/ -v ${workspace}:/home/dev/source/ -w /home/dev/source -t ghul/compiler:stable ./build.sh
