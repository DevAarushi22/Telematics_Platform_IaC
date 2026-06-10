targetScope = 'subscription'

@description('Azure location')
param location string

@description('Resource Group Name')
param resourceGroupName string

@description('AKS Cluster Name')
param clusterName string

@description('DNS Prefix')
param dnsPrefix string

@description('Kubernetes Version')
param kubernetesVersion string

param networkPlugin string
param networkPluginMode string
param networkPolicy string

param serviceCidr string
param dnsServiceIP string
param podCidr string

param acrName string
param keyVaultName string
param logAnalyticsWorkspaceName string

param systemNodePool object
param userNodePool object?

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

module monitoring './modules/monitoring.bicep' = {
  name: 'monitoring'
  scope: rg
  params: {
    location: location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module acr './modules/acr.bicep' = {
  name: 'acr'
  scope: rg

  params: {
    acrName: acrName
    location: location
  }
}

module keyVault './modules/keyvault.bicep' = {
  name: 'keyVault'
  scope: rg

  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

module aks './modules/aks.bicep' = {
  name: 'aks'
  scope: rg
  params: {
    location: location
    clusterName: clusterName
    dnsPrefix: dnsPrefix
    kubernetesVersion: kubernetesVersion

    networkPlugin: networkPlugin
    networkPluginMode: networkPluginMode
    networkPolicy: networkPolicy

    serviceCidr: serviceCidr
    dnsServiceIP: dnsServiceIP
    podCidr: podCidr

    systemNodePool: systemNodePool
    userNodePool: userNodePool

    logAnalyticsWorkspaceId: monitoring.outputs.workspaceId
  }
}

module roleAssignments './modules/roleassignments.bicep' = {
  name: 'roleAssignments'
  scope: rg

  params: {
    principalId: aks.outputs.kubeletIdentity.objectId
    acrId: acr.outputs.acrId
    keyVaultId: keyVault.outputs.keyVaultId
  }
}
