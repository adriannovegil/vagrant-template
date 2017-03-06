require 'json'
require 'resolv'

#
# Function that configure the network interfaces
#
def configureNetwork(machine_instance, server_config)
  # Iterate over the network configuration
  if server_config.has_key?("network")
    network_config = server_config["network"]
    #puts JSON.pretty_generate(network_config)
    # Configure interfaces
    if network_config.has_key?("interfaces")
      interfaces_config = network_config["interfaces"]
      # Iterate over the network interfaces
      interfaces_config.each do |interface|
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
    # Configure the gateway
    if network_config.has_key?("gateway")
      configureGateway(machine_instance, network_config["gateway"])
    end
  end
end

def configureGateway(machine_instance, gateway)
  # Determine the ip type
  #case gateway
  #when Resolv::IPv4::Regex
    # Default router ipv4
    machine_instance.vm.provision "shell",
      run: "always",
      inline: "route add default gw " + gateway
  #when Resolv::IPv6::Regex
    # Default router ipv6
    #machine_instance.vm.provision "shell",
    #  run: "always",
    #  inline: "route -A inet6 add default gw " + gateway
  #end
  # Delete default gw on eth0
  machine_instance.vm.provision "shell",
    run: "always",
    inline: "eval `route -n | awk '{ if ($8 ==\"eth0\" && $2 != \"0.0.0.0\") print \"route del default gw \" $2; }'`"
end

#
# Configure a public interface
#
def configurePublicNetwork(machine_instance, interface)
  # Disable autoconfig
  machine_instance.vm.network "public_network",
    auto_config: false
  # Manual ip
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
