{{- define "tplchart.ingress" -}}
{{- $builtins := pick .context "Capabilities" "Chart" "Files" "Release" -}}
{{- $ctx := merge $builtins (include "tplchart.utils.componentValues" . | fromYaml) -}}
{{- with $ctx -}}
{{- if .Values.ingress.enabled -}}
---
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ include "common.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list .Args.labels .Values.ingress.labels .Values.commonLabels) "component" .Args.component "context" .) | nindent 4 }}
  {{- if or .Args.annotations .Values.ingress.annotations .Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list .Args.annotations .Values.ingress.annotations .Values.commonAnnotations) "context" .) | nindent 4 -}}
  {{- end }}
spec:
  {{- if and .Values.ingress.ingressClassName (eq "true" (include "common.ingress.supportsIngressClassname" .)) }}
  ingressClassName: {{ include "common.tplvalues.render" (dict "value" .Values.ingress.ingressClassName "context" .) | quote }}
  {{- end }}
  rules:
    {{- if .Values.ingress.hostname }}
    - host: {{ include "common.tplvalues.render" (dict "value" .Values.ingress.hostname "context" .) }}
      http:
        paths:
          {{- if .Values.ingress.extraPaths }}
          {{- toYaml .Values.ingress.extraPaths | nindent 10 }}
          {{- end }}
          - path: {{ .Values.ingress.path }}
            {{- if eq "true" (include "common.ingress.supportsPathType" .) }}
            pathType: {{ .Values.ingress.pathType | default "ImplementationSpecific" }}
            {{- end }}
            backend: {{- include "common.ingress.backend" (dict "serviceName" .Args.serviceName "servicePort" .Args.servicePort "context" .)  | nindent 14 }}
    {{- end }}
    {{- range .Values.ingress.extraHosts }}
    - host: {{ include "common.tplvalues.render" (dict "value" .name "context" .) | quote }}
      http:
        paths:
          - path: {{ default "/" .path }}
            {{- if eq "true" (include "common.ingress.supportsPathType" .) }}
            pathType: {{ .pathType | default "ImplementationSpecific" }}
            {{- end }}
            backend: {{- include "common.ingress.backend" (dict "serviceName" .Args.serviceName "servicePort" .Args.servicePort "context" .) | nindent 14 }}
    {{- end }}
    {{- if .Values.ingress.extraRules }}
    {{- include "common.tplvalues.render" (dict "value" .Values.ingress.extraRules "context" .) | nindent 4 }}
    {{- end }}
  {{- if or (and .Values.ingress.tls (or .Values.ingress.existingSecret (include "common.ingress.certManagerRequest" ( dict "annotations" .Values.ingress.annotations )) .Values.ingress.selfSigned)) .Values.ingress.extraTls }}
  tls:
    {{- if and .Values.ingress.tls (or .Values.ingress.existingSecret (include "common.ingress.certManagerRequest" ( dict "annotations" .Values.ingress.annotations )) .Values.ingress.selfSigned) }}
    - hosts:
        - {{ include "common.tplvalues.render" (dict "value" .Values.ingress.hostname "context" .) | quote }}
      {{- if .Values.ingress.existingSecret }}
      secretName: {{ .Values.ingress.existingSecret }}
      {{- else }}
      secretName: {{ include "common.tplvalues.render" (dict "value" (printf "%s-tls" .Values.ingress.hostname) "context" .) }}
      {{- end }}
    {{- end }}
    {{- if .Values.ingress.extraTls }}
    {{- include "common.tplvalues.render" ( dict "value" .Values.ingress.extraTls "context" .) | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end -}}
{{- end -}}
