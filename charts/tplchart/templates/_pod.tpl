{{- define "tplchart.pod.checksumAnnotationsTemplate" -}}
{{ range $key, $file := .checksums -}}
{{ printf "checksum/%s: {{ include (print $.Template.BasePath \"/%s\") $ | sha256sum }}" $key $file }}
{{ end -}}
{{- end -}}

{{- define "tplchart.pod.checksumAnnotations" -}}
{{- $tpl := (include "tplchart.pod.checksumAnnotationsTemplate" .) -}}
{{- include "common.tplvalues.render" (dict "value" $tpl "context" .context) -}}
{{- end -}}

{{- define "tplchart.podTemplate" -}}
{{- $Scope := .Scope -}}
{{- $Values := index .context.Values .Scope -}}
{{- $Args := .Args | default dict -}}
{{/* Gather images from containers to render imagePullSecrets */}}
{{- $containers := concat (list .Args.container) (.Args.sidecars | default list) (.Args.initContainers | default list)  -}}
{{- $images := list -}}
{{- range $i, $container := $containers -}}
  {{- $images = append $images $container.image -}}
{{- end -}}
{{- $podLabels := include "common.tplvalues.merge" (dict "values" (list .Args.podLabels $Values.podLabels .context.Values.commonLabels) "context" .context) -}}
metadata:
  labels:
    {{- include "tplchart.common.labels" (dict "customLabels" $podLabels "component" .Args.component "context" .context) | nindent 4 }}
  {{- if or .Args.podAnnotations $Values.podAnnotations .Args.checksumAnnotations }}
  annotations:
    {{- if or .Args.podAnnotations $Values.podAnnotations -}}
    {{- include "tplchart.utils.renderDicts" (dict "values" (list .Args.podAnnotations $Values.podAnnotations) "context" .context) | nindent 4 -}}
    {{- end -}}
    {{- if .Args.checksumAnnotations -}}
    {{- include "tplchart.pod.checksumAnnotations" (dict "checksums" .Args.checksumAnnotations "context" .context) | nindent 4 -}}
    {{- end -}}
  {{- end }}
spec:
  {{- include "common.images.renderPullSecrets" (dict "images" $images "context" .context) | nindent 2 }}
  automountServiceAccountToken: {{ $Values.automountServiceAccountToken | default true }}
  {{- if or .Args.initContainers $Values.initContainers }}
  initContainers:
    {{- if .Args.initContainers }}
    {{ range $i, $container := .Args.initContainers -}}
    - {{ include "tplchart.container" (dict "context" .context "Scope" $Scope "Args" $container) | indent 6 | trim }}
    {{ end }}
    {{- end }}
    {{- if $Values.initContainers }}
    {{- include "common.tplvalues.render" (dict "value" $Values.extraInitContainers "context" .context) | nindent 4 }}
    {{- end }}
  {{- end }}
  containers:
    - {{ include "tplchart.container" (dict "context" .context "Scope" $Scope "Args" .Args.container) | indent 6 | trim }}
    {{- if .Args.sidecars }}
    {{ range $i, $container := .Args.sidecars -}}
    - {{ include "tplchart.container" (dict "context" .context "Scope" $Scope "Args" $container) | indent 6 | trim }}
    {{ end }}
    {{- end }}
  {{- if or .Args.volumes $Values.extraVolumes }}
  volumes:
    {{- if .Args.volumes }}
    {{- include "tplchart.utils.renderYaml" .Args.volumes | nindent 4 }}
    {{- end }}
    {{- if $Values.extraVolumes }}
    {{- include "common.tplvalues.render" (dict "value" $Values.extraVolumes "context" .context) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if $Values.hostAliases }}
  hostAliases:
    {{- include "common.tplvalues.render" (dict "value" $Values.hostAliases "context" .context) | nindent 4 }}
  {{- end }}
  {{- if $Values.affinity }}
  affinity: {{- include "common.tplvalues.render" (dict "value" $Values.affinity "context" .context) | nindent 4 }}
  {{- else }}
  affinity:
    podAffinity:
      {{- include "common.affinities.pods" (dict "type" $Values.podAffinityPreset "customLabels" $podLabels "component" .Args.component "context" .context) | nindent 6 }}
    podAntiAffinity:
      {{- include "common.affinities.pods" (dict "type" $Values.podAntiAffinityPreset "customLabels" $podLabels "component" .Args.component "context" .context) | nindent 6 }}
    nodeAffinity:
      {{- include "common.affinities.nodes" (dict "type" $Values.nodeAffinityPreset.type "key" $Values.nodeAffinityPreset.key "values" $Values.nodeAffinityPreset.values) | nindent 6 }}
  {{- end }}
  {{- if $Values.nodeSelector }}
  nodeSelector:
    {{- include "common.tplvalues.render" (dict "value" $Values.nodeSelector "context" .context) | nindent 4 }}
  {{- end }}
  {{- if $Values.tolerations }}
  tolerations:
    {{- include "common.tplvalues.render" (dict "value" $Values.tolerations "context" .context) | nindent 4 }}
  {{- end }}
  {{- if $Values.priorityClassName }}
  priorityClassName: {{ $Values.priorityClassName | quote }}
  {{- end }}
  {{- if $Values.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- include "common.tplvalues.render" (dict "value" $Values.topologySpreadConstraints "context" .context) | nindent 4 }}
  {{- end }}
  {{- if $Values.schedulerName }}
  schedulerName: {{ $Values.schedulerName | quote }}
  {{- end }}
  {{- if ($Values.podSecurityContext).enabled }}
  securityContext:
    {{- omit $Values.podSecurityContext "enabled" | toYaml | nindent 4 }}
  {{- end }}
  {{- if $Args.serviceAccount }}
  serviceAccountName: {{ include "tplchart.serviceAccountName" (dict "context" .context "values" $Args.serviceAccount) }}
  {{- end -}}
  {{- if $Values.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ $Values.terminationGracePeriodSeconds }}
  {{- end }}
{{- end -}}
