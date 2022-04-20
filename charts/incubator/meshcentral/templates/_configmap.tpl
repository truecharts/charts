{{/* Define the configmap */}}
{{- define "meshcentral.configmap" -}}

{{- $settings_cert := .Values.mesh.settings_cert }}
{{- $enable_webrtc := .Values.mesh.enable_webrtc }}
{{- $allow_new_accounts := .Values.mesh.allow_new_accounts }}
{{- $allow_plugins := .Values.mesh.allow_plugins }}
{{- $iframe := .Values.mesh.iframe }}
{{- $minify := .Values.mesh.minify }}
{{- $local_session_recording := .Values.mesh.local_session_recording }}

{{- if .Values.mesh.settings_domains_certUrl }}
  {{- $settings_domains_certUrl := "\"certUrl\": \"%v\" .Values.mesh.settings_domains_certUrl" }}
{{- else }}
  {{- $settings_domains_certUrl := "\"_certUrl\": \"https://192.168.2.106:443/\"" }}
{{- end -}}

{{- $mongodbURL := .Values.mongodb.url }}
{{- $port := .Values.service.main.ports.main.port }}

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: meshcentral-init
data:
  config.json.template: |-
      {
        "$schema": "http://info.meshcentral.com/downloads/meshcentral-config-schema.json",
        "__comment__": "This is a sample configuration file, all values and sections that start with underscore (_) are ignored. Edit a section and remove the _ in front of the name. Refer to the user's guide for details.",
        "settings": {
          "cert": "$settings_cert",
          "mongoDb": "$mongodbURL",
          "_mongoDbName": "meshcentral",
          "_mongoDbChangeStream": true,
          "_WANonly": true,
          "_LANonly": true,
          "_sessionKey": "MyReallySecretPassword1",
          "_sessionSameSite": "strict",
          "_certificatePrivateKeyPassword": ["password1", "password2"],
          "_dbEncryptKey": "MyReallySecretPassword2",
          "_dbRecordsEncryptKey": "MyReallySecretPassword",
          "_dbRecordsDecryptKey": "MyReallySecretPassword",
          "__dbExpire": "Amount of time to keep various events in the database, in seconds. Below are the default values.",
          "_dbExpire": {
            "events": 1728000,
            "powerevents": 864000,
            "statsevents": 2592000
          },
          "port": $port,
          "_portBind": "127.0.0.1",
          "_aliasPort": 444,
          "_redirPort": 80,
          "_redirPortBind": "127.0.0.1",
          "_redirAliasPort": 80,
          "_agentPort": 1234,
          "_agentPortBind": "127.0.0.1",
          "_agentAliasPort": 1234,
          "_agentAliasDNS": "agents.myserver.mydomain.com",
          "_agentPortTls": true,
          "_exactPorts": true,
          "_allowLoginToken": true,
          "allowFraming": $iframe,
          "_cookieIpCheck": false,
          "_cookieEncoding": "hex",
          "_compression": true,
          "_wscompression": false,
          "_agentwscompression": true,
          "_agentsInRam": false,
          "webRTC": $enable_webrtc,
          "_nice404": false,
          "_selfUpdate": true,
          "_browserPing": 60,
          "_browserPong": 60,
          "_agentPing": 60,
          "_agentPong": 60,
          "_agentIdleTimeout": 150,
          "_meshErrorLogPath": "c:\\tmp",
          "_npmPath": "c:\\npm.exe",
          "_npmProxy": "http://1.2.3.4:80",
          "_allowHighQualityDesktop": true,
          "_webPush": { "email": "xxxxx@xxxxx.com" },
          "_publicPushNotifications": true,
          "_desktopMultiplex": true,
          "_userAllowedIP": "127.0.0.1,192.168.1.0/24",
          "_userBlockedIP": "127.0.0.1,::1,192.168.0.100",
          "_agentAllowedIP": "192.168.0.100/24",
          "_agentBlockedIP": "127.0.0.1,::1",
          "_authLog": "c:\\temp\\auth.log",
          "_InterUserMessaging": ["user//admin"],
          "_manageAllDeviceGroups": ["user//admin"],
          "_manageCrossDomain": ["user//admin"],
          "_localDiscovery": {
            "name": "Local server name",
            "info": "Information about this server"
          },
          "_tlsOffload": "127.0.0.1,::1",
          "_trustedProxy": "127.0.0.1,::1",
          "_mpsPort": 44330,
          "_mpsPortBind": "127.0.0.1",
          "_mpsAliasPort": 4433,
          "_mpsAliasHost": "mps.mydomain.com",
          "_mpsTlsOffload": true,
          "_no2FactorAuth": true,
          "_runOnServerStarted": "c:\\tmp\\mcstart.bat",
          "_runOnServerUpdated": "c:\\tmp\\mcupdate.bat",
          "_runOnServerError": "c:\\tmp\\mcerror.bat",
          "_log": "main,web,webrequest,cert",
          "_syslog": "meshcentral",
          "_syslogauth": "meshcentral-auth",
          "_syslogjson": "meshcentral-json",
          "_syslogtcp": "localhost:514",
          "_webrtcConfig": {
            "iceServers": [
              { "urls": "stun:stun.services.mozilla.com" },
              { "urls": "stun:stun.l.google.com:19302" }
            ]
          },
          "_autoBackup": {
            "_mongoDumpPath": "C:\\Program Files\\MongoDB\\Server\\4.2\\bin\\mongodump.exe",
            "backupIntervalHours": 24,
            "keepLastDaysBackup": 10,
            "zipPassword": "MyReallySecretPassword3",
            "_backupPath": "C:\\backups",
            "_googleDrive": {
              "folderName": "MeshCentral-Backups",
              "maxFiles": 10
            },
            "webdav": {
              "url": "https://server/remote.php/dav/files/xxxxx@server.com/",
              "username": "user",
              "password": "pass",
              "folderName": "MeshCentral-Backups",
              "maxFiles": 10
            }
          },
          "_redirects": {
            "meshcommander": "https://www.meshcommander.com/"
          },
          "__maxInvalidLogin": "Time in minutes, max amount of bad logins from a source IP in the time before logins are rejected.",
          "_maxInvalidLogin": {
            "time": 10,
            "count": 10,
            "coolofftime": 10
          },
          "__maxInvalid2fa": "Time in minutes, max amount of bad two-factor authentication from a source IP in the time before 2FA's are rejected.",
          "_maxInvalid2fa": {
            "time": 10,
            "count": 10,
            "coolofftime": 10
          },
          "watchDog": { "interval": 100, "timeout": 400 },
          "_AmtProvisioningServer": {
            "port": 9971,
            "deviceGroup": "mesh//xxxxxxxxxxxxxxxxxxxxx",
            "newMebxPassword": "amtpassword",
            "trustedFqdn": "sample.com",
            "ip": "192.168.1.1"
          },
          "plugins": { "enabled": $allow_plugins }
        },
        "_domaindefaults": {
          "__comment__": "Any settings in this section is used as default setting for all domains",
          "title": "MyDefaultTitle",
          "footer": "Default page footer",
          "newAccounts": false
        },
        "domains": {
          "": {
            "_siteStyle": 2,
            "title": "MyServer",
            "title2": "Servername",
            "_titlePicture": "title-sample.png",
            "_loginPicture": "title-sample.png",
            "_userQuota": 1048576,
            "_meshQuota": 248576,
            "minify": $minify,
            "_guestDeviceSharing": false,
            "_AutoRemoveInactiveDevices": 37,
            "_DeviceSearchBarServerAndClientName": false,
            "_loginKey": ["abc", "123"],
            "_agentKey": ["abc", "123"],
            "newAccounts": $allow_new_accounts,
            "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
            "_userNameIsEmail": true,
            "_newAccountEmailDomains": ["sample.com"],
            "_newAccountsRights": ["nonewgroups", "notools"],
            "_welcomeText": "Sample Text on Login Page.",
            "_welcomePicture": "mainwelcome.jpg",
            "_welcomePictureFullScreen": false,
            "_meshMessengerTitle": "MeshMessenger",
            "_meshMessengerPicture": "messenger.png",
            "___hide__": "Sum of: 1 = Hide header, 2 = Hide tab, 4 = Hide footer, 8 = Hide title, 16 = Hide left bar, 32 = Hide back buttons",
            "_hide": 4,
            "_footer": "<a href='https://twitter.com/mytwitter'>Twitter</a>",
            "_loginfooter": "This is a private server.",
            "$settings_domains_certUrl",
            "_altMessenging": {
              "name": "Jitsi",
              "url": "https://meet.jit.si/myserver-{0}"
            },
            "_deviceMeshRouterLinks": {
              "rdp": true,
              "ssh": true,
              "scp": true,
              "extralinks": [
                {
                  "name": "HTTP",
                  "protocol": "http",
                  "port": 80,
                  "_ip": "192.168.1.100",
                  "_filter": ["mesh/(domainid)/(meshid)", "node/(domainid)/(nodeid)"]
                },
                {
                  "name": "HTTPS",
                  "protocol": "https",
                  "port": 443
                }
              ]
            },
            "PreconfiguredRemoteInput": [
              {
                "name": "CompagnyUrl",
                "value": "https://help.mycompany.com/"
              },
              {
                "name": "Any Text",
                "value": "Any text\r"
              },
              {
                "name": "Welcome",
                "value": "Default welcome text"
              }
            ],
            "myServer": {
              "Backup": false,
              "Restore": false,
              "Upgrade": false,
              "ErrorLog": false,
              "Console": false,
              "Trace": false
            },
            "_passwordRequirements": {
              "min": 8,
              "max": 128,
              "upper": 1,
              "lower": 1,
              "numeric": 1,
              "nonalpha": 1,
              "reset": 90,
              "force2factor": true,
              "skip2factor": "127.0.0.1,192.168.2.0/24",
              "oldPasswordBan": 5,
              "banCommonPasswords": false,
              "twoFactorTimeout": 300
            },
            "_twoFactorCookieDurationDays": 30,
            "_agentInviteCodes": true,
            "_agentNoProxy": true,
            "_geoLocation": true,
            "_novnc": false,
            "_mstsc": true,
            "_ssh": true,
            "_WebEmailsPath": "/myserver/email-templates",
            "_consentMessages": {
              "title": "MeshCentral",
              "desktop": "{0} requesting remote desktop access. Grant access?",
              "terminal": "{0} requesting remote terminal access. Grant access?",
              "files": "{0} requesting remote files access. Grant access?",
              "consentTimeout": 30,
              "autoAcceptOnTimeout": false
            },
            "_notificationMessages": {
              "title": "MeshCentral",
              "desktop": "{0} started a remote desktop session.",
              "terminal": "{0} started a remote terminal session.",
              "files": "{0} started a remote files session."
            },
            "_agentCustomization": {
              "displayName": "Company® Product™",
              "description": "Company® Product™ agent for remote monitoring, management and assistance.",
              "companyName": "Company®",
              "serviceName": "companyagent",
              "image": "agent-logo.png",
              "fileName": "compagnyagent"
            },
            "_assistantCustomization": {
              "title": "Company® Product™",
              "image": "assistant-logo.png",
              "fileName": "compagny"
            },
            "_androidCustomization": {
              "title": "Company® Product™",
              "subtitle": "Product Subtitle™",
              "image": "assistant-logo.png"
            },
            "_userAllowedIP": "127.0.0.1,192.168.1.0/24",
            "_userBlockedIP": "127.0.0.1,::1,192.168.0.100",
            "_agentAllowedIP": "192.168.0.100/24",
            "_agentBlockedIP": "127.0.0.1,::1",
            "_orphanAgentUser": "admin",
            "___userSessionIdleTimeout__": "Number of user idle minutes before auto-disconnect",
            "_userSessionIdleTimeout": 30,
            "userConsentFlags": {
              "desktopnotify": true,
              "terminalnotify": true,
              "filenotify": true,
              "desktopprompt": true,
              "terminalprompt": true,
              "fileprompt": true,
              "desktopprivacybar": true
            },
            "_urlSwitching": false,
            "_desktopPrivacyBarText": "Privacy bar: {0}, {1}",
            "_limits": {
              "_maxDevices": 100,
              "_maxUserAccounts": 100,
              "_maxUserSessions": 100,
              "_maxAgentSessions": 100,
              "maxSingleUserSessions": 10
            },
            "_terminal": {
              "_linuxshell": "login",
              "launchCommand": {
                "linux": "clear\necho \"Hello Linux\"\n",
                "darwin": "clear\necho \"Hello MacOS\"\n",
                "freebsd": "clear\necho \"Hello FreeBSD\"\n"
              }
            },
            "_amtScanOptions": [
              "LabNetwork 192.168.15.0/23",
              "SalesNetwork 192.168.8.0/24"
            ],
            "_amtAcmActivation": {
              "log": "amtactivation.log",
              "certs": {
                "mycertname": {
                  "certfiles": [
                    "amtacm-leafcert.crt",
                    "amtacm-intermediate1.crt",
                    "amtacm-intermediate2.crt",
                    "amtacm-rootcert.crt"
                  ],
                  "keyfile": "amtacm-leafcert.key"
                }
              }
            },
            "_amtManager": {
              "adminAccounts": [{ "user": "admin", "pass": "MyP@ssw0rd" }],
              "environmentDetection": [
                "domain1.com",
                "domain2.com",
                "domain3.com",
                "domain4.com"
              ],
              "wifiProfiles": [
                {
                  "name": "Profile1",
                  "ssid": "MyStation1",
                  "authentication": "wpa2-psk",
                  "encryption": "ccmp-aes",
                  "password": "MyP@ssw0rd"
                }
              ]
            },
            "_redirects": {
              "meshcommander": "https://www.meshcommander.com/"
            },
            "_yubikey": {
              "id": "0000",
              "secret": "xxxxxxxxxxxxxxxxxxxxx",
              "_proxy": "http://myproxy.domain.com:80"
            },
            "_httpHeaders": {
              "Strict-Transport-Security": "max-age=360000",
              "x-frame-options": "SAMEORIGIN"
            },
            "_agentConfig": ["webSocketMaskOverride=1", "coreDumpEnabled=1"],
            "_assistantConfig": ["disableUpdate=1"],
            "localSessionRecording": $local_session_recording,
            "_sessionRecording": {
              "_onlySelectedUsers": true,
              "_onlySelectedUserGroups": true,
              "_onlySelectedDeviceGroups": true,
              "_filepath": "C:\\temp",
              "_index": true,
              "_maxRecordings": 10,
              "_maxRecordingDays": 15,
              "_maxRecordingSizeMegabytes": 3,
              "__protocols__": "Is an array: 1 = Terminal, 2 = Desktop, 5 = Files, 100 = Intel AMT WSMAN, 101 = Intel AMT Redirection, 200 = Messenger",
              "protocols": [1, 2, 101]
            },
            "_authStrategies": {
              "__comment__": "This section is used to allow users to login using other accounts. You will need to get an API key from the services and register callback URL's",
              "twitter": {
                "_callbackurl": "https://server/auth-twitter-callback",
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "clientid": "xxxxxxxxxxxxxxxxxxxxxxx",
                "clientsecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
              },
              "google": {
                "_callbackurl": "https://server/auth-google-callback",
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "clientid": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com",
                "clientsecret": "xxxxxxxxxxxxxxxxxxxxxxx"
              },
              "github": {
                "_callbackurl": "https://server/auth-github-callback",
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "clientid": "xxxxxxxxxxxxxxxxxxxxxxx",
                "clientsecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
              },
              "reddit": {
                "_callbackurl": "https://server/auth-reddit-callback",
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "clientid": "xxxxxxxxxxxxxxxxxxxxxxx",
                "clientsecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
              },
              "azure": {
                "_callbackurl": "https://server/auth-azure-callback",
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "clientid": "00000000-0000-0000-0000-000000000000",
                "clientsecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                "tenantid": "00000000-0000-0000-0000-000000000000"
              },
              "jumpcloud": {
                "_callbackurl": "https://server/auth-jumpcloud-callback",
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "entityid": "meshcentral",
                "idpurl": "https://sso.jumpcloud.com/saml2/saml2",
                "cert": "jumpcloud-saml.pem"
              },
              "saml": {
                "_callbackurl": "https://server/auth-saml-callback",
                "_disableRequestedAuthnContext": true,
                "newAccounts": true,
                "_newAccountsUserGroups": ["ugrp//xxxxxxxxxxxxxxxxx"],
                "_newAccountsRights": ["nonewgroups", "notools"],
                "entityid": "meshcentral",
                "idpurl": "https://server/saml2",
                "cert": "saml.pem"
              },
              "oidc": {
                "authorizationURL": "https://sso.server.com/api/oidc/authorization",
                "callbackURL": "https://mesh.server.com/oidc-callback",
                "clientid": "00000000-0000-0000-0000-000000000000",
                "clientsecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                "issuer": "https://sso.server.com",
                "tokenURL": "https://sso.server.com/api/oidc/token",
                "userInfoURL": "https://sso.server.com/api/oidc/userinfo",
                "logoutURL": "https://sso.server.com/logout",
                "newAccounts": true
              }
            }
          },
          "_customer1": {
            "_dns": "customer1.myserver.com",
            "_title": "Customer1",
            "_title2": "TestServer",
            "_newAccounts": 1,
            "_auth": "sspi",
            "__auth": "ldap",
            "_LDAPUserName": "gecos",
            "_LDAPUserKey": "uid",
            "_LDAPUserEmail": "otherMail",
            "_LDAPPptions": {
              "url": "test",
              "anne": {
                "gecos": "Anne O'Nyme",
                "displayName": "O Nyme anne",
                "uid": "anneonyme",
                "mail": "anneonyme@example.com",
                "email": "anneonyme@example.com",
                "otherMail": ["other.anneonyme@example.com", "anneonyme@example.com"]
              },
              "so": {
                "displayName": "Sticker Sophie",
                "gecos": "Sophie Sticker",
                "uid": "ssticker",
                "mail": "ssticker@example.com",
                "email": "ssticker@example.com",
                "otherMail": ["other.ssticker@example.com", "ssticker@example.com"]
              }
            },
            "__LDAPOptions": {
              "URL": "ldap://1.2.3.4:389",
              "BindDN": "CN=svc_meshcentral,CN=Users,DC=meshcentral,DC=local",
              "BindCredentials": "Password.1",
              "SearchBase": "DC=meshcentral,DC=local",
              "SearchFilter": "(sAMAccountName={{"{{"}}username{{"}}"}})"
            },
            "_footer": "Test",
            "_certUrl": "https://192.168.2.106:443/"
          },
          "_info": {
            "_share": "C:\\ExtraWebSite"
          }
        },
        "_letsencrypt": {
          "__comment__": "Requires NodeJS 8.x or better, Go to https://letsdebug.net/ first before trying Let's Encrypt.",
          "email": "myemail@myserver.com",
          "names": "myserver.com,customer1.myserver.com",
          "skipChallengeVerification": false,
          "production": false
        },
        "_peers": {
          "serverId": "server1",
          "servers": {
            "server1": { "url": "wss://192.168.2.133:443/" },
            "server2": { "url": "wss://192.168.1.106:443/" }
          }
        },
        "_smtp": {
          "host": "smtp.myserver.com",
          "port": 25,
          "from": "myemail@myserver.com",
          "__tls__": "When 'tls' is set to true, TLS is used immidiatly when connecting. For SMTP servers that use TLSSTART, set this to 'false' and TLS will still be used.",
          "tls": false,
          "___tlscertcheck__": "When set to false, the TLS certificate of the SMTP server is not checked.",
          "_tlscertcheck": false,
          "__tlsstrict__": "When set to true, TLS cypher setup is more limited, SSLv2 and SSLv3 are not allowed.",
          "_tlsstrict": true
        },
        "_sendgrid": {
          "from": "myemail@myserver.com",
          "apikey": "***********"
        },
        "_sendmail": {
          "newline": "unix",
          "path": "/usr/sbin/sendmail",
          "_args": ["-f", "foo@example.com"]
        },
        "_sms": {
          "provider": "twilio",
          "sid": "ACxxxxxxxxx",
          "auth": "xxxxxxx",
          "from": "+1-555-555-5555"
        },
        "__sms": {
          "provider": "plivo",
          "id": "xxxxxxx",
          "token": "xxxxxxx",
          "from": "1-555-555-5555"
        },
        "___sms": {
          "provider": "telnyx",
          "apikey": "xxxxxxx",
          "from": "1-555-555-5555"
        }
      }
  init.sh: |-
    #!/bin/sh
    export configfile=/opt/meshcentral/meshcentral-data/config.json;
    if test -f $configfile; then
      echo "config.json exists.";
    else
      cp /init/meshcentral/config.json.template $configfile;
      echo Copied config file;
    fi

{{- end -}}
