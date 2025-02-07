{{- define "tplchart.tlsSecret" -}}
{{- $builtins := pick .context "Capabilities" "Chart" "Files" "Release" -}}
{{- $ctx := merge $builtins (include "tplchart.utils.componentValues" . | fromYaml) -}}
{{- with $ctx -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Args.name }}
  namespace: {{ include "common.names.namespace" . | quote }}
  labels: {{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" . ) | nindent 4 }}
  {{- if .Values.commonAnnotations }}
  annotations: {{- include "common.tplvalues.render" ( dict "value" .Values.commonAnnotations "context" . ) | nindent 4 }}
  {{- end }}
type: kubernetes.io/tls
data:
  tls.crt: {{ .Args.certificate | b64enc }}
  tls.key: {{ .Args.key | b64enc }}
{{- end -}}
{{- end -}}
