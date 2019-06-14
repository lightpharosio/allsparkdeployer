

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


###Requirements

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


## How to contribute?


## Special Thanks
Allspark has been initiated and created inside the actinium organization. As the "core" dev team navigate to new horizon the project moved to a new organization. However we thanks them #Xide and #Guiadco for their contribution and passion. 

Allspark is now part of lightpharosio. Long live to allspark ! :)