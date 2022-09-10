{{- define "metallb.community" -}}

{{- if .Values.metallb.Communities }}
apiVersion: metallb.io/v1beta1
kind: Community
metadata:
  name: communities
  labels:
    {{- include "tc.common.labels" $ | nindent 4 }}
  annotations:
    meta.helm.sh/release-name: {{ include "tc.common.names.fullname" $ }}
    meta.helm.sh/release-namespace: {{ $.Release.Namespace }}
spec:
  communities:
  {{- range .Values.metallb.Communities }}
    - name: {{ .name }}
      value: {{ .value }}
  {{- end }}
{{- end }}

{{- end -}}
