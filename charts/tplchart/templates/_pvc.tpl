{{- define "tplchart.pvc" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ (include "tplchart.renderName" (dict "name" $Args.name "nameTemplate" $Args.nameTemplate "context" .context)) }}
  labels:
    {{- include "tplchart.labels" (dict "customLabels" (list $Args.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
spec:
  accessModes:
  {{- range $Values.persistence.accessModes }}
  - {{ . | quote }}
  {{- end }}
  resources:
    requests:
      storage: {{ $Values.persistence.size | quote }}
  {{- include "common.storage.class" (dict "persistence" $Values.persistence "global" .context.Values.global) | nindent 2 }}
{{- end -}}
