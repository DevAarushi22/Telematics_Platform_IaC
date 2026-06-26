param keyVaultName string
param location string
param tags object = {}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags

  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }

    tenantId: tenant().tenantId

    enableRbacAuthorization: true
    enabledForTemplateDeployment: true
    publicNetworkAccess: 'Enabled'

    softDeleteRetentionInDays: 90
  }
}

output keyVaultName string = kv.name
output keyVaultId string = kv.id
