{{- define "tplchart.service" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ (include "tplchart.common.fullname" (dict "name" $Args.name "nameTemplate" $Args.nameTemplate "context" .context)) }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list $Args.labels $Values.service.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations $Values.service.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations $Values.service.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
spec:
  type: {{ $Values.service.type }}
  {{- if $Values.service.sessionAffinity }}
  sessionAffinity: {{ $Values.service.sessionAffinity }}
  {{- end }}
  {{- if $Values.service.sessionAffinityConfig }}
  sessionAffinityConfig:
    {{- include "common.tplvalues.render" (dict "value" $Values.service.sessionAffinityConfig "context" .context) | nindent 4 }}
  {{- end }}
  {{- if and $Values.service.clusterIP (eq $Values.service.type "ClusterIP") }}
  clusterIP: {{ $Values.service.clusterIP }}
  {{- end }}
  {{- if (and (eq $Values.service.type "LoadBalancer") (not (empty $Values.service.loadBalancerIP))) }}
  loadBalancerIP: {{ $Values.service.loadBalancerIP }}
  {{- end }}
  {{- if and (eq $Values.service.type "LoadBalancer") $Values.service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges: {{- toYaml $Values.service.loadBalancerSourceRanges | nindent 4 }}
  {{- end }}
  {{- if or (eq $Values.service.type "LoadBalancer") (eq $Values.service.type "NodePort") }}
  externalTrafficPolicy: {{ $Values.service.externalTrafficPolicy }}
  {{- end }}
  ports:
  {{- if $Args.ports }}
    {{- $Args.ports | toYaml | nindent 4 }}
  {{- else }}
    {{- range $port, $number := $Values.service.ports }}
    - name: {{ $port }}
      protocol: {{ index ($Args.protocols | default dict) $port | default "TCP" }}
      port: {{ $number }}
      {{- $targetPort := index ($Values.service.targetPorts | default dict) $port | default $port }}
      targetPort: {{ $targetPort }}
      {{- $nodePort := index ($Values.service.nodePorts | default dict) $port }}
      {{- if (and (list "NodePort" "LoadBalancer" | has $Values.service.type) (not (empty $nodePort))) }}
      nodePort: {{ $nodePort }}
      {{- end }}
    {{- end }}
  {{- end }}
  selector:
    {{- include "tplchart.common.matchLabels" (dict "customLabels" (list $Args.labels $Values.podLabels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 -}}
{{- end -}}
