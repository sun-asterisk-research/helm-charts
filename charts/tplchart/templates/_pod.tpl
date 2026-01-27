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
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
{{/* Gather images from containers to render imagePullSecrets */}}
{{- $context := .context -}}
{{- $images := list -}}
{{/*
  Collect images from all containers for imagePullSecrets rendering.
  Each image is resolved by merging scoped Values with Args, where Values takes precedence.
  This mirrors the same image resolution logic used in tplchart.container template.
  The final list of $images is used to determine which imagePullSecrets are needed.
*/}}
{{/* Main container: uses pod's Scope for Values lookup */}}
{{- $mainImage := merge ($Values.image | default dict) ($Args.container.image | default dict) -}}
{{- if not (empty $mainImage) -}}
{{- $images = append $images $mainImage -}}
{{- end -}}
{{/* Init containers: each may have its own Scope, defaults to pod's Scope */}}
{{- range $Args.initContainers | default list -}}
{{- $initScope := .Scope | default $Scope -}}
{{- $initValues := include "tplchart.utils.scopedValues" (dict "context" $context "Scope" $initScope) | fromYaml -}}
{{- $initImage := merge ($initValues.image | default dict) ((.Args).image | default dict) -}}
{{- if not (empty $initImage) -}}
{{- $images = append $images $initImage -}}
{{- end -}}
{{- end -}}
{{/* Sidecars: each may have its own Scope, defaults to pod's Scope */}}
{{- range $Args.sidecars | default list -}}
{{- $sidecarScope := .Scope | default $Scope -}}
{{- $sidecarValues := include "tplchart.utils.scopedValues" (dict "context" $context "Scope" $sidecarScope) | fromYaml -}}
{{- $sidecarImage := merge ($sidecarValues.image | default dict) ((.Args).image | default dict) -}}
{{- if not (empty $sidecarImage) -}}
{{- $images = append $images $sidecarImage -}}
{{- end -}}
{{- end -}}
{{- $podLabels := include "common.tplvalues.merge" (dict "values" (list $Args.podLabels $Values.podLabels .context.Values.commonLabels) "context" .context) -}}
metadata:
  labels:
    {{- include "tplchart.labels" (dict "customLabels" $podLabels "component" $Args.component "context" .context) | nindent 4 }}
  {{- if or $Args.podAnnotations $Values.podAnnotations $Args.checksumAnnotations }}
  annotations:
    {{- if or $Args.podAnnotations $Values.podAnnotations -}}
    {{- include "tplchart.utils.renderDicts" (dict "values" (list $Args.podAnnotations $Values.podAnnotations) "context" .context) | nindent 4 -}}
    {{- end -}}
    {{- if $Args.checksumAnnotations -}}
    {{- include "tplchart.pod.checksumAnnotations" (dict "checksums" $Args.checksumAnnotations "context" .context) | nindent 4 -}}
    {{- end -}}
  {{- end }}
spec:
  {{- include "common.images.renderPullSecrets" (dict "images" $images "context" .context) | nindent 2 }}
  automountServiceAccountToken: {{ $Values.automountServiceAccountToken | default true }}
  {{- if or $Args.initContainers $Values.initContainers }}
  initContainers:
    {{- if $Args.initContainers }}
    {{ $context := .context -}}
    {{ range $i, $container := $Args.initContainers -}}
    {{ $initContainerScope := $container.Scope | default $Scope -}}
    - {{ include "tplchart.container" (dict "context" $context "Scope" $initContainerScope "Args" $container.Args) | indent 6 | trim }}
    {{ end -}}
    {{ end -}}
    {{- if $Values.initContainers }}
    {{- include "common.tplvalues.render" (dict "value" $Values.extraInitContainers "context" .context) | nindent 4 }}
    {{- end }}
  {{- end }}
  containers:
    - {{ include "tplchart.container" (dict "context" .context "Scope" $Scope "Args" $Args.container) | indent 6 | trim }}
    {{ if $Args.sidecars -}}
    {{ $context := .context -}}
    {{ range $i, $container := $Args.sidecars -}}
    {{ $sidecarScope := $container.Scope | default $Scope -}}
    - {{ include "tplchart.container" (dict "context" $context "Scope" $sidecarScope "Args" $container.Args) | indent 6 | trim }}
    {{ end -}}
    {{ end -}}
  {{- if or $Args.volumes $Values.extraVolumes }}
  volumes:
    {{- if $Args.volumes }}
    {{- include "tplchart.utils.renderYaml" $Args.volumes | nindent 4 }}
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
      {{- include "common.affinities.pods" (dict "type" $Values.podAffinityPreset "customLabels" $podLabels "component" $Args.component "context" .context) | nindent 6 }}
    podAntiAffinity:
      {{- include "common.affinities.pods" (dict "type" $Values.podAntiAffinityPreset "customLabels" $podLabels "component" $Args.component "context" .context) | nindent 6 }}
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
