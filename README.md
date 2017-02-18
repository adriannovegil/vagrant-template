# Vagrant Template

This file contains instructions on how to setup and manage a collection of [Vagrant instances](http://vagrantup.com).

## Creating Your First Server

First, create the config file. You can copy the template file.

```
$ cp config.json.template config.json
```

Configure your instances. You can define a collection virtual machines.

Following you can see a example of the configuration of a instance.

```
"base-01": {
    "enabled": true,
    "guest-ip": "10.0.3.40",
    "guest-hostname": "base01.vm.server",
    "box": "ubuntu/trusty64",
    "box-url": "http://files.vagrantup.com/precise64.box",
    "timezone": "Europe/Madrid",
    "cpus": 1,
    "memory": 2048,
    "scripts": [
        "bootstrap.sh",
        "ssh.sh"
    ]
},
```

| Configuration         |  Value(s)                                                         |
| --------------------- | ----------------------------------------------------------------- |
| enabled               | True if we want to provision the machine, false otherwise.        |
| guest-ip              | IP of the server                                                  |
| guest-hostname        | Hostname of the server                                            |
| box                   | Vagrant Box                                                       |
| box-url               | URL to download the box                                           |
| timezone              | Server timezone                                                   |
| cpus                  | Number of CPUs                                                    |
| memory                | Instance memory                                                   |
| scripts               | List of script that we want to execute in the provisioning stage. |

Finally, run the following command:

```
$ vagrant up
```

This will create the machines based off the configuration settings in `config.json`.

## Connecting via SSH

```
$ vagrant ssh [instance-id]
```

## Suspending the Server

```
$ vagrant suspend [instance-id]
```

## Halting the Server

```
$ vagrant halt [instance-id]
```

## Destroying the Server

```
$ vagrant destroy [instance-id]
