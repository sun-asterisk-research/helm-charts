{{- define "tplchart.ingress" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
{{- $svcName := include "tplchart.renderName" (dict "name" $Args.service.name "nameTemplate" $Args.service.nameTemplate "context" .context) -}}
{{- $backend := include "common.ingress.backend" (dict "serviceName" $svcName "servicePort" $Args.service.port "context" .context) -}}
---
apiVersion: {{ include "common.capabilities.ingress.apiVersion" .context }}
kind: Ingress
metadata:
  name: {{ (include "tplchart.renderName" (dict "name" $Args.name "nameTemplate" $Args.nameTemplate "context" .context)) }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.labels" (dict "customLabels" (list $Args.labels $Values.ingress.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations $Values.ingress.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations $Values.ingress.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
spec:
  {{- if and $Values.ingress.ingressClassName (eq "true" (include "common.ingress.supportsIngressClassname" .context)) }}
  ingressClassName: {{ include "common.tplvalues.render" (dict "value" $Values.ingress.ingressClassName "context" .context) | quote }}
  {{- end }}
  rules:
    {{- if $Values.ingress.hostname }}
    - host: {{ include "common.tplvalues.render" (dict "value" $Values.ingress.hostname "context" .context) }}
      http:
        paths:
          {{- if $Values.ingress.extraPaths }}
          {{- toYaml $Values.ingress.extraPaths | nindent 10 }}
          {{- end }}
          {{- if $Args.extraPaths }}
          {{- toYaml $Args.extraPaths | nindent 10 }}
          {{- end }}
          - path: {{ $Values.ingress.path }}
            {{- if eq "true" (include "common.ingress.supportsPathType" .context) }}
            pathType: {{ $Values.ingress.pathType | default "ImplementationSpecific" }}
            {{- end }}
            backend: {{- $backend | nindent 14 }}
    {{- end }}
    {{- range $Values.ingress.extraHosts }}
    - host: {{ include "common.tplvalues.render" (dict "value" .name "context" $.context) | quote }}
      http:
        paths:
          - path: {{ default "/" .path }}
            {{- if eq "true" (include "common.ingress.supportsPathType" $.context) }}
            pathType: {{ .pathType | default "ImplementationSpecific" }}
            {{- end }}
            backend: {{- $backend | nindent 14 }}
    {{- end }}
    {{- if $Values.ingress.extraRules }}
    {{- include "common.tplvalues.render" (dict "value" $Values.ingress.extraRules "context" .context) | nindent 4 }}
    {{- end }}
  {{- if or (and $Values.ingress.tls (or $Values.ingress.existingSecret (include "common.ingress.certManagerRequest" (dict "annotations" $Values.ingress.annotations)) $Values.ingress.selfSigned)) $Values.ingress.extraTls }}
  tls:
    {{- if and $Values.ingress.tls (or $Values.ingress.existingSecret (include "common.ingress.certManagerRequest" (dict "annotations" $Values.ingress.annotations)) $Values.ingress.selfSigned) }}
    - hosts:
        - {{ include "common.tplvalues.render" (dict "value" $Values.ingress.hostname "context" .context) | quote }}
      {{- if $Values.ingress.existingSecret }}
      secretName: {{ $Values.ingress.existingSecret }}
      {{- else }}
      secretName: {{ include "common.tplvalues.render" (dict "value" (printf "%s-tls" $Values.ingress.hostname) "context" .context) }}
      {{- end }}
    {{- end }}
    {{- if $Values.ingress.extraTls }}
    {{- include "common.tplvalues.render" (dict "value" $Values.ingress.extraTls "context" .context) | nindent 4 }}
    {{- end }}
  {{- end }}
---
{{- if and $Values.ingress.tls $Values.ingress.selfSigned -}}
{{- $secretName := printf "%s-tls" $Values.ingress.hostname }}
{{- $ca := genCA "kubernetes-ca" 365 }}
{{- $cert := genSignedCert $Values.ingress.hostname nil (list $Values.ingress.hostname) 365 $ca }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.labels" (dict "customLabels" .context.Values.commonLabels "component" $Args.component "context" .context) | nindent 4 }}
  {{- if .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" .context.Values.commonAnnotations "context" .context) | nindent 4 -}}
  {{- end }}
type: kubernetes.io/tls
data:
  tls.crt: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" "tls.crt" "defaultValue" $cert.Cert "context" $.context) }}
  tls.key: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" "tls.key" "defaultValue" $cert.Key "context" $.context) }}
  ca.crt: {{ include "common.secrets.lookup" (dict "secret" $secretName "key" "ca.crt" "defaultValue" $ca.Cert "context" $.context) }}
{{- end -}}
{{- end -}}
