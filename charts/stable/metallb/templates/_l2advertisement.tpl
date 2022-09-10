{{- define "metallb.layer2adv" -}}

{{- if .Values.metallb.L2Advertisements }}
{{- range .Values.metallb.L2Advertisements }}
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: {{ .name }}
  labels:
    {{- include "tc.common.labels" $ | nindent 4 }}
  annotations:
    meta.helm.sh/release-name: {{ include "tc.common.names.fullname" $ }}
    meta.helm.sh/release-namespace: {{ $.Release.Namespace }}
spec:
  ipAddressPools:
  {{- range .addressPools }}
    - {{ . }}
  {{- end }}
  {{- if .nodeSelectors }}
    {{- range .nodeSelectors }}
  nodeSelectors:
    - matchLabels:
        kubernetes.io/hostname: {{ . }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{- end -}}
