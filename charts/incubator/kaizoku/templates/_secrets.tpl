{{/* Define the secrets */}}
{{- define "kaizoku.secret" -}}
{{- $secretName := (printf "%s-kaizoku-secret" (include "tc.v1.common.lib.chart.names.fullname" $)) -}}

{{- $user := .Values.cnpg.main.user -}}
{{- $password := .Values.cnpg.main.creds.password | trimAll "\"" -}}
{{- $host := .Values.cnpg.main.creds.host | trimAll "\""  -}}
{{- $database := .Values.cnpg.main.database -}}

kaizoku-secret:
  enabled: true
  data:
    DATABASE_URL: {{ printf "postgresql://%v:%v@%v:5432/%v" $user $password $host $database }}
{{- end -}}
