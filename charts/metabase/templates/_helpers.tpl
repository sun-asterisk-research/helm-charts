{{/*
Returns the metabase image
*/}}
{{- define "metabase.image" -}}
{{- $image := empty .Values.image.tag | ternary (merge .Values.image (dict "tag" .Chart.AppVersion)) .Values.image -}}
{{- include "common.images.image" ( dict "imageRoot" $image ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "metabase.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{- define "metabase.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
