{{/* vim: set filetype=mustache: */}}

{{/*
Returns the imaginary image
*/}}
{{- define "imaginary.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.image ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "imaginary.imagePullSecrets" }}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}
