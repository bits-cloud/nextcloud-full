#!/bin/bash

HOSTNAME=""
PORT=""
RESULT=1

function split(){
  local - IFS=":"
  set -o noglob

  local SPLIT=( $1 )

  HOSTNAME="${SPLIT[0]}"
  PORT="${SPLIT[1]}"
}

if [ -n "${POSTGRES_HOST}" ]; then
  echo "CHECKING IF POSTGRES DATABASE IS READY"

  split "${POSTGRES_HOST}"

  while [ ${RESULT} -ne 0 ]; do
    sleep 1
    /usr/bin/pg_isready --username="${POSTGRES_USER}" --dbname="${POSTGRES_DB}" --host="${HOSTNAME}" --port="${PORT:=5432}" --timeout=1
    RESULT="$?"
  done
fi

RESULT=1

if [ -n "${MYSQL_HOST}" ]; then
  echo "CHECKING IF MYSQL DATABASE IS READY"

  split "${MYSQL_HOST}"

  while [ ${RESULT} -ne 0 ]; do
    sleep 1
    /usr/bin/mysqladmin --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" --host="${HOSTNAME}" --port="${PORT:=3306}" --connect-timeout=1 status
    RESULT="$?"
  done
fi

echo "DATABASE READY..."
echo "STARTING SUPERVISORD..."

/usr/bin/supervisord -c /etc/supervisord.conf
