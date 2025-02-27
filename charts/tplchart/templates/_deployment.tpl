{{- define "tplchart.deployment" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
---
apiVersion: {{ include "common.capabilities.deployment.apiVersion" .context }}
kind: Deployment
metadata:
  name: {{ (include "tplchart.common.fullname" (dict "name" $Args.name "nameTemplate" $Args.nameTemplate "context" .context)) }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list $Args.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
spec:
  {{- if not ($Values.autoscaling).enabled }}
  replicas: {{ $Values.replicaCount | default 1 }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "tplchart.common.matchLabels" (dict "customLabels" (list $Args.podLabels $Values.podLabels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 6 -}}
  {{- if $Values.updateStrategy }}
  strategy: {{- toYaml $Values.updateStrategy | nindent 4 }}
  {{- end }}
  template:
    {{- include "tplchart.podTemplate" (dict "context" .context "Scope" .Scope "Args" $Args) | nindent 4 }}
{{- end -}}
