{{/* vim: set filetype=mustache: */}}
{{/*
Returns the HAProxy image
*/}}
{{- define "redis-ha.haproxyImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.haproxy.image ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redis-ha.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.haproxy.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the HAProxy service account to use
*/}}
{{- define "redis-ha.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
