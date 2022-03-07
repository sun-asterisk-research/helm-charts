{{- define "openedx.jwt.issuer" -}}
{{ .Values.openedx.jwt.common.issuer | default (printf "http://%s%s" .Values.baseDomain "/oauth2") }}
{{- end -}}

{{- define "openedx.jwt.secretKey" -}}
{{ .Values.openedx.jwt.secretKey | required "openedx.jwt.secretKey is required" }}
{{- end -}}
