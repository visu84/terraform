# terraform-aws-vpc

This repository contains a [Terraform][] project that builds 

1 VPC
2 Public Subnets
2 Private subets
1 NAT Gateway
1 Internet Gateway

Route tables etc.,

## Usage

`terraform.tfvars` holds variables which should be overriden with valid ones.

### Plan

```
terraform plan -var-file terraform.tfvars
```

### Apply

```
terraform apply -var-file terraform.tfvars
```

### Destroy

```
terraform destroy -var-file terraform.tfvars
```

## Author

Visu
