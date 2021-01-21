

# Backup Postgresql to Minio S3 

# Supported Versions
* 9 
* 10
* 11
* 12
* 13

#### `cp .env.example .env`
```
MINIO_ACCESS_KEY=12345678
MINIO_SECRET_KEY=12345678
MINIO_BUCKET=minio
MINIO_SERVER=http://127.0.0.1:9000
```

#### `docker-compose up -d`
```
version: '3'
services:
  pgbackupminio:
    image: insignficant/backup-postgresql-to-minio
    env_file:
      - .env
    network_mode: host
    container_name: pgbackupminio
```


## Required Envionment Variables

- `MINIO_ACCESS_KEY` - Your Minio access key.
- `MINIO_SECRET_KEY` - Your Minio access key.
- `MINIO_BUCKET` - Your Minio bucket.
- `MINIO_HOST` - Your Minio Host

- `POSTGRES_HOST` - Hostname of the PostgreSQL database to backup, alternatively this container can be linked to the container with the name `postgres`.
- `POSTGRES_DATABASE` - Name of the PostgreSQL database to backup.
- `POSTGRES_USER` - PostgreSQL user, with priviledges to dump the database.

### Optional Enviroment Variables

- `POSTGRES_PASSWORD` - Password for the PostgreSQL user, if you are using a database on the same machine this isn't usually needed.
- `POSTGRES_PORT` - Port of the PostgreSQL database, uses the default 5432.
- `POSTGRES_EXTRA_OPTS` - Extra arguments to pass to the `pg_dump` command.
- `MINIO_API_VERSION` - you can change with S3v4 or S3v2.
- `SCHEDULE` - Cron schedule to run periodic backups.


# some script from 
-  URL : https://github.com/wonderu/docker-backup-postgres-s3
-  URL : https://github.com/schickling/dockerfiles/tree/master/postgres-backup-s3 
-  More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
