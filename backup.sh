#! /bin/sh

set -e
set -o pipefail

if [[ -z "${MINIO_ACCESS_KEY}" ]]; then
  echo "You need to set the MINIO_ACCESS_KEY environment variable."
  exit 1
fi

if [[ -z "${MINIO_SECRET_KEY}" ]]; then
  echo "You need to set the MINIO_SECRET_KEY environment variable."
  exit 1
fi

if [[ -z "${MINIO_BUCKET}"  ]]; then
  echo "You need to set the MINIO_BUCKET environment variable."
  exit 1
fi

if [[ -z "${MINIO_SERVER}" ]]; then
  echo "You need to set the MINIO_SERVER environment variable."
  exit 1
fi

if [[ -z "${POSTGRES_DATABASE}" ]]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [[ -z "${POSTGRES_HOST}"  ]]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [[ -z "${POSTGRES_USER}" ]]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [[ -z "${POSTGRES_PASSWORD}" ]]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

export MINIO_ACCESS_KEY=$MINIO_ACCESS_KEY
export MINIO_SECRET_KEY=$MINIO_SECRET_KEY
export MINIO_SERVER=$MINIO_SERVER
export MINIO_API_VERSION=$MINIO_API_VERSION

mc alias set minio "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" --api "$MINIO_API_VERSION" > /dev/null

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > $HOME/tmp_dump.sql.gz

echo "Uploading dump to $MINIO_BUCKET"

mc cp $HOME/tmp_dump.sql.gz minio/$MINIO_BUCKET/${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz || exit 2
rm tmp_dump.sql.gz 
sync

echo "SQL backup uploaded successfully" 1>&2