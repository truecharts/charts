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
{{/*
This template serves as a blueprint for all Ingress objects that are created
within the common library.
*/}}
{{- define "common.classes.ingress" -}}
{{- $ingressName := include "common.names.fullname" . -}}
{{- $values := .Values.ingress -}}
{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.ingress -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}
{{- if hasKey $values "nameSuffix" -}}
  {{- $ingressName = printf "%v-%v" $ingressName $values.nameSuffix -}}
{{ end -}}
{{- $svcName := $values.serviceName | default (include "common.names.fullname" .) -}}
{{- $svcPort := $values.servicePort | default $.Values.services.main.port.port -}}
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ $ingressName }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: {{ $values.entrypoint }}
    traefik.ingress.kubernetes.io/router.middlewares: traefik-middlewares-chain-public@kubernetescrd
    {{- if $values.authForwardURL }}
    traefik.ingress.kubernetes.io/router.middlewares: {{ $ingressName }}
    {{- end }}
    {{- with $values.annotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
  {{- if $values.ingressClassName }}
  ingressClassName: {{ $values.ingressClassName }}
  {{- end }}
  {{- end }}
  {{- if or ( eq $values.certType "selfsigned") (eq $values.certType "ixcert") ( $values.tls ) }}
  tls:
    {{- if $values.tls }}
    {{- range $values.tls }}
    - hosts:
	    {{- if and ( not .hosts ) ( not .hostsTpl ) }}
        {{- range $values.hosts }}
        - {{ .host | quote }}
        {{- end }}
		{{- end }}
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
        {{- range .hostsTpl }}
        - {{ tpl . $ | quote }}
        {{- end }}
      {{- if .secretNameTpl }}
      secretName: {{ tpl .secretNameTpl $ | quote}}
	  {{- else if eq $values.certType "ixcert" }}
	  secretName: {{ $ingressName }}
      {{- else if .secretName }}
      secretName: {{ .secretName }}
      {{- end }}
    {{- end }}
	{{- else }}
    - hosts:
        {{- range $values.hosts }}
        - {{ .host | quote }}
        {{- end }}
	  {{- if eq $values.certType "ixcert" }}
	  secretName: {{ $ingressName }}
      {{- end }}
	{{- end }}
  {{- end }}
  rules:
  {{- range $values.hosts }}
  {{- if .hostTpl }}
    - host: {{ tpl .hostTpl $ | quote }}
  {{- else }}
    - host: {{ .host | quote }}
  {{- end }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
            pathType: Prefix
            {{- end }}
            backend:
            {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" }}
              service:
                name: {{ $svcName }}
                port:
                  number: {{ $svcPort }}
            {{- else }}
              serviceName: {{ $svcName }}
              servicePort: {{ $svcPort }}
            {{- end }}
          {{- end }}
  {{- end }}
{{- end }}
