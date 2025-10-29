# Logic App CI/CD Demo

This project demonstrates a Logic App deployment with CI/CD pipelines using Azure DevOps.

## Project Structure

- `src/` - Contains the Logic App workflow definition
- `infrastructure/` - Contains the Bicep infrastructure code
- `pipelines/` - Contains the Azure DevOps pipeline definitions
  - `infrastructure-pipeline.yml` - Pipeline for deploying infrastructure
  - `logicapp-pipeline.yml` - Pipeline for deploying Logic App workflow

## Setup Instructions

1. Create an Azure Service Connection in your Azure DevOps project:
   - Go to Project Settings > Service Connections
   - Create a new Azure Resource Manager service connection
   - Name it and note the name to use in the pipelines

2. Configure Pipeline Variables:
   Set the following variables in your Azure DevOps pipeline:
   - `azureSubscription` - Name of your Azure Service Connection
   - `resourceGroup` - Target resource group name
   - `location` - Azure region (e.g., 'westeurope')

3. Create the resource group if it doesn't exist:
   ```powershell
   az group create --name {your-resource-group} --location {your-location}
   ```

## Pipeline Configuration

1. Infrastructure Pipeline (`infrastructure-pipeline.yml`):
   - Triggered on changes to infrastructure/* files
   - Deploys Bicep templates to create/update resources
   - Deploys to test and prod environments sequentially

2. Logic App Pipeline (`logicapp-pipeline.yml`):
   - Triggered on changes to src/* files
   - Deploys Logic App workflow definition
   - Deploys to test and prod environments sequentially

## Development

1. Make changes to the Logic App workflow in `src/workflow.json`
2. Commit and push changes
3. The pipelines will automatically deploy to test environment first
4. After validation, changes will be deployed to production

## Environment Setup

The pipelines are configured to deploy to both test and prod environments. Make sure to:
1. Configure environments in Azure DevOps
2. Set up appropriate approval gates for production deployments
3. Configure environment-specific variables if needed