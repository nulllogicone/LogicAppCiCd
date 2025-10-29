param location string = resourceGroup().location
param environmentName string
param logicAppName string = 'logic-${environmentName}'

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    state: 'Enabled'
    definition: loadJsonContent('../src/workflow.json')
  }
}

output logicAppResourceId string = logicApp.id
