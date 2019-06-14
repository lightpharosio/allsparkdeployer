

# Allspark Integration[![Chat with us on Slack](https://img.shields.io/badge/chat%20with%20us%20on-Slack-blue.svg)](https://lightpharosio.slack.com)

Allspark is a Docker based developer toolbox fully automated in term of configuration and parameterization between the different developpment tool stacks.

## About Allspark

Allspark is a devops pipeline including forge components (Gitlab, Jenkins...). Managing all these components could be a brain teaser. Allspark has the objectives to reduce forge integration, management complexity, improve hosting agnosticity and providing multi tenancy approach.  

Allspark targets 3 types of implementation accross 3 subproducts:
1. OneBox (**Available Under stabilization**) ==> For Small Businesses
2. ElasticSparks (**not initiated**) ==> The ideal choice for IaaS hosting services.
3. Kubsparks (**not initiated**) ==> An implementation compatible with Kubernete.

## Current Repository organization

1. docs ==> Designs, User guides... documentation concerning the project
2. onebox ==> Deploy all the allspark forge content inside one VM. SHould be merged with ElasticSpark in the near future.
3. (not available) elasticsparks ==> Deploy the forge components following HA/Redundancy  
3. (not available) kubsparks ==> Allspark Kubernete integration 

## How to deploy allspark forge?

Currently Onebox deployment is available. Information bellow concerns only onebox deployment mode.


### Requirements

On the allspark Onebox machine

1. Docker ( tested with version 18.06.0 )
2. Copy your ssh key to the remote server (with an empty passphrase)
3. Generate & Copy SSH Key

See the here

On the control machine

1. Ansible ( tested with version 2.5.5 )
2. Ansible playbook

If you are on to adapt the configuration see the configuration pages

Warning
For offline install, the images configuration must be the same on both end.

If you are on a migration see the operation pages

### Online install

Change the hosts file to point to the allspark machine.

~~~~
ansible-playbook -i hosts install.yml
~~~~

<aside class="warning">
>Warning
>Before using the playbook, you need to be sure to have your deployment user in the wheel groups

At this point, you will be able to see component show up along with their access URL at ingress.YOUR_ROOT_DOMAIN.
</aside>

### Offline install

0. On the online control machine

<aside class="notice">
Change the allspark_release_destination and allspark_release_tmp_directory to point to somwhere with at least 10Go of free space
</aside>

~~~~
ansible-playbook -i hosts release.yml
~~~~

it will generate a .tar.gz file at `allspark_release_destination`. This file needs to be copied along with the group_vars directory to the offline allspark machine.

1. On the offline allspark machine

* Import the `group_vars` directory and the release .tar.gz
* Set the allspark_release_destination in the `group_vars/all.yml` file to point to the release.
* Set the `allspark_release_tmp_directory` to point to somwhere with at least 10Go of free space

~~~~
ansible-playbook -i hosts setup.yml
ansible-playbook -i hosts install.yml
~~~~
<aside class="warning">
This playbook does not setup the system yet. The release is packaged along with CentOS RPM dependencies as well as pip wheels, but you will however have to install them yourself.
</aside>

### Hosts

1. Edit the file hosts to fit with your needs, like:
2. Define the ansible_user (In this example we use a account named allspark)

~~~~
[all]
localhost ansible_connection=ssh ansible_user=allspark
~~~~

### Group_vars

1. Edit the file group_vars/all.yml to fit with your needs, like:
2. The allspark_root_domain to use your domain name (each component will be exposed as a subdomain).
3. The allspark_docker_version to choose the docker version you want.
4. Enable or disable component using their enabled boolean toggle.

~~~~
allspark_monitoring:
  enabled: true
~~~~

### HTTPS

In order to provide HTTPS, you can either :

1. Enable self signed certificates by activating the allspark_haproxy.ssl.enabled and allspark_haproxy.ssl.selfsigned.enabled flags.
2. Import a certificate from your control machine : enable allspark_haproxy.ssl.enabled, set the allspark_haproxy.ssl.certificates_directory variable to a folder on the control machine containing PEM certificates named like their endpoint (e.g: infra.allspark.localhost.pem)

You can also do a mix of both, imported certificates will be picked over generated ones, allowing you to import certificates for some of the endpoints and let Allspark generate the missing ones.

<aside class="notice">
For wildcard and UCC certificates signing multiple domains, simply copy the file (or create a symbolic link pointing to it) to mirror the new endpoint e.g:
</aside>

~~~~
cp infra.allspark.localhost.pem chat.allspark.localhost
~~~~

###Downloads

<aside class="notice">
You can customize the image or tag for a component by overriding the component_image and component_tag, using either :
</aside>

* Ansible extra vars
* Add those variables to your group_vars/all.yml file.
e.g: gitlab

