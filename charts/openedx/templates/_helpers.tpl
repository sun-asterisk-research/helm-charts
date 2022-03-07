{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openedx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openedx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openedx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openedx.labels" -}}
helm.sh/chart: {{ include "openedx.chart" . }}
{{ include "openedx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openedx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openedx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "openedx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "openedx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "openedx.python-settings" -}}
{{ range $setting, $value := . }}
{{ $setting }} = {{ $value | quote }}
{{ end }}
{{- end -}}

{{- define "openedx.cmsDomain" -}}
{{ .Values.cms.subdomain }}.{{ .Values.baseDomain }}
{{- end -}}

{{- define "openedx.lmsDomain" -}}
{{ .Values.lms.subdomain }}.{{ .Values.baseDomain }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "openedx.tplValue" ( dict "value" .Values.path.to.the.Value "context" $ ) }}
*/}}
{{- define "openedx.tplValue" -}}
  {{- if typeIs "string" .value }}
    {{- tpl .value .context }}
  {{- else }}
    {{- tpl (.value | toYaml) .context }}
  {{- end }}
{{- end -}}

{{/*
Pod annotations
*/}}
{{- define "openedx.podAnnotations" -}}
checksum/configmapCms: {{ include (print $.Template.BasePath "/cms/configmap-setting-cms.yaml") . | sha256sum }}
checksum/configmapLms: {{ include (print $.Template.BasePath "/lms/configmap-setting-lms.yaml") . | sha256sum }}
checksum/configmapopenedx: {{ include (print $.Template.BasePath "/configmap-openedx.yaml") . | sha256sum }}
{{- end -}}

{{- define "openedx.jwt.secretKey" -}}
{{ .Values.openedx.jwt.secretKey | required "openedx.jwt.secretKey is required" }}
{{- end -}}

{{- define "openedx.secretKey" -}}
{{ .Values.openedx.secretKey | required "openedx.secretKey is required" }}
{{- end -}}
