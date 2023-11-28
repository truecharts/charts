{{/* Define the configmap */}}
{{- define "magicmirror2.configmaps" -}}
{{- $fullname := (include "tc.v1.common.lib.chart.names.fullname" $) -}}

{{- $magicmirror := .Values.magicmirror -}}

magicmirror2-config-env:
  enabled: true
  data:
    config.env: |
     ADDRESS={{ $magicmirror.address }}
     PORT=":{{ .Values.service.main.ports.main.port }}"
     HTTPS=false
     IPWHITELIST={{ $magicmirror.ipWhitelist }}
     LANG={{ $magicmirror.lang }}
     TIME_FORMAT={{ $magicmirror.time_format }}
     UNITS={{ $magicmirror.units }}

magicmirror2-config:
  enabled: true
  data:
    config.js.template: |
     /* Magic Mirror Config Sample
    *
    * By Michael Teeuw http://michaelteeuw.nl
    * MIT Licensed.
    *
    * For more information on how you can configure this file
    * See https://github.com/MichMich/MagicMirror#configuration
    *
    */

    var config = {
      /*************** DO NOT CHANGE FOLLOWING VALUES ***************/
      address: "${ADDRESS}",
      port: ${PORT},
      useHttps: ${HTTPS},
      serverOnly: "true",
      /*************** EDIT THE BELOW THIS LINE ONLY ***************/

      ipWhitelist: [${IPWHITELIST}],  // Set [] to allow all IP addresses
                        // or add a specific IPv4 of 192.168.1.5 :
                        // ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
                        // or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
                        // ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],

      language: "${LANG}",
      timeFormat: "{TIME_FORMAT}",
      units: "${UNITS}",

      modules: [
        {
          module: "alert",
        },
        {
          module: "updatenotification",
          position: "top_bar"
        },
        {
          module: "clock",
          position: "top_left"
        },
        {
          module: "calendar",
          header: "US Holidays",
          position: "top_left",
          config: {
            calendars: [
              {
                symbol: "calendar-check",
                url: "webcal://www.calendarlabs.com/ical-calendar/ics/76/US_Holidays.ics"
              }
            ]
          }
        },
        {
          module: "compliments",
          position: "lower_third"
        },
        {
          module: "currentweather",
          position: "top_right",
          config: {
            location: "New York",
            locationID: "", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
            appid: "YOUR_OPENWEATHER_API_KEY"
          }
        },
        {
          module: "weatherforecast",
          position: "top_right",
          header: "Weather Forecast",
          config: {
            location: "New York",
            locationID: "5128581", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
            appid: "YOUR_OPENWEATHER_API_KEY"
          }
        },
        {
          module: "newsfeed",
          position: "bottom_bar",
          config: {
            feeds: [
              {
                title: "New York Times",
                url: "http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml"
              }
            ],
            showSourceTitle: true,
            showPublishDate: true,
            broadcastNewsFeeds: true,
            broadcastNewsUpdates: true
          }
        },
      ]
    };

    /*************** DO NOT EDIT THE LINE BELOW ***************/
    if (typeof module !== "undefined") {module.exports = config;}

{{- end -}}
