# Terraform Commands Cheat Sheet
### Docs: https://registry.terraform.io
#### HCL: Hashicorp Configuration Language

## Basic Commands:
1. `terraform init`: Initialize a Terraform working directory containing Terraform configuration files.
2. `terraform plan`: Create an execution plan for changes to infrastructure.
3. `terraform apply` & `terraform apply -auto-approve`: Apply the changes required to reach the desired state of the configuration.
4. `terraform show`: Inspect Terraform state or plan.
5. `terraform output`: Read an output from a state file.
6. `terraform console`: Try Terraform expressions interactively.
7. `terraform validate`: Check whether the configuration files are valid.
8. `terraform destroy -target RESOURCE_TYPE.NAME`: destroy one specific resource
9. `terraform refresh`: Sync/refresh remote changes to state file 
### 10. `terraform console`: 
```
❯ terraform console
> var.username
"khaleel"
> var.token
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




# Interview Highlights
1. Lifecycle of Terraform
2. Why Terraform?
3. Features of Terraform/HCL
4. Destory only specific resources: terraform destroy target ....
5. Reserve key
6. Modules (types of modules)
7. Why Terraform doesn't recommend tint command? and why replace command?

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
## 9. Deadlock condition in terraform (use self keyword)
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
