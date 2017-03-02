#
# Function to configure network in the instance
#
def configureNetwork(machine_instance, server_config)

  # Network configuration
  machine_instance.vm.network "private_network", ip: server_config['guest-ip']

end
