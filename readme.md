# Terraform Web Application Infrastructure

This Terraform project provisions a simple web application infrastructure on AWS, including VPC networking and an EC2 instance running a basic Python HTTP server.

## Architecture

The infrastructure consists of:

- **VPC Module**: Creates a Virtual Private Cloud with public subnet, internet gateway, and routing
- **EC2 Module**: Deploys an Ubuntu EC2 instance with security groups and a simple web server

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

## Project Structure

```
.
├── envs
│   ├── dev
│   │   ├── backend.hcl
│   │   └── dev.tfvars
│   └── prod
│       ├── backend.hcl
│       └── prod.tfvars
├── gitignore.tf
├── main.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── providers.tf
├── readme.md
└── variables.tf
```

## Resources Created

### VPC Module
- VPC with DNS support and hostnames enabled
- Internet Gateway
- Public subnet with auto-assign public IP
- Route table with internet gateway route
- Route table association

### EC2 Module
- EC2 instance (Ubuntu 25.04)
- Security group with rules:
  - Inbound: HTTP (port 80) from anywhere
  - Inbound: SSH (port 22) from anywhere (should be restricted)
  - Outbound: All traffic
- User data script to run a Python HTTP server

## Configuration

### Required Variables

Create a `terraform.tfvars` file or pass variables via command line:

```hcl
aws_region         = "us-east-1"
availability_zone  = "us-east-1a"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
route_cidr_block   = "0.0.0.0/0"
instance_type      = "t2.micro"
environment        = "dev"
```

### Backend Configuration

Update `backend.tf` with your S3 bucket details:

```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "webapp/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Usage

### Initialize Terraform

```bash
terraform init
```

### Plan Infrastructure

```bash
terraform plan
```

### Apply Configuration

```bash
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

## Outputs

After successful deployment, Terraform outputs:
- `public_ip`: Public IP address of the EC2 instance
- `public_dns`: Public DNS name of the EC2 instance

Access the web server at `http://<public_ip>` to see "Hello from Terraform!"

## Security Considerations

⚠️ **Important Security Notes:**

1. **SSH Access**: The security group allows SSH from anywhere (`0.0.0.0/0`). Restrict this to your IP:
   ```hcl
   cidr_ipv4 = "YOUR_IP/32"
   ```

2. **HTTP Access**: Port 80 is open to the internet. Consider adding authentication or restricting access.

3. **State File**: Ensure your S3 backend bucket has:
   - Versioning enabled
   - Encryption at rest
   - Proper access controls

## Customization

### Change Instance Type

Modify the `instance_type` variable in your `terraform.tfvars`:

```hcl
instance_type = "t3.small"
```

### Modify Network CIDR

Adjust VPC and subnet CIDR blocks:

```hcl
vpc_cidr           = "10.1.0.0/16"
public_subnet_cidr = "10.1.1.0/24"
```

### Update User Data Script

Edit the `user_data` section in `modules/ec2/main.tf` to customize the web server behavior.

## Troubleshooting

### Instance Not Accessible

1. Verify security group rules allow inbound traffic on port 80
2. Check that the instance has a public IP assigned
3. Ensure the subnet has internet gateway routing configured

### Terraform State Issues

If using S3 backend, ensure:
- Bucket exists and is accessible
- AWS credentials have appropriate permissions
- Region is correctly specified

## Contributing

When making changes:
1. Test in a development environment first
2. Update this README if adding new resources
3. Follow Terraform best practices for module design

## License

[Specify your license here]
