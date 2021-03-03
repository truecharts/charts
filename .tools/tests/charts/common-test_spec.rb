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
          service: {
            port: {
              name: 'server'
            }
          }
        }
        chart.value values
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal values[:service][:port][:name]
        jq('.spec.ports[0].name', resource('Service')).must_equal values[:service][:port][:name]
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal default_port
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal values[:service][:port][:name]
      end

      it 'targetPort can be overridden' do
        values = {
          service: {
            port: {
              targetPort: 80
            }
          }
        }
        chart.value values
        jq('.spec.ports[0].port', resource('Service')).must_equal default_port
        jq('.spec.ports[0].targetPort', resource('Service')).must_equal values[:service][:port][:targetPort]
        jq('.spec.ports[0].name', resource('Service')).must_equal default_name
        jq('.spec.template.spec.containers[0].ports[0].containerPort', resource('Deployment')).must_equal values[:service][:port][:targetPort]
        jq('.spec.template.spec.containers[0].ports[0].name', resource('Deployment')).must_equal default_name
      end

      it 'targetPort cannot be a named port' do
        values = {
          service: {
            port: {
              targetPort: 'test'
            }
          }
        }
        chart.value values
        exception = assert_raises HelmCompileError do
          chart.execute_helm_template!
        end
        assert_match("Our charts do not support named ports for targetPort. (port name #{default_name}, targetPort #{values[:service][:port][:targetPort]})", exception.message)
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

  end
end
