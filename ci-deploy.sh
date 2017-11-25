#!/bin/bash
set -e
docker pull ghul/compiler:release-candidate
docker tag ghul/compiler:release-candidate ghul/compiler:stable
docker push ghul/compiler:stable


