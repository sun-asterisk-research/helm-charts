{{/* vim: set filetype=mustache: */}}
{{/*
Subchart redis fullnames
*/}}
{{- define "openedx.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openedx.redis.host" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- template "openedx.redis.fullname" . -}}-master
  {{- else -}}
    {{- .Values.externalRedis.host -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.redis.port" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s" "6379" -}}
  {{- else -}}
    {{- .Values.externalRedis.port -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.redis.password" -}}
  {{- if and (not .Values.redis.enabled) .Values.externalRedis.password -}}
    {{- .Values.externalRedis.password -}}
  {{- end -}}
  {{- if and .Values.redis.enabled .Values.redis.password .Values.redis.usePassword -}}
    {{- .Values.redis.password -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.redis.connection-string" -}}
{{- $redisPassword := include "openedx.redis.password" . -}}
redis://{{ if $redisPassword }}:{{ $redisPassword }}@{{ end }}{{ include "openedx.redis.host" . }}:{{ include "openedx.redis.port" . }}
{{- end -}}
