#!/usr/bin/env bash
set -u
set -e

# Configurable items
PGBOUNCER_HOSTS=""
PGBOUNCER_DATABASE_INI="/etc/pgbouncer.database.ini"
PGBOUNCER_DATABASE="appdb"
PGBOUNCER_PORT=6432

REPMGR_DB="repmgr"
REPMGR_USER="repmgr"

# 1. Promote this node from standby to primary
/usr/pgsql-12/bin/repmgr standby promote -f /etc/repmgr/12/repmgr.conf --log-to-file

# 2. Reconfigure pgbouncer instances
PGBOUNCER_DATABASE_INI_NEW="/tmp/pgbouncer.database.ini"

for HOST in $PGBOUNCER_HOSTS
do
    # Recreate the pgbouncer config file
    echo -e "[databases]\n" > $PGBOUNCER_DATABASE_INI_NEW

    psql -d $REPMGR_DB -U $REPMGR_USER -t -A \
      -c "SELECT '${PGBOUNCER_DATABASE}-rw= ' || conninfo || ' application_name=pgbouncer_${HOST}' \
          FROM repmgr.nodes \
          WHERE active = TRUE AND type='primary'" >> $PGBOUNCER_DATABASE_INI_NEW

    psql -d $REPMGR_DB -U $REPMGR_USER -t -A \
      -c "SELECT '${PGBOUNCER_DATABASE}-ro= ' || conninfo || ' application_name=pgbouncer_${HOST}' \
          FROM repmgr.nodes \
          WHERE node_name='${HOST}'" >> $PGBOUNCER_DATABASE_INI_NEW


    rsync $PGBOUNCER_DATABASE_INI_NEW $HOST:$PGBOUNCER_DATABASE_INI

    psql -tc "reload" -h $HOST -p $PGBOUNCER_PORT -U postgres pgbouncer

done

# Clean up generated file
rm $PGBOUNCER_DATABASE_INI_NEW

echo "Reconfiguration of pgbouncer complete"