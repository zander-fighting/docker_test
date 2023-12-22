# What is the purpose of this Docker image?
This docker-compose.yaml is to build a test environment for centos7 convenient.

# How to use this docker image?
Download the docker-compose.yaml file and run the command
```bash
docker compose up
exec -it centos7 /bin/bash
cd /opt
mkdir init
cd init
```
input the .sh file into the docker container
```bash
docker cp .\init.sh centos7:/opt/init/init.sh 
docker cp .\change_password.sh centos7:/opt/init/change_password.sh
docker cp .\user_add.sh centos7:/opt/init/user_add.sh
docker cp .\ssh_install.sh centos7:/opt/init/ssh_install.sh
docker cp .\gnome_install.sh centos7:/opt/init/gnome_install.sh
```
in the container. use command to get start the project to test
```bash
./init.sh
```
the `init.sh` add a new user `admin1` with the password `admin1` with `sudo` authority 