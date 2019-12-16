# move_state
This repository contains code that was modified. The new code was not applied to change the tfstate but the tfstate was modified to facilitate the new code.

# What this repo does
This repo's intention is to show how you can use the move state command to change the state of the terraform code without having to run apply.If make a change on the code and move to a module you can just make a change on the tfstate and will not need to destroy and re-deploy the resource.

# Why you should use this repo

This repo will show you the terraform state mv command and how to use to avoid re-deployment after making changes to your code.

# How to use this repo

 * Install Terraform
 ```
 https://www.terraform.io/downloads.html
 ```
 
 * Clone this repository
 
 ```
 git clone https://github.com/yordanivh/move_state
 ```
 
 * Change directory
 
 ```
 cd move_state
 ```
 * Start of in the initial_code folder.
```
cd initial_code
```
you will see two resources there random_pet and null_resource

* Run initialization in the folder to download any necessary plugins
 
 ```
 terraform init
 ```
 
* Plan the operation so that you see what actions will be taken
 
 ```
 terraform plan
 ```
 
 * Run Terraform apply to create the resources
 
 ```
 terraform apply
 ```
 
 ```
 Terraform will perform the following actions:

  # null_resource.hello will be created
  + resource "null_resource" "hello" {
      + id = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 4
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_pet.name: Creating...
random_pet.name: Creation complete after 0s [id=forcibly-vaguely-key-mutt]
null_resource.hello: Creating...
null_resource.hello: Provisioning with 'local-exec'...
null_resource.hello (local-exec): Executing: ["/bin/sh" "-c" "echo Hello forcibly-vaguely-key-mutt"]
null_resource.hello (local-exec): Hello forcibly-vaguely-key-mutt
null_resource.hello: Creation complete after 0s [id=5280407370708761972]
```
 * Now you have the resources created and tfstate file is up-todate.
 
 * Move the main.tf file in null_resource folder to the initial_code folder and check what changes have been made.
 
 ```
 mv ../null_resource/main.tf .; cat main.tf
 ```
 
 * We have added a module in place of the random_pet resource .The module is located in the random_pet folder.
 
 * Run terraform init to initialize the module
 
 ```
 terraform init
 ```

 * If we apply the changes we will have to to redeploy the random_pet resource.
 
 ```
 initial_code (newbrnach) $ terraform apply
random_pet.name: Refreshing state... [id=forcibly-vaguely-key-mutt]
null_resource.hello: Refreshing state... [id=5280407370708761972]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
  - destroy

Terraform will perform the following actions:

  # random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "forcibly-vaguely-key-mutt" -> null
      - length    = 4 -> null
      - separator = "-" -> null
    }

  # module.random_pet.random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 4
      + separator = "-"
    }

Plan: 1 to add, 0 to change, 1 to destroy.
```

* But if we use terraform state mv we don't need to do that.We just need to change the resource name to be the same as the module.
```
initial_code (newbrnach) $ terraform state mv 'random_pet.name' 'module.random_pet.random_pet.name'
Move "random_pet.name" to "module.random_pet.random_pet.name"
Successfully moved 1 object(s).
```
* Now if we run apply nothing will need to change and so the re-deployment has been avoided

initial_code (newbrnach) $ terraform apply
module.random_pet.random_pet.name: Refreshing state... [id=forcibly-vaguely-key-mutt]
null_resource.hello: Refreshing state... [id=5280407370708761972]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

* Run Destroy command to destroy the resources. 
```
initial_code (newbrnach) $ terraform destroy
module.random_pet.random_pet.name: Refreshing state... [id=forcibly-vaguely-key-mutt]
null_resource.hello: Refreshing state... [id=5280407370708761972]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.hello will be destroyed
  - resource "null_resource" "hello" {
      - id = "5280407370708761972" -> null
    }

  # module.random_pet.random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "forcibly-vaguely-key-mutt" -> null
      - length    = 4 -> null
      - separator = "-" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

null_resource.hello: Destroying... [id=5280407370708761972]
null_resource.hello: Destruction complete after 0s
module.random_pet.random_pet.name: Destroying... [id=forcibly-vaguely-key-mutt]
module.random_pet.random_pet.name: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
```




 
 
 
  
