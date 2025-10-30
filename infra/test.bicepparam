using 'main.bicep'

param location  = 'westeurope'
param projectPrefix = 'LogicAppCiCd'
param environment = 'dev'
param logAnalyticsWorkspaceId = '/subscriptions/320c1690-489d-43e6-865f-239c96117dc7/resourcegroups/central-log-analytics-workspace/providers/microsoft.operationalinsights/workspaces/centralloganalyticsworkspace'
param tags = {
  Owner: 'frederic.luchting@i8c.nl'
}
