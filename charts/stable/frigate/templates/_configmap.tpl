{{/* Define the configmap */}}
{{- define "frigate.configmap" -}}
enabled: true
data:
  {{- if .Values.frigateConfig }}
  config.yml: |
    {{- .Values.frigateConfig | toYaml | nindent 4 }}
  {{- else }}
  config.yml.dummy: |
    mqtt:
      enabled: false
    cameras:
      dummy:
        enabled: false
        ffmpeg:
          inputs:
            - path: rtsp://127.0.0.1:554/rtsp
              roles:
                - detect
  {{- end }}
{{- end -}}

{{- define "frigate.configVolume" -}}
enabled: true
type: configmap
objectName: frigate-config
targetSelector:
  main:
    main: 
      subPath: config.yml
    init-config:
      subPath: config.yml
{{- if .Values.frigateConfig }}
mountPath: /config/config.yaml
{{- else  }}
mountPath: /dummy-config/config.yml.dummy
{{- end -}}
{{- end -}}
