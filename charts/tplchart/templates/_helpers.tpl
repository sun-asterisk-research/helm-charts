{{/*
Render component's name.
- If .name is provided, use it as-is.
- If .nameTemplate is provided, render it with "common.names.fullname" as the string (%s) in template.
- Otherwise, render "common.names.fullname" with .context
*/}}
{{- define "tplchart.renderName" -}}
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
{{- define "tplchart.labels" -}}
{{- $labels := include "tplchart.utils.mergeDicts" (dict "values" .customLabels "context" .context) -}}
{{- include "common.labels.standard" (dict "customLabels" $labels "context" .context) -}}
{{- if .component }}
app.kubernetes.io/component: {{ .component | quote }}
{{- end -}}
{{- end -}}

{{- define "tplchart.matchLabels" -}}
{{- $labels := include "tplchart.utils.mergeDicts" (dict "values" .customLabels "context" .context) -}}
{{- include "common.labels.matchLabels" (dict "customLabels" $labels "context" .context) -}}
{{- if .component }}
app.kubernetes.io/component: {{ .component | quote }}
{{- end -}}
{{- end -}}

{{/*
Format a dict of values as environment variables.
Convert keys to upper snake cases with optional replacements. Convert values to strings.
{{ include "tplchart.utils.renderLabels" (dict "customLabels" (list .Args.labels .Values.commonLabels) "component" "myapp" "context" .) }}
*/}}
{{- define "tplchart.configEnv" -}}
{{- $replacements := .replace | default dict }}
{{- range $key, $value := .vars }}
  {{- $varName := $key | snakecase | upper }}
  {{- range $find, $replace := $replacements -}}
    {{- $varName = replace $find $replace $varName }}
  {{- end -}}
  {{ $varName | nindent 0 }}: {{ print "" -}}
    {{/* Format numbers as string with many trailing zeros and strip them so large numbers don't get converted to float64 */}}
    {{- if kindIs "float64" $value }}
      {{- $fval := printf "%.10f" $value }}
      {{- mustRegexReplaceAll "\\.?0+$" $fval "${1}" | quote }}
    {{- else }}
      {{- $value | quote }}
    {{- end }}
{{- end }}
{{- end -}}
