{{/* Define the configmap */}}
{{- define "teslamate.configmaps" -}}
{{- if .Values.dashboards.enabled }}
{{- $rootDir := "dashboards/" -}}
{{- $dirs := dict -}}
{{- range $path, $_ := .Files.Glob (printf "%s**/*.json" $rootDir) }}
  {{- $pathElements := splitList "/" $path -}}
  {{- $dirName := index $pathElements 1 }}
  {{- $existingFiles := get $dirs $dirName | default list -}}
  {{- $updatedFiles := append $existingFiles $path -}}
  {{- $_ := set $dirs $dirName $updatedFiles }}
{{- end }}

{{- range $dir, $files := $dirs }}
{{- range $files }}
{{- $fileName := lower (base .) }}
{{- $fileNameWithoutExt := trimSuffix ".json" $fileName }}
{{- $configMapKey := printf "%s-%s-%s" "dashboard" $dir $fileNameWithoutExt }}
{{ $configMapKey | quote }}:
  enabled: true
  annotations:
    {{- range $key, $value := $.Values.dashboards.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  labels:
    grafana_dashboard: "1"
  data:
    {{ $fileName | quote }}: |
{{ $.Files.Get . | indent 6 }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end }}
