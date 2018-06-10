#!/bin/sh

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Pull request build."
  DOCKER_TAG="pr-$TRAVIS_PULL_REQUEST-$TRAVIS_BUILD_NUMBER"
else
  if echo "$TRAVIS_BRANCH" | grep -e "^fix\/.*" -e "^feature\/.*"; then
    echo "Skipping docker build."
    exit 0
  fi
  echo "Normal build."
  DOCKER_TAG=$TRAVIS_BRANCH
fi

docker build . -t $TRAVIS_REPO_SLUG:$DOCKER_TAG -f Dockerfile
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push $TRAVIS_REPO_SLUG:$DOCKER_TAG
