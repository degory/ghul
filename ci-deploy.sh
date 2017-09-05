#!/bin/bash
docker tag docker.giantblob.com/ghul:release-candidate docker.giantblob.com/ghul:stable
docker push docker.giantblob.com/ghul:stable
