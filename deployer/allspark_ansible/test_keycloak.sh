docker kill haproxy
docker kill keycloak
docker kill keycloak_database
docker container prune -f 
docker volume rm allspark_keycloak_postgres_data
docker volume rm allspark_keycloak_logs
ansible-playbook -i hosts install.yml --connection=local
