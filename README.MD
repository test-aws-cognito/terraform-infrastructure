# Manual introduction

Every terraform `apply` and `destroy` needs manual entering value `yes`
(or -auto-approve parameter).
This approvals may be skipped in the manual.

Some terraform `init` may need `yes` approval. It should be described in the manual.

# Requirement

- AWS account

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

1. `/live/stage/network/> terraform apply`

2. `/live/stage/key/> terraform apply`

3. `/live/stage/postgresql/> terraform apply`

4. `/live/stage/cognito/> terraform apply`

    Enter value: your@mail.com
    
    On this mail temporary passwords for example users will be sent.
    
    Example users:  
    - foo
    - bar

5. `/live/stage/alb/> terraform apply`

6. `/live/stage/alb_autoscaling_group/> terraform apply`
