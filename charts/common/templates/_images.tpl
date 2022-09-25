{{/*
Renders the image pull policy.
Default to Always if using a rolling tag, otherwise IfNotPresent.

Usage: {{ include "common.images.pullPolicy" (dict "imageRoot" $ "rollingTags" (list latest)) }}
*/}}
{{- define "common.images.pullPolicy" -}}
{{- $defaultRollingTags := list "latest" "master" "main" "stable" "develop" "dev" -}}
{{- $extraRollingTags := .rollingTags | default (list) -}}
{{- if .imageRoot.pullPolicy -}}
{{- .imageRoot.pullPolicy -}}
{{- else -}}
{{- ternary "Always" "IfNotPresent" (has .imageRoot.tag (concat $defaultRollingTags $extraRollingTags)) -}}
{{- end -}}
{{- end -}}
