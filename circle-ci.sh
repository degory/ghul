set +x
export BUILD_NUMBER=circle-ci-$CIRCLE_BUILD_NUM
docker login -u "$DOCKER_USER_NAME" -p "$DOCKER_PASSWORD"
set -x
./ci-bootstrap.sh
