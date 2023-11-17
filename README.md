# Terraform Project

This repository contains the Terraform configuration files for managing the infrastructure of the project. Below is the structure and description of the files and directories.

## Directory Structure

.
├── .gitignore
├── .terraform.lock.hcl
├── README.md
├── config/
│   └── terraform.tfvars
├── main/
│   ├── .terraform.lock.hcl
│   ├── backend.tf
│   ├── datasource.tf
│   ├── main.tf
│   ├── providers.tf
│   └── variables.tf
└── modules/
    ├── backends3/
    ├── database/
    ├── ecs/
    ├── frontend/
    ├── iam/
    ├── loadbalancer/
    └── vpc/


### Root Directory

- `.gitignore`: Contains the list of files and directories to be ignored by Git.
- `.terraform.lock.hcl`: Lock file that constrains Terraform's provider versions.
- `README.md`: This file, containing a description of the project.

### Config Directory

- `terraform.tfvars`: Variable definitions specific to the environment, used to customize the behavior of the Terraform configuration. This file serves the purpose of allowing customization for different environments and requirements.

### Main Directory

Contains the main Terraform configuration files, including backend configuration, data sources, main configuration, providers, and variable definitions.

### Modules Directory

#### VPC Module

Located in `modules/vpc/`, this module is responsible for creating a VPC, public, private, and database subnets, along with their route tables and associations. It also creates an Internet Gateway (IGW) and security group (SG) of the VPC.

#### Database Module

Located in `modules/database/`, this module creates a database instance and its security group.

#### Frontend Module

Located in `modules/frontend/`, this module creates an S3 bucket and its CloudFront, along with a CloudFront edge function.

#### ECS Module

Located in `modules/ecs/`, this module creates an ECR, ECS task definition, cluster, services, CloudWatch for ECS, and ECS security group.

#### IAM Module

Located in `modules/iam/`, this module creates a role for ECS task execution policy.

#### Load Balancer Module

Located in `modules/loadbalancer/`, this module creates a load balancer and target group for ECS services.


## Usage

### Prerequisites

- Ensure that Terraform is installed on your system.
- Configure any required authentication for the providers used in the project.

### Initialization

Navigate to the `main/` directory, where the main Terraform configuration files are located.

```bash
cd main/
terraform init
```
### Planning

Preview the changes that will be made to the infrastructure.

```bash
terraform plan -var-file="../config/terraform.tfvars"
```

### Applying

Apply the changes to create or update the infrastructure.

```bash
terraform apply -var-file="../config/terraform.tfvars"
```

### Destroying

```bash
terraform destroy -var-file="../config/terraform.tfvars"
```

Note: Make sure to review and understand the variable definitions in the config/terraform.tfvars file, as they may need to be customized based on your specific environment and requirements.


## Disclaimer

Please note that there might be some problems with the target group configuration when connecting it with ECS services. Make sure to review and test the configuration carefully to ensure proper functionality.
