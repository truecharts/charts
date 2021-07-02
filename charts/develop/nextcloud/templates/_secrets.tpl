{{/* Define the secrets */}}
{{- define "nextcloud.secrets" -}}

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    {{- include "common.labels" . | nindent 4 }}
  name: dbcreds
{{- $previous := lookup "v1" "Secret" .Release.Namespace "dbcreds" }}
{{- $dbPass := "" }}
data:
{{- if $previous }}
  {{- $dbPass = ( index $previous.data "postgresql-password" ) | b64dec  }}
  postgresql-password: {{ ( index $previous.data "postgresql-password" ) }}
  postgresql-postgres-password: {{ ( index $previous.data "postgresql-postgres-password" ) }}
{{- else }}
  {{- $dbPass = randAlphaNum 50 }}
  postgresql-password: {{ $dbPass | b64enc | quote }}
  postgresql-postgres-password: {{ randAlphaNum 50 | b64enc | quote }}
{{- end }}
  url: {{ ( printf "%v%v:%v@%v-%v:%v/%v" "postgresql://" .Values.postgresql.postgresqlUsername $dbPass .Release.Name "postgresql" "5432" .Values.postgresql.postgresqlDatabase  ) | b64enc | quote }}
  host: {{ ( printf "%v-%v" .Release.Name "postgresql" ) | b64enc | quote }}
  redishost: {{ ( printf "%v-%v" .Release.Name "redis" ) | b64enc | quote }}
type: Opaque
{{- end -}}
