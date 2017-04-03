#!/bin/bash

# Updating repository

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt install -y python-minimal

eval "$(ssh-agent -s)"

cat /vagrant/html/id_rsa_vagrant.pub >> /home/ubuntu/.ssh/authorized_keys 
