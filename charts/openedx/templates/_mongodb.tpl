{{/* vim: set filetype=mustache: */}}
{{/*
Subchart mongodb fullnames
*/}}
{{- define "openedx.mongodb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mongodb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openedx.mongodb.host" -}}
  {{- if eq .Values.mongodb.enabled true -}}
    {{- template "openedx.mongodb.fullname" . -}}
  {{- else -}}
    {{- .Values.externalMongodb.host -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.mongodb.password" -}}
  {{- if and (not .Values.mongodb.enabled) .Values.externalMongodb.password -}}
    {{- .Values.externalMongodb.password -}}
  {{- end -}}
  {{- if and .Values.mongodb.enabled .Values.mongodb.auth.password -}}
    {{- .Values.mongodb.auth.password -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.mongodb.port" -}}
  {{- if eq .Values.mongodb.enabled true -}}
    {{ .Values.mongodb.service.port }}
  {{- else -}}
    {{- .Values.externalMongodb.port -}}
  {{- end -}}
{{- end -}}
