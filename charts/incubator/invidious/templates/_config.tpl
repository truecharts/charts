{{/* Define the configmap */}}
{{- define "invidious.config" -}}

{{- $configName := printf "%s-invidious-config" (include "tc.common.names.fullname" .) }}
{{- $configEnvName := printf "%s-invidious-env" (include "tc.common.names.fullname" .) }}

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
data:
  config.yml: |
    # version compatible 0.20.1+
#########################################
#
#  Database configuration
#
#########################################

##
## Database configuration with separate parameters.
## This setting is MANDATORY, unless 'database_url' is used.
##
db:
  user: "{{ .Values.invidious.db_user }}"
  password: "{{ .Values.invidious.db_pass }}"
  host: "{{ .Values.invidious.db_host }}"
  port: {{ .Values.invidious.db_port }}
  dbname: "{{ .Values.invidious.db_name }}"

##
## Enable automatic table integrity check. This will create
## the required tables and columns if anything is missing.
##
## Accepted values: true, false
## Default: false
##
check_tables: "{{ .Values.invidious.check_tables }}"



#########################################
#
#  Server config
#
#########################################

# -----------------------------
#  Network (inbound)
# -----------------------------

##
## Port to listen on for incoming connections.
##
## Note: Ports lower than 1024 requires either root privileges
## (not recommended) or the "CAP_NET_BIND_SERVICE" capability
## (See https://stackoverflow.com/a/414258 and `man capabilities`)
##
## Accepted values: 1-65535
## Default: 3000
##
port: {{ .Values.network.inbound.internal_port }}

##
## When the invidious instance is behind a proxy, and the proxy
## listens on a different port than the instance does, this lets
## invidious know about it. This is used to craft absolute URLs
## to the instance (e.g in the API).
##
## Note: This setting is MANDATORY if invidious is behind a
## reverse proxy.
##
## Accepted values: 1-65535
## Default: <none>
##
external_port: {{ .Values.network.inbound.external_port }}

##
## Interface address to listen on for incoming connections.
##
## Accepted values: a valid IPv4 or IPv6 address.
## default: 0.0.0.0  (listen on all interfaces)
##
host_binding: {{ .Values.network.inbound.host_binding }}

##
## Domain name under which this instance is hosted. This is
## used to craft absolute URLs to the instance (e.g in the API).
## The domain MUST be defined if your instance is accessed from
## a domain name (like 'example.com').
##
## Accepted values: a fully qualified domain name (FQDN)
## Default: <none>
##
domain: {{ .Values.network.inbound.domain }}

##
## Tell Invidious that it is behind a proxy that provides only
## HTTPS, so all links must use the https:// scheme. This
## setting MUST be set to true if invidious is behind a
## reverse proxy serving HTTPs.
##
## Accepted values: true, false
## Default: false
##
https_only: {{ .Values.network.inbound.https_only }}

##
## Enable/Disable 'Strict-Transport-Security'. Make sure that
## the domain specified under 'domain' is served securely.
##
## Accepted values: true, false
## Default: true
##
#hsts: {{ .Values.network.inbound.hsts }}


# -----------------------------
#  Network (outbound)
# -----------------------------

##
## Disable proxying server-wide. Can be disable as a whole, or
## only for a single function.
##
## Accepted values: true, false, dash, livestreams, downloads, local
## Default: false
##
#disable_proxy: false

##
## Size of the HTTP pool used to connect to youtube. Each
## domain ('youtube.com', 'ytimg.com', ...) has its own pool.
##
## Accepted values: a positive integer
## Default: 100
##
#pool_size: 100

##
## Enable/Disable the use of QUIC (HTTP/3) when connecting
## to the youtube API and websites ('youtube.com', 'ytimg.com').
## QUIC's main advantages are its lower latency and lower bandwidth
## use, compared to its predecessors. However, the current version
## of QUIC used in invidious is still based on the IETF draft 31,
## meaning that the underlying library may still not be fully
## optimized. You can read more about QUIC at the link below:
## https://datatracker.ietf.org/doc/html/draft-ietf-quic-transport-31
##
## Note: you should try both options and see what is the best for your
## instance. In general QUIC is recommended for public instances. Your
## mileage may vary.
##
## Note 2: Using QUIC prevents some captcha challenges from appearing.
## See: https://github.com/iv-org/invidious/issues/957#issuecomment-576424042
##
## Accepted values: true, false
## Default: false
##
#use_quic: false

##
## Additional cookies to be sent when requesting the youtube API.
##
## Accepted values: a string in the format "name1=value1; name2=value2..."
## Default: <none>
##
#cookies:

