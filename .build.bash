#!/bin/bash -ex

if [ "${TRAVIS_BRANCH}" == "master" ]; then
  TAG="latest"
elif [ ! -z "${TRAVIS_TAG}" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  TAG=${TRAVIS_TAG}
elif [ ! -z "${TRAVIS_BRANCH}" ] && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  TAG=${TRAVIS_BRANCH}
else
  echo "Don't know how to build image"
  exit 1
fi

echo "Building image with tag ${TAG}"

mkdir -p bin
docker build -t mvisonneau/php:${TAG} .
docker run -d --name php mvisonneau/php:${TAG}
