#!/bin/bash
set -e
docker tag ghul/compiler:release-candidate ghul/compiler:stable
docker push ghul/compiler:stable


