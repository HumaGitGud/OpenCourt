FROM mysql:8.0

COPY create_tables.sql /docker-entrypoint-initdb.d/01-create_tables.sql
COPY seed_tables.sql /docker-entrypoint-initdb.d/02-seed_tables.sql