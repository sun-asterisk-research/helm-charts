{{- define "codecov.redis.host" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}-master
  {{- else -}}
    {{- .Values.config.redis.host -}}
  {{- end -}}
{{- end -}}

{{- define "codecov.redis.port" -}}
  {{- if eq .Values.redis.enabled true -}}
    {{- .Values.redis.master.service.ports.redis -}}
  {{- else -}}
    {{- .Values.config.redis.port -}}
  {{- end -}}
{{- end -}}

{{- define "codecov.redis.password" -}}
  {{- if not .Values.redis.enabled  -}}
    {{- .Values.config.redis.password -}}
  {{- else if .Values.redis.auth.enabled -}}
    {{- .Values.redis.auth.password | required ".Values.redis.password is required" -}}
  {{- end -}}
{{- end -}}

{{- define "codecov.redis.url" -}}
  {{- printf "redis://:%s@%s:%s/0" (include "codecov.redis.password" .) (include "codecov.redis.host" .) (include
  "codecov.redis.port" .) -}}
{{- end -}}
