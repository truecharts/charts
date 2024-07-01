{{- define "webdav.validation" -}}

  {{- $authTypes := (list "none" "basic") -}}
  {{- if not (mustHas .Values.webdavConfig.authType $authTypes) -}}
    {{- fail (printf "WebDAV - Expected [Auth Type] to be one of [%v], but got [%v]" (join ", " $authTypes) .Values.webdavConfig.authType) -}}
  {{- end -}}

  {{- if eq .Values.webdavConfig.authType "basic" -}}
    {{- if not .Values.webdavConfig.username -}}
      {{- fail "WebDAV - Expected [Username] to be configured when [Auth Type] is set to [Basic Auth]" -}}
    {{- end -}}
    {{- if not .Values.webdavConfig.password -}}
      {{- fail "WebDAV - Expected [Password] to be configured when [Auth Type] is set to [Basic Auth]" -}}
    {{- end -}}
  {{- end -}}

  {{- if and (not .Values.webdavNetwork.http) (not .Values.webdavNetwork.https) -}}
    {{- fail "WebDAV - Expected at least one protocol [HTTP, HTTPS] to be enabled" -}}
  {{- end -}}

  {{- if and .Values.webdavNetwork.https (not .Values.webdavNetwork.certificateID) -}}
    {{- fail "WebDAV - Expected a certificate to be configured when HTTPS is enabled" -}}
  {{- end -}}

  {{- if not .Values.webdavStorage.shares -}}
    {{- fail "WebDAV - Expected at least 1 [Share] to be configured" -}}
  {{- end -}}

  {{- range .Values.webdavStorage.shares -}}
    {{- if not (mustRegexMatch "^[a-zA-Z0-9_-]+$" .name) -}}
      {{- fail "WebDAV - Expected [Share] name to only consist of [Letters(a-z, A-Z), Numbers(0-9), Underscores(_), Dashes(-)]" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
