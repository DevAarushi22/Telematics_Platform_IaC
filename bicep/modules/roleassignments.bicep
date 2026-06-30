@description('AKS Managed Identity Principal ID')
param principalId string

@description('ACR Name')
param acrId string

@description('Key Vault Name')
param keyVaultId string

param kubeletPrincipalId string
param clusterPrincipalId string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  scope: resourceGroup()
  name: last(split(acrId, '/'))
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  scope: resourceGroup()
  name: last(split(keyVaultId, '/'))
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, principalId, 'AcrPull')

  scope: acr

  properties: {
    principalId: clusterPrincipalId

    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d'
    ) // AcrPull

    principalType: 'ServicePrincipal'
  }
}

resource keyVaultSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, principalId, 'KeyVaultSecretsUser')

  scope: keyVault

  properties: {
    principalId: principalId

    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    ) // Key Vault Secrets User

    principalType: 'ServicePrincipal'
  }
}

resource networkContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, 'NetworkContributor')
  scope: resourceGroup()
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4d97b98b-1d4f-4787-a291-c67834d212e7'
    )
    principalType: 'ServicePrincipal'
  }
}
