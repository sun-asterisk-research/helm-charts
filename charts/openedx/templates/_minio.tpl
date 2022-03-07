{{/* vim: set filetype=mustache: */}}
{{/*
Subchart minio fullnames
*/}}
{{- define "openedx.minio.fullname" -}}
{{- printf "%s-%s" .Release.Name "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "openedx.minio.host" -}}
  {{- if eq .Values.minio.enabled true -}}
    {{- template "openedx.minio.fullname" . -}}
  {{- else -}}
    {{- .Values.externalStorage.host -}}
  {{- end -}}
{{- end -}}

{{- define "openedx.minio.accessKey" -}}
{{ .Values.minio.accessKey.password }}
{{- end -}}

{{- define "openedx.minio.secretKey" -}}
{{ .Values.minio.secretKey.password }}
{{- end -}}
