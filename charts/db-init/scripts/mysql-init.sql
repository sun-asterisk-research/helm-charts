{{- range .Values.users }}
/* Create user {{ .username }} */
CREATE USER IF NOT EXISTS '{{ .username | required "A username is required" }}';
{{ if or .password (.forcePassword | default false) -}}
ALTER USER '{{ .username }}'@'%' IDENTIFIED BY '{{ .password | default (randAlphaNum 10) }}';
{{ end -}}
{{ end -}}

{{- range $db, $roles := .Values.databases }}
/* Create database {{ $db }} */
CREATE DATABASE IF NOT EXISTS `{{ $db }}`;
{{- if not (empty $roles.owner) }}
/* Make {{ $roles.owner }} owner of {{ $db }} */
GRANT ALL PRIVILEGES ON `{{ $db }}`.* TO '{{ $roles.owner }}'@'%';
{{ end -}}
{{- range $roles.readonly }}
/* Grant readonly on {{ $db }} to {{ . }} */
REVOKE ALL PRIVILEGES ON `{{ $db }}`.* FROM '{{ . }}'@'%';
GRANT SELECT ON `{{ $db }}`.* TO '{{ . }}'@'%';
{{ end -}}
{{- range $roles.readwrite }}
/* Grant readwrite on {{ $db }} to {{ . }} */
REVOKE ALL PRIVILEGES ON `{{ $db }}`.* FROM '{{ . }}'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP ON `{{ $db }}`.* TO '{{ . }}'@'%';
{{ end -}}
{{ end -}}
