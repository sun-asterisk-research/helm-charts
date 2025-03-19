{{- define "tplchart.secret" -}}
{{- $Args := .Args | default dict -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ (include "tplchart.renderName" (dict "name" $Args.name "nameTemplate" $Args.nameTemplate "context" .context)) }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.labels" (dict "customLabels" (list $Args.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
type: {{ $Args.type | default "Opaque" }}
{{- if $Args.data }}
data:
  {{- if kindIs "string" $Args.data -}}
  {{ $Args.data | nindent 2 }}
  {{- else -}}
  {{- range $key, $value := $Args.data }}
  {{ $key }}: {{ $value | toString | b64enc | quote }}
  {{- end }}
  {{- end -}}
{{- end }}
{{- if $Args.stringData }}
stringData:
  {{- if kindIs "string" $Args.stringData -}}
  {{ $Args.stringData | nindent 2 }}
  {{- else -}}
  {{- range $key, $value := $Args.stringData }}
  {{- if $value | toString | contains "\n" }}
  {{ $key }}: |-
    {{- $value | nindent 4 }}
  {{- else }}
  {{ $key }}: {{ $value | default "" | quote }}
  {{- end }}
  {{- end }}
  {{- end -}}
{{- end }}
{{- end -}}
