{{/* Define the secrets */}}
{{- define "yourls.secrets" -}}
{{- $secretName := (printf "%s-yourls-secrets" (include "tc.v1.common.lib.chart.names.fullname" $)) }}

{{- $cookiesKey := randAlphaNum 64 -}}

 {{- with lookup "v1" "Secret" .Release.Namespace $secretName -}}
   {{- $cookiesKey = index .data "YOURLS_COOKIEKEY" | b64dec -}}
 {{- end }}
enabled: true
data:
  YOURLS_COOKIEKEY: {{ $cookiesKey }}
{{- end -}}
