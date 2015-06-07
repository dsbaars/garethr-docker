require 'ostruct'

Puppet::Type.type(:docker_container).provide(:ruby) do
    commands :docker => 'docker'

    mk_resource_methods

    def initialize(value={})
        super(value)
        @property_flush = {}
    end

    def self.get_list_of_containers
        containers = docker(['ps', '-q']).chomp().split(/\n/)
    end

    def self.get_container_properties(container_id)
        container_properties = {}
        properties = JSON.parse(docker(['inspect', "#{container_id}"]))

        container_properties[:provider] = :ruby
        container_properties[:ensure] = :present
        container_properties[:name] =  properties[0]['Name'][1..-1]
        container_properties[:hostname] =  properties[0]['Name']
        container_properties[:id] =  properties[0]['Id']
        container_properties[:short_id] = container_id
        container_properties[:ip_address] = properties[0]['NetworkSettings']['IPAddress']
        container_properties[:gateway] = properties[0]['NetworkSettings']['Gateway']
        container_properties[:mac_address] = properties[0]['NetworkSettings']['MacAddress']
        container_properties[:network_bridge] = properties[0]['NetworkSettings']['Bridge']
        container_properties[:log_path] = properties[0]['LogPath']
        container_properties[:image] = properties[0]['Image']
        container_properties[:volumes] = properties[0]['Volumes']
        container_properties[:ports] = properties[0]['NetworkSettings']['Ports']

        Puppet.debug "Container properties: #{container_properties.inspect}"

        container_properties
    end

    def self.get_container_ip(container_id)
        docker("inspect -f \"{{ .NetworkSettings.IPAddress }}\" #{container_id}")
    end

    def self.prefetch(resources)
      instances.each do |prov|
        if resource = resources[prov.name]
          resource.provider = prov
        end
      end
    end

    def self.instances
        get_list_of_containers.collect do |container_id|
            container_properties = get_container_properties(container_id)
            new(container_properties)
        end
    end

    def flush
        @property_has = self.class.get_container_properties(resource[:name])
    end

    def create
      #docker(['start', resource[:name]])
      @property_flush[:ensure] = :present
    end

    def destroy
      #docker(['stop', resource[:name]])
      @property_flush[:ensure] = :absent
    end

    def exists?
        @property_hash[:ensure] == :present
    end
end
