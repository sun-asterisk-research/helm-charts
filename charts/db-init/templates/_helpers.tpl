{{/* vim: set filetype=mustache: */}}
{{- define "db-init.mysqlImage" -}}
{{ include "common.images.image" (dict "imageRoot" (mergeOverwrite (dict) .Values.image .Values.mysql.image)) }}
{{- end -}}

{{- define "db-init.postgresqlImage" -}}
{{ include "common.images.image" (dict "imageRoot" (mergeOverwrite (dict) .Values.image .Values.postgresql.image)) }}
{{- end -}}

{{- define "db-init.image" -}}
{{- include (printf "db-init.%sImage" .Values.dbType) . -}}
{{- end -}}

{{- define "db-init.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.mysql.image .Values.postgresql.image) "global" .Values.global) }}
{{- end -}}
