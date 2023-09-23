{{/* Define the cronjob */}}
{{- define "plextraktsync.cronjob" -}}
enabled: true
type: "CronJob"
schedule: "{{ .Values.plexTraktSync.schedule }}"
podSpec:
  restartPolicy: Never
  containers:
    cron:
      enabled: true
      primary: true
      imageSelector: "image"
      securityContext:
        runAsNonRoot: false
        readOnlyRootFilesystem: false
        runAsUser: 0
        runAsGroup: 0
        capabilities:
          drop:
            - ALL
      command:
          - /bin/bash
          - -c
          - |
            plextraktsync
            {{- if  .Values.plexTraktSync.task }}
              {{ .Values.plexTraktSync.task }}
            {{- else }}
              sync --sync=all
            {{- end }}
      probes:
        liveness:
          enabled: false
        readiness:
          enabled: false
        startup:
          enabled: false
{{- end -}}
