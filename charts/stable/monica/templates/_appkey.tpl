{{- define "monica.appkey" -}}
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: appkey
  labels:
    {{- include "common.labels" . | nindent 4 }}
{{- $keyprevious := lookup "v1" "Secret" .Release.Namespace "appkey" }}
{{- $appkey := "" }}
data:
  {{- if $keyprevious }}
  appkey: {{ ( index $keyprevious.data "appkey" ) }}
  {{- else }}
  {{- $appkey = randAlphaNum 32 }}
  appkey: {{ $appkey | b64enc }}
  {{- end }}
{{- end -}}
