#!/bin/bash

file=../inventory.txt

get_ip () {
echo "jenkins ansible_user="ec2-user" ansible_host=$(terraform output ip) ansible_connection=ssh ansible_port=22 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_ssh_private_key_file=~/.ssh/id_rsa" > ../inventory.txt
}

if [[ -f "$file" ]]
then
	rm ../inventory.txt
	get_ip
else
	echo "No File to delete"
	get_ip
fi

ansible-playbook ../playbook.yaml -i ../inventory.txt