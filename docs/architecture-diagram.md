# AWS Architecture Diagram

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                 Internet                                    │
└─────────────────────────┬───────────────────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────────────────────┐
│                        Internet Gateway                                    │
└─────────────────────────┬───────────────────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────────────────────┐
│                          VPC (10.0.0.0/16)                                │
│                                                                             │
│  ┌─────────────────────┐                    ┌─────────────────────┐        │
│  │   Public Subnet 1   │                    │   Public Subnet 2   │        │
│  │   (10.0.1.0/24)     │                    │   (10.0.2.0/24)     │        │
│  │                     │                    │                     │        │
│  │  ┌───────────────┐  │                    │                     │        │
│  │  │  SonarQube    │  │                    │                     │        │
│  │  │  EC2 Instance │  │                    │                     │        │
│  │  │  (t2.medium)  │  │                    │                     │        │
│  │  │               │  │                    │                     │        │
│  │  │  Port 9000    │  │                    │                     │        │
│  │  │  Port 22      │  │                    │                     │        │
│  │  └───────┬───────┘  │                    │                     │        │
│  │          │          │                    │                     │        │
│  │  ┌───────▼───────┐  │                    │                     │        │
│  │  │  EBS Volume   │  │                    │                     │        │
│  │  │  (20GB gp2)   │  │                    │                     │        │
│  │  │  /dev/sdh     │  │                    │                     │        │
│  │  └───────────────┘  │                    │                     │        │
│  └─────────────────────┘                    └─────────────────────┘        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Component Details

### Networking Layer

- **VPC**: `10.0.0.0/16` CIDR block in `ap-southeast-2` region
- **Public Subnets**: Two subnets across different AZs for high availability
  - Subnet 1: `10.0.1.0/24`
  - Subnet 2: `10.0.2.0/24`
- **Internet Gateway**: Provides internet access to public subnets
- **Route Table**: Routes traffic from public subnets to Internet Gateway

### Security

- **Security Group (SonarQube)**:
  - Inbound: Port 9000 (SonarQube Web UI) from `0.0.0.0/0`
  - Inbound: Port 22 (SSH) from `0.0.0.0/0`
  - Outbound: All traffic allowed
- **IAM Role**: `sonarqube-ec2-role` for EC2 instance
- **Instance Profile**: Attached to EC2 for secure AWS API access

### Compute & Storage

- **EC2 Instance**:
  - Type: `t2.medium`
  - AMI: Amazon Linux 2
  - Placement: Public Subnet 1
  - Auto-assigned public IP
- **EBS Volume**:
  - Size: 20GB
  - Type: gp2
  - Attached as `/dev/sdh`
  - Mounted at `/var/sonarqube`

### Application Stack

- **Docker**: Installed via user_data script
- **SonarQube**: Running as Docker container
  - Image: `sonarqube:lts-community`
  - Port mapping: `9000:9000`
  - Persistent volumes for data, logs, and extensions

## Data Flow

1. **Developer pushes code** → GitHub repository
2. **GitHub Actions triggers** → CI/CD pipeline starts
3. **Build & Test** → .NET application compilation and unit tests
4. **SonarQube Analysis** → Code quality analysis sent to SonarQube server
5. **Playwright Tests** → E2E tests validate feature flag behavior
6. **Quality Gates** → Pipeline continues only if all checks pass
7. **Deployment** → Application deployed to AWS (ECS/App Runner/EC2)

## External Integrations

- **GitHub**: Source code repository and CI/CD orchestration
- **LaunchDarkly**: Feature flag management service
- **SonarQube**: Code quality and security analysis
- **Playwright**: End-to-end testing framework

## Scalability Considerations

- **Multi-AZ Setup**: Subnets span multiple availability zones
- **Load Balancer**: Can be added for SonarQube high availability
- **Auto Scaling**: EC2 instances can be placed in Auto Scaling Groups
- **Database**: SonarQube can use RDS for production workloads
