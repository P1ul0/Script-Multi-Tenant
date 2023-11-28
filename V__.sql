CREATE SCHEMA IF NOT EXISTS ${SCHEMA_NAME};


CREATE TABLE ${SCHEMA_NAME}.tenants
(
    name     VARCHAR(255),
    jwks_url VARCHAR(255),
    issuer   VARCHAR(255),
    audience VARCHAR(255),
    CONSTRAINT pk_tenants PRIMARY KEY (issuer)
);

INSERT INTO ${SCHEMA_NAME}.tenants (name, jwks_url, issuer, audience)
VALUES ('${SCHEMA_NAME}', '${JWKS_URL}', '${ISSUER}', '${AUDIENCE}');