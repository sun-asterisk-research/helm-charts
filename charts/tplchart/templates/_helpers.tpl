{{/*
Render component's name.
- If .name is provided, use it as-is.
- If .nameTemplate is provided, render it with "common.names.fullname" as the string (%s) in template.
- Otherwise, render "common.names.fullname" with .context
*/}}
{{- define "tplchart.common.fullname" -}}
{{- if .name -}}
{{- .name -}}
{{- else if .nameTemplate -}}
{{ printf (.nameTemplate | default "%s") (include "common.names.fullname" .context) }}
{{- else -}}
{{- include "common.names.fullname" .context -}}
{{- end -}}
{{- end -}}

{{/*
Render component labels with standard & custom labels
{{ include "tplchart.utils.renderLabels" (dict "customLabels" (list .Args.labels .Values.commonLabels) "component" "myapp" "context" .) }}
*/}}
{{- define "tplchart.common.labels" -}}
{{- $labels := include "tplchart.utils.mergeDicts" (dict "values" .customLabels "context" .context) -}}
{{- include "common.labels.standard" (dict "customLabels" $labels "context" .context) -}}
{{- if .component }}
app.kubernetes.io/component: {{ .component | quote }}
{{- end -}}
{{- end -}}

{{- define "tplchart.common.matchLabels" -}}
{{- $labels := include "tplchart.utils.mergeDicts" (dict "values" .customLabels "context" .context) -}}
{{- include "common.labels.matchLabels" (dict "customLabels" $labels "context" .context) -}}
{{- if .component }}
app.kubernetes.io/component: {{ .component | quote }}
{{- end -}}
{{- end -}}

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