##
## Force connection to youtube over a specific IP family.
##
## Note: This may sometimes resolve issues involving rate-limiting.
## See https://github.com/ytdl-org/youtube-dl/issues/21729.
##
## Accepted values: ipv4, ipv6
## Default: <none>
##
#force_resolve:


# -----------------------------
#  Logging
# -----------------------------

##
## Path to log file. Can be absolute or relative to the invidious
## binary. This is overridden if "-o OUTPUT" or "--output=OUTPUT"
## are passed on the command line.
##
## Accepted values: a filesystem path or 'STDOUT'
## Default: STDOUT
##
#output: STDOUT

##
## Logging Verbosity. This is overridden if "-l LEVEL" or
## "--log-level=LEVEL" are passed on the command line.
##
## Accepted values: All, Trace, Debug, Info, Warn, Error, Fatal, Off
## Default: Info
##
#log_level: Info


# -----------------------------
#  Features
# -----------------------------

##
## Enable/Disable the "Popular" tab on the main page.
##
## Accepted values: true, false
## Default: true
##
#popular_enabled: true

##
## Enable/Disable statstics (available at /api/v1/stats).
## The following data is available:
##   - Software name ("invidious") and version+branch (same data as
##     displayed in the footer, e.g: "2021.05.13-75e5b49" / "master")
##   - The value of the 'registration_enabled' config (true/false)
##   - Number of currently registered users
##   - Number of registered users who connected in the last month
##   - Number of registered users who connected in the last 6 months
##   - Timestamp of the last server restart
##   - Timestamp of the last "Channel Refresh" job execution
##
## Warning: This setting MUST be set to true if you plan to run
## a public instance. It is used by api.invidious.io to refresh
## your instance's status.
##
## Accepted values: true, false
## Default: false
##
#statistics_enabled: false


# -----------------------------
#  Users and accounts
# -----------------------------

##
## Allow/Forbid Invidious (local) account creation. Invidious
## accounts allow users to subscribe to channels and to create
## playlists without a Google account.
##
## Accepted values: true, false
## Default: true
##
#registration_enabled: true

##
## Allow/Forbid users to log-in. This setting affects the ability
## to connect with BOTH Google and Invidious (local) accounts.
##
## Accepted values: true, false
## Default: true
##
#login_enabled: true

##
## Enable/Disable the captcha challenge on the login page.
##
## Note: this is a basic captcha challenge that doesn't
## depend on any third parties.
##
## Accepted values: true, false
## Default: true
##
#captcha_enabled: true

##
## List of usernames that will be granted administrator rights.
## A user with administrator rights will be able to change the
## server configuration options listed below in /preferences,
## in addition to the usual user preferences.
##
## Server-wide settings:
##   - popular_enabled
##   - captcha_enabled
##   - login_enabled
##   - registration_enabled
##   - statistics_enabled
## Default user preferences:
##   - default_home
##   - feed_menu
##
## Accepted values: an array of strings
## Default: [""]
##
#admins: [""]


# -----------------------------
#  Background jobs
# -----------------------------

##
## Number of threads to use when crawling channel videos (during
## subscriptions update).
##
## Notes: This setting is overridden if either "-c THREADS" or
## "--channel-threads=THREADS" is passed on the command line.
##
## Accepted values: a positive integer
## Default: 1
##
channel_threads: 1

##
## Time interval between two executions of the job that crawls
## channel videos (subscriptions update).
##
## Accepted values: a valid time interval (like 1h30m or 90m)
## Default: 30m
##
#channel_refresh_interval: 30m

##
## Forcefully dump and re-download the entire list of uploaded
## videos when crawling channel (during subscriptions update).
##
## Accepted values: true, false
## Default: false
##
full_refresh: false

##
## Number of threads to use when updating RSS feeds.
##
## Notes: This setting is overridden if either "-f THREADS" or
## "--feed-threads=THREADS" is passed on the command line.
##
## Accepted values: a positive integer
## Default: 1
##
feed_threads: 1

##
## Enable/Disable the polling job that keeps the decryption
## function (for "secured" videos) up to date.
##
## Note: This part of the code generate a small amount of data every minute.
## This may not be desired if you have bandwidth limits set by your ISP.
##
## Note 2: This part of the code is currently broken, so changing
## this setting has no impact.
##
## Accepted values: true, false
## Default: false
##
#decrypt_polling: false


