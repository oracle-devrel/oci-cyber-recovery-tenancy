## Overview

Cyber recovery architecture has been designed for the purpose when ever there is any event of cyber attack on the  production tenancy, backups will transferred from cyber recovery tenancy back to production tenancy, where the system will be ultimately restored. Additionally this cyber recovery tenancy will be able to provide platform to safely recover the systems in order to test the validity of the backups.



## Deliverables

Repository contains following deliverables:

- A reference implementation script written in ansible that takes backup in production tenancy and restore it in cyber recovery only after digital signature validation and anti virus scan is successful. 

- A Terraform HCL code that provision the baseline infrastructure in cyber tenancy for restore.

- A reference implementation script written in ansible script to restore database in cyber tenancy.

  

## Executing Instructions

### Infrastructure

#### Pre-Requisite 

1. Create Orchestration VM in production and cyber recovery tenancy. Recommended specification is given below.

   1. OS OL7 or OL8
   2. Memory 60GB
   3. OCPU 4

2. Configure OCI CIS Landing Zone in the cyber recovery tenancy refer to the following link.

   ​	https://docs.oracle.com/en/solutions/cis-oci-benchmark/index.html

3. Install OCI CLI in production and cyber recovery tenancy orchestration VM.

   `yum install python36-oci-cli`

4. Install s3fuse package to mount object storage in production and cyber recovery tenancy orchestration VM.

   1. `yum --enablerepo ol7_developer_EPEL install s3fs-fuse`

   2. ```
      Configure Credentials
      Goto profile/user setting
      Generate key given name (s3fs-access)
      access key: 87680c241000000000010765ae1df2f43738
      secret key: 6ylubJdL15m0000000I1bfMQ2vIMcOlq/14pTk=
      ```



5. Install Ansible in production and cyber recovery tenancy orchestration VM.

   1. `yum install -y oci-ansible-collection --enablerepo ol7_developer --enablerepo ol7_developer_EPEL`
   1. `yum install -y oci-ansible-collection --enablerepo ol8_developer --enablerepo ol8_developer_EPEL`

6. Install Terraform in cyber recovery tenancy orchestration VM. Follow the link below

   ​	https://developer.hashicorp.com/terraform/downloads

7. Install Rclone in cyber recovery tenancy orchestration VM.

   ```
   curl https://rclone.org/install.sh | sudo bash
   % Total  % Received % Xferd Average Speed  Time  Time   Time Current
   ​                 Dload Upload  Total  Spent  Left Speed
   
   100 4497 100 4497  0   0 15513   0 --:--:-- --:--:-- --:--:-- 19637
   Archive: rclone-current-linux-amd64.zip
   
     creating: tmp_unzip_dir_for_rclone/rclone-v1.56.0-linux-amd64/
   ```



8. Create Topic and subscription in both production and cyber recovery tenancy follow below link.

   ​	https://docs.oracle.com/en-us/iaas/Content/Notification/Tasks/managingtopicsandsubscriptions.htm

9. Install ClamAV antivirus package in cyber recovery tenancy orchestration VM refer following link.

   ​	https://docs.oracle.com/en/solutions/anti-virus/index.html

10. Create cross tenancy policy for object storage in production and cyber recovery tenancy. Please refer to below doc.

    ​	https://docs.oracle.com/en-us/iaas/Content/Object/Concepts/accessingresourcesacrosstenancies.htm

11. Create object storage bucket in production and cyber recovery tenancy and ensure to have immutable bucket by applying retention rule and lifecycle.

    ```
    Production Tenancy: prd-backup-bucket
    Cyber Tenancy: crs-restore-blue-bucket
    Cyber Tenancy: crs-restore-red-bucket
    Cyber Tenancy:  crs-backup-blue-bucket
    ```



12. Create a separate script to take block volume and FSS tar backup and upload it to the production object storage bucket.


#### Script Implementation on Production Tenancy

VM backup in production tenancy will be taken care by ansible playbook. Overview of activity performed by the ansible playbook.

