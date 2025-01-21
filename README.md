## Overview

Cyber security has become an increasingly critical topic as malware and ransomware attacks continue to occur around the world. For mission-critical databases, such attacks leading to lost data and system downtime can have far ranging impacts throughout the business in terms of revenue, operations, reputation, and even penalties.

Cyber recovery architecture has been designed for the purpose when ever there is any event of cyber attack on the  production tenancy, backups will transferred from cyber recovery tenancy back to production tenancy, where the system will be ultimately restored. Additionally this cyber recovery tenancy will be able to provide platform to safely recover the systems in order to test the validity of the backups.





Repository contains following artifacts:

- A reference implementation script written in ansible that takes backup in production tenancy.

-  A reference implementation script written in ansible to restore backups in cyber recovery only after digital signature validation and anti virus scans are successful. 

- A Terraform HCL code that provision the baseline infrastructure in cyber tenancy for restore.

- A reference implementation script written in ansible to restore database in cyber tenancy after anti virus scan is successful.

## Solution Deployment Steps

This reference architecture shows how you can implement an automated backup and restore solution that is deployed on OCI.

Oracle E-Business Suite application (EBS) is used as an example for this solution but you can easily adopt it for other Oracle applications.



- [Configure Production backup](prodbackup.md)
- [Restore CRS Tenancy](crsrestore.md)
- [Restore Database](dbrestore.md)



## License
Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE.txt) for more details.

ORACLE AND ITS AFFILIATES DO NOT PROVIDE ANY WARRANTY WHATSOEVER, EXPRESS OR IMPLIED, FOR ANY SOFTWARE, MATERIAL OR CONTENT OF ANY KIND CONTAINED OR PRODUCED WITHIN THIS REPOSITORY, AND IN PARTICULAR SPECIFICALLY DISCLAIM ANY AND ALL IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR PURPOSE.  FURTHERMORE, ORACLE AND ITS AFFILIATES DO NOT REPRESENT THAT ANY CUSTOMARY SECURITY REVIEW HAS BEEN PERFORMED WITH RESPECT TO ANY SOFTWARE, MATERIAL OR CONTENT CONTAINED OR PRODUCED WITHIN THIS REPOSITORY. IN ADDITION, AND WITHOUT LIMITING THE FOREGOING, THIRD PARTIES MAY HAVE POSTED SOFTWARE, MATERIAL OR CONTENT TO THIS REPOSITORY WITHOUT ANY REVIEW. USE AT YOUR OWN RISK. 
