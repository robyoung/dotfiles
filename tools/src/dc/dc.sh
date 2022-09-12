#!/bin/bash

set -x

if [ -n "${DOCKER_USER}" ]; then
  sudo="sudo -u ${DOCKER_USER}"
else
  sudo=""
fi

function main-container() {
  git config robyoung.dc-main-container || echo flask
}

function test-runner() {
  git config robyoung.dc-test-runner || echo pytest -vvs
}

function postgres-container() {
  git config robyoung.dc-postgres || echo postgres
}

case $1 in
  test)
    if [ $# -eq 1 ]; then
      docker-compose run --rm $(main-container) make test
    else
      shift
      docker-compose run --rm $(main-container) $(test-runner) "$@"
    fi
    ;;
  psql)
    shift
    $sudo docker exec \
      -ti \
      --env COLUMNS=$(tput cols) --env LINES=$(tput lines) \
      --user postgres \
      $(docker-compose ps -q $(postgres-container)) psql "$@"
    ;;
  flask)
    shift
    docker-compose run --rm $(main-container) flask "$@"
    ;;
  alembic)
    shift
    docker-compose run --rm $(main-container) alembic "$@"
    ;;
  *)
    docker-compose "$@"
    ;;
esac
