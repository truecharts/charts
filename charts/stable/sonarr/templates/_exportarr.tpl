{{/* Define the exportarr container */}}
{{- define "sonarr.exportarr" -}}
{{- $fname := (include "tc.v1.common.lib.chart.names.fullname" .) -}}
enabled: true
type: Deployment
  containers:
    exportarr:
      enabled: true
      primary: true
      imageSelector: exportarrImage
      args: ["sonarr"]
      envFrom:
        - configMapRef:
            name: exportarr-config
      probes:
        readiness:
          enabled: true
          type: http
          path: /metrics
          port: {{ .Values.service.metrics.ports.metrics.port }}
        liveness:
          enabled: true
          type: http
          path: /metrics
          port: {{ .Values.service.metrics.ports.metrics.port }}
        startup:
          enabled: true
          type: http
          path: /metrics
          port: {{ .Values.service.metrics.ports.metrics.port }}
{{- end -}}
