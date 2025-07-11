# Terraform Cheat Sheet (HCL)
## Docs: https://registry.terraform.io
## Directory Structure
📦 **terraform/**  
├── [1.hello_world](1.hello_world)                          `# Example Terraform configuration for a simple "hello world" resource.`  
├── [2.variables](2.variables)                              `# Contains examples and explanations for Terraform variables.`  
├── [3.builtin-functions](3.builtin-functions)              `# Terraform Builtin functions`  
├── [4.terraform.tfvars](4.terraform.tfvars)                `# Default Terraform variable definitions.`  
├── [5.terraform.tfvars_custom](5.terraform.tfvars_custom)  `# Custom Terraform variable definitions.`  
├── [6.terraform.env.vars](6.terraform.env.vars)            `# Environment-specific Terraform variable definitions.`  
├── [7.github_provider](7.github_provider)                  `# Terraform configuration examples using GitHub provider.`  
├── [8.terraform_console](8.terraform_console)              `# Examples and explanations for using Terraform console.`  
├── [9.terraform-aws](9.terraform-aws)                      `# Terraform configurations specific to AWS resources.`  
├── [10.provisioners](10.provisioners)                      `# Examples and explanations for using Terraform provisioners.`  
├── [11.aws-data_sources](11.aws-data_sources)              `# Examples of using AWS data sources in Terraform.`  
├── [12.graph-view](12.graph-view)                          `# Contains configurations to generate Terraform resource dependency graphs.`  
├── [13.terraform-workspace](13.terraform-workspace)        `# Examples for managing Terraform workspaces.`  
├── [14.terraform-module](14.terraform-module)              `# Terraform module examples and configurations.`  
├── [15.terraform-backend](15.terraform-backend)            `# Configurations for setting up Terraform backend.`  
└── [16.dynamoDB-state-locking](16.dynamoDB-state-locking)  `# Example configuration for using DynamoDB for Terraform state locking.`  

[README.md](README.md)                      `# This README file for documentation.`  
[terraform-projects](terraform-projects)    `# Directory for general Terraform projects and configurations.`  

---
## Table of Contents
0. [Directory Structure](#directory-structure)
1. [Basic Commands](#basic-commands)
2. [Terraform vars input methods](#terraform-vars-input-methods)
3. [Terraform Taint](#terraform-taint)
4. [Terraform Logs](#terraform-logs)
5. [Terraform State Commands](#terraform-state-commands)
6. [Terraform Import](#terraform-import)
7. [Terraform Provisioners](#terraform-provisioners)
8. [Terraform Provisioners Problems](#Terraform-Provisioner-Problems)
9. [Terraform Graph Command](#terraform-graph-command)
10. [Terraform Workspace](#terraform-workspace)
11. [Terraform Backend](#terraform-backend)
12. [Terraform State Locking (Race condition)](#terraform-state-locking-race-condition)
13. [Deadlock condition in terraform (use self keyword)](#deadlock-condition-in-terraform-use-self-keyword)
14. [Interview Highlights](#interview-highlights) 

---

## Basic Commands:
1. `terraform init`: Initialize a Terraform working directory containing Terraform configuration files.
2. `terraform plan`: Create an execution plan for changes to infrastructure.
3. `terraform apply` & `terraform apply -auto-approve & terraform apply --auto-approve --var-file=dev-terraform.tfvars`: Apply the changes required to reach the desired state of the configuration.
4. `terraform show`: Inspect Terraform state or plan.
5. `terraform output`: Read an output from a state file.
6. `terraform console`: Try Terraform expressions interactively.
7. `terraform validate`: Check whether the configuration files are valid.
8. `terraform destroy -target RESOURCE_TYPE.NAME & terraform destroy --auto-approve --var-file=dev-terraform.tfvars`: destroy one specific resource
9. `terraform refresh`: Sync/refresh remote changes to state file 
### 10. `terraform console`: 
```
❯ terraform console
> var.username
"khaleel"
> var.github_repository.repo1.html_url
"https://github.com/khaleel-git/git1"
```

## Terraform vars input methods
### passing a single var
`terraform plan -var 'user=user_01'`
### using env variable
```
export TF_VAR_username=khaleel
terraform plan
```
### passing a list
`terraform plan -var 'usersage=["apple","banana","mangos"]'`
### passing a map
`terraform plan -var 'usersage={ "khaleel":"23","zafar":"22","shivmeena":"25" }'
`
### passing var file
`terraform plan -var-file=custom.tfvars`
## Terraform Taint
### Definition:
In Terraform, the `taint` command marks a resource as degraded or damaged, indicating it will be destroyed and recreated during the next apply operation.

- When you run `terraform apply` next time, that resource will be destroyed and re-created.
- The configuration for the resource will not change, but the actual resource will be replaced.
- Can cause problems in a collaborative environment.
### Taint Commands:
1. `terraform taint {resource}`: Mark a resource for recreation. (manual)
2. `terraform untaint {resource}`: Remove the taint from a resource.
### New Feature:
- `terraform plan`, `terraform taint` -> `terraform plan -replaced`
- `terraform plan -replace="resource_name.main"` (imperative)
## Terraform Logs:
Levels: Info, Warning, Error, Debug, Trace

- Enable logs: `export TF_LOG=<log_level>`
  Example: `export TF_LOG=TRACE`
- Save logs to a file: `export TF_LOG_PATH=/tmp/terraform.log`
- Disable logs: `unset TF_LOG`
## Terraform State Commands:
### Important Points:
- `for_each` (loop) does not accept a list. Convert the list to a set first.
## Terraform Import:
- `terraform import aws_instance.webserver-2 i-023324324df7`
- It does not update configuration, only the state file.
- Initialize the configuration block as follows:
```
resource "aws_instance" "webserver-2" {
    # empty
}
```
## Terraform Provisioners
### (1) file, (2) local-exec, (3) remote-exec
#### If provisioner failed to run, terraform will mark it as tainted, so next time it will replace the resources
### By default provisioner runs at creation time
```
  # write public ip to local file
  provisioner "local-exec" {
    working_dir = "/tmp/"
    command     = "echo ${self.public_ip} > public_ip.txt"
  }

  provisioner "local-exec" {
    interpreter = ["/usr/bin/python3", "-c"]
    command     = "print('hello world')"
  }

  provisioner "local-exec" {
    command = "env>env.txt"
    environment = {
      envname = "envvalue"
    }
  }
```
### Run Provisioner at Deletion time
```
# local-exec at deletion of the instance
  provisioner "local-exec" {
    when = destroy
    command = "echo 'at Delete'"
  }
```
### Continue to apply even if some local-exec filed
```
 provisioner "local-exec" {
    on_failure = continue
    command = "env>env.txt"
    environment = {
      envname = "envvalue"
    }
  }
```
## Terraform Provisioner Problems
```
*Terraform won't detect remote changes, therefore, we don't recommend using provisioners, use ansible for alternatives*
```
#### First time run
```
  # in-line remote-exec
  provisioner "remote-exec" {
    inline = [
      "sudo apt install net-tools",
      "ifconfig > /tmp/ifconfig.output",
      "echo 'hello world' > /tmp/hello.txt"
    ]
  }
```
#### Second time run -> won't run, bcz wont' detect changes
```
  # in-line remote-exec
  provisioner "remote-exec" {
    inline = [
      "ifconfig > /tmp/ifconfig.output",
      "echo 'hello world 1' > /tmp/hello.txt"
    ]
  }
```
## Terraform Graph Command:
```
sudo apt-get install graphviz
terraform graph | dot -Tpdf > graph.pdf 
terraform graph | dot -Tsvg > graph.svg
terraform graph | dot -Tpng > graph.png
```
## Terraform Workspace 
```
terraform workspace list
terraform workspace new dev
terraform workspace show
terraform workspace select dev
workspace delete prod
```
## Terraform Backend
### Not recommended to use github
#### S3 Remote Backend
```
terraform {
  backend "s3" {
    bucket = "lenovo-tf-state"
    region = "us-east-1"
    key = "terraform-tfstate"
  }
}
```
### Migrate Remote backend
`terraform init -migrate-state`
## Terraform State Locking (Race condition)
### DynamoDB State Locking
```
terraform {
  backend "s3" {
    bucket = "lenovo-tf-state"
    region = "us-east-1"
    key = "terraform-tfstate"
    dynamodb_table = "khaleel-tf-table"
  }
}
```
## Deadlock condition in terraform (use self keyword)
```
 # replace self.public_ip with aws_instance.name.public_ip (this provisioner is called within the aws instance creation block)
  provisioner "file" {
    source      = "${path.module}/nginx.sh"
    destination = "/tmp/nginx.sh"
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/khaleel/.ssh/aws_rsa")
    }
  }
  ```
---

# Interview Highlights
1. Lifecycle of Terraform
2. Why Terraform?
3. Features of Terraform/HCL
4. Destory only specific resources: terraform destroy target ....
5. Reserve key
6. Modules (types of modules)
7. Why Terraform doesn't recommend terraform taint command? and why replace command? link: [terraform taint vs replace](https://rhegisanjebas.medium.com/terraform-taint-vs-replace-why-replace-is-the-better-option-for-your-infrastructure-e59c1193e6db)

### 8. aws user_data and problems with Configuration Management
#### Below code wont be run becuase of indentation in Shebang
```
user_data = <<EOF
  #!/bin/bash
  ls > ls.txt
  sudo apt-get update -y
  sudo apt-get install nginx -y
  sudo echo "Hello Nginx" > /var/www/html/index.nginx-debian.html
EOF
```
#### Below code run successfully because (-) in EOF i.e -EOF
```
user_data = <<-EOF
  #!/bin/bash
  ls > ls.txt
  sudo apt-get update -y
  sudo apt-get install nginx -y
  sudo echo "Hello Nginx" > /var/www/html/index.nginx-debian.html
EOF
```
#### Below code run successfully because of no indentation in shebang
```
user_data = <<-EOF
#!/bin/bash
ls > ls.txt
sudo apt-get update -y
sudo apt-get install nginx -y
sudo echo "Hello Nginx" > /var/www/html/index.nginx-debian.html
EOF
```