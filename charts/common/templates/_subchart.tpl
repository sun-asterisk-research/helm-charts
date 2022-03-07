{{/* vim: set filetype=mustache: */}}

{{/*
Call a template from the context of a subchart.

https://git.io/JvuGN

Usage:
  {{ include "common.subchart.tpl" (list <context> "<subchart_name>" "<subchart_template_name>") }}
*/}}
{{- define "common.subchart.tpl" -}}
{{- $context := index . 0 }}
{{- $subcharts := index . 1 | splitList "." }}
{{- $chartName := last $subcharts -}}
{{- $template := index . 2 }}
{{- $values := $context.Values }}
{{- range $subcharts }}
{{- $values = index $values . }}
{{- end }}
{{- include $template (dict "Chart" (dict "Name" $chartName) "Values" $values "Release" $context.Release "Capabilities" $context.Capabilities) }}
{{- end -}}
