{{/*
Render container command or args, given a string or a slice.
*/}}
{{- define "tplchart.containers.cmd" -}}
{{- $cmd := list -}}
{{- if kindIs "slice" . -}}
{{- $cmd = . -}}
{{- else if kindIs "string" . -}}
{{- $cmd = splitList " " . -}}
{{- else -}}
{{- fail (printf "Invalid type for command. Expected string or slice. Got %s." (kindOf .)) -}}
{{- end -}}
{{ range $cmd -}}
- {{ . | quote }}
{{ end -}}
{{- end -}}

{{/*
Render container env vars, whether provided a dict, a list of dict or raw string.
*/}}
{{- define "tplchart.containers.envVars" -}}
{{- $ctx := .context -}}
{{- if kindIs "string" .values }}
{{ .values }}
{{- else if kindIs "map" .values }}
{{ range $key, $value := .values -}}
- name: {{ $key }}
  value: {{ $value | quote }}
{{ end }}
{{- else if kindIs "slice" .values }}
{{ range .values -}}
{{- if not (kindIs "map" .) -}}
{{- fail (printf "Invalid type for envVars item. Expected map. Got %s." (kindOf .)) -}}
{{- end -}}
- name: {{ .name }}
  value: {{ .value | quote }}
{{ end -}}
{{- else -}}
{{- fail (printf "Invalid type for envVars. Expected map or slice. Got %s." (kindOf .values)) -}}
{{- end }}
{{- end -}}

{{/*
Render HTTP probe for container liveness, readiness and startup probes.
*/}}
{{- define "common.containers.healthcheck.http" -}}
httpGet:
  path: {{ .path | default "/" }}
  scheme: {{ .scheme | default "HTTP" }}
  port: {{ .port }}
  {{- if .headers -}}
  httpHeaders:
    {{- toYaml .headers | nindent 4 }}
  {{- end -}}
{{- end -}}

{{/*
Render container in a pod
*/}}
{{- define "tplchart.container" -}}
{{- $Values := include "tplchart.utils.scopedValues" . | fromYaml -}}
{{- $Args := .Args | default dict -}}
name: {{ $Args.name | default .context.Chart.Name }}
{{- if ($Values.containerSecurityContext).enabled }}
securityContext: {{- omit $Values.containerSecurityContext "enabled" | toYaml | nindent 2 }}
{{- end }}
image: {{ typeIs "string" $Args.image | ternary ($Args.image) (include "common.images.image" (dict "imageRoot" $Args.image "global" .context.Values.global)) }}
imagePullPolicy: {{ default (eq $Args.image.tag "latest" | ternary "Always" "IfNotPresent") $Args.image.pullPolicy }}
{{- if $Args.command }}
command:
  {{- include "tplchart.containers.cmd" $Args.command | nindent 2 }}
{{- end }}
{{- if $Args.args }}
args:
  {{- include "tplchart.containers.cmd" $Args.args | nindent 2 }}
{{- end }}
{{- if or $Args.envVars $Values.extraEnvVars }}
env:
  {{- if $Args.envVars -}}
  {{- include "tplchart.containers.envVars" (dict "values" $Args.envVars "context" .context) | indent 2 }}
  {{- end -}}
  {{- if $Values.extraEnvVars -}}
  {{- include "tplchart.containers.envVars" (dict "values" $Values.extraEnvVars "context" .context) | indent 2 }}
  {{- end -}}
{{- end }}
{{- if or $Args.envVarsCMs $Args.envVarsSecrets $Values.extraEnvVarsCM $Values.extraEnvVarsSecret }}
envFrom:
  {{- if $Args.envVarsCMs }}
  {{- range $Args.envVarsCMs }}
  - configMapRef:
      name: {{ include "tplchart.renderName" (dict "name" .name "nameTemplate" .nameTemplate "context" $.context) }}
  {{- end }}
  {{- end }}
  {{- if $Values.extraEnvVarsCM }}
  - configMapRef:
      name: {{ include "common.tplvalues.render" (dict "value" $Values.extraEnvVarsCM "context" .context) }}
  {{- end }}
  {{- if $Args.envVarsSecrets }}
  {{- range $Args.envVarsSecrets }}
  - secretRef:
      name: {{ include "tplchart.renderName" (dict "name" .name "nameTemplate" .nameTemplate "context" $.context) }}
  {{- end }}
  {{- end }}
  {{- if $Values.extraEnvVarsSecret }}
  - secretRef:
      name: {{ include "common.tplvalues.render" (dict "value" $Values.extraEnvVarsSecret "context" .context) }}
  {{- end }}
{{- end }}
{{- if $Args.ports }}
ports:
  {{- if kindIs "map" $Args.ports -}}
  {{- range $port, $number := $Args.ports }}
  - name: {{ $port }}
    containerPort: {{ $number }}
    protocol: TCP
  {{- end }}
  {{- else if kindIs "slice" $Args.ports -}}
  {{- range $Args.ports }}
  - name: {{ .name }}
    containerPort: {{ .containerPort }}
    protocol: {{ .protocol | default "TCP" }}
    {{- if .hostPort }}
    hostPort: {{ .hostPort }}
    {{- end }}
    {{- if .hostIP }}
    hostIP: {{ .hostIP }}
    {{- end }}
  {{- end }}
  {{- end -}}
{{- end }}
{{- with merge ($Args.livenessProbe | default dict) ($Values.livenessProbe | default dict) }}
{{- if .enabled }}
livenessProbe:
  {{- omit . "enabled" | include "tplchart.utils.renderYaml" | nindent 2 }}
{{- end }}
{{- end }}
{{- with merge ($Args.readinessProbe | default dict) ($Values.readinessProbe | default dict) }}
{{- if .enabled }}
readinessProbe:
  {{- omit . "enabled" | include "tplchart.utils.renderYaml" | nindent 2 }}
{{- end }}
{{- end }}
{{- with merge ($Args.startupProbe | default dict) ($Values.startupProbe | default dict) }}
{{- if .enabled }}
startupProbe:
  {{- omit . "enabled" | include "tplchart.utils.renderYaml" | nindent 2 }}
{{- end }}
{{- end }}
{{- with merge ($Args.lifecycleHooks | default dict) ($Values.lifecycleHooks | default dict) }}
{{- if not (empty .) }}
lifecycle:
  {{- include "common.tplvalues.render" (dict "value" . "context" .context) | nindent 2 }}
{{- end }}
{{- end }}
{{- if $Values.resources }}
resources:
  {{- toYaml $Values.resources | nindent 2 }}
{{- end }}
{{- if or $Args.volumeMounts $Values.extraVolumeMounts }}
volumeMounts:
  {{- if $Args.volumeMounts }}
  {{- include "tplchart.utils.renderYaml" $Args.volumeMounts | nindent 2 }}
  {{- end }}
  {{- if $Values.extraVolumeMounts }}
  {{- include "common.tplvalues.render" (dict "value" $Values.extraVolumeMounts "context" .context) | nindent 2 }}
  {{- end }}
{{- end }}
{{- end -}}
