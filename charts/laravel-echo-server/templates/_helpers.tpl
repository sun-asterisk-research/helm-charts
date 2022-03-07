{{/* vim: set filetype=mustache: */}}
{{/*
Returns the laravel-echo-server image
*/}}
{{- define "laravel-echo-server.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.image ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "laravel-echo-server.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{- define "laravel-echo-server.checksums" -}}
{{- if and .Values.subscribers.redis.enabled (empty .Values.subscribers.redis.passwordSecret) -}}
checksum/secret-redis: {{ include (print $.Template.BasePath "/secret-redis.yaml") . | sha256sum }}
{{ end -}}
{{- if .Values.subscribers.http.enabled -}}
checksum/secret-clients: {{ include (print $.Template.BasePath "/secret-clients.yaml") . | sha256sum }}
{{ end -}}
{{- end -}}
