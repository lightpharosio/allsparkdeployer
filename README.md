

# Allspark Integration[![Chat with us on Slack](https://img.shields.io/badge/chat%20with%20us%20on-Slack-blue.svg)](https://lightpharosio.slack.com)

Allspark is a Docker based developer toolbox fully automated in term of configuration and parameterization between the different developpment tool stacks.

<aside class="notice">
The current Readme provides information the information bellow:
  
** About AllSpark
** Contributing
  
Information concerning:

** Installation and Configuration
** Design
** Product scope are available on the GitHUb [Wiki](https://github.com/lightpharosio/allspark_iaas_integration/wiki).
</aside>


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


## Contributing

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

## Special Thanks
Allspark has been initiated and created inside the actinium organization. As the "core" dev team navigate to new horizon the project moved to a new organization. However we thanks them #Xide and #Guiadco for their contribution and passion. 

Allspark is now part of lightpharosio. Long live to allspark ! :)
