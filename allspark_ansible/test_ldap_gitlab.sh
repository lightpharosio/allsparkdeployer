docker stop gitlab
docker container rm gitlab
docker stop mattermost
docker container rm mattermost
rm -rf /var/lib/docker/volumes/allspark_gitlab*
rm -rf /opt/allspark/config/gitlab/
docker volume rm allspark_gitlab_config
docker volume rm allspark_gitlab_data
rm -rf /var/lib/docker/volumes/allspark_mattermost*
rm -rf /opt/allspark/config/mattermost/
docker volume rm allspark_mattermost_config
docker volume rm allspark_mattermost_data
ansible-playbook -i hosts install.yml --connection=local -v
