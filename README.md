# Sela-Week6-Terraform
## Project overview
![Layout](Terraform/assets/week-6-envs.png)
## General
1. The Terraform code is the same for 2 environments: production and staging. These environemts were created by Terraform's workspaces.
1. Create the Terraform infrastructure, one for each environemt:
    - terraform select **production**; terraform apply
    - terraform select **staging**; terraform apply
1. Check for the outputs: 
    - Connection string to the database 
    - Load balancer IP address
    - User names and passwords for the VMs
1. Set in your Okta account, in the right application settings with the new LB IP. Note you need to have **2 applications**, one for each envirnment (and each one has a different IP for its own load balancer and of course a different key and secret for the .env file).
2. Run your Ansible project on each Ansible machine as described [here](https://github.com/ItaiGafny/Sela-Week6-Ansible).
