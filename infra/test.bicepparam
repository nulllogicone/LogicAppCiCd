using 'main.bicep'

param location  = 'westeurope'
param projectPrefix = 'LogicAppCiCd'
param environment = 'dev'
param logAnalyticsWorkspaceId = 'PLACEHOLDER: add variable to GitHub settings named LOG_ANALYTICS_WORKSPACE_ID'
param tags = {
  Owner: 'frederic.luchting@i8c.nl'
  Description: 'Simple Logic App to show CI/CD with Bicep and GitHub Actions for infra and application code.'
  Remarks: 'Please delete Logic App instance and hosting plan when you dont need it anymore, recreate by pipline when needed.'
  Environment: 'experimental'
}
