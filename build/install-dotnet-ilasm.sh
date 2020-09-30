#!/bin/bash
VERSION=2.0.8
DUMMY_PROJECT=`mktemp -d`

if [ -z "$DUMMY_PROJECT" ] ; then
    exit 1;
fi

pushd $DUMMY_PROJECT
apt update
apt install libunwind8
dotnet new console
dotnet add package runtime.linux-x64.Microsoft.NETCore.ILAsm --version $VERSION
dotnet add package runtime.linux-x64.Microsoft.NETCore.Runtime.CoreCLR --version $VERSION
cp ~/.nuget/packages/runtime.linux-x64.microsoft.netcore.runtime.coreclr/$VERSION/runtimes/linux-x64/native/* ~/.nuget/packages/runtime.linux-x64.microsoft.netcore.ilasm/$VERSION/runtimes/linux-x64/native
echo -e "#!/bin/bash\n~/.nuget/packages/runtime.linux-x64.microsoft.netcore.ilasm/$VERSION/runtimes/linux-x64/native/ilasm \"\$@\"" >/usr/bin/ilasm
chmod +x /usr/bin/ilasm
popd
rm -r $DUMMY_PROJECT

