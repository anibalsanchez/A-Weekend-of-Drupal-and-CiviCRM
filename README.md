# A Weekend of Drupal and CiviCRM

## Prerequisites

- AWS command line tools
- Terraform
- Ansible

## Infrastructure: Stage - Vagrant 

    vagrant up --provider=virtualbox

Testing connections:

    vagrant ssh
    ...
    ssh ubuntu@local-server.extly -p 2222

## Infrastructure: Production - Terraform - Amazon AWS

- 1 server (DrupalCiviCRM) - instance_type t2.micro
- AMI: ami-38f5d15d - xenial - 16.04 LTS - amd64 - hvm:ebs-ssd 
- Availability zone: us-east-2
- Volume size: 8 GB
- DNS: drupalcivicrm.extly.com
- Security Group Rule: Port 80/ 443 public, port 22 from the office.

### Generating a new SSH key

    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add id_rsa_drupalcivicrm
    puttygen id_rsa_drupalcivicrm -o drupalcivicrm.ppk

### Building server

    terraform plan
    terraform apply

#### Initial configuration

    ssh ubuntu@drupalcivicrm.extly.com

    apt-get -y update
    apt-get -y upgrade
    apt install -y python-minimal

#### New superuser

    adduser --disabled-password --gecos "" unsuperusuario
    mkdir /home/unsuperusuario/.ssh
    cp /home/ubuntu/.ssh/authorized_keys /home/unsuperusuario/.ssh/authorized_keys       
    chown -R unsuperusuario:unsuperusuario /home/unsuperusuario/.ssh
    chmod -R 700 /home/unsuperusuario/.ssh
    chmod -R 600 /home/unsuperusuario/.ssh/authorized_keys
    visudo .... unsuperusuario ALL=(ALL) NOPASSWD:ALL
    ...
    ssh unsuperusuario@drupalcivicrm.extly.com
    passwd -l ubuntu
    rm /home/ubuntu/.ssh/authorized_keys

## Ansible

Definitions:

- ansible.cfg: remote_user, nocows pls, local roles, no retry files
- Organization: general *sites*, divided in *dbservers* and *webservers* (though we've 1 server now).
- Environments: Local *stage* and remote *production*

### Configuration Management

Connection tests: 

- Stage: ansible sites -i stage -m ping
- Production: ansible sites -i production -m ping

### Playbooks

#### General configuration

    ansible-playbook -i production sites.yml
    ansible-playbook -i production dbservers.yml
    ansible-playbook -i production webservers.yml

#### Webserver configuration    

    ansible-playbook -i production webservers-setup-nginx.yml
    ansible-playbook -i production webservers-setup-php.yml
    ansible-playbook -i production webservers-setup-php2.yml (TODO: merge it in a single playbook)
    ansible-playbook -i production webservers-setup-user.yml
    ansible-playbook -i production webservers-setup-web.yml
    ansible-playbook -i production webservers-setup-ssl.yml

#### Drupal - CiviCRM configuration    

    ansible-playbook -i production drupal.yml (TODO: Or.. drush site-install ...)
    ansible-playbook -i production drupal-custom.yml
    ansible-playbook -i production drupal-cronjob.yml
    ansible-playbook -i production civiccrm-pre.yml (TODO: Re-Check in detail)
    ansible-playbook -i production civiccrm.yml

    http://drupalcivicrm.extly.com/sites/all/modules/civicrm/install/index.php

#### TODO

- A better backup... with [Akeeba](https://www.akeebabackup.com/)
