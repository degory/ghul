#!/bin/bash
docker tag docker.giantblob.com/ghul:release-candidate docker.giantblob.com/ghul:stable
docker push docker.giantblob.com/ghul:stable

docker tag degory/ghul:release-candidate degory/ghul:stable || echo "Could not push to public Docker registry"
docker push degory/ghul:stable || echo "Could not push to public Docker registry"

