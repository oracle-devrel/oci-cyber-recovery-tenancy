## Pre-Requisite 

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

11. Create object storage bucket in cyber recovery tenancy and ensure to have immutable bucket by applying retention rule and lifecycle.

    ```
    Cyber Tenancy: crs-restore-bucket01
    Cyber Tenancy: crs-restore-bucket02
    
    ```



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
   # Clone the git repository
   git clone <Repository URL>
   
   # change to crs restore script directory 
   cd cyber_infra_restore_script
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
   region: "Region"
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
   region: "Region code"
   access_id: "access key id"
   secret_id: "secret key id"
   fss_mount_point: "object storage mount point path on orchestration VM"
   namespace_name: "object storage namespace"
   bucket_name: "cyber tenancy object storage bucket name"
   
   # configuration for rclone
   rclone_local: "production tenancy location name mentioned in rclone config"
   source_bucket: "cyber tenancy location name mentioned in rclone config"
   rclone_remote: "cyber-dest"
   destination_bucket: "cust-crs-ebs-prd-restore"
   
   #Digital Signature Verification
   public_key: "./pubkey.pem"
   
   ## Notification Parameters
   topic_ocid: "ocid1.onstopic.oc1.uk-london-1.aaaaaaaausopw2pqfj5dob6o0000000000osa"
   
   ## Terraform Parameter
   terraform_homedir: "/dirname/cyber_infra_terraform_restore_script/crs"
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
   # change the script directory
   cd cyber_infra_restore_script
   
   # Execution of script
   ansible-playbook cyber_infra_restore.yml
   
   # Validate the restore
   ansible-playbook cyber_infra_validate.yml
   ```

9. Run the following ansible command to cleanup the infrastructure daily once the restore is successful in cyber recovery orchestration VM.

   ```
   # change the script directory
   cd cyber_infra_restore_script
   
   # Destroy Infrastructure
   ansible-playbook cyber_infra_destroy.yml
   ```

10. Same script can be used for both red room and blue room configuration.

## License

Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
