{{- define "filebrowser.configmap" -}}

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}-config
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
  .filebrowser.json: |
    {{- tpl .Values.config $ | nindent 4 }}

