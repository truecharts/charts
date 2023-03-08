{{/* Define the secrets */}}
{{- define "wg.env.configmap" -}}

{{- $configName := printf "%s-wg-env-config" (include "tc.v1.common.lib.chart.names.fullname" .) }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
data:
  SEPARATOR: ";"
  IPTABLES_BACKEND: nft
  KILLSWITCH: {{ .Values.wg.killswitch | quote }}
  {{- if .Values.wg.killswitch }}
    {{- $excludedIP4net := "172.16.0.0/12" }}
    {{- range .Values.wg.excludedIP4networks }}
      {{- $excludedIP4net = ( printf "%v;%v" $excludedIP4net . ) }}
    {{- end }}
  KILLSWITCH_EXCLUDEDNETWORKS_IPV4: {{ $excludedIP4net | quote }}
    {{- $excludedIP6net := "" }}
    {{- range .Values.wg.excludedIP6networks }}
      {{- $excludedIP6net = ( printf "%v;%v" $excludedIP6net . ) }}
    {{- end }}
  KILLSWITCH_EXCLUDEDNETWORKS_IPV6: {{ $excludedIP4net | quote }}
  {{- end }}
{{- end -}}
