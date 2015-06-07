Puppet::Type.newtype(:docker_container) do
    desc "Puppet type that models a docker container"

    ensurable

    newproperty(:id) do
        desc "Container ID"
    end

    newparam(:name, :namevar => true) do
        desc "Container Name"
    end

    newproperty(:ip_address) do
        desc "Container IP address"
    end

    newproperty(:ip_gatewa, :readonly => true) do
        desc "Container IP gateway"
    end

    newproperty(:network_bridge) do
        desc "Container Network Bridge"
    end

    newproperty(:mac_address, :readonly => true) do
        desc "Container MAC address"
    end

    newproperty(:log_path, :readonly => true) do
        desc "Container log path"
    end

    newproperty(:hostname) do
        desc "Container hostname"
    end

    newproperty(:volumes) do
        desc "Container volumes"
        def insync?(is)
          is.sort == should.sort
        end
    end

    newproperty(:ports) do
        desc "Container ports"
        def insync?(is)
          is.sort == should.sort
        end
    end

    newproperty(:image) do
        desc "Container image"
    end
end
