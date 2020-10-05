#!/bin/bash

# not sure if I'm using it wrong or it's simply flaky but this seems to fail randomly from time to time. Try it a few times until it produces output, or we get sick of trying:
for I in 1 2 3 ; do
    if docker run --env CHANGELOG_GITHUB_TOKEN --rm -v `pwd`:/usr/local/src/your-app ferrarimarco/github-changelog-generator -u degory -p ghul ; then
        break;
    fi
    sleep 5
done

if [ -f CHANGELOG.md ] ; then
    echo "::set-output name=success::true"
else
    echo "::set-output name=success::false"
fi