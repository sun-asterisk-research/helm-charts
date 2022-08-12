{{- range .Values.users }}
{{- $username := .username | required "A username is required" -}}
/* Create user {{ $username }} */
{{- if or .password (.forcePassword | default false) }}
{{- $password := .password | default (randAlphaNum 10)  }}
CREATE USER IF NOT EXISTS '{{ $username }}' IDENTIFIED WITH {{ $.Values.mysql.authPlugin }} BY '{{ $password }}';
ALTER USER '{{ .username }}'@'%' IDENTIFIED WITH {{ $.Values.mysql.authPlugin }} BY '{{ $password }}';
{{ else -}}
CREATE USER IF NOT EXISTS '{{ $username }}';
{{ end }}
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
