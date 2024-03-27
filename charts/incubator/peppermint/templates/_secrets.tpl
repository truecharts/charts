{{/* Define the secrets */}}
{{- define "peppermint.secrets" -}}
{{- $secretName := (printf "%s-peppermint-secrets" (include "tc.v1.common.lib.chart.names.fullname" $)) }}

{{- $secretKey := randAlphaNum 64 -}}

 {{- with lookup "v1" "Secret" .Release.Namespace $secretName -}}
   {{- $secretKey = index .data "SECRET" | b64dec -}}
 {{- end }}
enabled: true
data:
  SECRET: {{ $secretKey }}
{{- end -}}
