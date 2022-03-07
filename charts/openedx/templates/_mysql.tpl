{{/* vim: set filetype=mustache: */}}
{{/*
Subchart mysql fullnames
*/}}
{{- define "openedx.mysql.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openedx.mysql.host" -}}
  {{- if eq .Values.mysql.enabled true -}}
    {{- template "openedx.mysql.fullname" . -}}
  {{- else -}}
    {{- .Values.externalMysql.host -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.mysql.password" -}}
  {{- if and (not .Values.mysql.enabled) .Values.externalMysql.password -}}
    {{- .Values.externalMysql.password -}}
  {{- end -}}
  {{- if and .Values.mysql.enabled .Values.mysql.auth.password .Values.mysql.auth.rootPassword -}}
    {{- .Values.mysql.auth.password -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.mysql.port" -}}
  {{- if eq .Values.mysql.enabled true -}}
    {{- printf "%s" "3306" -}}
  {{- else -}}
    {{- .Values.externalMysql.port -}}
  {{- end -}}
{{- end -}}
