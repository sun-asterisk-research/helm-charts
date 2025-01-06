{{- define "tplchart.deployment" -}}
{{- $builtins := pick .context "Capabilities" "Chart" "Files" "Release" "Template" -}}
{{- $values := include "tplchart.utils.componentValues" $ | fromYaml -}}
{{- $ctx := merge $builtins $values -}}
{{- with $ctx -}}
---
apiVersion: {{ include "common.capabilities.deployment.apiVersion" . }}
kind: Deployment
metadata:
  name: {{ (include "tplchart.common.fullname" (dict "nameTemplate" .Args.nameTemplate "context" .)) }}
  namespace: {{ include "common.names.namespace" . | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list .Args.labels .Values.commonLabels) "component" .Args.component "context" .) | nindent 4 }}
  {{- if or .Args.annotations .Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list .Args.annotations .Values.commonAnnotations) "context" .) | nindent 4 -}}
  {{- end }}
spec:
  {{- if not (.Values.deployment.autoscaling).enabled }}
  replicas: {{ .Values.deployment.replicaCount | default 1 }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "tplchart.common.matchLabels" (dict "customLabels" (list .Args.podLabels .Values.podLabels .Values.commonLabels) "component" .Args.component "context" .) | nindent 6 -}}
  {{- if .Values.deployment.updateStrategy }}
  strategy: {{- toYaml .Values.deployment.updateStrategy | nindent 4 }}
  {{- end }}
  template:
    {{- include "tplchart.podTemplate" (dict "context" . "values" .Values.deployment "args" .Args) | nindent 4 }}
{{- end -}}
{{- end -}}
