{{/* Define the configmap */}}
{{- define "kitchenowl.configmaps" -}}

{{- $fullname := (include "tc.v1.common.lib.chart.names.fullname" $) -}}

backend:
  enabled: true
  data:
    BACK_URL: {{ printf "%v-backend:%v" $fullname .Values.service.backend.ports.backend.port }}

{{- end -}}
