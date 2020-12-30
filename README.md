# Vagrant and ansible to setup PostgreSQL 12 Master Slave replication on Ubuntu 20.04

This repo will create PostgreSQL single Master and Two Slave Cluster setup using Vagrant to create VM on virtualbox. Ansible will perform the initial installation and also the configuration of Master-Slave replication configuration. If the PostgreSQL Master goes down then change the ansible hosts file i.e, move any server from db_slave group to db_master group and re-run the ansible command to promote slave as master. 

Similarly new slave can be added later on by adding server to db_slave group in hosts file and run ansible playbook to perform the installation and configuration of slave server.

## Prerequisites
Below software must be installed on the machine to run this automation
1. Oracle VirtualBox
2. Vagrant
3. Ansible
4. Git

[OPTIONAL] You can also download the Ubuntu 20.04 vagrant box with command `vagrant box add ubuntu/focal64`. If this step skipped then `vagrant up` command will first download vagrant box then create VM(s) from it.

### Creating ssh key for postgres
ssh-keygen -t ed25519 -C postgres
touch authorized_keys
echo id_ed25519_postgres.pub > authorized_keys


## Usage
First clone the repo 

`git clone https://github.com/m-adnan8080/ansible-postgresql_master-slave.git`

Change directory to ansible-postgresql_master-slave

```
cd ansible-postgresql_master-slave
vagrant up
ansible-playbook pg_setup.yml
```
