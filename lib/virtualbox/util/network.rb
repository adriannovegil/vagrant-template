require 'json'

#
# Function that configure the network interfaces
#
def configureNetwork(machine_instance, server_config)
  # Iterate over the network configuration
  if server_config.has_key?("network")
    # Iterate
    server_config['network'].each do |interface|
      type = interface['network-type']
      # We only handle private and public networks
      next if type != "private" && type != "public"
      # Configure it
      if type == "public"
        configurePublicNetwork(machine_instance, interface)
      elsif type == "private"
        configurePrivateNetwork(machine_instance, interface)
      end
    end
  end
end

#
# Configure a public interface
#
def configurePublicNetwork(machine_instance, interface)
  # Disable autoconfig
  machine_instance.vm.network "public_network", auto_config: false
  # manual ip
  machine_instance.vm.provision "shell",
    run: "always",
    inline: "ifconfig " +
      interface['if-adapter'] + " " +
      interface['if-address'] +
      " netmask " + interface['if-netmask'] +
      " up"
end

#
# Configure a private interface
#
def configurePrivateNetwork(machine_instance, interface)
  # Determine the configuration method
  if interface["if-inet-type"] == "static"
    machine_instance.vm.network "private_network",
      ip: interface['if-address']
  else
    machine_instance.vm.network "private_network",
      type: "dhcp"
  end
end
