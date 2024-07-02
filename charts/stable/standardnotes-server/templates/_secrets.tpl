{{/* Define the secrets */}}
{{- define "standardnotes.secrets" -}}
{{- $secretName := (printf "%s-standardnotes-secrets" (include "tc.v1.common.lib.chart.names.fullname" $)) }}
{{/* Encryption server key must be 32 bytes, 64 hex characters long. */}}
{{/* https://github.com/standardnotes/server/blob/f975dd9697bc3fd96277731bfa8f71dbed960531/packages/auth/src/Domain/Encryption/CrypterNode.ts#L20 */}}
{{- $authKey := randAlphaNum 32 -}}
{{- $authKey := printf "%x" $authKey -}}
{{- $jwtSecret := randAlphaNum 32 -}}
{{- $valetSecret := randAlphaNum 32 -}}
{{- with (lookup "v1" "Secret" .Release.Namespace $secretName) -}}
  {{- $jwtSecret = index .data "AUTH_JWT_SECRET" | b64dec -}}
  {{- $authKey = index .data "AUTH_SERVER_ENCRYPTION_SERVER_KEY" | b64dec -}}
  {{- $valetSecret = index .data "VALET_TOKEN_SECRET" | b64dec -}}
{{- end }}
enabled: true
data:
  AUTH_SERVER_ENCRYPTION_SERVER_KEY: {{ $authKey }}
  AUTH_JWT_SECRET: {{ $jwtSecret }}
  VALET_TOKEN_SECRET: {{ $valetSecret }}
{{- end -}}
