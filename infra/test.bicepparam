using 'main.bicep'

param location  = 'westeurope'
param projectPrefix = 'LogicAppCiCd'
param environment = 'dev'
param logAnalyticsWorkspaceId = 'PLACEHOLDER: add variable to GitHub settings named LOG_ANALYTICS_WORKSPACE_ID'
param tags = {
  Owner: 'frederic.luchting@i8c.nl'
}
