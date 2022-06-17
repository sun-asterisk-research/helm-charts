/* Prepare users */
{{ range .Values.users -}}
/* Create user {{ .username }} */
DO $$
BEGIN
    CREATE ROLE {{ .username | required "username is required" }} LOGIN;
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role {{ .username }} already exists, skipping';
END
$$;

{{ if or .password (.forcePassword | default false) -}}
ALTER USER {{ .username }} WITH ENCRYPTED PASSWORD '{{ .password | default (randAlphaNum 10) }}';
{{ end }}
{{ end -}}

{{ if not (empty .Values.databases) -}}
/* Prepare databases */
CREATE EXTENSION IF NOT EXISTS dblink;
{{- range $db, $spec := .Values.databases }}

/* Create database {{ $db }} */
DO $$
BEGIN
    PERFORM dblink_exec('dbname={{ $.Values.postgresql.database }} user={{ $.Values.postgresql.username }} password={{ $.Values.postgresql.password }}', 'CREATE DATABASE {{ $db }}{{ if not (empty $spec.owner) }} OWNER {{ $spec.owner }}{{ end }}');
EXCEPTION WHEN DUPLICATE_DATABASE THEN
    RAISE NOTICE 'Database {{ $db }} already exists, skipping';
END
$$;
{{- end }}

DROP EXTENSION dblink;
{{ end -}}

{{ range $db, $spec := .Values.databases }}
/* Create roles for {{ $db }} and grant privileges */
\c {{ $db }}

{{ $owner := $spec.owner -}}
{{ $readonly := printf "%s_readonly" $db -}}
{{ $readwrite := printf "%s_readwrite" $db -}}

DO $$
BEGIN
    /* Create {{ $readonly }} role */
    CREATE ROLE {{ $readonly }} NOLOGIN;

    /* Grant access to all tables */
    GRANT CONNECT ON DATABASE {{ $db }} TO {{ $readonly }};
    GRANT USAGE ON SCHEMA public TO {{ $readonly }};
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO {{ $readonly }};
    GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO {{ $readonly }};
    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO {{ $readonly }};

    /* Grant access to future tables created by {{ $owner }} (owner) */
    ALTER DEFAULT PRIVILEGES FOR ROLE {{ $owner }} IN SCHEMA public GRANT SELECT ON TABLES TO {{ $readonly }};
    ALTER DEFAULT PRIVILEGES FOR ROLE {{ $owner }} IN SCHEMA public GRANT SELECT ON SEQUENCES TO {{ $readonly }};
    ALTER DEFAULT PRIVILEGES FOR ROLE {{ $owner }} IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO {{ $readonly }};
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role {{ $readonly }} already exists, skipping';
END
$$;

DO $$
BEGIN
    /* Create {{ $readwrite }} role */
    CREATE ROLE {{ $readwrite }} NOLOGIN;

    /* Grant write privileges */
    GRANT {{ $readonly }} TO {{ $readwrite }};
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO {{ $readwrite }};

    /* Grant write privileges to future tables created by {{ $owner }} (owner) */
    ALTER DEFAULT PRIVILEGES FOR ROLE {{ $owner }} IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO {{ $readwrite }};
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role {{ $readwrite }} already exists, skipping';
END
$$;

{{ range $spec.readonly -}}
/* Grant {{ $readonly }} to {{ . }} */
REVOKE {{ $readwrite }} FROM {{ . }};
/* Revoke default privileges for {{ . }} in case it was granted before by the readwrite role */
ALTER DEFAULT PRIVILEGES FOR ROLE {{ . }} IN SCHEMA public REVOKE SELECT ON TABLES FROM {{ $readonly }};
ALTER DEFAULT PRIVILEGES FOR ROLE {{ . }} IN SCHEMA public REVOKE SELECT ON SEQUENCES FROM {{ $readonly }};
ALTER DEFAULT PRIVILEGES FOR ROLE {{ . }} IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM {{ $readonly }};
GRANT {{ $readonly }} TO {{ . }};
{{ end -}}

{{ range $spec.readwrite }}
/* Grant {{ $readwrite }} to {{ . }} */
REVOKE {{ $readonly }} FROM {{ . }};
GRANT {{ $readwrite }} TO {{ . }};
/* Grant access to future tables created by {{ . }} */
ALTER DEFAULT PRIVILEGES FOR ROLE {{ . }} IN SCHEMA public GRANT SELECT ON TABLES TO {{ $readonly }};
ALTER DEFAULT PRIVILEGES FOR ROLE {{ . }} IN SCHEMA public GRANT SELECT ON SEQUENCES TO {{ $readonly }};
ALTER DEFAULT PRIVILEGES FOR ROLE {{ . }} IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO {{ $readonly }};
{{ end -}}

{{ if not (empty $spec.extensions) }}
/* Create extensions for {{ $db }} */
{{- range $spec.extensions }}
CREATE EXTENSION IF NOT EXISTS {{ . }};
{{- end }}
{{ end }}
\c postgres
{{ end -}}
