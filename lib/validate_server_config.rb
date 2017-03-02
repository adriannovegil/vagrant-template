require 'ipaddr'

#
# Function that validate the machine config
#
def validateServerConfig(config)
  # Validate the configuration of the machine.
  #if !config.has_key?("provider")
  #  config["provider"] = "virtualbox"
  #end

  # Validate the IP Address
  #if !config.has_key?("guest-ip")
  #  return false
  #else
  #  if !is_ip?(config["guest-ip"])
  #    return false
  #  end
  #end

  # All ok, return true
  return true
end


#
# Validate an IP address
#
def is_ip?(ip)
  !!IPAddr.new(ip) rescue false
end
