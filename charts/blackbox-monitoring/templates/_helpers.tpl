{{/* vim: set filetype=mustache: */}}

{{- define "blackbox-monitoring.prometheus.url" -}}
{{- if .Values.prometheus.enabled -}}
{{ printf "http://%s-server" (include "common.subchart.tpl" (list . "prometheus" "prometheus.fullname")) }}:{{ .Values.prometheus.server.service.servicePort }}
{{- else -}}
{{- printf "%s" .Values.externalPrometheus.url -}}
{{- end -}}
{{- end -}}

{{- define "blackbox-monitoring.prometheus.auth.enabled" -}}
{{- print "%s" (ternary "false" "true" (or (empty .Values.externalPrometheus.auth.username) (empty .Values.externalPrometheus.auth.password))) -}}
{{- end -}}

{{- define "blackbox-monitoring.prometheus.auth.username" -}}
{{- printf "%s" .Values.externalPrometheus.auth.username -}}
{{- end -}}

{{- define "blackbox-monitoring.prometheus.auth.password" -}}
{{- printf "%s" .Values.externalPrometheus.auth.password -}}
{{- end -}}
