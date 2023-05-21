#!/bin/bash
sudo yum update -y 
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo dnf repolist enabled | grep "mysql.-community."
sudo dnf install mysql-community-server -y