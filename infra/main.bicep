targetScope = 'subscription'


param location string 
param environment string
param projectPrefix string
param logAnalyticsWorkspaceId string
param tags object = {}

var uniqueStringSuffix = uniqueString(subscription().id, resourceGroupName)
var resourceGroupName = '${projectPrefix}-${environment}-RG'
var logicAppName = '${projectPrefix}-${uniqueStringSuffix}'
var hostingPlanName = '${projectPrefix}-hostingplan'
var managedIdentityName = '${projectPrefix}-mgmtidentity'
var keyVaultName = '${take('${logicAppName}', 21)}-kv'
var applicationInsightsName = '${projectPrefix}-appinsights'
var storageAccountName = take(toLower(replace('${projectPrefix}${uniqueStringSuffix}', '-', '')), 24)

resource appResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}



module serverFarm 'br/public:avm/res/web/serverfarm:0.3.0' = {
  scope: appResourceGroup
  name: '${hostingPlanName}-deployment'
  params: {
    name: hostingPlanName
    kind: 'Elastic'
    maximumElasticWorkerCount: 3
    skuName: 'WS1'
  }
}

module mgmtIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  scope: appResourceGroup
  name: '${managedIdentityName}-deployment'
  params: {
    name: managedIdentityName
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  scope: appResourceGroup
  name: '${keyVaultName}-deployment'
  params: {
    name: keyVaultName
    sku: 'standard'
    roleAssignments: [
      { principalId: mgmtIdentity.outputs.principalId, roleDefinitionIdOrName: 'Key Vault Secrets User' }
    ]
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.14.3' = {
  scope: appResourceGroup
  name: '${storageAccountName}-deployment'
  params: {
    name: storageAccountName
    secretsExportConfiguration: { 
      keyVaultResourceId: keyvault.outputs.resourceId
      connectionString1: '${storageAccountName}-connectionstring'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    publicNetworkAccess: 'Enabled'
  }
}

// module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.9.0' = {
//   scope: appResourceGroup
//   name: 'log-webshop-${uniqueString(deployment().name, location)}'
//   params: {
//     name: 'loganaly01'
//   }
// }

module appInsights 'br/public:avm/res/insights/component:0.4.2' = {
  scope: appResourceGroup
  name: '${applicationInsightsName}-deployment'
  params: {
    name: applicationInsightsName
    workspaceResourceId: logAnalyticsWorkspaceId
  }
}

module logicapp 'br/public:avm/res/web/site:0.11.1' = {
  scope: appResourceGroup
  name: '${logicAppName}-deployment'
  params: {
    name: logicAppName
    kind: 'functionapp,workflowapp'
    serverFarmResourceId: serverFarm.outputs.resourceId
    appInsightResourceId: appInsights.outputs.resourceId
    siteConfig: {
      alwaysOn: true
      netFrameworkVersion: 'v8.0'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        mgmtIdentity.outputs.resourceId
      ]
    }
    keyVaultAccessIdentityResourceId: mgmtIdentity.outputs.resourceId
    appSettingsKeyValuePairs: {
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
      WEBSITE_CONTENTSHARE: toLower(projectPrefix)
      APP_KIND: 'workflowApp'
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: '@Microsoft.KeyVault(VaultName=${keyvault.outputs.name};SecretName=${storageAccountName}-connectionstring)'
      AzureWebJobsStorage: '@Microsoft.KeyVault(VaultName=${keyvault.outputs.name};SecretName=${storageAccountName}-connectionstring)'
    }
  }
}
