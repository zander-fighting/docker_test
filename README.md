# What is the purpose of this Docker image?
This docker-compose.yaml is to build a test environment for centos7_test convenient.

# How to use this docker image?
Download the docker-compose.yaml file and run the command
```bash
docker compose up
docker exec -it centos7_test /bin/bash
cd /opt
mkdir init
cd init
```
input the .sh file into the docker container
```bash
docker cp .\init.sh centos7_test:/opt/init/init.sh 
docker cp .\change_password.sh centos7_test:/opt/init/change_password.sh
docker cp .\user_add.sh centos7_test:/opt/init/user_add.sh
docker cp .\ssh_install.sh centos7_test:/opt/init/ssh_install.sh
docker cp .\gnome_install.sh centos7_test:/opt/init/gnome_install.sh
docker cp .\basic_packages_install.sh centos7_test:/opt/init/basic_packages_install.sh
docker cp .\test.sh centos7_test:/opt/init/test.sh
docker cp .\vnc_install.sh centos7_test:/opt/init/vnc_install.sh
docker cp .\vnc_user_add.sh centos7_test:/opt/init/vnc_user_add.sh
```
in the container. use command to get start the project to test
```bash
./init.sh
```
the `init.sh` add a new user `admin1` with the password `admin1` with `sudo` authority 