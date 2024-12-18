# ProductSecurity-IR-Playbook

A collection of web applications deployed on AWS App Runner using containers, with infrastructure managed by OpenTofu and automated deployments via GitHub Actions.

## Project Structure

.
├── apps/ # Applications directory
│ ├── app1/ # First application
│ │ ├── app/ # Application source code
│ │ ├── docker/ # Docker configuration
│ │ └── infrastructure/# OpenTofu configuration
│ └── app2/ # Second application
│ ├── app/ # Application source code
│ ├── docker/ # Docker configuration
│ └── infrastructure/# OpenTofu configuration
└── .github/workflows/ # GitHub Actions workflows

## Deployment

Applications can be deployed individually using GitHub Actions workflow. To deploy a specific application:

1. Go to Actions tab
2. Select "Deploy Application" workflow
3. Click "Run workflow"
4. Enter the application name (directory name from apps/)

## Available Applications

- app1: Basic Flask application
- app2: [Description of second app]