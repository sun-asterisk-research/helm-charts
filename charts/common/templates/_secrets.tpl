{{/* vim: set filetype=mustache: */}}

{{/*
Render the docker config.json file containing registry login credentials

Usage: {{ include "common.secrets.docker.auth" $registries }}

Params:
  - $registries: list of registry objects
    e.g.:
    - server: docker.io
      username: foo
      password: bar
*/}}
{{- define "common.secrets.docker.auth" }}
{{- $auths := "" -}}
{{- range  $i, $registry := . }}
  {{- with $registry }}
    {{- $auth := printf "\"%s\": {\"auth\": \"%s\"}" .server (printf "%s:%s" .username .password | b64enc) -}}
    {{- if eq $i 0 -}}
      {{- $auths = printf "%s" $auth -}}
    {{- else -}}
      {{- $auths = printf ",%s" $auth -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{ printf "{\"auths\": {%s}}" $auths | b64enc }}
{{- end }}
