{{/*
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

`SPDX-License-Identifier: Apache-2.0`

This file is considered to be modified by the TrueCharts Project.
*/}}


{{- /*
The pod definition included in the controller.
*/ -}}
{{- define "common.controller.pod" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "common.names.serviceAccountName" . }}
securityContext:
{{- if not .Values.startAsRoot }}
  runAsUser: {{ .Values.PUID }}
  runAsGroup: {{ .Values.PGID }}
  fsGroup: {{ .Values.PGID }}
  # 5=tty 20=dailout 24=cdrom 44=video 107=render
  supplementalGroups: [{{- .Values.supplementalGroups }}]
  runAsNonRoot: true
{{- end }}
{{- with .Values.podSecurityContext }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.priorityClassName }}
priorityClassName: {{ . }}
{{- end }}
{{- with .Values.schedulerName }}
schedulerName: {{ . }}
{{- end }}
{{- with .Values.hostNetwork }}
hostNetwork: {{ . }}
{{- end }}
{{- with .Values.hostname }}
hostname: {{ . }}
{{- end }}
{{- if .Values.dnsPolicy }}
{{- with .Values.dnsPolicy }}
dnsPolicy: {{ . }}
{{- end }}
{{- else if .Values.hostNetwork }}
dnsPolicy: "ClusterFirstWithHostNet"
{{- else }}
dnsPolicy: ClusterFirst
{{- end }}
{{- with .Values.dnsConfig }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}
enableServiceLinks: {{ .Values.enableServiceLinks }}
{{- with .Values.initContainers }}
initContainers:
  {{- toYaml . | nindent 2 }}
{{- end }}
containers:
  {{- include "common.controller.mainContainer" . | nindent 0 }}
  {{- with .Values.additionalContainers }}
    {{- toYaml . | nindent 0 }}
  {{- end }}
{{- with (include "common.controller.volumes" . | trim) }}
volumes:
  {{- . | nindent 0 }}
{{- end }}
{{- with .Values.hostAliases }}
hostAliases:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
