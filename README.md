# Developer Tooling Integration Lab

A comprehensive DevOps toolchain demonstrating the integration of SonarQube, LaunchDarkly, and Playwright with a .NET 8 minimal API using Terraform, AWS, and GitHub Actions.

## Project Overview

This project showcases how a modern Platform Engineering team would provision, integrate, and manage developer tooling for multiple development teams. It provides a complete, reproducible environment that can be deployed with a single command.

### Architecture Components

- **Infrastructure as Code**: Terraform provisions all AWS resources
- **Application**: .NET 8 minimal API with Todo functionality
- **Code Quality**: SonarQube for static analysis and quality gates
- **Feature Management**: LaunchDarkly for feature flag control
- **Testing**: Playwright for end-to-end test automation
- **CI/CD**: GitHub Actions for complete pipeline automation

## Quick Start

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.12.2
- .NET 8 SDK
- Node.js 18+
- An existing EC2 key pair in your AWS account

### 1. Infrastructure Deployment

```bash
# Clone the repository
git clone <your-repo-url>
cd terraform-aws-devops-toolchain

# Navigate to Terraform directory
cd terraform

# Create terraform.tfvars file
echo 'key_name = "your-ec2-key-pair-name"' > terraform.tfvars

# Initialize and deploy infrastructure
terraform init
terraform plan
terraform apply
```

### 2. Configure External Services

#### SonarQube Setup

1. Access SonarQube at the IP address from Terraform output
2. Default credentials: `admin/admin` (change immediately)
3. Create a new project and generate a token
4. Add the token to GitHub Secrets as `SONAR_TOKEN`
5. Add SonarQube URL to GitHub Secrets as `SONAR_HOST_URL`

#### LaunchDarkly Setup

1. Create a LaunchDarkly account
2. Create a new project and environment
3. Create a feature flag named `show-new-greeting`
4. Add your SDK key to GitHub Secrets as `LAUNCHDARKLY_SDK_KEY`

### 3. GitHub Actions Configuration

Add these secrets to your GitHub repository:

```
AWS_ACCESS_KEY_ID=<your-aws-access-key>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-key>
SONAR_TOKEN=<sonarqube-project-token>
SONAR_HOST_URL=http://<sonarqube-ip>:9000
LAUNCHDARKLY_SDK_KEY=<your-launchdarkly-sdk-key>
```

### 4. Run the Application Locally

```bash
# Set LaunchDarkly SDK key in appsettings.json
# Then run the application
dotnet run

# Test the feature flag endpoint
curl http://localhost:5000/
```

### 5. Run Tests

```bash
# Navigate to tests directory
cd tests

# Install dependencies
npm install
npm run install-browsers

# Run Playwright tests
npm test
```

## Features Demonstrated

### Infrastructure as Code

- VPC with public subnets across multiple AZs
- EC2 instance running SonarQube with Docker
- EBS volume for persistent SonarQube data
- Security groups with appropriate access controls
- IAM roles following least privilege principles

### Application Integration

- .NET 8 minimal API with modern patterns
- LaunchDarkly SDK integration for feature flags
- Feature-flagged endpoint demonstrating toggle functionality
- Todo API for comprehensive testing scenarios

### Quality Assurance

- SonarQube analysis integrated into CI/CD
- Quality gates preventing deployment of poor code
- Playwright E2E tests validating feature flag behavior
- Automated testing in headless browser environments

### CI/CD Pipeline

- Multi-stage pipeline with proper job dependencies
- Parallel execution where appropriate
- Artifact management for test reports
- Conditional deployment based on quality gates
- AWS deployment automation

## Documentation

- [Architecture Diagram](docs/architecture-diagram.md) - Detailed infrastructure layout
- [Playwright Tests](tests/setup.md) - Testing framework setup

## Development Team Adoption Guide

### For Development Teams

1. Fork this repository for your project
2. Customize the .NET application with your business logic
3. Add your feature flags in LaunchDarkly
4. Extend Playwright tests for your specific scenarios
5. Configure SonarQube rules for your coding standards

### For Platform Teams

1. Customize Terraform modules for organizational standards
2. Add monitoring and alerting (CloudWatch, Datadog, etc.)
3. Implement backup strategies for SonarQube data
4. Set up multi-environment deployments (dev/staging/prod)
5. Add security scanning tools to the pipeline

### Best Practices Implemented

- Secrets management via GitHub Secrets and AWS Secrets Manager
- Infrastructure versioning with Terraform state management
- Quality gates preventing broken code deployment
- Feature flag testing ensuring toggle reliability
- Automated rollback capabilities in deployment pipeline

## Troubleshooting

### Common Issues

1. **SonarQube not accessible**: Check security group rules and EC2 instance status
2. **Feature flags not working**: Verify LaunchDarkly SDK key configuration
3. **Playwright tests failing**: Ensure application is running and accessible
4. **Terraform apply errors**: Check AWS permissions and resource limits

### Debug Commands

```bash
# Check SonarQube logs
ssh -i your-key.pem ec2-user@<sonarqube-ip>
docker logs sonarqube

# Run Playwright in debug mode
cd tests && npm run test:debug
```

## License

This project is licensed under the MIT License.
