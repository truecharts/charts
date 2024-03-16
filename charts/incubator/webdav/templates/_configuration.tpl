{{- define "webdav.configuration" -}}
{{- include "webdav.validation" $ }}

{{- if ne .Values.webdavConfig.authType "none" }}
secret:
  htauth:
    enabled: true
    data:
      htauth: |
        {{- include "webdav.htauth" $ | nindent 8 }}
{{- end }}

configmap:
  config:
    enabled: true
    data:
      {{- if ne .Values.webdavConfig.authType "none" }}
      htauth: |
        {{- include "webdav.htauth" $ | nindent 8 }}
      {{- end }}

      webdav.conf: |
        {{- include "webdav.http.config" $ | nindent 8 }}

      {{- $modulePath := "/usr/local/apache2/modules" }}
      httpd.conf: |
        # This path is a emptyDir in memory
        PidFile "/usr/local/apache2/var/httpd.pid"
        # The absolutely necessary modules
        LoadModule authn_file_module {{ $modulePath }}/mod_authn_file.so
        LoadModule authn_core_module {{ $modulePath }}/mod_authn_core.so
        LoadModule authz_user_module {{ $modulePath }}/mod_authz_user.so
        LoadModule authz_core_module {{ $modulePath }}/mod_authz_core.so
        LoadModule alias_module {{ $modulePath }}/mod_alias.so
        LoadModule mpm_event_module {{ $modulePath }}/mod_mpm_event.so
        LoadModule auth_basic_module {{ $modulePath }}/mod_auth_basic.so
        LoadModule auth_digest_module {{ $modulePath }}/mod_auth_digest.so
        LoadModule setenvif_module {{ $modulePath }}/mod_setenvif.so
        LoadModule dav_module {{ $modulePath }}/mod_dav.so
        LoadModule dav_fs_module {{ $modulePath }}/mod_dav_fs.so
        LoadModule allowmethods_module {{ $modulePath }}/mod_allowmethods.so
        LoadModule ssl_module {{ $modulePath }}/mod_ssl.so
        LoadModule socache_shmcb_module {{ $modulePath }}/mod_socache_shmcb.so
        LoadModule unixd_module {{ $modulePath }}/mod_unixd.so
        LoadModule rewrite_module {{ $modulePath }}/mod_rewrite.so

        # Still deciding whether or not to keep these modules or not
        LoadModule authz_host_module {{ $modulePath }}/mod_authz_host.so
        LoadModule authz_groupfile_module {{ $modulePath }}/mod_authz_groupfile.so
        LoadModule access_compat_module {{ $modulePath }}/mod_access_compat.so
        LoadModule reqtimeout_module {{ $modulePath }}/mod_reqtimeout.so
        LoadModule filter_module {{ $modulePath }}/mod_filter.so
        LoadModule mime_module {{ $modulePath }}/mod_mime.so
        LoadModule env_module {{ $modulePath }}/mod_env.so
        LoadModule headers_module {{ $modulePath }}/mod_headers.so
        LoadModule status_module {{ $modulePath }}/mod_status.so
        LoadModule autoindex_module {{ $modulePath }}/mod_autoindex.so
        LoadModule dir_module {{ $modulePath }}/mod_dir.so

        ServerName localhost

        <IfModule dir_module>
          DirectoryIndex disabled
        </IfModule>

        <Files ".ht*">
          Require all denied
        </Files>

        ErrorLog "/proc/self/fd/2"
        LogLevel warn

        <IfModule log_config_module>
          LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
          LogFormat "%h %l %u %t \"%r\" %>s %b" common

          <IfModule logio_module>
            LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
          </IfModule>

          CustomLog "/proc/self/fd/1" common
        </IfModule>

        <IfModule alias_module>
          ScriptAlias /cgi-bin/ "/usr/local/apache2/cgi-bin/"
        </IfModule>

        <IfModule mime_module>
          # TypesConfig points to the file containing the list of mappings from
          # filename extension to MIME-type.

          TypesConfig /usr/local/apache2/conf/mime.types

          # AddType allows you to add to or override the MIME configuration
          # file specified in TypesConfig for specific file types.

          # AddType application/x-gzip .tgz

          # AddEncoding allows you to have certain browsers uncompress
          # information on the fly. Note: Not all browsers support this.

          # AddEncoding x-compress .Z
          # AddEncoding x-gzip .gz .tgz

          # If the AddEncoding directives above are commented-out, then you
          # probably should define those extensions to indicate media types:

          AddType application/x-compress .Z
          AddType application/x-gzip .gz .tgz

          # AddHandler allows you to map certain file extensions to "handlers":
          # actions unrelated to filetype. These can be either built into the server
          # or added with the Action directive (see below)

          # To use CGI scripts outside of ScriptAliased directories:
          # (You will also need to add "ExecCGI" to the "Options" directive.)

          # AddHandler cgi-script .cgi

          # For type maps (negotiated resources):
          # AddHandler type-map var

          # Filters allow you to process content before it is sent to the client.

          # To parse .shtml files for server-side includes (SSI):
          # (You will also need to add "Includes" to the "Options" directive.)

          # AddType text/html .shtml
          # AddOutputFilter INCLUDES .shtml
        </IfModule>

        # Secure (SSL/TLS) connections
        # Include etc/apache24/extra/httpd-ssl.conf

        # Note: The following must must be present to support
        #       starting without SSL on platforms with no /dev/random equivalent
        #       but a statically compiled-in mod_ssl.

        <IfModule ssl_module>
          SSLRandomSeed startup builtin
          SSLRandomSeed connect builtin
          SSLProtocol +TLSv1.2 +TLSv1.3
        </IfModule>

        Include /usr/local/apache2/conf/Includes/*.conf
{{- end -}}
