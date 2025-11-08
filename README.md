# Logic App CI/CD

This repository is a simple demo of how to implement CI/CD for Azure Logic Apps using Bicep and GitHub Actions.

## Infra

Hosting plan, Functionapp site, Application Insights and a storage account, all the basic setup.

- Just provide an existing Log Analytics Workspace ID for monitoring. 

## Application

A key aspect was to have all workflow code running in a local developers environment, and deploy from there to Azure.  
All environment specific settings are in local.settings.json, or environment variables when running in Azure. All secrets are in Key Vault.



## Links

Infrastructure as Code with Bicep and Azure Verified Modules  
https://azuretechinsider.com/deploying-logic-app-standard-with-bicep-a-step-by-step-guide/

Application deployment with GitHub Actions  
https://github.com/karlrissland/Logic-App-Standard-Deployment

## Deployment

Test subscription on Azure