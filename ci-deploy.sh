#!/bin/bash
set -e
echo pull
docker pull ghul/compiler:release-candidate
echo tag
docker tag ghul/compiler:release-candidate ghul/compiler:stable
echo push
docker push ghul/compiler:stable
echo done


