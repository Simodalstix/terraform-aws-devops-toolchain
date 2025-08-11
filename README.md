# Developer Tooling Integration Lab

This project demonstrates a reproducible internal tooling environment using Terraform on AWS to deploy and integrate SonarQube, LaunchDarkly, and Playwright into a .NET 8 minimal API sample application’s CI/CD pipeline.

## Project Overview

The goal is to build a robust, automated, and scalable developer toolchain that mirrors what a modern DevOps or Platform Engineering team would provide to internal development teams.

### Core Components:

- **Infrastructure as Code (IaC):** Terraform is used to provision all necessary AWS resources, ensuring the environment is version-controlled and easily reproducible.
- **Application:** A standard .NET 8 minimal API serves as the sample application.
- **CI/CD:** GitHub Actions orchestrates the entire build, test, and deployment pipeline.
- **Quality Gate:** SonarQube is integrated for static code analysis to maintain code quality.
- **Feature Flagging:** LaunchDarkly is used to manage feature toggles within the application.
- **End-to-End Testing:** Playwright provides automated E2E tests to validate application behavior.

### High-Level Architecture

The architecture consists of:

1.  **AWS Foundation:** A VPC with public and private subnets, security groups, and IAM roles.
2.  **SonarQube:** Deployed on an EC2 instance with a persistent EBS volume for data.
3.  **Application Environment:** The .NET application will be deployed to a suitable AWS service like App Runner or ECS.
4.  **GitHub Actions Pipeline:** A workflow that automates the following stages:
    - Code checkout and build.
    - SonarQube analysis.
    - Playwright E2E tests (interacting with LaunchDarkly).
    - Conditional deployment to AWS based on test and quality gate results.
