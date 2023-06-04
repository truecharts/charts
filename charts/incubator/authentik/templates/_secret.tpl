{{/* Define the secrets */}}
{{- define "authentik.secrets" -}}

{{- $authentikSecretName := printf "%s-authentik-secret" (include "tc.v1.common.lib.chart.names.fullname" .) }}
{{- $geoipSecretName := printf "%s-geoip-secret" (include "tc.v1.common.lib.chart.names.fullname" .) }}
{{- $ldapSecretName := printf "%s-ldap-secret" (include "tc.v1.common.lib.chart.names.fullname" .) }}
{{- $proxySecretName := printf "%s-proxy-secret" (include "tc.v1.common.lib.chart.names.fullname" .) }}
{{- $token := randAlphaNum 128 | b64enc }}

{{/* This secret is loaded in both the main authentik container and worker */}}
{{ $authentikSecretName }}:
  enabled: true
  data:
    {{/* Secret Key */}}
    {{- with (lookup "v1" "Secret" .Release.Namespace $authentikSecretName) }}
    AUTHENTIK_SECRET_KEY: {{ index .data "AUTHENTIK_SECRET_KEY" }}
    {{ $token = index .data "AUTHENTIK_BOOTSTRAP_TOKEN" }}
    {{- else }}
    AUTHENTIK_SECRET_KEY: {{ randAlphaNum 32 | b64enc }}
    {{- end }}
    AUTHENTIK_BOOTSTRAP_TOKEN: {{ $token }}
    {{/* TODO: Dependencies */}}
    AUTHENTIK_POSTGRESQL__PASSWORD: {{ .Values.postgresql.postgresqlPassword | trimAll "\"" | b64enc }}
    AUTHENTIK_REDIS__PASSWORD: {{ .Values.redis.redisPassword | trimAll "\"" | b64enc }}
    {{/* Credentials */}}
    {{- with .Values.authentik.credentials.password }}
    AUTHENTIK_BOOTSTRAP_PASSWORD: {{ . | b64enc }}
    {{- end }}
    {{/* Mail */}}
    {{- with .Values.authentik.mail.host }}
    AUTHENTIK_EMAIL__HOST: {{ . | b64enc }}
    {{- end }}
    {{- with .Values.authentik.mail.user }}
    AUTHENTIK_EMAIL__USERNAME: {{ . | b64enc }}
    {{- end }}
    {{- with .Values.authentik.mail.pass }}
    AUTHENTIK_EMAIL__PASSWORD: {{ . | b64enc }}
    {{- end }}
    {{- with .Values.authentik.mail.from }}
    AUTHENTIK_EMAIL__FROM: {{ . | b64enc }}
    {{- end }}

{{/* This secret is loaded in the geoip container */}}
{{ $geoipSecretName }}:
  enabled: {{ .Values.geoip.enabled }}
  data:
    {{/* Credentials */}}
    {{- with .Values.geoip.account_id }}
    GEOIPUPDATE_ACCOUNT_ID: {{ . | b64enc }}
    {{- end }}
    {{- with .Values.geoip.license_key }}
    GEOIPUPDATE_LICENSE_KEY: {{ . | b64enc }}
    {{- end }}
    {{/* Proxy */}}
    {{- with .Values.geoip.proxy }}
    GEOIPUPDATE_PROXY: {{ . | b64enc }}
    {{- end }}
    {{- with .Values.geoip.proxy_user_pass }}
    GEOIPUPDATE_PROXY_USER_PASSWORD: {{ . | b64enc }}
    {{- end }}

{{/* This secret is loaded in the ldap container */}}
{{ $ldapSecretName }}:
  enabled: {{ .Values.outposts.ldap.enabled }}
  data:
    {{- with .Values.outposts.ldap.token }}
    AUTHENTIK_TOKEN: {{ . | b64enc }}
    {{- else }}
    AUTHENTIK_TOKEN: {{ $token }}
    {{- end }}

{{/* This secret is loaded in the proxy container */}}
{{ $proxySecretName }}:
  enabled: {{ .Values.outposts.proxy.enabled }}
  data:
    {{- with .Values.outposts.proxy.token }}
    AUTHENTIK_TOKEN: {{ . | b64enc }}
    {{- else }}
    AUTHENTIK_TOKEN: {{ $token }}
    {{- end }}
{{- end }}
