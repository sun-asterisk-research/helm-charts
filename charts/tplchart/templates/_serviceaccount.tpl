{{- define "tplchart.serviceAccount" -}}
{{- $builtins := pick .context "Capabilities" "Chart" "Files" "Release" -}}
{{- $ctx := merge $builtins (include "tplchart.utils.componentValues" . | fromYaml) -}}
{{- with $ctx -}}
{{- if .Values.serviceAccount.create -}}
---
kind: ServiceAccount
apiVersion: v1
metadata:
  name: {{ include "tplchart.serviceAccountName" . }}
  namespace: {{ include "common.names.namespace" . | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list .Args.labels .Values.serviceAccount.labels .Values.commonLabels) "component" .Args.component "context" .) | nindent 4 }}
  {{- if or .Args.annotations .Values.serviceAccount.annotations .Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list .Args.annotations .Values.serviceAccount.annotations .Values.commonAnnotations) "context" .) | nindent 4 -}}
  {{- end }}
automountServiceAccountToken: {{ .Values.serviceAccount.automountServiceAccountToken | default true }}
{{- if .Args.imagePullSecrets -}}
{{- include "tplchart.utils.renderYaml" .Args.imagePullSecrets -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
