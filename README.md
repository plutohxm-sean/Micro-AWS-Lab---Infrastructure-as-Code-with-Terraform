# Micro AWS Lab - Infrastructure as Code with Terraform

## Overview

Micro AWS Lab merupakan implementasi Infrastructure as Code (IaC) menggunakan Terraform untuk melakukan deployment dan pengelolaan infrastruktur AWS secara otomatis. Proyek ini menggabungkan layanan serverless dan containerized workloads dalam satu lingkungan cloud yang terintegrasi.

Tujuan utama dari proyek ini adalah mempelajari proses provisioning resource AWS menggunakan Terraform, memahami integrasi antar layanan AWS, serta menerapkan praktik otomatisasi infrastruktur yang umum digunakan dalam lingkungan cloud modern.

---

## Architecture

Arsitektur yang dibangun terdiri dari beberapa komponen utama:

```text
                    +-------------------+
                    |    API Gateway    |
                    +---------+---------+
                              |
                              v
                    +-------------------+
                    | Lambda Function   |
                    +---------+---------+
                              |
                              v
                    +-------------------+
                    |   EC2 Instance    |
                    | Dockerized App    |
                    +---------+---------+
                              |
                +-------------+-------------+
                |                           |
                v                           v
      +-------------------+     +-------------------+
      |    Amazon S3      |     |    Amazon ECR     |
      |   Object Storage  |     | Container Registry|
      +-------------------+     +-------------------+
```

---

## Infrastructure Components

### Network Infrastructure

The following networking resources are provisioned:

| Resource                      | Purpose                 |
| ----------------------------- | ----------------------- |
| VPC                           | Isolated cloud network  |
| Internet Gateway              | Internet connectivity   |
| Public Subnet                 | Public-facing resources |
| Route Table                   | Network routing         |
| Route Table Association       | Route assignment        |
| Security Group                | Traffic filtering       |
| Availability Zone Data Source | Dynamic AZ selection    |

### Compute Resources

#### EC2 Instance

Configuration:

| Parameter        | Value                |
| ---------------- | -------------------- |
| Operating System | Amazon Linux         |
| Instance Type    | t3.micro             |
| Subnet           | Public Subnet        |
| IAM Profile      | EC2 Instance Profile |

Responsibilities:

* Docker host
* Application runtime environment
* Backend service execution

### Serverless Resources

#### AWS Lambda

Lambda functions provide event-driven compute capabilities and expose application functionality through API Gateway.

#### API Gateway

API Gateway acts as the public entry point for serverless workloads and forwards requests to Lambda functions.

### Storage Resources

#### Amazon S3

Used for:

* File storage
* Object management
* Application assets

#### Lifecycle Configuration

Lifecycle policies are configured to automatically manage object retention and reduce storage costs.

### Container Registry

#### Amazon ECR

Used to:

* Store Docker images
* Version application containers
* Support CI/CD deployment workflows

### Identity and Access Management

The environment uses dedicated IAM roles and policies for:

* EC2 access permissions
* Lambda execution permissions
* Secure interaction with AWS services

---

## Terraform Resources

The deployment provisions approximately 24 AWS resources.

### Network Resources

```text
aws_vpc.main
aws_internet_gateway.main
aws_subnet.public
aws_route_table.public
aws_route_table_association.public
aws_security_group.web
data.aws_availability_zones.available
```

### Compute Resources

```text
aws_instance.web
aws_iam_instance_profile.ec2
```

### Serverless Resources

```text
aws_lambda_function.api
aws_api_gateway_rest_api.api
aws_api_gateway_resource.proxy
aws_api_gateway_method.proxy
aws_api_gateway_integration.lambda
aws_api_gateway_deployment.api
aws_api_gateway_stage.dev
```

### Storage and Registry Resources

```text
aws_s3_bucket.storage
aws_s3_bucket_lifecycle_configuration.cleanup
aws_ecr_repository.app
aws_ecr_lifecycle_policy.app_policy
```

### IAM Resources

```text
aws_iam_role.ec2
aws_iam_role_policy.ec2
aws_iam_role.lambda
aws_iam_role_policy.lambda
aws_lambda_permission.api_gw
```

---

## Deployment Workflow

```text
Terraform
    |
    v
Provision AWS Resources
    |
    +--> VPC
    +--> EC2
    +--> IAM
    +--> Lambda
    +--> API Gateway
    +--> S3
    +--> ECR
    |
    v
User Data Execution
    |
    +--> Install Docker
    +--> Install AWS CLI
    +--> Build Container
    +--> Start Application
    |
    v
Application Ready
```

---

## User Data Automation

The EC2 instance executes an initialization script during first boot.

Automated tasks include:

1. System update
2. Docker installation
3. AWS CLI installation
4. Docker Compose installation
5. Amazon ECR authentication
6. Node.js application deployment
7. Docker image build
8. Container execution
9. Systemd service registration
10. Service auto-start configuration

Expected provisioning time:

| Stage                  | Duration       |
| ---------------------- | -------------- |
| System preparation     | 0–30 seconds   |
| Docker installation    | 30–60 seconds  |
| Application deployment | 60–90 seconds  |
| Container startup      | 90–120 seconds |
| Service availability   | ~2 minutes     |

---

## Terraform Outputs

After deployment, Terraform provides useful output values.

Available outputs:

```bash
terraform output
```

Example:

```bash
terraform output api_url
terraform output ec2_public_ip
terraform output ecr_url
terraform output s3_bucket
```

Outputs include:

* API Gateway endpoint
* EC2 public IP address
* EC2 application URL
* ECR repository URL
* S3 bucket name
* Lambda function name

---

## Terraform State Management

Terraform maintains infrastructure state using the state file.

Common commands:

```bash
terraform show

terraform state list

terraform state show aws_instance.web

terraform import aws_instance.web INSTANCE_ID
```

Important considerations:

* Do not manually edit the state file.
* Do not commit state files to version control.
* Use remote state storage for collaborative environments.
* Store state securely using Amazon S3 and DynamoDB locking.

---

## Deployment

Initialize Terraform:

```bash
terraform init
```

Review execution plan:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply -auto-approve
```

Display outputs:

```bash
terraform output
```

Destroy infrastructure:

```bash
terraform destroy -auto-approve
```

---

## Cost Estimation

Estimated monthly costs:

| Service        | Estimated Cost  |
| -------------- | --------------- |
| EC2 t3.micro   | Free Tier / ~$8 |
| Lambda         | Free Tier       |
| API Gateway    | Free Tier       |
| Amazon S3      | Pay-as-you-use  |
| Amazon ECR     | 500 MB free     |
| VPC Components | Minimal         |

Estimated total monthly cost:

```text
$0 – $15 USD
```

depending on usage and Free Tier eligibility.

---

## Learning Outcomes

Through this project, users will gain experience with:

* Terraform fundamentals
* Infrastructure as Code practices
* AWS networking concepts
* Serverless application deployment
* Container deployment on EC2
* IAM and security management
* Resource lifecycle management
* Automated cloud provisioning

---

## Author

Micro AWS Lab

Infrastructure as Code Project using Terraform and AWS Cloud Services.
