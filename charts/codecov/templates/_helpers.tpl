{{- define "codecov.images.api" -}}
{{ include "codecov.renderImage" (dict "imageRoot" .Values.api.image "context" .) }}
{{- end -}}

{{- define "codecov.images.worker" -}}
{{ include "codecov.renderImage" (dict "imageRoot" .Values.worker.image "context" .) }}
{{- end -}}

{{- define "codecov.images.frontend" -}}
{{ include "codecov.renderImage" (dict "imageRoot" .Values.frontend.image "context" .) }}
{{- end -}}

{{- define "codecov.images.gateway" -}}
{{ include "codecov.renderImage" (dict "imageRoot" .Values.gateway.image "context" .) }}
{{- end -}}

{{- define "codecov.renderImage" -}}
{{- $ := .context -}}
{{- $image := empty .imageRoot.tag | ternary (merge (dict) .imageRoot (dict "tag" $.Chart.AppVersion)) .imageRoot -}}
{{ include "common.images.image" (dict "imageRoot" $image "global" $.Values.global) }}
{{- end -}}

{{- define "codecov.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.api.image .Values.worker.image .Values.frontend.image .Values.gateway.image) "context" $) -}}
{{- end -}}

{{- define "codecov.config.scheme" -}}
{{- ternary "https" "http" (and .Values.ingress.enabled .Values.ingress.tls)  -}}
{{- end -}}

{{- define "codecov.config.hostname" -}}
{{- ternary .Values.ingress.hostname (printf "%s-api.%s.svc.%s" (include "common.names.fullname" .) .Release.Namespace .Values.clusterDomain) .Values.ingress.enabled -}}
{{- end -}}

{{- define "codecov.config.port" -}}
{{- ternary "" (printf ":%d" .Values.frontend.service.port) .Values.ingress.enabled -}}
{{- end -}}

{{- define "codecov.config.host" -}}
{{- printf "%s%s" (include "codecov.config.hostname" .) (include "codecov.config.port" .) -}}
{{- end -}}

{{- define "codecov.config.url" -}}
{{- printf "%s://%s" (include "codecov.config.scheme" .) (include "codecov.config.host" .) -}}
{{- end -}}

{{- define "codecov.config.apiHostname" -}}
{{- ternary .Values.ingress.hostname (printf "%s-frontend.%s.svc.%s" (include "common.names.fullname" .) .Release.Namespace .Values.clusterDomain) .Values.ingress.enabled -}}
{{- end -}}

{{- define "codecov.config.apiPort" -}}
{{- ternary "" (printf ":%d" .Values.api.service.port) .Values.ingress.enabled -}}
{{- end -}}

{{- define "codecov.config.apiHost" -}}
{{- printf "%s%s" (include "codecov.config.apiHostname" .) (include "codecov.config.apiPort" .) -}}
{{- end -}}

{{- define "codecov.config.apiUrl" -}}
{{- printf "%s://%s" (include "codecov.config.scheme" .) (include "codecov.config.apiHost" .) -}}
{{- end -}}

{{- define "codecov.checksums.appConfig" -}}
checksum/configmap: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- if not (empty .Values.secretFiles) }}
checksum/secretFiles: {{ include (print $.Template.BasePath "/secret-files.yaml") . | sha256sum }}
{{- end }}
{{- end -}}

{{- define "codecov.env" -}}
- configMapRef:
    name: {{ template "common.names.fullname" . }}
- secretRef:
    name: {{ template "common.names.fullname" . }}
{{- end -}}

{{- define "codecov.volumes" -}}
{{- if not (empty .Values.secretFiles) -}}
- name: secret-files
  secret:
    secretName: {{ template "common.names.fullname" . }}-secret-files
    defaultMode: 0640
{{- end -}}
{{- end -}}

{{- define "codecov.volumeMounts" -}}
{{- range $filename, $content := .Values.secretFiles -}}
- name: secret-files
  mountPath: {{ printf "/home/codecov/%s" $filename }}
  subPath: {{ $filename }}
{{- end -}}
{{- end -}}

{{/*
Returns the ServiceAccount name
*/}}
{{- define "codecov.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
