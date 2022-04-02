# Sela-Week6-Terraform
## Project overview
![Layout](/assets/week-6-envs.png)
## General

1. Create the Terraform infrastructure, one for each environemt
    - terraform select production; terraform apply
    - terraform select staging; terraform apply
1. Check for the outputs: 
    - Connection string to the database 
    - Load balancer IP address
    - User names and passwords for the VMs
1. Set in your Okta account, in the right application settings with the new LB IP. Note you need to have **2 applications**, one for each envirnment (and each one has a different IP for its own load balancer and of course a different key and secret for the .env file)