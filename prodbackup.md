## Pre-Requisite 

1. Create Orchestration VM in production and cyber recovery tenancy. Recommended specification is given below.

   1. OS OL7 or OL8
   2. Memory 60GB
   3. OCPU 4

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

   

10. Create cross tenancy policy for object storage in production and cyber recovery tenancy. Please refer to below doc.

    ​	https://docs.oracle.com/en-us/iaas/Content/Object/Concepts/accessingresourcesacrosstenancies.htm

11. Create object storage bucket in production and cyber recovery tenancy and ensure to have immutable bucket by applying retention rule and lifecycle.

    ```
    object storage bucket for production Tenancy: prd-backup-bucket
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
   # Git clone URL
   git clone < git Repository URL>
   
   # Change to production directory
   cd production_infra_backup_script
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

   ```
   # Change to production directory
   cd production_infra_backup_script
   
   # Run the ansible script to take backup.
   ansible-playbook create_bootvolume_clone.yml
   ```
   
   

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
