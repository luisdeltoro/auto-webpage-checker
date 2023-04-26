#!/usr/bin/env bash

generate_version() {
  GIT_SHA=$(git rev-parse --short HEAD)
  DT=$(date +'%Y.%m.%d')
  echo "${DT}_${GIT_SHA}"
}

VERSION=$(generate_version)
echo $VERSION > out/version.txt
echo $VERSION