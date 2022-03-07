if [ "$DEBUG" = true ]; then
    show_queries="--echo-queries"
fi

PGPASSWORD="$POSTGRESQL_POSTGRES_PASSWORD" psql -U postgres \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    "$show_queries" \
    < /opt/script/init-db.sql
