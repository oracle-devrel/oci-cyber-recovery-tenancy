#!/bin/bash
cd /root/prod_backup_script
/bin/ansible-playbook-3 create_bootvolume_clone.yml > /tmp/crlog 2>&1
