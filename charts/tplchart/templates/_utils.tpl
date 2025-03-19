{{- define "tplchart.utils.mergeDicts" -}}
{{- if kindIs "string" .values -}}
  {{- .values -}}
{{- else if kindIs "slice" .values -}}
  {{- include "common.tplvalues.merge" (dict "values" .values "context" .context) }}
{{- else if kindIs "map" .values -}}
  {{- toYaml .values -}}
{{- else -}}
  {{- fail (printf "Invalid type for mergeDicts values. Expected string, slice or map. Got %s." (kindOf .values)) -}}
{{- end -}}
{{- end -}}

{{- define "tplchart.utils.renderDicts" -}}
{{- $values := include "common.tplvalues.merge" (dict "values" .values "context" .context) }}
{{- include "common.tplvalues.render" (dict "value" $values "context" .context) -}}
{{- end -}}

{{- define "tplchart.utils.scopedValues" -}}
{{- $values := .context.Values -}}
{{- if .Scope -}}
{{- $values = index $values .Scope -}}
{{- end -}}
{{- toYaml $values -}}
{{- end -}}

{{- define "tplchart.utils.debugDump" -}}
{{- . | toYaml | printf "\n%s" | fail }}
{{- end -}}

{{/*
Render a value to YAML, unless it's a string (already rendered as YAML).
*/}}
{{- define "tplchart.utils.renderYaml" -}}
{{- if kindIs "string" . -}}
{{ . }}
{{- else -}}
{{ toYaml . }}
{{- end -}}
{{- end -}}
