if [ "$DEBUG" = true ]; then
    show_queries="--echo-queries"
fi

mysql \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u"$DB_USERNAME" \
    -p"$DB_PASSWORD" \
    "$show_queries" \
    -f < /opt/script/init-db.sql
