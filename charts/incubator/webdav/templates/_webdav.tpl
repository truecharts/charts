{{- define "webdav.workload" -}}
workload:
  main:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      containers:
        main:
          imageSelector: image
          envList:
          probes:
            {{ $port := $.Values.service.main.ports.main.port }}
            liveness:
              enabled: true
              path: /health
              port: {{ $port }}
            {{ if eq .Values.webdavConfig.authType "basic" }}
              httpHeaders:
                Authorization: Basic {{ (printf "%s:%s" .Values.webdavConfig.username .Values.webdavConfig.password) | b64enc }}
            {{ end }}
            readiness:
              enabled: true
              path: /health
              port: {{ $port }}
            {{ if eq .Values.webdavConfig.authType "basic" }}
              httpHeaders:
                Authorization: Basic {{ (printf "%s:%s" .Values.webdavConfig.username .Values.webdavConfig.password) | b64enc }}
            {{ end }}
            startup:
              enabled: true
              path: /health
              port: {{ $port }}
            {{ if eq .Values.webdavConfig.authType "basic" }}
              httpHeaders:
                Authorization: Basic {{ (printf "%s:%s" .Values.webdavConfig.username .Values.webdavConfig.password) | b64enc }}
            {{ end }}
{{- end -}}
