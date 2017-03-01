
#
# Function that provision the servers using Virtualbox
#
def configVirtualBox(machine_instance, server_config)

  # Provide the Virtual Maniche
  # More Info See: http://docs.vagrantup.com/v2/vagrantfile/machine_settings.html
  machine_instance.vm.provider :virtualbox do |vb|
    vb.name = server_config['guest-hostname']
    vb.cpus = server_config['cpus'] || 2
    vb.memory = server_config['memory'] || 2048

    # ssh settings
    #config.ssh.insert_key = false
    #config.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
    #config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
    #config.vm.provision "shell", inline: <<-EOC
#sudo sed -i -e "\\#PasswordAuthentication yes# s#PasswordAuthentication yes#PasswordAuthentication no#g" /etc/ssh/sshd_config
#sudo service ssh restart
#EOC

    # Configure the instance group
    if server_config["group"]
      vb.customize ["modifyvm", :id, "--groups", "/" + server_config["group"]]
    end

    # http://stackoverflow.com/questions/19490652/how-to-sync-time-on-host-wake-up-within-virtualbox
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
    vb.gui = false
  end

  # Configure the hostname
  machine_instance.vm.hostname = server_config['guest-hostname']

  # Network configuration
  machine_instance.vm.network "private_network", ip: server_config['guest-ip']

  # custom hostname aliases
  if server_config['aliases']
    machine_instance.hostmanager.aliases = server_config['aliases'].join(' ').to_s
  end

  # Set box type based on configuration. Defaults to `precise64` (Ubuntu).
  # The URL that you see below is from Vagrant's own list of available boxes:
  # http://www.vagrantbox.es/
  if !server_config["box"]
    machine_instance.vm.box = "precise64"
    machine_instance.vm.box_url = "http://files.vagrantup.com/precise64.box"
  else
    machine_instance.vm.box = server_config["box"]
    machine_instance.vm.box_url = server_config["box-url"]
  end

  # Provisioning the server
  if server_config.has_key?("scripts")
    # [Workaround]
    # default: stdin: is not a tty
    # If you're using Vagrant with Ubuntu and getting this annoying (but not
    # impactful) error during provisioning, Just paste this into your Vagrantfile
    # as the first provisioner:
    machine_instance.vm.provision "fix-no-tty", type: "shell" do |s|
      s.privileged = false
      s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end
    # Execute the provisioning servers
    server_config["scripts"].each do |script, key|
      #serverScript = "./provisioning/" + script + " 2&>1 >> /vagrant/provision.log"
      serverScript = "./provisioning/" + script
      machine_instance.vm.provision "shell", path: serverScript
    end
  end

end
