if [ "$DEBUG" = true ]; then
    show_queries="--echo-queries"
fi

mysql \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u"$DB_USERNAME" \
    -p"$DB_PASSWORD" \
    --ssl-mode "$SSL_MODE" \
    "$show_queries" \
    {{- range $arg := .Values.extraArgs }}
    {{ $arg }} \
    {{- end }}
    -f < /opt/script/init-db.sql
