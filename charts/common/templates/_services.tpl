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
{{- printf "%s://%s:%d" $scheme $fqdn (int .port) -}}
{{- end -}}
