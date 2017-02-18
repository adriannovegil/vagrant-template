# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative "lib/config_loader.rb"
require_relative "lib/config_virtualbox.rb"
require_relative "lib/validate_server_config.rb"
require 'vagrant/ui'

#require 'json'

UI = Vagrant::UI::Colored.new

VAGRANTFILE_API_VERSION = "2"

begin
  # Loading the config file
  begin
    UI.info '++> [INFO] Loading the machines config...'
    machines_config = loadConfig();
  rescue Exception => e
    UI.info '++> [ERROR] ' + e.message
    exit
  end
  #puts JSON.pretty_generate(machines_config)
end

# All Vagrant configuration is done here. The most common configuration options
# are documented and commented below. For a complete reference, please see the
# online documentation at vagrantup.com.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Vagrant.require_version ">= 1.8.4"
  # Provision all the machines defined in the config file.
  machines_config["servers"].each do |server_id, server_config|
    # Validate the server configuration
    if !validateServerConfig(server_config)
      UI.info '++> [ERROR] Error validating machine configuration: ' + server_id
      next
    end
    # If the server is not enabled, we skip it.
    if !server_config["enabled"]
      UI.info '++> [WARNING] The machine ' + server_id + ' is disable.'
      next
    end
    # Config the virtual machiche.
    config.vm.define server_id, autostart: server_config["autostart"] do |machine_instance|
      # Determine the provision mechanism
      case server_config["provider"]
      when "virtualbox"
        configVirtualBox(machine_instance, server_config)
      else
        UI.info '++> [ERROR] Unknown provider specified: ' + server["provider"]
      end
    end
  end
end
