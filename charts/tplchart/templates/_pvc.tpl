{{- define "tplchart.pvc" -}}
{{- $builtins := pick .context "Capabilities" "Chart" "Files" "Release" -}}
{{- $ctx := merge $builtins (include "tplchart.utils.componentValues" . | fromYaml) -}}
{{- with $ctx -}}
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ (include "tplchart.common.fullname" (dict "name" .Args.name "nameTemplate" .Args.nameTemplate "context" .)) }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list .Args.labels .Values.commonLabels) "component" .Args.component "context" .) | nindent 4 }}
  {{- if or .Args.annotations .Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list .Args.annotations .Values.commonAnnotations) "context" .) | nindent 4 -}}
  {{- end }}
spec:
  accessModes:
  {{- range .Values.persistence.accessModes }}
  - {{ . | quote }}
  {{- end }}
  resources:
    requests:
      storage: {{ .Values.persistence.size | quote }}
  {{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) | nindent 2 }}
{{- end -}}
{{- end -}}