- Cloning the boot volume of instance mentioned in ansible inventory.
- Creating the temporary instance from the clone.
- Creating the custom image from the temporary instance.
- Export the custom image to customer managed object storage bucket.
- Create the digital signature of the backups uploaded on object storage bucket.

Cyber recovery Solution is designed to have blue room and red room restore. Blue room is meant for data validation which performed daily and red room is for application testing which performed in once in quater.

- Daily recovery is done in blue room where VM, OS and block volumes are restored but application are not started. Database is also restore and opened in read only mode. This room is restore is for data validation

- Quarterly full recovery is done in the red room where VM, OS, block volume are restored and application and database are also started and validated. This room restore mostly is for end to end application testing.



1. Clone GitHub production repository in production orchestration server.

   ```
   git clone < Production Repository URL>
   ```



2. Update the files in following directory in ansible home in production orchestration server.

   `group_vars`
   `host_vars`
   `Inventory`

3. Update inventory file with the list of servers in production orchestration server.

   inventory/server.yaml

   ```
   [prod_host]
   webserver1
   webserver2
   ```



4. Update the respective host file with boot volume ocid e.g host_var/webserver1 in production orchestration server.

   ```
   boot_ocid: "boot volume ocid"
   ```



5. Update host_var/localhost following parameter in production orchestration server.

   ```
   region: "region(eu-zurich-1)"
   access_id: "customer access id"
   secret_id: "customer secret id"
   fss_mount_point: "/oss"
   namespace_name: "Object storage namespace"
   bucket_name: "object storage bucket"
   private_key: "privkey.pem"
   ```



6. Update group_var/prod_host.yaml following parameter in production orchestration server.

   ```
   bucket_name: "prod bucket name"
   namespace_name: "prod namespace"
   dest_compartment_ocid: "Compartment OCID of where boot volume backup will be taken"
   dest_subnet_ocid: "Subnet OCID from which temporary instance will be created"
   shape: "VM.Standard2.2"
   topic_ocid: "Topic OCID for Notification"
   ```



7. Run the ansible command to take the backup of boot volumes in production orchestration server.

​	`ansible-playbook create_bootvolume_clone.yml`

#### Script Implementation on CRS Tenancy

Infrastructure restoration in CRS tenancy will be taken care by ansible and terraform script. Terraform code has been integrated with ansible so that we only need to configure ansible script on cron job to schedule the restore process. Overview the activity performed by the script.

- Syncing cyber recovery bucket with production bucket.
- Mount cyber restore object storage bucket in the orchestration server.
- Perform digital signature verification of the backup synced.
- Perform antivirus verification of the backup synced.
- Import custom image.
- Call terraform script to provision instance, Block volume and FSS.
- Create disk partition, LVM and file system.
- Restore block volume.
- Restore FSS.
- Run Validation script.
- Call terraform script to destroy infrastructure.



1. Clone GitHub cyber recovery repository in cyber recovery orchestration VM.

   ```
   git clone <Cyber Repository URL>
   ```

2. Update the files in the following directories in ansible home directory in cyber recovery orchestration VM.

   `group_vars`
   `host_vars`
   `Inventory`

3. Update inventory file with the list of servers in cyber recovery orchestration VM.

   inventory/server.yaml

   ```
   [cyber_host]
   webserver1
   webserver2
   ```

4. Update the group_vars/cyber_host.yaml in cyber recovery orchestration VM

   ```
   ##Storage bucket parameters
   region: "Region <uk-london-1>"
   bucket_name: "<cyber tenancy bucket>""
   namespace_name: "Object Storage name space"
   fss_mount_point: "object stroage mount point path on orchestration VM"

   #Destination compartment OCID
   dest_compartment_ocid: "ocid1.compartment.compartment ocid in cyber tenancy"

   ##Notification parameters
   topic_ocid: "ocid1.onstopic.oc1.topic ocid"

   ##Backup Store Area
   local_backup_location: "<Path of the temporary backup staging in orch VM"

   ## Staging FSS Detail
   staging_mount:
    mount_target: "<FSS IP >"
    fss_name: "/crs-staging-fss"
    mount_path: "/staging"

   ```

