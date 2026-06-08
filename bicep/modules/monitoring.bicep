@description('Azure Region')
param location string

@description('Environment Name')
param environment string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'telematics-${environment}-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

output workspaceId string = logAnalyticsWorkspace.id

output workspaceName string = logAnalyticsWorkspace.name

output workspaceCustomerId string = logAnalyticsWorkspace.properties.customerId
