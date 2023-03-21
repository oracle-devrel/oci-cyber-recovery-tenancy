########################################
# Shell script to schedule job in cron #
########################################
#!/bin/bash
ANSI_HOME='/u01/OCI-Cyber-scripts/cyber_infra_restore_script'
ANSI_MANIFEST_FILE='cyber_infra_restore.yml'
ANSI_BINARY='/usr/bin/ansible-playbook'
cd $ANSI_HOME
$ANSI_BINARY $ANSI_MANIFEST_FILE > /u01/infra_logs/infra_restore_`date +"%Y-%m-%d_%H%M%S"`.log 2>&1

