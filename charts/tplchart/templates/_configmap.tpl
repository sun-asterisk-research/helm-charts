{{- define "tplchart.configMap" -}}
{{- $builtins := pick .context "Capabilities" "Chart" "Files" "Release" -}}
{{- $ctx := merge $builtins (include "tplchart.utils.componentValues" . | fromYaml) -}}
{{- with $ctx -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list .Args.labels .Values.commonLabels) "component" .Args.component "context" .) | nindent 4 }}
  {{- if or .Args.annotations .Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list .Args.annotations .Values.commonAnnotations) "context" .) | nindent 4 -}}
  {{- end }}
data:
  {{- if kindIs "string" .Args.data -}}
  {{ .Args.data | nindent 2 }}
  {{- else -}}
  {{- range $key, $value := .Args.data }}
  {{- if $value | toString | contains "\n" }}
  {{ $key }}: |- {{ $value | nindent 4 }}
  {{- else }}
  {{ $key }}: {{ $value | default "" | quote }}
  {{- end }}
  {{- end }}
  {{- end -}}
{{- end -}}
{{- end -}}
