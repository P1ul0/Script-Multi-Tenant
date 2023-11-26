#!/bin/bash

# Comando para executar o script
#./createTenant.sh "NAME_MIGRATION" "SCHEMA_NAME" "VERSION_MIGRATION" "ISSUER_TENANT" "JWKS_URL" "AUDIENCE"

NAME_MIGRATION=$1
SCHEMA_NAME=$2
VERSION_MIGRATION=$3
ISSUER_TENANT=$4
JWKS_URL=$5
AUDIENCE=$6

if [ -z "$NAME_MIGRATION" ]; then
    echo "Please provide the name of the migration"
    exit 1
fi

if [ -z "$SCHEMA_NAME" ]; then
    echo "Please provide the name of the schema"
    exit 1
fi

if [ -z "$VERSION_MIGRATION" ]; then
    echo "Please provide the version of the migration"
    exit 1
fi

if [ -z "$ISSUER_TENANT" ]; then
    echo "Please provide the issuer of the tenant"
    exit 1
fi

if [ -z "$JWKS_URL" ]; then
    echo "Please provide the jwks url of the tenant"
    exit 1
fi

if [ -z "$AUDIENCE" ]; then
    echo "Please provide the audience of the tenant"
    exit 1
fi

if cp src/main/resources/db/migration/V__.sql src/main/resources/db/migration/${NAME_MIGRATION}.sql;
then
    echo "Migration created"
else
    echo "Error creating migration"
    exit 1
fi

if awk -v SCHEMA_NAME="$SCHEMA_NAME" -v ISSUER_TENANT="$ISSUER_TENANT" -v JWKS_URL="$JWKS_URL" -v AUDIENCE="$AUDIENCE" '{gsub(/\${SCHEMA_NAME}/, SCHEMA_NAME); gsub(/\${ISSUER_TENANT}/, ISSUER_TENANT); gsub(/\${JWKS_URL}/, JWKS_URL); gsub(/\${AUDIENCE}/, AUDIENCE); print}' src/main/resources/db/migration/${NAME_MIGRATION}.sql > temp.sql
then
    echo "Assigning values passed to migrations"
else
    echo "Error updating assigning values passed to migrations"
    exit 1
fi

if mv temp.sql src/main/resources/db/migration/${NAME_MIGRATION}.sql
then
    echo "Migration updated"
else
    echo "Error updating migration"
    exit 1
fi

if mvn flyway:migrate -Dflyway.target=$VERSION_MIGRATION
then
    echo "Migration executed $NAME_MIGRATION for schema $SCHEMA_NAME and version $VERSION_MIGRATION"
else
    echo "Error executing migration $NAME_MIGRATION for schema $SCHEMA_NAME and version $VERSION_MIGRATION"
    exit 1
fi

