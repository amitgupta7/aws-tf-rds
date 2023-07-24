# aws-tf-rds
## Provided as-is (w/o support) 
This is an example to setup a mysql database instance for sensitive data scanning. The setup utilizes terraform to setup the database instance and destroy the same. This requires the aws access_key and secret_key to authenticate to aws. Please make sure the access_key provided has admin access in aws. Only for demo/training purposes. 

## Prerequisites
The script needs terraform and mysql-client to run/test. This can be installed using a packet manager like apt (linux) or using homebrew (mac).

NOTE: These are mac instructions (homebrew -> terraform). Provided as-is. 
```shell
#install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## install terraform
brew install terraform
## install mysql-client
brew install mysql-client

## To use the tfscript
Clone `main` branch. Alternatively use [released packages](https://github.com/amitgupta7/azure-tf-vms/releases)
```shell
$> git clone https://github.com/amitgupta7/aws-tf-rds.git
$> cd aws-tf-rds
$> source tfAlias
$> tf init 
## provision infra for pods provide EXISTING resource group name,
## azure subscription-id and vm-password on prompt
$> tfaa 
## to de-provision provide EXISTING resource group name, 
## azure subscription-id and vm-password on prompt 
## EXACTLY SAME VALUES AS PROVIDED DURING PROVISIONING
$> tfda