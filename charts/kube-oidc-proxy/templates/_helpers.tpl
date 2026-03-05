{{/*
Required claims serialized to CLI argument format (key=value,key=value)
*/}}
{{- define "kube-oidc-proxy.requiredClaims" -}}
{{- if .Values.oidc.requiredClaims -}}
{{- $local := (list) -}}
{{- range $k, $v := .Values.oidc.requiredClaims -}}
{{- $local = (printf "%s=%s" $k $v | append $local) -}}
{{- end -}}
{{ join "," $local }}
{{- end -}}
{{- end -}}

{{/*
Container environment variables from OIDC config secret
*/}}
{{- define "kube-oidc-proxy.env" -}}
- name: OIDC_CLIENT_ID
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.client-id
- name: OIDC_ISSUER_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.issuer-url
- name: OIDC_USERNAME_CLAIM
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.username-claim
{{- if .Values.oidc.usernamePrefix }}
- name: OIDC_USERNAME_PREFIX
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.username-prefix
{{- end }}
{{- if .Values.oidc.groupsClaim }}
- name: OIDC_GROUPS_CLAIM
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.groups-claim
{{- end }}
{{- if .Values.oidc.groupsPrefix }}
- name: OIDC_GROUPS_PREFIX
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.groups-prefix
{{- end }}
{{- if .Values.oidc.signingAlgs }}
- name: OIDC_SIGNING_ALGS
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.signing-algs
{{- end }}
{{- if .Values.oidc.requiredClaims }}
- name: OIDC_REQUIRED_CLAIMS
  valueFrom:
    secretKeyRef:
      name: {{ include "common.names.fullname" . }}-config
      key: oidc.required-claims
{{- end }}
{{- end -}}

{{/*
Container arguments for kube-oidc-proxy
*/}}
{{- define "kube-oidc-proxy.args" -}}
- "--secure-port=8443"
- "--tls-cert-file=/etc/oidc/tls/crt.pem"
- "--tls-private-key-file=/etc/oidc/tls/key.pem"
- "--oidc-client-id=$(OIDC_CLIENT_ID)"
- "--oidc-issuer-url=$(OIDC_ISSUER_URL)"
- "--oidc-username-claim=$(OIDC_USERNAME_CLAIM)"
{{- if .Values.oidc.caPEM }}
- "--oidc-ca-file=/etc/oidc/oidc-ca.pem"
{{- end }}
{{- if .Values.oidc.usernamePrefix }}
- "--oidc-username-prefix=$(OIDC_USERNAME_PREFIX)"
{{- end }}
{{- if .Values.oidc.groupsClaim }}
- "--oidc-groups-claim=$(OIDC_GROUPS_CLAIM)"
{{- end }}
{{- if .Values.oidc.groupsPrefix }}
- "--oidc-groups-prefix=$(OIDC_GROUPS_PREFIX)"
{{- end }}
{{- if .Values.oidc.signingAlgs }}
- "--oidc-signing-algs=$(OIDC_SIGNING_ALGS)"
{{- end }}
{{- if .Values.oidc.requiredClaims }}
- "--oidc-required-claims=$(OIDC_REQUIRED_CLAIMS)"
{{- end }}
{{- if .Values.tokenPassthrough.enabled }}
- "--token-passthrough"
{{- if .Values.tokenPassthrough.audiences }}
- "--token-passthrough-audiences={{ join "," .Values.tokenPassthrough.audiences }}"
{{- end }}
{{- end }}
{{- if .Values.extraImpersonationHeaders.clientIP }}
- "--extra-user-header-client-ip"
{{- end }}
{{- if .Values.extraImpersonationHeaders.headers }}
- "--extra-user-headers={{ .Values.extraImpersonationHeaders.headers }}"
{{- end }}
{{- range $key, $value := .Values.extraArgs }}
- "--{{ $key }}={{ $value }}"
{{- end }}
{{- end -}}

{{/*
TLS secret name resolution
*/}}
{{- define "kube-oidc-proxy.tlsSecretName" -}}
{{- .Values.tls.secretName | default (printf "%s-tls" (include "common.names.fullname" .)) -}}
{{- end -}}

{{/*
Volume mounts for the main container
*/}}
{{- define "kube-oidc-proxy.volumeMounts" -}}
{{- if .Values.oidc.caPEM }}
- name: oidc-config
  mountPath: /etc/oidc
  readOnly: true
{{- end }}
- name: oidc-tls
  mountPath: /etc/oidc/tls
  readOnly: true
{{- end -}}

{{/*
Volumes for the pod
*/}}
{{- define "kube-oidc-proxy.volumes" -}}
{{- if .Values.oidc.caPEM }}
- name: oidc-config
  secret:
    secretName: {{ include "common.names.fullname" . }}-config
    items:
    - key: oidc.ca-pem
      path: oidc-ca.pem
{{- end }}
- name: oidc-tls
  secret:
    secretName: {{ include "kube-oidc-proxy.tlsSecretName" . }}
    items:
    - key: tls.crt
      path: crt.pem
    - key: tls.key
      path: key.pem
{{- end -}}

{{/*
OIDC config secret data (pre-encoded base64)
*/}}
{{- define "kube-oidc-proxy.secretData" -}}
{{- if .Values.oidc.caPEM }}
oidc.ca-pem: {{ .Values.oidc.caPEM | b64enc }}
{{- end }}
{{- if .Values.oidc.issuerUrl }}
oidc.issuer-url: {{ .Values.oidc.issuerUrl | b64enc }}
{{- end }}
{{- if .Values.oidc.usernameClaim }}
oidc.username-claim: {{ .Values.oidc.usernameClaim | b64enc }}
{{- end }}
{{- if .Values.oidc.clientId }}
oidc.client-id: {{ .Values.oidc.clientId | b64enc }}
{{- end }}
{{- if .Values.oidc.usernamePrefix }}
oidc.username-prefix: {{ .Values.oidc.usernamePrefix | b64enc }}
{{- end }}
{{- if .Values.oidc.groupsClaim }}
oidc.groups-claim: {{ .Values.oidc.groupsClaim | b64enc }}
{{- end }}
{{- if .Values.oidc.groupsPrefix }}
oidc.groups-prefix: {{ .Values.oidc.groupsPrefix | b64enc }}
{{- end }}
{{- if .Values.oidc.signingAlgs }}
oidc.signing-algs: {{ join "," .Values.oidc.signingAlgs | b64enc }}
{{- end }}
{{- if .Values.oidc.requiredClaims }}
oidc.required-claims: {{ include "kube-oidc-proxy.requiredClaims" . | b64enc }}
{{- end }}
{{- end -}}
