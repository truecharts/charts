{{/*
This template generates a random password and ensures it persists across updates/edits to the chart
*/}}
{{- define "tc.v1.common.dependencies.postgresql.secret" -}}
{{- $pghost := printf "%v-%v" .Release.Name "postgresql" }}

{{- if .Values.postgresql.enabled }}
enabled: true
{{- $basename := include "tc.v1.common.lib.chart.names.fullname" $ -}}
{{- $fetchname := printf "%s-dbcreds" $basename -}}
{{- $dbprevious := lookup "v1" "Secret" .Release.Namespace $fetchname }}
{{- $dbpreviousold := lookup "v1" "Secret" .Release.Namespace "dbcreds" }}
{{- $dbPass := "" }}
{{- $pgPass := "" }}
data:
{{- if $dbprevious }}
  {{- $dbPass = ( index $dbprevious.data "postgresql-password" ) | b64dec  }}
  {{- $pgPass = ( index $dbprevious.data "postgresql-postgres-password" ) | b64dec  }}
  postgresql-password: {{ ( index $dbprevious.data "postgresql-password" ) }}
  postgresql-postgres-password: {{ ( index $dbprevious.data "postgresql-postgres-password" ) }}
{{- else if $dbpreviousold }}
  {{- $dbPass = ( index $dbpreviousold.data "postgresql-password" ) | b64dec  }}
  {{- $pgPass = ( index $dbpreviousold.data "postgresql-postgres-password" ) | b64dec  }}
  postgresql-password: {{ ( index $dbpreviousold.data "postgresql-password" ) }}
  postgresql-postgres-password: {{ ( index $dbpreviousold.data "postgresql-postgres-password" ) }}
{{- else }}
  {{- $dbPass = randAlphaNum 50 }}
  {{- $pgPass = randAlphaNum 50 }}
  postgresql-password: {{ $dbPass }}
  postgresql-postgres-password: {{ $pgPass }}
{{- end }}
  url: {{ ( printf "postgresql://%v:%v@%v-postgresql:5432/%v" .Values.postgresql.postgresqlUsername $dbPass .Release.Name .Values.postgresql.postgresqlDatabase  ) }}
  url-noql: {{ ( printf "postgres://%v:%v@%v-postgresql:5432/%v" .Values.postgresql.postgresqlUsername $dbPass .Release.Name .Values.postgresql.postgresqlDatabase  ) }}
  urlnossl: {{ ( printf "postgresql://%v:%v@%v-postgresql:5432/%v?sslmode=disable" .Values.postgresql.postgresqlUsername $dbPass .Release.Name .Values.postgresql.postgresqlDatabase  ) }}
  plainporthost: {{ ( printf "%v-%v" .Release.Name "postgresql" ) }}
  plainhost: {{ ( printf "%v-%v" .Release.Name "postgresql" ) }}
  jdbc: {{ ( printf "jdbc:postgresql://%v-postgresql:5432/%v" .Release.Name .Values.postgresql.postgresqlDatabase  ) }}
type: Opaque
{{- $_ := set .Values.postgresql "postgresqlPassword" ( $dbPass | quote ) }}
{{- $_ := set .Values.postgresql "postgrespassword" ( $pgPass | quote ) }}
{{- $_ := set .Values.postgresql.url "plain" ( ( printf "%v-%v" .Release.Name "postgresql" ) | quote ) }}
{{- $_ := set .Values.postgresql.url "plainhost" ( ( printf "%v-%v" .Release.Name "postgresql" ) | quote ) }}
{{- $_ := set .Values.postgresql.url "plainport" ( ( printf "%v-%v:5432" .Release.Name "postgresql" ) | quote ) }}
{{- $_ := set .Values.postgresql.url "plainporthost" ( ( printf "%v-%v:5432" .Release.Name "postgresql" ) | quote ) }}
{{- $_ := set .Values.postgresql.url "complete" ( ( printf "postgresql://%v:%v@%v-postgresql:5432/%v" .Values.postgresql.postgresqlUsername $dbPass .Release.Name .Values.postgresql.postgresqlDatabase  ) | quote ) }}
{{- $_ := set .Values.postgresql.url "complete-noql" ( ( printf "postgres://%v:%v@%v-postgresql:5432/%v" .Values.postgresql.postgresqlUsername $dbPass .Release.Name .Values.postgresql.postgresqlDatabase  ) | quote ) }}
{{- $_ := set .Values.postgresql.url "jdbc" ( ( printf "jdbc:postgresql://%v-postgresql:5432/%v" .Release.Name .Values.postgresql.postgresqlDatabase  ) | quote ) }}

{{- end }}
{{- end -}}

{{- define "tc.v1.common.dependencies.postgresql.injector" -}}
  {{- $secret := include "tc.v1.common.dependencies.postgresql.secret" . | fromYaml -}}
  {{- if $secret -}}
    {{- $_ := set .Values.secret "dbcreds" $secret -}}
  {{- end -}}
{{- end -}}
