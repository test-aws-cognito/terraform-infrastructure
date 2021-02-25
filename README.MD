# Manual introduction

Every terragrunt `apply` and `destroy` needs manual entering value `yes`
(or -auto-approve parameter).
This approvals may be skipped in the manual.

Some terragrunt `init` may need `yes` approval. It should be described in the manual.

Terragrunt is creating Terraform backend out of the box.
Remember to remove it if not needed any more.

# Requirement

- Terraform installed (last test on 0.14.5)
- Terragrunt installed (last test on 0.27.0)
- AWS account
- AWS certificate for domain `*.amazonaws.com`
    - This certificate can be done with module `certificate`.
      Do it only once as you may upload (very) limited number of certificates!
- (optional) AWS uploaded public/private key - only for bastion host. You may
    - Skip this (upload mocked default key) - not really necessary to run this stack OR
    - Replace mocked public key is in `modules/security/keys/resources/pr-01-key.pub` OR
    - Replace key name in configuration and upload key to AWS manually (or use already uploaded).

# First usage

## General configuration

There are two main configuration files:

- terragrunt.hcl
    - Main terragrunt configuration -
      at the end it passes all configurations `inputs` to terraform modules

- terragrunt-config-global.yml
    - Important configuration necessary for running

Before running stack you MUST configure `terragrunt-config-global.yml`.
Especially necessary variables to set are:
    
- `cognito.mail`
    - On this mail Cognito user passwords will be sent.
      Without it you won't be able to access web application.
      
- `terraform.backend.prefix`
    - Prefix for AWS S3/DynamoDB Terraform backend.
      It MUST be AWS-globally-unique as S3 buckets names requires.
      
- `aws.credentials.file`
    - File with AWS Credentials.
      By default it points to Windows 10 default location.
      You must to create this file and point to it.

## Remote state container

### Remote state container creation

It is automatically createt by Terragrunt on first `apply`

### Remote state container destruction (do on destroying whole project only!)

You must manually remove S3 bucket and DynamoDB table:

- `${terraform.backend.prefix}-bucket` - S3 bucket

- `${terraform.backend.prefix}-table` - DynamoDB table

# Starting infrastructure

Every terraform/terragrunt `apply` and `destroy` needs manual entering value `yes`

**Only once per whole project development**

As certificates have limits of uploads it is better to do not do it to often ;)

    `/live/stage/certificate/> terragrunt apply`
    
**Every time you want to start and destroy infrastructure**

Destroy in opposite direction...

1. Be sure you have valid certificate or create it (and do not destroy it!) with:

    `/live/stage/certificate/> terragrunt apply`

2. `/live/stage/network/> terragrunt apply`

3. Importing (EC2) key
    
    a. If you have your own, already imported to AWS key,
    and you properly pointed it in `terragrunt-config-global.yml`
    you may skip to next point. If not read further.
    
    b. If you do not want access EC2 just skip to (d)
    
    c. If you have your own public/private key pair you may replace default/mock public key:
  
    `modules/modules/security/keys/resources/pr-01-key.pub`
     
     d. `/live/stage/key/> terragrunt apply`

4. `/live/stage/postgresql/> terragrunt apply`

5. `/live/stage/cognito/> terragrunt apply`

    Enter value: your@mail.com
    
    On this mail temporary passwords for example users will be sent.
    
    Example users:  
    - foo
    - bar

6. `/live/stage/alb/> terragrunt apply`

7. `/live/stage/alb_autoscaling_group/> terragrunt apply`

8. Enter web site with following steps

    - Get Load Balancer DNS
        - (EC2 -> Load balancers -> Name: terraform-cognito-alb -> Copy DNS name)
        
    - Go to DNS through HTTPS (S at the end!)
    
    - Wait if Load Balancer or Spring Application is not ready yet
    
    - Accept manually custom certificate (it is self signed certificate)
    
    - Log in with username and password received from `cognito step` mail
        - Mind the dot at the end of password as it is not part of the password! 

# Summary

This terraform stack combines:

- Cognito

- Application Load Balancer
    - access protected by Cognito

- Auto Scaling Group

- Spring Boot Application
    - on Auto Scaling Group
    - protected by cognito
    - joined with cognito groups and DB roles making more granular access
    - cached with Elasticache (Redis)
    
- PostgreSQL DB

- Elasticache (Redis)

Access to ALB and Spring Boot application is protected by Cognito.
Access to Spring Boot endpoints is protected by Roles.
Roles are obtained as follows:
- Spring Boot application reads Cognito User groups.
- Then groups are joined with Roles from PostgreSQL.
- Roles on PostgreSQL are joined (many-to-many) with Cognito groups.
