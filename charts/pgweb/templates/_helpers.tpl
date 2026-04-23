{{/*
Build the PostgreSQL connection URL from individual parameters.
Format: postgres://user:password@host:port/database?sslmode=<sslmode>
*/}}
{{- define "pgweb.databaseUrl" -}}
{{- $pg := .Values.postgresql -}}
{{- printf "postgres://%s:%s@%s:%s/%s?sslmode=%s" $pg.username $pg.password $pg.host (toString $pg.port) $pg.database $pg.sslmode -}}
{{- end -}}
