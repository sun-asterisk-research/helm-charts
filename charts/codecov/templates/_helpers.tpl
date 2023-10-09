{{/* vim: set filetype=mustache: */}}

{{- define "codecov.checksums.appConfig" -}}
checksum/configmap: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- if not (empty .Values.secretFiles) }}
checksum/secretFiles: {{ include (print $.Template.BasePath "/secret-files.yaml") . | sha256sum }}
{{- end }}
{{- end -}}

{{- define "codecov.env" -}}
- configMapRef:
    name: {{ template "common.names.fullname" . }}
- secretRef:
    name: {{ template "common.names.fullname" . }}
{{- end -}}

{{- define "codecov.volumes" -}}
{{- if not (empty .Values.secretFiles) -}}
- name: secret-files
  secret:
    secretName: {{ template "common.names.fullname" . }}-secret-files
    defaultMode: 0640
{{- end -}}
{{- end -}}

{{- define "codecov.volumeMounts" -}}
{{- range $filename, $content := .Values.secretFiles -}}
- name: secret-files
  mountPath: {{ printf "/home/codecov/%s" $filename }}
  subPath: {{ $filename }}
{{- end -}}
{{- end -}}

{{/*
Returns the ServiceAccount name
*/}}
{{- define "codecov.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
