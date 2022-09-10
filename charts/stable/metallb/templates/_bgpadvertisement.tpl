{{- define "metallb.bgpadv" -}}

{{- if .Values.metallb.BGPAdvertisements }}
{{- range .Values.metallb.BGPAdvertisements }}
apiVersion: metallb.io/v1beta1
kind: BGPAdvertisement
metadata:
  name: {{ .name }}
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "tc.common.labels" $ | nindent 4 }}
  annotations:
    meta.helm.sh/release-name: {{ $.Release.Name }}
    meta.helm.sh/release-namespace: {{ $.Release.Namespace }}
spec:
  ipAddressPools:
  {{- range .addressPools }}
    - {{ . }}
  {{- end }}
  {{- with .aggregationLength }}
  aggregationLength: {{ . }}
  {{- end }}
  {{- with .localpref }}
  localpref: {{ . }}
  {{- end }}
  {{- if .communities }}
  communities:
    {{- range .communities }}
    - {{ . }}
    {{- end }}
  {{- end }}
  {{- if .peers }}
  peers:
    {{- range .peers }}
    - {{ . }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{- end -}}
