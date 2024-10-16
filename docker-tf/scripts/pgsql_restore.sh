#!/bin/bash

PG_CONTAINER=$1
DUMP_PATH=$2

PGPASSWORD=$POSTGRES_PASSWORD
export PGPASSWORD

dbUser=$POSTGRES_USER
database=$POSTGRES_DB
host=$POSTGRES_HOST
port=$POSTGRES_PORT

docker exec $PG_CONTAINER psql -U $dbUser -h 127.0.0.1 -d $database -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
docker exec $PG_CONTAINER psql -U $dbUser -h 127.0.0.1 -d $database -f $DUMP_PATH


#docker exec postgres psql -U postgres -d database -h localhost -p 5432 -f /db/2024-08-19.dump
unset PGPASSWORD
