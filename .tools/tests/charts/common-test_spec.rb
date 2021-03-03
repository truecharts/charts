# frozen_string_literal: true
require_relative '../test_helper'

class Test < ChartTest
  @@chart = Chart.new('library/common-test')

  describe @@chart.name do
    describe 'controller type' do
      it 'defaults to "Deployment"' do
        assert_nil(resource('StatefulSet'))
        assert_nil(resource('DaemonSet'))
        refute_nil(resource('Deployment'))
      end

      it 'accepts "statefulset"' do
        chart.value controllerType: 'statefulset'
        assert_nil(resource('Deployment'))
        assert_nil(resource('DaemonSet'))
        refute_nil(resource('StatefulSet'))
      end

      it 'accepts "daemonset"' do
        chart.value controllerType: 'daemonset'
        assert_nil(resource('Deployment'))
        assert_nil(resource('StatefulSet'))
        refute_nil(resource('DaemonSet'))
      end
    end

    describe 'pod replicas' do
      it 'defaults to 1' do
        jq('.spec.replicas', resource('Deployment')).must_equal 1
      end

      it 'accepts integer as value' do
        chart.value replicas: 3
        jq('.spec.replicas', resource('Deployment')).must_equal 3
      end
    end

    describe 'Environment settings' do
      it 'Check no environment variables' do
        values = {}
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal 'PUID'
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[1].name', resource('Deployment')).must_equal 'PGID'
        jq('.spec.template.spec.containers[0].env[1].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[2].name', resource('Deployment')).must_equal 'UMASK'
        jq('.spec.template.spec.containers[0].env[2].value', resource('Deployment')).must_equal "002"
      end

      it 'set "static" environment variables' do
        values = {
          env: {
            STATIC_ENV: 'value_of_env'
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal 'PUID'
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[1].name', resource('Deployment')).must_equal 'PGID'
        jq('.spec.template.spec.containers[0].env[1].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[2].name', resource('Deployment')).must_equal 'UMASK'
        jq('.spec.template.spec.containers[0].env[2].value', resource('Deployment')).must_equal "002"
        jq('.spec.template.spec.containers[0].env[3].name', resource('Deployment')).must_equal values[:env].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[3].value', resource('Deployment')).must_equal values[:env].values[0].to_s
      end

      it 'set "valueFrom" environment variables' do
        values = {
          envValueFrom: {
            NODE_NAME: {
              fieldRef: {
                fieldPath: "spec.nodeName"
              }
            }
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal 'PUID'
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[1].name', resource('Deployment')).must_equal 'PGID'
        jq('.spec.template.spec.containers[0].env[1].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[2].name', resource('Deployment')).must_equal 'UMASK'
        jq('.spec.template.spec.containers[0].env[2].value', resource('Deployment')).must_equal "002"
        jq('.spec.template.spec.containers[0].env[3].name', resource('Deployment')).must_equal values[:envValueFrom].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[3].valueFrom | keys[0]', resource('Deployment')).must_equal values[:envValueFrom].values[0].keys[0].to_s
      end

      it 'set "static" and "Dynamic/Tpl" environment variables' do
        values = {
          env: {
            STATIC_ENV: 'value_of_env'
          },
          envTpl: {
            DYN_ENV: "{{ .Release.Name }}-admin"
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal 'PUID'
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[1].name', resource('Deployment')).must_equal 'PGID'
        jq('.spec.template.spec.containers[0].env[1].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[2].name', resource('Deployment')).must_equal 'UMASK'
        jq('.spec.template.spec.containers[0].env[2].value', resource('Deployment')).must_equal "002"
        jq('.spec.template.spec.containers[0].env[3].name', resource('Deployment')).must_equal values[:env].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[3].value', resource('Deployment')).must_equal values[:env].values[0].to_s
        jq('.spec.template.spec.containers[0].env[4].name', resource('Deployment')).must_equal values[:envTpl].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[4].value', resource('Deployment')).must_equal 'common-test-admin'
      end

      it 'set "Dynamic/Tpl" environment variables' do
        values = {
          envTpl: {
            DYN_ENV: "{{ .Release.Name }}-admin"
          }
        }
        chart.value values
        jq('.spec.template.spec.containers[0].env[0].name', resource('Deployment')).must_equal 'PUID'
        jq('.spec.template.spec.containers[0].env[0].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[1].name', resource('Deployment')).must_equal 'PGID'
        jq('.spec.template.spec.containers[0].env[1].value', resource('Deployment')).must_equal "568"
        jq('.spec.template.spec.containers[0].env[2].name', resource('Deployment')).must_equal 'UMASK'
        jq('.spec.template.spec.containers[0].env[2].value', resource('Deployment')).must_equal "002"
        jq('.spec.template.spec.containers[0].env[3].name', resource('Deployment')).must_equal values[:envTpl].keys[0].to_s
        jq('.spec.template.spec.containers[0].env[3].value', resource('Deployment')).must_equal 'common-test-admin'
      end
    end

    describe 'ports settings' do
      default_name = 'http'
      default_port = 8080

      it 'defaults to name "http" on port 8080' do
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal default_name
        jq('.spec.ports[0].name', resource('Service')).must_equal default_name
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal default_port
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal default_name
      end

      it 'port name can be overridden' do
        values = {
          services: {
		    main: {
              port: {
                name: 'server'
              }
			}
          }
        }
        chart.value values
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal values[:services][:main][:port][:name]
        jq('.spec.ports[0].name', resource('Service')).must_equal values[:services][:main][:port][:name]
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal default_port
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal values[:services][:main][:port][:name]
      end

      it 'targetPort can be overridden' do
        values = {
          services: {
		    main: {
              port: {
                targetPort: 80
              }
			}
          }
        }
        chart.value values
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal values[:services][:main][:port][:targetPort]
        jq('.spec.ports[0].name', resource('Service')).must_equal default_name
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal values[:services][:main][:port][:targetPort]
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal default_name
      end

      it 'targetPort cannot be a named port' do
        values = {
          services: {
		    main: {
              port: {
                targetPort: 'test'
              }
			}
          }
        }
        chart.value values
        exception = assert_raises HelmCompileError do
          chart.execute_helm_template!
        end
        assert_match("Our charts do not support named ports for targetPort. (port name #{default_name}, targetPort #{values[:services][:main][:port][:targetPort]})", exception.message)
      end
    end

    describe 'statefulset volumeClaimTemplates' do

      it 'volumeClaimTemplates should be empty by default' do
        chart.value controllerType: 'statefulset'
        assert_nil(resource('StatefulSet')['spec']['volumeClaimTemplates'])
      end

      it 'can set values for volumeClaimTemplates' do
        values = {
          controllerType: 'statefulset',
          volumeClaimTemplates: [
            {
              name: 'storage',
              accessMode: 'ReadWriteOnce',
              size: '10Gi',
              storageClass: 'storage'
            }
          ]
        }

        chart.value values
        jq('.spec.volumeClaimTemplates[0].metadata.name', resource('StatefulSet')).must_equal values[:volumeClaimTemplates][0][:name]
        jq('.spec.volumeClaimTemplates[0].spec.accessModes[0]', resource('StatefulSet')).must_equal values[:volumeClaimTemplates][0][:accessMode]
        jq('.spec.volumeClaimTemplates[0].spec.resources.requests.storage', resource('StatefulSet')).must_equal values[:volumeClaimTemplates][0][:size]
        jq('.spec.volumeClaimTemplates[0].spec.storageClassName', resource('StatefulSet')).must_equal values[:volumeClaimTemplates][0][:storageClass]
      end
    end

	describe 'appVolumeMounts' do
      default_name_1 = 'test1'
	  default_name_2 = 'test2'
      default_mountPath_1 = '/test1'
	  default_mountPath_2 = '/test2'
	  empty_dir = {}
	  path = '/tmp'

      it 'appVolumeMounts creates VolumeMounts' do
        jq('.spec.template.spec.containers[0].volumeMounts[0].name', resource('Deployment')).must_equal default_name_1
		jq('.spec.template.spec.containers[0].volumeMounts[1].name', resource('Deployment')).must_equal default_name_2
		jq('.spec.template.spec.containers[0].volumeMounts[0].mountPath', resource('Deployment')).must_equal default_mountPath_1
		jq('.spec.template.spec.containers[0].volumeMounts[1].mountPath', resource('Deployment')).must_equal default_mountPath_2
      end

      it 'appVolumeMounts creates Volumes' do
		jq('.spec.template.spec.volumes[0].emptyDir', resource('Deployment')).must_equal empty_dir
		jq('.spec.template.spec.volumes[1].hostPath.path', resource('Deployment')).must_equal path
      end
    end

	describe 'additionalAppVolumeMounts' do
      default_name_3 = 'test3'
	  default_name_4 = 'test4'
      default_mountPath_3 = '/test3'
	  default_mountPath_4 = '/test4'
	  empty_dir = {}
	  path = '/tmp'

      it 'additionalAppVolumeMounts creates VolumeMounts' do
        jq('.spec.template.spec.containers[0].volumeMounts[2].name', resource('Deployment')).must_equal default_name_3
		jq('.spec.template.spec.containers[0].volumeMounts[3].name', resource('Deployment')).must_equal default_name_4
		jq('.spec.template.spec.containers[0].volumeMounts[2].mountPath', resource('Deployment')).must_equal default_mountPath_3
		jq('.spec.template.spec.containers[0].volumeMounts[3].mountPath', resource('Deployment')).must_equal default_mountPath_4
      end

      it 'additionalAppVolumeMounts creates Volumes' do
		jq('.spec.template.spec.volumes[2].emptyDir', resource('Deployment')).must_equal empty_dir
		jq('.spec.template.spec.volumes[3].hostPath.path', resource('Deployment')).must_equal path
      end
    end

    describe 'ingress' do
      it 'should be disabled when (additional)ingress enabled = false' do
        values = {
          ingress: {
            test1: {
              enabled: false
            },
            test2: {
              enabled: false
            }
          },
          additionalIngress: [
            {
            enabled: false,
            name: "test3"
            },
            {
              enabled: false,
              name: "test4"
            }
          ]
        }
        chart.value values
        assert_nil(resource('Ingress'))
      end

      it 'should be enabled when (additional)ingress enabled = true' do
        values = {
          ingress: {
            test1: {
              enabled: true
            },
            test2: {
              enabled: true
            }
          },
          additionalIngress: [
            {
            enabled: true,
            name: "test3"
            },
            {
              enabled: true,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('Ingress'))
      end

      it 'should be not create ingressroute unless type tcp/udp' do
        values = {
          ingress: {
            test1: {
              enabled: true
            },
            test2: {
              enabled: true
            }
          },
          additionalIngress: [
            {
            enabled: true,
            name: "test3"
            },
            {
              enabled: true,
              name: "test4"
            }
          ]
        }
        chart.value values
        assert_nil(resource('IngressRouteTCP'))
        assert_nil(resource('IngressRouteUDP'))
      end

      it 'should be enabled when half (additional)ingress enabled = true' do
        values = {
          ingress: {
            test1: {
              enabled: false
            },
            test2: {
              enabled: true
            }
          },
          additionalIngress: [
            {
            enabled: false,
            name: "test3"
            },
            {
              enabled: true,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('Ingress'))
      end

      it 'ingress with hosts' do
        values = {
          ingress: {
            test1: {
              hosts: [
                {
                  host: 'hostname',
                  paths: [
                    {
                      path: '/'
                    }
                  ]
                }
              ]
            }
          }
        }

        chart.value values
        jq('.spec.rules[0].host', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:host]
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:paths][0][:path]
      end

      it 'ingress with hosts template is evaluated' do
        expectedHostName = 'common-test.hostname'
        values = {
          ingress: {
            test1: {
              hosts: [
                {
                  hostTpl: '{{ .Release.Name }}.hostname',
                  paths: [
                    {
                      path: '/'
                    }
                  ]
                }
              ]
            }
          }
        }

        chart.value values
        jq('.spec.rules[0].host', resource('Ingress')).must_equal expectedHostName
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:paths][0][:path]
      end

      it 'ingress with hosts and tls' do
        values = {
          ingress: {
            test1: {
              enabled: true,
              hosts: [
                {
                  host: 'hostname',
                  paths: [
                    {
                      path: '/'
                    }
                  ]
                }
              ],
              tls: [
                {
                  hosts: [ 'hostname' ],
                  secretName: 'hostname-secret-name'
                }
              ]
            }
          }
        }

        chart.value values
        jq('.spec.rules[0].host', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:host]
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:paths][0][:path]
        jq('.spec.tls[0].hosts[0]', resource('Ingress')).must_equal values[:ingress][:test1][:tls][0][:hosts][0]
        jq('.spec.tls[0].secretName', resource('Ingress')).must_equal values[:ingress][:test1][:tls][0][:secretName]
      end

      it 'ingress with tls template is evaluated' do
        expectedHostName = 'common-test.hostname'
        expectedSecretName = 'common-test-hostname-secret-name'
        values = {
          ingress: {
            test1: {
              enabled: true,
              tls: [
                {
                  hostsTpl: [ '{{ .Release.Name }}.hostname' ],
                  secretNameTpl: '{{ .Release.Name }}-hostname-secret-name'
                }
              ]
            }
          }
        }

        chart.value values
        jq('.spec.tls[0].hosts[0]', resource('Ingress')).must_equal expectedHostName
        jq('.spec.tls[0].secretName', resource('Ingress')).must_equal expectedSecretName
      end

      it 'ingress with hosts and tls template is evaluated' do
        expectedHostName = 'common-test.hostname'
        expectedSecretName = 'common-test-hostname-secret-name'
        values = {
          ingress: {
            test1: {
              enabled: true,
              hosts: [
                {
                  hostTpl: '{{ .Release.Name }}.hostname',
                  paths: [
                    {
                      path: '/'
                    }
                  ]
                }
              ],
              tls: [
                {
                  hostsTpl: [ '{{ .Release.Name }}.hostname' ],
                  secretNameTpl: '{{ .Release.Name }}-hostname-secret-name'
                }
              ]
            }
          }
        }

        chart.value values
        jq('.spec.rules[0].host', resource('Ingress')).must_equal expectedHostName
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:paths][0][:path]
        jq('.spec.tls[0].hosts[0]', resource('Ingress')).must_equal expectedHostName
        jq('.spec.tls[0].secretName', resource('Ingress')).must_equal expectedSecretName
      end

      it 'ingress with selfsigned certtype is evaluated' do
        expectedHostName = 'common-test.hostname'
        expectedSecretName = 'common-test-hostname-secret-name'
        values = {
          ingress: {
            test1: {
              enabled: true,
              hosts: [
                {
                  host: 'hostname',
                  paths: [
                    {
                      path: '/'
                    }
                  ]
                }
              ],
              certType: "selfsigned"
            }
          }
        }

        chart.value values
        jq('.spec.rules[0].host', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:host]
        jq('.spec.rules[0].http.paths[0].path', resource('Ingress')).must_equal values[:ingress][:test1][:hosts][0][:paths][0][:path]
        jq('.spec.tls[0].hosts[0]', resource('Ingress')).must_equal  values[:ingress][:test1][:hosts][0][:host]
        jq('.spec.tls[0].secretName', resource('Ingress')).must_equal nil
      end

      it 'should create when type = HTTP' do
        values = {
          ingress: {
            test1: {
              enabled: true,
              type: "HTTP"
            },
            test2: {
              enabled: false
            }
          },
          additionalIngress: [
            {
            enabled: false,
            name: "test3"
            },
            {
              enabled: false,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('Ingress'))
      end

      it 'check no middleware without traefik' do
        values = {
          ingress: {
            test1: {
              enabled: true
            }
          }
        }
        chart.value values
        assert_nil(resource('Middleware'))
      end

      it 'check authForward when authForwardURL is set' do
        expectedName = 'common-test-test1'
        values = {
          ingress: {
            test1: {
              enabled: true,
              authForwardURL: "test.test.com"
            }
          }
        }
        chart.value values
        refute_nil(resource('Middleware'))
        jq('.spec.forwardAuth.address', resource('Middleware')).must_equal  values[:ingress][:test1][:authForwardURL]
        jq('.metadata.name', resource('Middleware')).must_equal  expectedName
        jq('.metadata.name', resource('Ingress')).must_equal  expectedName
      end

    end

    describe 'ingressRoutes' do
      it 'should create only TCP when type = TCP' do
        values = {
          ingress: {
            test1: {
              enabled: true,
              type: "TCP"
            },
            test2: {
              enabled: false
            }
          },
          additionalIngress: [
            {
            enabled: false,
            name: "test3"
            },
            {
              enabled: false,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('IngressRouteTCP'))
        assert_nil(resource('IngressRouteUDP'))
      end

      it 'should create only UDP when type = UDP' do
        values = {
          ingress: {
            test1: {
              enabled: true,
              type: "UDP"
            },
            test2: {
              enabled: false
            }
          },
          additionalIngress: [
            {
            enabled: false,
            name: "test3"
            },
            {
              enabled: false,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('IngressRouteUDP'))
        assert_nil(resource('IngressRouteTCP'))
      end

      it 'should create only additional TCP when type = TCP' do
        values = {
          ingress: {
            test1: {
              enabled: false
            },
            test2: {
              enabled: false
            }
          },
          additionalIngress: [
            {
            enabled: true,
            name: "test3",
            type: "TCP"
            },
            {
              enabled: false,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('IngressRouteTCP'))
        assert_nil(resource('IngressRouteUDP'))
      end

      it 'should create only additional UDP when type = UDP' do
        values = {
          ingress: {
            test1: {
              enabled: false
            },
            test2: {
              enabled: false
            }
          },
          additionalIngress: {
            test3: {
              enabled: true,
              type: "UDP"
            },
            test4: {
              enabled: false
            }
          }
        }
        chart.value values
        refute_nil(resource('IngressRouteUDP'))
        assert_nil(resource('IngressRouteTCP'))
      end

      it 'should be able to create 3 ingress types' do
        values = {
          ingress: {
            test1: {
              enabled: true,
              type: "UDP"
            },
            test2: {
              enabled: true,
              type: "TCP"
            },
            test2b: {
              enabled: true,
              type: "HTTP"
            }
          },
          additionalIngress: [
            {
            enabled: false,
            name: "test3"
            },
            {
              enabled: false,
              name: "test4"
            }
          ]
        }
        chart.value values
        refute_nil(resource('IngressRouteUDP'))
        refute_nil(resource('IngressRouteTCP'))
        refute_nil(resource('Ingress'))
      end

      it 'should be able to create 3 additional ingress types' do
        values = {
          ingress: {
            test1: {
              enabled: false,
              type: "UDP"
            },
            test2: {
              enabled: false,
              type: "TCP"
            },
            test2b: {
              enabled: false,
              type: "HTTP"
            }
          },
          additionalIngress: [
            {
            enabled: true,
            type: "HTTP",
            name: "test3"
            },
            {
              enabled: true,
              type: "TCP",
              name: "test4"
            },
            {
              enabled: true,
              type: "UDP",
              name: "test5"
            }
          ]
        }
        chart.value values
        refute_nil(resource('IngressRouteUDP'))
        refute_nil(resource('IngressRouteTCP'))
        refute_nil(resource('Ingress'))
      end

      it 'ingressroute with selfsigned certtype is evaluated' do
        values = {
          ingress: {
            test1: {
              type: "TCP",
              enabled: true,
              hosts: [
                {
                  host: 'hostname'
                }
              ],
              certType: "selfsigned"
            }
          }
        }

        chart.value values
        jq('.spec.tls.domains[0].main', resource('IngressRouteTCP')).must_equal  values[:ingress][:test1][:hosts][0][:host]
        jq('.spec.tls.secretName', resource('IngressRouteTCP')).must_equal nil
      end

      it 'ingressrouteUDP + HTTP +TCP with selfsigned cert is evaluated ' do
        values = {
          ingress: {
            test1: {
              type: "TCP",
              enabled: true,
              hosts: [
                {
                  host: 'hostname'
                }
              ],
              certType: "selfsigned"
            },
            test2: {
              enabled: true,
              type: "UDP"
            },
            test2b: {
              enabled: true,
              type: "HTTP"
            }
          }
        }

        chart.value values
        jq('.spec.tls.domains[0].main', resource('IngressRouteTCP')).must_equal  values[:ingress][:test1][:hosts][0][:host]
        jq('.spec.tls.secretName', resource('IngressRouteTCP')).must_equal nil
        refute_nil(resource('IngressRouteUDP'))
        refute_nil(resource('IngressRouteTCP'))
        refute_nil(resource('Ingress'))
      end

    end

  end
end
