{{/* vim: set filetype=mustache: */}}

{{- define "deployer.role.kind" -}}
{{- if .Values.existingRole -}}
{{- .Values.existingRole.kind -}}
{{- else -}}
{{- .Values.role.kind -}}
{{- end -}}
{{- end -}}

{{- define "deployer.role.name" -}}
{{- if .Values.existingRole -}}
{{- .Values.existingRole.name -}}
{{- else -}}
{{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}
