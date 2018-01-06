set +x
docker login -u "$DOCKER_USER_NAME" -p "$DOCKER_PASSWORD" "$DOCKER_REGISTRY"

if [ ! -z $DOCKER_REGISTRY_2 ]; then
    docker login -u "$DOCKER_USER_NAME_2" -p "$DOCKER_PASSWORD_2" "$DOCKER_REGISTRY_2"
fi

set -x

