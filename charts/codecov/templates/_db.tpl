{{/* vim: set filetype=mustache: */}}
{{- define "codecov.db.host" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- .Values.config.services.postgres.host -}}
  {{- end -}}
{{- end -}}

{{- define "codecov.db.port" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.service.port | default 5432 -}}
  {{- else -}}
    {{- .Values.config.services.postgres.port -}}
  {{- end -}}
{{- end }}

{{- define "codecov.db.database" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.auth.database -}}
  {{- else -}}
    {{- .Values.config.services.postgres.database -}}
  {{- end -}}
{{- end }}

{{- define "codecov.db.username" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.auth.username -}}
  {{- else -}}
    {{- .Values.config.services.postgres.username -}}
  {{- end -}}
{{- end }}

{{- define "codecov.db.password" -}}
  {{- if eq .Values.postgresql.enabled true -}}
    {{- .Values.postgresql.auth.postgresPassword | required ".Values.postgresql.auth.postgresPassword is required" -}}
  {{- else -}}
    {{- .Values.config.services.postgres.password -}}
  {{- end -}}
{{- end }}

{{- define "codecov.db.url" -}}
{{- printf "postgres://%s:%s@%s:%s/%s"
    (include "codecov.db.username" .)
    (include "codecov.db.password" .)
    (include "codecov.db.host" .)
    (include "codecov.db.port" .)
    (include "codecov.db.database" .)
-}}
{{- end }}

{{- define "codecov.db.timescaleUrl" -}}
{{- printf "postgres://postgres:%s@%s:5432/postgres"
    .Values.timescaledb.secrets.credentials.PATRONI_SUPERUSER_PASSWORD
    .Values.timescaledb.fullnameOverride
-}}
{{- end }}
