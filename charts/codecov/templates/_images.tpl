
{{/*
Render image pull secrets
*/}}
{{- define "codecov.imagePullSecrets" -}}
{{- $images := list .Values.image -}}
{{- if index .Values "image-pull-secret" "enabled" }}
{{- $secretName := include "common.subchart.tpl" (list . "image-pull-secret" "common.names.fullname") -}}
{{- $images = append $images (dict "pullSecrets" (list ($secretName))) -}}
{{- end -}}
{{- include "common.images.pullSecrets" (dict "images" $images "global" .Values.global) -}}
{{- end -}}