5. Update host_vars/localhost in cyber recovery orchestration VM.

   ```
   #Object Storage Parameter
   region: "Region uk-london-1"
   access_id: "access key id"
   secret_id: "secret key id"
   fss_mount_point: "object storage mount point path on orchestration VM"
   namespace_name: "object storage namespace"
   bucket_name: "cyber tenancy object storage bucket name"
   
   # configuration for rclone
   rclone_local: "production tenancylocation name mentioned in rclone config"
   source_bucket: "p"
   rclone_remote: "cyber-dest"
   destination_bucket: "cust-crs-ebs-prd-restore"
   
   #Digital Signature Verification
   public_key: "./pubkey.pem"
   
   ## Notification Parameters
   topic_ocid: "ocid1.onstopic.oc1.uk-london-1.aaaaaaaausopw2pqfj5dob6o0000000000osa"
   
   ## Terraform Parameter
   terraform_homedir: "/u01/OCI-Cyber-scripts/cyber_terraform/crs"
   ```



6. Update host_vars/webserver1 for block volume partition, LVM, block volume restore and FSS restore etc in cyber recovery orchestration VM.

   ```
   # Define FSS Share

   fss_mount:
    - fss_name: "/export/fssname"
      mount_target: "0.0.0.0"
        mount_point: "/mnt/fssname_122-1_0.0.0.0"
        fss_backup: "<fss_backup_prefix>_{{ ansible_date_timee.date }}.tar.gz"

   # Define Block Volume share
   disk_part:
    - 'sdb'

   disk_vg:
    - vg_name: 'vg_var'      #Size 100G
      device: 'sdb1'

   disk_lv:
    - lv_name: 'lv_vg_var'
      vg_name: 'vg_var'
      mount_fs: "ext4"
      size: "49G"
      mount_path: '/var'
      backup_name: '<bv_backup_prefix>_{{inventory_hostname}}_{{ansible_date_timee.date }}.tar.gz'
   ```

7. Update Terraform variables in cyber recovery orchestration VM.

   **crs_instances.auto.tfvars**

   The variable file contains the details for the instance provisioning such as the image name (Instance name) compartment, Subnet, AD, IP, NSG etc

   **crs_blockvolumes.auto.tfvars**

   The variable file contains the details required to provision the block volumes such as block volume name, AD, Size etc.

   **bv_attchment.tf**

   The block volume attachment activity is not carried out with modules, As we have to control the order of attaching the block volumes to the corresponding instance. Hence, we have used the block volume attachment resource directly

   To control the order, we have used **depends_on** metadata argument.

   **crs_fss-blueroom.auto.tfvars**

   The variable file contains the details for the Mount, File system and the NFS export options. It will supply the inputs like FSS name, path and export options.

   Note: Mount target will be the part of OCI Landing zone.

   ##### **Load Balancers**

   **crs_lb-hostname-certs.auto.tfvars**

   The variable file contains the details of LB, hostname and SSL certificates.

   **crs_lb-backendset.auto.tfvars**

   The variable file contains the details of backends and the backend sets

   **crs_lb-listners.auto.tfvars**

   The variable file contains the details of load balancer listener information

   ##### **Terraform Modules**

    Here are corresponding files for the modules for Instance, Block volume and FSS. The modules are located under the directory called modules inside the code base.

   **instance.tf**

   Contain the code for calling instance module

   **block-volume.tf**

   Contain the code for calling block volume module

   **fss.tf**

   Contain the code for calling fss module

   **loadbalancer.tf**

   Contain the code for calling loadbalancer module

   ##### Terraform Data Source

   **oci-data.tf**

   The oci-data terraform file which contain the data source for fetching the Availability domain, Custom images and the FSS Mount targets

8. Run the ansible command to take the backup of boot volumes in cyber recovery orchestration VM.

   ```
   ansible-playbook cyber_restore.yml
   ```

9. Run the following ansible command to cleanup the infrastructure daily once the restore is successful in cyber recovery orchestration VM.

   ```
   ansible-playbook cyber_cleanup.yml
   ```



### Database

#### Pre-Requisite

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
