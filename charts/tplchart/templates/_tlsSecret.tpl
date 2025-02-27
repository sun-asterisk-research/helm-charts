{{- define "tplchart.tlsSecret" -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Args.name }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels: {{- include "common.labels.standard" ( dict "customLabels" .context.Values.commonLabels "context" .context ) | nindent 4 }}
  {{- if .context.Values.commonAnnotations }}
  annotations: {{- include "common.tplvalues.render" ( dict "value" .context.Values.commonAnnotations "context" .context ) | nindent 4 }}
  {{- end }}
type: kubernetes.io/tls
data:
  tls.crt: {{ .Args.certificate | b64enc }}
  tls.key: {{ .Args.key | b64enc }}
{{- end -}}
