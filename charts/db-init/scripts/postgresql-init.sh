if [ "$DEBUG" = true ]; then
    show_queries="--echo-queries"
fi

export PGPASSWORD="$DB_PASSWORD"
export PGSSLMODE="$SSL_MODE"

psql -U "$DB_USERNAME" \
    -d "$DB_DATABASE" \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    "$show_queries" \
    {{- range $arg := .Values.extraArgs }}
    {{ $arg }} \
    {{- end }}
    < /opt/script/init-db.sql
