targetScope = 'subscription'

@description('Environment name')
param environment string

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
    environment: environment
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
    principalId: aks.outputs.kubeletIdentity.principalId
    acrName: acrName
    keyVaultName: keyVaultName
  }
}
