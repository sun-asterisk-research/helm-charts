{{/* vim: set filetype=mustache: */}}
{{/*
Returns the soketi image
*/}}
{{- define "soketi.image" -}}
{{- $defaultTag := printf "%s-%s-%s" .Chart.AppVersion .Values.image.nodeVersion .Values.image.distro -}}
{{- $image := empty .Values.image.tag | ternary (merge .Values.image (dict "tag" $defaultTag)) .Values.image -}}
{{- include "common.images.image" ( dict "imageRoot" $image ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "soketi.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "soketi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
