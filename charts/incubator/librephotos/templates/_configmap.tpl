{{- define "librephotos.configmap" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}-config
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
  nginx-config: |-
    user  nginx;
    worker_processes  1;

    error_log  /var/log/nginx/error.log debug;

    events {
        worker_connections  1024;
    }

    http {
      server {
        listen 80;
        location / {
          # React routes are entirely on the App side in the web broswer
          # Always proxy to root with the same page request when nginx 404s
          error_page 404 /;
          proxy_intercept_errors on;
          proxy_set_header Host $host;
          proxy_pass http://frontend:3000/;
        }
        location ~ ^/(api|media)/ {
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header Host backend;
          include uwsgi_params;
          proxy_pass http://backend:8001;
        }
        # Django media
        location /protected_media  {
            internal;
            alias /protected_media/;
        }

        location /static/drf-yasg {
            proxy_pass http://backend:8001;
        }

        location /data  {
            internal;
            alias /data/;
        }

        # Original Photos
        location /original  {
            internal;
            alias /data/;
        }
        # Nextcloud Original Photos
        location /nextcloud_original  {
            internal;
            alias /data/nextcloud_media/;
        }
      }
    }
{{- end -}}
