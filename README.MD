# Manual introduction

Every terraform `apply` and `destroy` needs manual entering value `yes`
(or -auto-approve parameter).
This approvals may be skipped in the manual.

Some terraform `init` may need `yes` approval. It should be described in the manual.

# Requirement

- AWS account
- AWS certificate for domain `*.amazonaws.com`
    - This certificate can be done with module `certificate`.
      Do it only once as you may upload (very) limited number of certificates!

# First usage

## General configuration

1. Find all `backend.tf` files and check configuration
    
    It is impossible to use variables inside backend configuration so it have to be done manually.
    
    Because AWS require S3 bucket names to be globally unique, state bucket name must be changed.
    
2. Find all `_variables.tf` files inside used module and check if proper values are set.

    Set any unset values or not suitable default values.
    
    Update state S3 bucket and state DynamoDB lock table names.
    
    Default values may be set in repository `_terraform.tfvars` files (mind the `_`).

3. Before first usage comment `/global/backend/backend.tf` file as remote state container must be
initialized first.

## Remote state container

### Remote state container creation

1. `/global/backend/> terraform init`

2. `/global/backend/> terraform apply`
    
3. Uncomment `/global/backend/backend.tf`

4. `/global/backend/> terraform init`

    Enter a value: yes

### Remote state container destruction (do on destroying whole project only!)

1. Comment `/global/backend/backend.tf`

2. `/global/backend/> terraform init`

    Enter a value: yes

3. Uncomment `force_destroy` in `/global/backend/backend-infrastructure.tf`

4. `/global/backend/> terraform apply`

5. `/global/backend/> terraform destroy`

# Starting infrastructure

Every terraform `apply` and `destroy` needs manual entering value `yes`

**Only once per whole project development**

As certificates have limits of uploads it is better to do not do it to often ;)

    `/live/stage/certificate/> terraform apply`
    
**Every time you want to start and destroy infrastructure**

Destroy in opposite direction...

1. Be sure you have valid certificate or create it (and do not destroy it!) with:

    `/live/stage/certificate/> terraform apply`

2. `/live/stage/network/> terraform apply`

3. `/live/stage/key/> terraform apply`

4. `/live/stage/postgresql/> terraform apply`

5. `/live/stage/cognito/> terraform apply`

    Enter value: your@mail.com
    
    On this mail temporary passwords for example users will be sent.
    
    Example users:  
    - foo
    - bar

6. `/live/stage/alb/> terraform apply`

7. `/live/stage/alb_autoscaling_group/> terraform apply`

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
