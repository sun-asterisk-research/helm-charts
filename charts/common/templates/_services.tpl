{{/*
Renders the FQDN for a service.
Usage: {{ include "common.services.fqdn" (dict "nameTemplate" "%s-api" "context" .) }}
*/}}
{{- define "common.services.fqdn" -}}
{{- $name := include "common.names.render" . -}}
{{- $ns := .context.Release.Namespace -}}
{{- $domain := .context.Values.clusterDomain | default (.context.Values.global).clusterDomain | default "cluster.local" -}}
{{- printf "%s.%s.svc.%s" $name $ns $domain -}}
{{- end -}}

{{/*
Renders a full service URL (scheme://fqdn:port).
- .port is required.
- .scheme defaults to "http".
Usage: {{ include "common.services.url" (dict "context" . "nameTemplate" "%s-api" "port" 80 "scheme" "http") }}
*/}}
{{- define "common.services.url" -}}
{{- $fqdn := include "common.services.fqdn" . -}}
{{- $scheme := .scheme | default "http" -}}
{{- $port := .port | int64 -}}

{{/* Port validation: 1-65535 */}}
{{- if or (lt $port 1) (gt $port 65535) -}}
{{- fail (printf "Invalid port '%d' for common.services.url. Port must be between 1 and 65535." $port) -}}
{{- end -}}

{{/* Default port check */}}
{{- $isDefaultHttp := and (eq $scheme "http") (eq $port 80) -}}
{{- $isDefaultHttps := and (eq $scheme "https") (eq $port 443) -}}

{{- if or $isDefaultHttp $isDefaultHttps -}}
{{- printf "%s://%s" $scheme $fqdn -}}
{{- else -}}
{{- printf "%s://%s:%d" $scheme $fqdn $port -}}
{{- end -}}
{{- end -}}
