{{/*
Render the ingress pathType

Usage: {{ include "common.ingress.pathType" (dict "context" $ "value" .pathType) }}
*/}}
{{- define "common.ingress.pathType" -}}
{{- if eq "true" (include "common.ingress.supportsPathType" .context) -}}
pathType: {{ .value | default "ImplementationSpecific" }}
{{- end -}}
{{- end -}}
