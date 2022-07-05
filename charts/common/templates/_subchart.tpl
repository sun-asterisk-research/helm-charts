{{/* vim: set filetype=mustache: */}}

{{/*
Call a template from the context of a subchart.

https://git.io/JvuGN

Usage:
  {{ include "common.subchart.tpl" (dict "context" <context> "subchart" "<subchart_name>" "tpl" "<subchart_template_name>") }}
*/}}
{{- define "common.subchart.tpl" -}}
{{- $subchartPath := .subchart | splitList "." }}
{{- $chartName := last $subchartPath -}}
{{- $values := .context.Values }}
{{- range $subchartPath }}
{{- $values = index $values . }}
{{- end }}
{{- include .tpl (dict "Chart" (dict "Name" $chartName) "Values" $values "Release" .context.Release "Capabilities" .context.Capabilities) }}
{{- end -}}
