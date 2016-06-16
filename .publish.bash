#!/bin/bash -ex

mkdir -p ~/.docker && openssl aes-256-cbc -K $encrypted_42099b4af021_key -iv $encrypted_42099b4af021_iv -in .dockercfg.enc -out ~/.docker/config.json -d
if [ "$TRAVIS_BRANCH" == "master" ]; then
  echo "Deploying image to docker hub for master (latest)"
  docker push "mvisonneau/php:latest"
elif [ ! -z "$TRAVIS_TAG" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  echo "Deploying image to docker hub for tag ${TRAVIS_TAG}"
  docker push "mvisonneau/php:${TRAVIS_TAG}"
elif [ ! -z "$TRAVIS_BRANCH" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  echo "Deploying image to docker hub for branch ${TRAVIS_BRANCH}"
  docker push "mvisonneau/php:${TRAVIS_BRANCH}"
else
  echo "Not deploying image"
fi
