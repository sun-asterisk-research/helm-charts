{{- define "tplchart.serviceAccountName" -}}
{{- if .values.create -}}
  {{- default (include "common.names.fullname" .context) .values.name -}}
{{- else -}}
  {{- default "default" .values.name -}}
{{- end -}}
{{- end -}}

{{- define "tplchart.serviceAccount" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
{{- if $Values.serviceAccount.create -}}
---
kind: ServiceAccount
apiVersion: v1
metadata:
  name: {{ include "tplchart.serviceAccountName" (dict "context" .context "values" $Values.serviceAccount) }}
  namespace: {{ include "common.names.namespace" .context | quote }}
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" (list $Args.labels $Values.serviceAccount.labels .context.Values.commonLabels) "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.annotations $Values.serviceAccount.annotations .context.Values.commonAnnotations }}
  annotations:
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.annotations $Values.serviceAccount.annotations .context.Values.commonAnnotations) "context" .context) | nindent 4 -}}
  {{- end }}
automountServiceAccountToken: {{ $Values.serviceAccount.automountServiceAccountToken | default true }}
{{- if $Args.imagePullSecrets -}}
{{- include "tplchart.utils.renderYaml" $Args.imagePullSecrets -}}
{{- end -}}
{{- end -}}
{{- end -}}
