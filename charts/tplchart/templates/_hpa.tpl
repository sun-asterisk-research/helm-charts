{{- define "tplchart.hpa" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- if $Values.autoscaling.enabled }}
---
apiVersion: {{ include "common.capabilities.hpa.apiVersion" ( dict "context" .context) }}
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "common.names.fullname" .context }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "common.labels.standard" .context | nindent 4 }}
    {{- if .context.Values.commonLabels }}
    {{- include "common.tplvalues.render" ( dict "value" .context.Values.commonLabels "context" .context) | nindent 4 }}
    {{- end }}
  {{- if .context.Values.commonAnnotations }}
  annotations: {{- include "common.tplvalues.render" ( dict "value" .context.Values.commonAnnotations "context" .context) | nindent 4 }}
  {{- end }}
spec:
  scaleTargetRef:
    apiVersion: {{ include "common.capabilities.deployment.apiVersion" .context }}
    kind: Deployment
    name: {{ include "common.names.fullname" .context }}
  minReplicas: {{ $Values.autoscaling.minReplicas }}
  maxReplicas: {{ $Values.autoscaling.maxReplicas }}
  metrics:
  {{- if $Values.autoscaling.targetCPU }}
    - type: Resource
      resource:
        name: cpu
      {{- if semverCompare "<1.23-0" (include "common.capabilities.kubeVersion" .) }}
        targetAverageUtilization: {{ $Values.autoscaling.targetCPU }}
      {{- else }}
        target:
          type: Utilization
          averageUtilization: {{ $Values.autoscaling.targetCPU }}
      {{- end }}
  {{- end }}
  {{- if $Values.autoscaling.targetMemory }}
    - type: Resource
      resource:
        name: memory
      {{- if semverCompare "<1.23-0" (include "common.capabilities.kubeVersion" .) }}
        targetAverageUtilization: {{ $Values.autoscaling.targetMemory }}
      {{- else }}
        target:
          type: Utilization
          averageUtilization: {{ $Values.autoscaling.targetMemory }}
      {{- end }}
  {{- end }}
  {{- if $Values.autoscaling.metrics }}
  {{- include "common.tplvalues.render" (dict "value" $Values.autoscaling.metrics "context" $) | nindent 4 }}
  {{- end }}
{{- end }}
{{- end -}}
