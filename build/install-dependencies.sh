if [ "`id -u`" != "0" ] ; then
    echo "not root: will use sudo"
    PREFIX=sudo
fi

$PREFIX apt-get clean
$PREFIX apt-get update
$PREFIX apt-get --yes --force-yes install libgc1c2 wget

if [ ! -x "/usr/bin/chmod" ] ; then
    $PREFIX cp /bin/chmod /usr/bin
fi

if [ "$1" == "-L" ] ; then
    wget https://ghul.io/artefacts/lrt-ithunk-0.2.so
    $PREFIX chown root:root lrt-ithunk-0.2.so
    $PREFIX mkdir -p /usr/lib/lang/linux-x86-64
    $PREFIX cp lrt-ithunk-0.2.so /usr/lib/lang/linux-x86-64
fi
