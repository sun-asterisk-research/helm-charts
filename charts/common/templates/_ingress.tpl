{{/* vim: set filetype=mustache: */}}

{{- define "common.ingress.pathType" -}}
{{- if eq "true" (include "common.ingress.supportsPathType" .context) -}}
pathType: {{ default "ImplementationSpecific" (.value | default "ImplementationSpecific") }}
{{- end -}}
{{- end -}}
