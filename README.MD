# First usage

## General configuration

1. Find all `backend.tf` files and check configuration
    
    It is impossible to use variables inside backend configuration so it have to be done manually.
    
2. Find all `_variables.tf` files inside used module and check if proper values are set.

    Set any unset values or not suitable default values
    
    Default values may be set in repository `_terraform.tfvars` files (mind the `_`)

3. Before first usage comment `/global/backend/backend.tf` file as remote state container must be
initialized first.

## Remote state container

### Remote state container creation

1. `/global/backend/> terraform init`

2. `/global/backend/> terraform apply`

    Enter a value: yes
    
3. Uncomment `/global/backend/backend.tf`

4. `/global/backend/> terraform init`

    Enter a value: yes

### Remote state container destruction (do on destroying whole project only!)

1. Comment `/global/backend/backend.tf`

2. `/global/backend/> terraform init`

    Enter a value: yes

3. Uncomment `force_destroy` in `/global/backend/backend-infrastructure.tf`

4. `/global/backend/> terraform apply`

    Enter a value: yes

5. `/global/backend/> terraform destroy`

    Enter a value: yes
