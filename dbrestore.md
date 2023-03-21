## Pre-Requisite

1. TDE Wallet

The TDE wallet files from the source database has to be transferred and placed under the target database nodes as per the wallet path mentioned in the sqlnet.ora file.

2. Oracle Database Cloud Backup Module

​		2.1 Download the Oracle Database Cloud Backup Module for OCI from Oracle Technology Network (OTN): https://www.oracle.com/database/technologies/oracle-cloud-backup-downloads.html

*Accept the license agreement, click All Supported Platforms, and provide your OTN username and password when prompted.*
Download the ZIP file that contains the installer (opc_installer.zip) to your system.
		2.2 Extract the contents of the zip file.

*The below example shows how the installer automatically downloads the Oracle Database Cloud Backup Module for OCI for your operating system, creates a wallet that contains Oracle Database Backup Cloud Service identifiers and credentials, creates the backup module configuration file, and downloads the library necessary for backups and restores to Oracle Cloud Infrastructure.*

```
java -jar oci_install.jar -host https://objectstorage.<region-name>.oraclecloud.com \
-pvtKeyFile '<OCI user key>' \
-pubFingerPrint <OCI user pubFingerPrint> \
-tOCID <tenancy OCID> \
-uOCID <User OCID> \
-walletDir <install base directory/opc_wallet > \
-libDir <install base directory/lib \
-configfile <install base directory/opcdbbkp.ora \
-bucket <bucket_name where the backups are stored>
```

**_Make sure to use a generic OCI User account for the OCI user key and fingerPrint. This user has to be an active user in the tenancy for the restore to work_**

​	2.3 Files Created when Oracle Database Cloud Backup Module for OCI is Installed

```
[opc@hostname opc]$ ls lib/
bulkimport.pl  libopc.so  metadata.xml  odbsrmt.py  perl_readme.txt  python_readme.txt
[opc@hostname opc]$ ls opc_wallet/
cwallet.sso  cwallet.sso.lck
[opc@hostname opc]$ ls
lib  opcCRS.ora  opc_wallet
```

​		2.3.1	**_libopc.so_** on Linux and UNIX systems
Operating system-specific SBT library that enables cloud backups and restores with the Oracle Cloud Infrastructure.

​		2.3.2 **_opcSID.ora_**
The configuration file contains the Oracle Cloud Infrastructure Object Storage bucket URL and credential wallet location, where SID is the system identifier of the Oracle database being backed up to Oracle Cloud Infrastructure.

​		2.3.3 **_cwallet.sso_**
Oracle wallet file that securely stores Oracle Cloud Infrastructure Object Storage credentials. This file is used during Recovery Manager (RMAN) backup and restore operations and is stored in the Oracle Cloud Infrastructure Object Storage wallet directory (for example, opc_wallet).

​	2.4 Configure RMAN settings

```
RMAN> CONFIGURE DEFAULT DEVICE TYPE TO 'SBT_TAPE';
RMAN> CONFIGURE DEVICE TYPE 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
RMAN> CONFIGURE COMPRESSION ALGORITHM 'MEDIUM';
RMAN> CONFIGURE ENCRYPTION FOR DATABASE ON;
```

#### Script Implementation on CRS Tenancy

Database restoration in CRS tenancy will be taken care of by ansible and shell scripts with RMAN and SQL commands. The shell script has been integrated with ansible so that we only need to configure the ansible script on cronjob to schedule the database restore process.

##### Task performed by the Restore Script

1. Shutdown the database
2. Drop/remove the database
3. Restore the control file
4. Mount the database
5. Restore database
6. Recover database
7. Run the validation script
8. Send the notification with the validation script output

##### Restore Script Location

The Base location of the scripts is /u01/OCI-Cyber-scripts/DB-Restore/DB.

