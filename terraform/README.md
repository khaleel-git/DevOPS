# Commands:

## Basic Commands:
1. terraform init
2. terraform plan
3. terraform apply & terraform apply -auto-approve
4. terraform show
5. terraform output
6. terraform console
7. terraform validate

## Terraform Taint
### Definition:
In Terraform, the taint command marks a resource as degraded or damaged, and indicates that it will be destroyed and recreated during the next apply operation. This can be useful when a resource is in an undesirable state, but its configuration hasn't changed. For example, you might taint a VM if its setup script failed, or a storage bucket if you need to empty it out and recreate it.

-> When you run terraform apply Next time, that resource will be destroyed and re-created.
-> The configuration for the resource will not change, but the actual resource will be replaced.
-> Cause problems in a collaborative environment

### Taint Commands
1. terraform taint {resource}
2. terraform untaint {resource}

### new feature
-> terraform plan, terraform taint -> terraform plan -replaced
-> terraform plan -replace="resource_name.main" (imperative)


## Terraform Logs
Info, Warning, Error, Debug, Trace
command: export TF_LOG=<log_level> 
example: export TF_LOG=TRACE
save logs: export TF_LOG_Path=/tmp/terraform.log

Disable logs:
unset 

## Terraform State Commands:

# Important Points:
for_each (loop) does not accept a list. Just convert list to set. Then it will accept.
