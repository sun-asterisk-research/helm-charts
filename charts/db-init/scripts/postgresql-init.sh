if [ "$DEBUG" = true ]; then
    show_queries="--echo-queries"
fi

PGPASSWORD="$DB_PASSWORD" psql -U "$DB_USERNAME" \
    -d "$DB_DATABASE" \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    "$show_queries" \
    < /opt/script/init-db.sql
