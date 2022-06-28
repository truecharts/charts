{{/*
  Custom PrivateBin configuration. See also:
  https://github.com/PrivateBin/docker-nginx-fpm-alpine#custom-configuration

  The default configuration file can be found here:
  https://github.com/PrivateBin/PrivateBin/blob/master/cfg/conf.sample.php
*/}}
{{- define "privatebin.secrets" -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "tc.common.names.fullname" . }}-secret
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
stringData:
  conf.php: |-
    ;<?php http_response_code(403); /*
    ; config file for PrivateBin
    ;
    ; An explanation of each setting can be find online at https://github.com/PrivateBin/PrivateBin/wiki/Configuration.

    [main]
    ; (optional) set a project name to be displayed on the website
    {{- with .Values.privatebin.main.name }}
    name = "{{ . }}"
    {{- end }}

    ; The full URL, with the domain name and directories that point to the PrivateBin files
    ; This URL is essential to allow Opengraph images to be displayed on social networks
    {{- with .Values.privatebin.main.basepath }}
    basepath = "{{ . }}"
    {{- end }}

    ; enable or disable the discussion feature, defaults to true
    discussion = {{ .Values.privatebin.main.discussion }}

    ; preselect the discussion feature, defaults to false
    opendiscussion = {{ .Values.privatebin.main.opendiscussion }}

    ; enable or disable the password feature, defaults to true
    password = {{ .Values.privatebin.main.password }}

    ; enable or disable the file upload feature, defaults to false
    fileupload = {{ .Values.privatebin.main.fileupload }}

    ; preselect the burn-after-reading feature, defaults to false
    burnafterreadingselected = {{ .Values.privatebin.main.burnafterreadingselected }}

    ; which display mode to preselect by default, defaults to "plaintext"
    ; make sure the value exists in [formatter_options]
    defaultformatter = "{{ .Values.privatebin.main.defaultformatter }}"

    ; (optional) set a syntax highlighting theme, as found in css/prettify/
    {{- with .Values.privatebin.main.syntaxhighlightingtheme }}
    syntaxhighlightingtheme = "{{ . }}"
    {{- end }}

    ; size limit per paste or comment in bytes, defaults to 10 Mebibytes
    {{/*
      Multiply by 1, so large integers aren't rendered in scientific notation
      See: https://github.com/helm/helm/issues/1707#issuecomment-1167860346
    */}}
    sizelimit = {{ mul .Values.privatebin.main.sizelimit 1 }}

    ; template to include, default is "bootstrap" (tpl/bootstrap.php)
    template = "{{ .Values.privatebin.main.template }}"

    ; (optional) info text to display
    ; use single, instead of double quotes for HTML attributes
    {{- with .Values.privatebin.main.info }}
    info = "{{ . }}"
    {{- end }}

    ; (optional) notice to display
    {{- with .Values.privatebin.main.notice }}
    notice = "{{ . }}"
    {{- end }}

    ; by default PrivateBin will guess the visitors language based on the browsers
    ; settings. Optionally you can enable the language selection menu, which uses
    ; a session cookie to store the choice until the browser is closed.
    languageselection = {{ .Values.privatebin.main.languageselection }}

    ; set the language your installs defaults to, defaults to English
    ; if this is set and language selection is disabled, this will be the only language
    {{- with .Values.privatebin.main.languagedefault }}
    languagedefault = "{{ . }}"
    {{- end }}

    ; (optional) URL shortener address to offer after a new paste is created
    ; it is suggested to only use this with self-hosted shorteners as this will leak
    ; the pastes encryption key
    {{- with .Values.privatebin.main.urlshortener }}
    urlshortener = "{{ . }}"
    {{- end }}

    ; (optional) Let users create a QR code for sharing the paste URL with one click.
    ; It works both when a new paste is created and when you view a paste.
    {{- with .Values.privatebin.main.qrcode }}
    qrcode = {{ . }}
    {{- end }}

    ; (optional) IP based icons are a weak mechanism to detect if a comment was from
    ; a different user when the same username was used in a comment. It might be
    ; used to get the IP of a non anonymous comment poster if the server salt is
    ; leaked and a SHA256 HMAC rainbow table is generated for all (relevant) IPs.
    ; Can be set to one these values: "none" / "vizhash" / "identicon" (default).
    {{- with .Values.privatebin.main.icon }}
    icon = "{{ . }}"
    {{- end }}

    ; Content Security Policy headers allow a website to restrict what sources are
    ; allowed to be accessed in its context. You need to change this if you added
    ; custom scripts from third-party domains to your templates, e.g. tracking
    ; scripts or run your site behind certain DDoS-protection services.
    ; Check the documentation at https://content-security-policy.com/
    ; Notes:
    ; - If you use a bootstrap theme, you can remove the allow-popups from the
    ;   sandbox restrictions.
    ; - By default this disallows to load images from third-party servers, e.g. when
    ;   they are embedded in pastes. If you wish to allow that, you can adjust the
    ;   policy here. See https://github.com/PrivateBin/PrivateBin/wiki/FAQ#why-does-not-it-load-embedded-images
    ;   for details.
    ; - The 'unsafe-eval' is used in two cases; to check if the browser supports
    ;   async functions and display an error if not and for Chrome to enable
    ;   webassembly support (used for zlib compression). You can remove it if Chrome
    ;   doesn't need to be supported and old browsers don't need to be warned.
    {{- with .Values.privatebin.main.cspheader }}
    cspheader = "{{ . }}"
    {{- end }}

    ; stay compatible with PrivateBin Alpha 0.19, less secure
    ; if enabled will use base64.js version 1.7 instead of 2.1.9 and sha1 instead of
    ; sha256 in HMAC for the deletion token
    {{- with .Values.privatebin.main.zerobincompatibility }}
    zerobincompatibility = {{ . }}
    {{- end }}

    ; Enable or disable the warning message when the site is served over an insecure
    ; connection (insecure HTTP instead of HTTPS), defaults to true.
    ; Secure transport methods like Tor and I2P domains are automatically whitelisted.
    ; It is **strongly discouraged** to disable this.
    ; See https://github.com/PrivateBin/PrivateBin/wiki/FAQ#why-does-it-show-me-an-error-about-an-insecure-connection for more information.
    {{- with .Values.privatebin.main.httpwarning }}
    httpwarning = {{ . }}
    {{- end }}

    ; Pick compression algorithm or disable it. Only applies to pastes/comments
    ; created after changing the setting.
    ; Can be set to one these values: "none" / "zlib" (default).
    {{- with .Values.privatebin.main.compression }}
    compression = "{{ . }}"
    {{- end }}

    [expire]
    ; expire value that is selected per default
    ; make sure the value exists in [expire_options]
    default = "{{ .Values.privatebin.expire.default }}"

    [expire_options]
    ; Set each one of these to the number of seconds in the expiration period,
    ; or 0 if it should never expire
    5min = 300
    10min = 600
    1hour = 3600
    1day = 86400
    1week = 604800
    ; Well this is not *exactly* one month, it's 30 days:
    1month = 2592000
    1year = 31536000
    never = 0

    [formatter_options]
    ; Set available formatters, their order and their labels
    plaintext = "Plain Text"
    syntaxhighlighting = "Source Code"
    markdown = "Markdown"

    [traffic]
    ; time limit between calls from the same IP address in seconds
    ; Set this to 0 to disable rate limiting.
    limit = {{ .Values.privatebin.traffic.limit }}

    ; (optional) Set IPs addresses (v4 or v6) or subnets (CIDR) which are exempted
    ; from the rate-limit. Invalid IPs will be ignored. If multiple values are to
    ; be exempted, the list needs to be comma separated. Leave unset to disable
    ; exemptions.
    {{- with .Values.privatebin.traffic.exempted }}
    exempted = "{{ . }}"
    {{- end }}

    ; (optional) If you want only some source IP addresses (v4 or v6) or subnets
    ; (CIDR) to be allowed to create pastes, set these here. Invalid IPs will be
    ; ignored. If multiple values are to be exempted, the list needs to be comma
    ; separated. Leave unset to allow anyone to create pastes.
    {{- with .Values.privatebin.traffic.creators }}
    creators = "{{ . }}"
    {{- end }}

    ; (optional) if your website runs behind a reverse proxy or load balancer,
    ; set the HTTP header containing the visitors IP address, i.e. X_FORWARDED_FOR
    {{- with .Values.privatebin.traffic.header }}
    header = "{{ . }}"
    {{- end }}

    [purge]
    ; minimum time limit between two purgings of expired pastes, it is only
    ; triggered when pastes are created
    ; Set this to 0 to run a purge every time a paste is created.
    limit = {{ .Values.privatebin.purge.limit }}

    ; maximum amount of expired pastes to delete in one purge
    ; Set this to 0 to disable purging. Set it higher, if you are running a large
    ; site
    batchsize = {{ .Values.privatebin.purge.batchsize }}

    [model]
    ; DB configuration for PostgreSQL
    class = Database
    [model_options]
    dsn = "{{ printf "pgsql:host=%v-postgresql;dbname=%v" .Release.Name .Values.postgresql.postgresqlDatabase }}"
    tbl = "privatebin_"    ; table prefix
    usr = "{{ .Values.postgresql.postgresqlUsername }}"
    pwd = {{ .Values.postgresql.postgresqlPassword }}
    opt[12] = true    ; PDO::ATTR_PERSISTENT

{{- end }}
