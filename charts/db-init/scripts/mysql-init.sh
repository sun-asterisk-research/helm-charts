if [ "$DEBUG" = true ]; then
    show_queries="--echo-queries"
fi

mysql \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u"$MYSQL_ROOT_USER" \
    -p"$MYSQL_ROOT_PASSWORD" \
    "$show_queries" \
    -f < /opt/script/init-db.sql
