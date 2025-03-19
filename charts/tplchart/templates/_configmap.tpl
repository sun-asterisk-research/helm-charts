{{- define "tplchart.configMap" -}}
{{- $Args := .Args | default dict -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ (include "tplchart.renderName" (dict "name" $Args.name "nameTemplate" $Args.nameTemplate "context" .context)) }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.labels" (dict "customLabels" (list $Args.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
data:
  {{- if kindIs "string" $Args.data -}}
  {{ $Args.data | nindent 2 }}
  {{- else -}}
  {{- range $key, $value := $Args.data }}
  {{- if $value | toString | contains "\n" }}
  {{ $key }}: |-
    {{ $value | nindent 4 }}
  {{- else }}
  {{ $key }}: {{ $value | default "" | quote }}
  {{- end }}
  {{- end }}
  {{- end -}}
{{- end -}}