```
• /u01/OCI-Cyber-scripts/DB-Restore/db_restore.sh
• /u01/OCI-Cyber-scripts/DB-Restore/db/db_scripts.sh
• /u01/OCI-Cyber-scripts/DB-Restore/db/db_shut.sh
• /u01/OCI-Cyber-scripts/DB-Restore/db/db_asm_rm.sh
• /u01/OCI-Cyber-scripts/DB-Restore/db/db_restore.sh
```

**Scripts**

**_1. Filename: ebs_restore.sh_**
This is the**_ main script that performs _**the end-to-end DB restore and redirects the log file to the logs folder. This script will call the main scripts which should be executed as opc/root user.

**_2. Filename: ebs_scripts.sh_**
  This script will call other scripts to perform the below task
•	Shutdown EBS Database
•	Remove EBS datafiles from ASM
•	Restore the EBS database

**_3. Filename: ebs_shut.sh_**
This script will shut down the database before it's been removed. This script is executed as a oracle user, update the DB.env as per your environment.

**_4. Filename: ebs_asm_rm.sh_**
This script is executed as a grid user and needs to be updated as per the disk group names.
*Update the Script as per your environment.*
4.1 Update with the absolute path details for Oracle Home, if there is any change with your envirnomnet.
4.2 Update the DB Unique name
4.3 Update the hostname

**_5. Filename: ebs_db_restore.sh_**
This script will perform the database restore. It restore the control file, restore & recover the database using standby DB backup. This script is executed as a oracle user and needs to be updated as per your environment.
*Update the Script as per your environment.*
5.1 Update the environment file name and path which needs to be sourced.
5.2 Make sure we have the required pfile in place to start the DB in nomount.
5.3 Update the DBSID.
5.4 Disk Group name at set newname for database line.

##### Validation Scripts

Once the Database restore completes the validation script will be executed from root user and the output of the script will be pushed to validation.out file. This file will be used as an input to send the notification to the customer.
The Base location of the scripts is /u01/OCI-Cyber-scripts/DB-Restore

```
• /u01/OCI-Cyber-scripts/DB-Restore/validation_ebs.sh
• /u01/OCI-Cyber-scripts/DB-Restore/db/validation.sql
```

**_6. Filename: Validation.sh_**
This script will call the main validation script which is executed as oracle user

**_7. Filename: Validation.sql_**
This script runs the EBS validation queries connected as sysdba.

##### Ansible Database Restore Script Implementation

Database restoration in CRS tenacy will be taken care by the ansible and shell scripts. Ansible will connect to the database and run the local shell scripts from the target database. Overview activities performed by the script.

##### cyber_database_restore

- Start Database Node
- Syncing Remote Bucket & Mounting s3fs mount point
- Restoration and validation Database using local shell scripts
- Notification
- Stop Database Node

##### Ansible Script Configuration

1. Update the files in following directory in ansible home in orchestration server.

   `inventory`
   `host_vars`
   `roles/oci-start-database-node/defaults`
   `roles/oci-stop-database-node/defaults`

2. Update inventory file with the list of servers in orchestration server.

  inventory/main.yaml

  ```
[cyber_database]
database1
database2
  ```

4. Update the respective host file with boot volume ocid e.g host_var/database1 in orchestration server.

  host_vars/main.yaml

  ```
ansible_ssh_host="x.x.x.x"
restore_script_location="/u01/OCI-Cyber-scripts/DB-Restore/soa_restore.sh"
validation_script_location="/u01/OCI-Cyber-scripts/DB-Restore/validation_soa.sh"
validation_output_location="/u01/OCI-Cyber-scripts/DB-Restore/validation_soa.out"
  ```

5. Update the node ocid for the starting the nodes.

   roles/oci-start-database-node/defaults/main.yml

   ```
   database_ocid: "ocid1.dbnode.oc1.xxx"
   ```

6. Update the node ocid for the stopping the nodes.

   roles/oci-stop-database-node/defaults/main.yml

   ```
   database_ocid: "ocid1.dbnode.oc1.xxx"
   ```



## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