~~~~
   # Change gitlab-ce to gitlab-ee
   gitlab_image: gitlab_ee
   gitlab_tag: latest
~~~~

You can access the complete list of available components in the roles/downloads/defaults/main.yml file.


## Contributing

## Development

### Ansible Lint (Not Yet implemented)
You need to edit `.circleci/.config.yml` if you add a main core playbook for allspark

_e.g_:
```yaml
 - run: PATH=$PATH:/root/.local/bin ansible-lint mynewplaybook.yml -c .circleci/.ansible-lint
```

### OS Compatibility

To add an OS compatibility
  - you need to add a valid yml on folder ```roles/system/tasks```
  - you need to named it like : "{{ ansible_distribution }}-{{ ansible_distribution_major_version}}.yml"
  - for example:
    - Ubuntu-14.yml
    - CentOS-7.yml
  - you need to edit the Makefile, add you os like:
    ```
       test-<osmajorversion>:
       vagrant up <osmajorversion> --provision
    ```
  - you need to edit the Vagrantfile
    ```
    config.vm.define "<osmajorversion>", autostart: false do |<osmajorversion>|
      ubuntu14.vm.box = "actinium/<osmajorversion>"
      ubuntu14.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
      ubuntu14.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
      ubuntu14.vm.provision "ansible" do |ansible|
        ansible.verbose = "vvv"
        ansible.playbook = "install.yml"
      end
    end
    ```
  - you need to validate it via vagrant

>For the Red Hat Enterprise Linux, only the Actinium team could validate the playbook

>If you don't found a box to test your compatibility, you can contribute [Here](https://app.vagrantup.com/actinium/)

#### Docker images

##### Download

The docker images are downloaded in the `download` role.
If you need to add an image to allspark, add the corresponding entry
in the `roles/download/defaults/main.yml` file. You can then refer to
your image using `{{ downloads.component_name.image }}:{{ downloads.component_name.tag }}`.

By convention, the image `name` and `tag` are exposed in separated variables `${component_name}_image` and `${component_name}_tag`.

_e.g_:
```yaml
# Images
gitlab_image: gitlab/gitlab-ce

# Tags
gitlab_tag: latest

# Downloads
downloads:
  gitlab:
    enabled: "{{ allspark_gitlab.enabled }}"
    image: "{{ gitlab_image }}"
    tag: "{{ gitlab_tag }}"
```

This format is helful to centralize `downloads` for an easier access in roles, the exposed variables also allow the user to
easily override an image/tag with a `ansible-playbook -e "${component_name}_image=my-image"`

##### Expose

All the docker containers beside `haproxy` does not export any port on the host.
However, you can configure `haproxy` in the `roles/haproxy/defaults/main.yml` file.
This file allow you to configure ingress on the machine, with automatic ssl termination handled
by the reverse proxy (only if your backend is of type `http`)

_e.g_: Ingress of the `portainer` infra service.
```yaml

-
  # Runtime name of the container
  # (defined by the `docker_container` module `name` parameter)
  name: "portainer"
  # The host on which the service will be exposed
  host: "infra.{{ allspark_root_domain }}"

  # List of object with the following properties:
  # - mode: http|tcp
  # - port: the listening container port to expose
  # - exposed_port: The port exposed on the host machine (only for tcp mode)
  backends:
    # # Sample HTTP backend
    # - port: 8080
    #   mode: http
    # # Sample TCP backend
    # - port: 6578
    #   mode: tcp
    #   exposed_port: 6578

    - port: 9000
      mode: http

```

### Test modifications

We use `vagrant` to test the Allspark single node environment.
You can see the [install notes here](https://www.vagrantup.com/docs/installation/).
The box used is the `centos/7` one.
You can test modification using Vagrant like so :
```sh

# Run this once, vagrant will let you know if it needs updates
vagrant box add centos/7

# Create a virtual machine, run the install.yml playbook on it
# It needs to be online when running this command.
make test

# The make test command launch the default system (CentOS 7)

# If you want to test in another system, juste run this command:

make test-ubuntu14

# It's always the {{ ansible_distribution }}{{ ansible_distribution_major_version }}

# Stop & destroy the VM
make clean
```

### Documentation

#### Build
You can build the documetation using the `make doc` command. The resulting artifacts will be stored in the `doc` directory.
To view the resulting docs, you can use any http server, like :
```sh
# Python3
python3 -m http.server

# Python2
python2 -m SimpleHTTPServer
```

#### Hot reload
If you want to review your work while editing, you can use :
```sh
# Serve the documentation on http://localhost:8000
make doc-dev
```


## Special Thanks
Allspark has been initiated and created inside the actinium organization. As the "core" dev team navigate to new horizon the project moved to a new organization. However we thanks them #Xide and #Guiadco for their contribution and passion. 

Allspark is now part of lightpharosio. Long live to allspark ! :)