jobs:

  ## Options for the database cleaning job
  clear_expired_items:

    ## Enable/Disable job
    ##
    ## Accepted values: true, false
    ## Default: true
    ##
    enable: true

  ## Options for the channels updater job
  refresh_channels:

    ## Enable/Disable job
    ##
    ## Accepted values: true, false
    ## Default: true
    ##
    enable: true

  ## Options for the RSS feeds updater job
  refresh_feeds:

    ## Enable/Disable job
    ##
    ## Accepted values: true, false
    ## Default: true
    ##
    enable: true


# -----------------------------
#  Captcha API
# -----------------------------

##
## URL of the captcha solving service.
##
## Accepted values: any URL
## Default: https://api.anti-captcha.com
##
#captcha_api_url: https://api.anti-captcha.com

##
## API key for the captcha solving service.
##
## Accepted values: a string
## Default: <none>
##
#captcha_key:


# -----------------------------
#  Miscellaneous
# -----------------------------

##
## custom banner displayed at the top of every page. This can
## used for instance announcements, e.g.
##
## Accepted values: any string. HTML is accepted.
## Default: <none>
##
#banner:

##
## Subscribe to channels using PubSubHub (Google PubSubHubbub service).
## PubSubHub allows Invidious to be instantly notified when a new video
## is published on any subscribed channels. When PubSubHub is not used,
## Invidious will check for new videos every minute.
##
## Note: This setting is recommended for public instances.
##
## Note 2:
##  - Requires a public instance (it uses /feed/webhook/v1)
##  - Requires 'domain' and 'hmac_key' to be set.
##  - Setting this parameter to any number greater than zero will
##    enable channel subscriptions via PubSubHub, but will limit the
##    amount of concurrent subscriptions.
##
## Accepted values: true, false, a positive integer
## Default: false
##
#use_pubsub_feeds: false

##
## HMAC signing key used for CSRF tokens and pubsub
## subscriptions verification.
##
## Accepted values: a string
## Default: <none>
##
#hmac_key:

##
## List of video IDs where the "download" widget must be
## disabled, in order to comply with DMCA requests.
##
## Accepted values: an array of string
## Default: <none>
##
#dmca_content:

##
## Cache video annotations in the database.
##
## Warning: empty annotations or annotations that only contain
## cards won't be cached.
##
## Accepted values: true, false
## Default: false
##
#cache_annotations: false

##
## Source code URL. If your instance is running a modified source
## code, you MUST publish it somewhere and set this option.
##
## Accepted values: a string
## Default: <none>
##
#modified_source_code_url: ""

##
## Maximum custom playlist length limit.
##
## Accepted values: Integer
## Default: 500
##
#playlist_length_limit: 500

#########################################
#
#  Default user preferences
#
#########################################

##
## NOTE: All the settings below define the default user
## preferences. They will apply to ALL users connecting
## without a preferences cookie (so either on the first
## connection to the instance or after clearing the
## browser's cookies).
##

