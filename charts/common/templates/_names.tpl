{{/*
Render name using string template.
- If .name is provided, use it as-is.
- If .nameTemplate is provided, render it with "common.names.fullname" as the string (%s) in template.
- Otherwise, render "common.names.fullname" with .context
Usage:
{{ include "common.names.render" (dict "name" .name "nameTemplate" .nameTemplate "context" .) }}
*/}}
{{- define "common.names.render" -}}
{{- if .name -}}
{{- .name -}}
{{- else if .nameTemplate -}}
{{- printf .nameTemplate (include "common.names.fullname" .context) -}}
{{- else -}}
{{- include "common.names.fullname" .context -}}
{{- end -}}
{{- end -}}