default_user_preferences:

  # -----------------------------
  #  Internationalization
  # -----------------------------

  ##
  ## Default user interface language (locale).
  ##
  ## Note: When hosting a public instance, overriding the
  ## default (english) is not recommended, as it may
  ## people using other languages.
  ##
  ## Accepted values:
  ##   ar      (Arabic)
  ##   da      (Danish)
  ##   de      (German)
  ##   en-US   (english, US)
  ##   el      (Greek)
  ##   eo      (Esperanto)
  ##   es      (Spanish)
  ##   fa      (Persian)
  ##   fi      (Finnish)
  ##   fr      (French)
  ##   he      (Hebrew)
  ##   hr      (Hungarian)
  ##   id      (Indonesian)
  ##   is      (Icelandic)
  ##   it      (Italian)
  ##   ja      (Japanese)
  ##   nb-NO   (Norwegian, Bokmål)
  ##   nl      (Dutch)
  ##   pl      (Polish)
  ##   pt-BR   (Portuguese, Brazil)
  ##   pt-PT   (Portuguese, Portugal)
  ##   ro      (Romanian)
  ##   ru      (Russian)
  ##   sv      (Swedish)
  ##   tr      (Turkish)
  ##   uk      (Ukrainian)
  ##   zh-CN   (Chinese, China)  (a.k.a "Simplified Chinese")
  ##   zh-TW   (Chinese, Taiwan) (a.k.a "Traditional Chinese")
  ##
  ## Default: en-US
  ##
  #locale: en-US

  ##
  ## Default geographical location for content.
  ##
  ## Accepted values:
  ##   AE, AR, AT, AU, AZ, BA, BD, BE, BG, BH, BO, BR, BY, CA, CH, CL, CO, CR,
  ##   CY, CZ, DE, DK, DO, DZ, EC, EE, EG, ES, FI, FR, GB, GE, GH, GR, GT, HK,
  ##   HN, HR, HU, ID, IE, IL, IN, IQ, IS, IT, JM, JO, JP, KE, KR, KW, KZ, LB,
  ##   LI, LK, LT, LU, LV, LY, MA, ME, MK, MT, MX, MY, NG, NI, NL, NO, NP, NZ,
  ##   OM, PA, PE, PG, PH, PK, PL, PR, PT, PY, QA, RO, RS, RU, SA, SE, SG, SI,
  ##   SK, SN, SV, TH, TN, TR, TW, TZ, UA, UG, US, UY, VE, VN, YE, ZA, ZW
  ##
  ## Default: US
  ##
  #region: US

  ##
  ## Top 3 preferred languages for video captions.
  ##
  ## Note: overriding the default (no preferred
  ## caption language) is not recommended, in order
  ## to not penalize people using other languages.
  ##
  ## Accepted values: a three-entries array.
  ## Each entry can be one of:
  ##   "English", "English (auto-generated)",
  ##   "Afrikaans", "Albanian", "Amharic", "Arabic",
  ##   "Armenian", "Azerbaijani", "Bangla", "Basque",
  ##   "Belarusian", "Bosnian", "Bulgarian", "Burmese",
  ##   "Catalan", "Cebuano", "Chinese (Simplified)",
  ##   "Chinese (Traditional)", "Corsican", "Croatian",
  ##   "Czech", "Danish", "Dutch", "Esperanto", "Estonian",
  ##   "Filipino", "Finnish", "French", "Galician", "Georgian",
  ##   "German", "Greek", "Gujarati", "Haitian Creole", "Hausa",
  ##   "Hawaiian", "Hebrew", "Hindi", "Hmong", "Hungarian",
  ##   "Icelandic", "Igbo", "Indonesian", "Irish", "Italian",
  ##   "Japanese", "Javanese", "Kannada", "Kazakh", "Khmer",
  ##   "Korean", "Kurdish", "Kyrgyz", "Lao", "Latin", "Latvian",
  ##   "Lithuanian", "Luxembourgish", "Macedonian",
  ##   "Malagasy", "Malay", "Malayalam", "Maltese", "Maori",
  ##   "Marathi", "Mongolian", "Nepali", "Norwegian Bokmål",
  ##   "Nyanja", "Pashto", "Persian", "Polish", "Portuguese",
  ##   "Punjabi", "Romanian", "Russian", "Samoan",
  ##   "Scottish Gaelic", "Serbian", "Shona", "Sindhi",
  ##   "Sinhala", "Slovak", "Slovenian", "Somali",
  ##   "Southern Sotho", "Spanish", "Spanish (Latin America)",
  ##   "Sundanese",  "Swahili", "Swedish", "Tajik", "Tamil",
  ##   "Telugu", "Thai", "Turkish", "Ukrainian", "Urdu",
  ##   "Uzbek", "Vietnamese", "Welsh", "Western Frisian",
  ##   "Xhosa", "Yiddish", "Yoruba", "Zulu"
  ##
  ## Default: ["", "", ""]
  ##
  #captions: ["", "", ""]


  # -----------------------------
  #  Interface
  # -----------------------------

  ##
  ## Enable/Disable dark mode.
  ##
  ## Accepted values: "dark", "light", "auto"
  ## Default: "auto"
  ##
  #dark_mode: "auto"

  ##
  ## Enable/Disable thin mode (no video thumbnails).
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #thin_mode: false

  ##
  ## List of feeds available on the home page.
  ##
  ## Note: "Subscriptions" and "Playlists" are only visible
  ## when the user is logged in.
  ##
  ## Accepted values: A list of strings
  ## Each entry can be one of: "Popular", "Trending",
  ##    "Subscriptions", "Playlists"
  ##
  ## Default: ["Popular", "Trending", "Subscriptions", "Playlists"]  (show all feeds)
  ##
  #feed_menu: ["Popular", "Trending", "Subscriptions", "Playlists"]

  ##
  ## Default feed to display on the home page.
  ##
  ## Note: setting this option to "Popular" has no
  ## effect when 'popular_enabled' is set to false.
  ##
  ## Accepted values: Popular, Trending, Subscriptions, Playlists, <none>
  ## Default: Popular
  ##
  #default_home: Popular

  ##
  ## Default number of results to display per page.
  ##
  ## Note: this affects invidious-generated pages only, such
  ## as watch history and subscription feeds. Playlists, search
  ## results and channel videos depend on the data returned by
  ## the Youtube API.
  ##
  ## Accepted values: any positive integer
  ## Default: 40
  ##
  #max_results: 40

  ##
  ## Show/hide annotations.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #annotations: false

  ##
  ## Show/hide annotation.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #annotations_subscribed: false

  ##
  ## Type of comments to display below video.
  ##
  ## Accepted values: a two-entries array.
  ## Each entry can be one of: "youtube", "reddit", ""
  ##
  ## Default: ["youtube", ""]
  ##
  #comments: ["youtube", ""]

  ##
  ## Default player style.
  ##
  ## Accepted values: invidious, youtube
  ## Default: invidious
  ##
  #player_style: invidious

  ##
  ## Show/Hide the "related videos" sidebar when
  ## watching a video.
  ##
  ## Accepted values: true, false
  ## Default: true
  ##
  #related_videos: true


  # -----------------------------
  #  Video player behavior
  # -----------------------------

  ##
  ## Automatically play videos on page load.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #autoplay: false

  ##
  ## Automatically load the "next" video (either next in
  ## playlist or proposed) when the current video ends.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #continue: false

  ##
  ## Autoplay next video by default.
  ##
  ## Note: Only effective if 'continue' is set to true.
  ##
  ## Accepted values: true, false
  ## Default: true
  ##
  #continue_autoplay: true

  ##
  ## Play videos in Audio-only mode by default.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #listen: false

  ##
  ## Loop videos automatically.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #video_loop: false


  # -----------------------------
  #  Video playback settings
  # -----------------------------

  ##
  ## Default video quality.
  ##
  ## Accepted values: dash, hd720, medium, small
  ## Default: hd720
  ##
  #quality: hd720

  ##
  ## Default dash video quality.
  ##
  ## Note: this setting only takes effet if the
  ## 'quality' parameter is set to "dash".
  ##
  ## Accepted values:
  ##    auto, best, 4320p, 2160p, 1440p, 1080p,
  ##    720p, 480p, 360p, 240p, 144p, worst
  ## Default: auto
  ##
  #quality_dash: auto

  ##
  ## Default video playback speed.
  ##
  ## Accepted values: 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0
  ## Default: 1.0
  ##
  #speed: 1.0

  ##
  ## Default volume.
  ##
  ## Accepted values: 0-100
  ## Default: 100
  ##
  #volume: 100

  ##
  ## Allow 360° videos to be played.
  ##
  ## Note: This feature requires a WebGL-enabled browser.
  ##
  ## Accepted values: true, false
  ## Default: true
  ##
  #vr_mode: true

  # -----------------------------
  #  Subscription feed
  # -----------------------------

  ##
  ## In the "Subscription" feed, only show the latest video
  ## of each channel the user is subscribed to.
  ##
  ## Note: when combined with 'unseen_only', the latest unseen
  ## video of each channel will be displayed instead of the
  ## latest by date.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #latest_only: false

  ##
  ## Enable/Disable user subscriptions desktop notifications.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #notifications_only: false

  ##
  ## In the "Subscription" feed, Only show the videos that the
  ## user haven't watched yet (i.e which are not in their watch
  ## history).
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #unseen_only: false

  ##
  ## Default sorting parameter for subscription feeds.
  ##
  ## Accepted values:
  ##   'alphabetically'
  ##   'alphabetically - reverse'
  ##   'channel name'
  ##   'channel name - reverse'
  ##   'published'
  ##   'published - reverse'
  ##
  ## Default: published
  ##
  #sort: published


  # -----------------------------
  #  Miscellaneous
  # -----------------------------

  ##
  ## Proxy videos through instance by default.
  ##
  ## Warning: As most users won't change this setting in their
  ## preferences, defaulting  to true will significantly
  ## increase the instance's network usage, so make sure that
  ## your server's connection can handle it.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #local: false

  ##
  ## Show the connected user's nick at the top right.
  ##
  ## Accepted values: true, false
  ## Default: true
  ##
  #show_nick: true

  ##
  ## Automatically redirect to a random instance when the user uses
  ## any "switch invidious instance" link (For videos, it's the plane
  ## icon, next to "watch on youtube" and "listen"). When set to false,
  ## the user is sent to https://redirect.invidious.io instead, where
  ## they can manually select an instance.
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #automatic_instance_redirect: false

  ##
  ## Show the entire video description by default (when set to 'false',
  ## only the first few lines of the description are shown and a
  ## "show more" button allows to expand it).
  ##
  ## Accepted values: true, false
  ## Default: false
  ##
  #extend_desc: false
