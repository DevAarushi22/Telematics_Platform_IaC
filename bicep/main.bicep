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

param vnetName string
param vnetAddressSpace array

param aksSubnetName string
param aksSubnetPrefix string

param ingressSubnetName string
param ingressSubnetPrefix string

param acrName string
param keyVaultName string
param logAnalyticsWorkspaceName string

param systemNodePool object
param userNodePool object?

param ingressPublicIpName string

param tags object = {}

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

module networking './modules/networking.bicep' = {
  name: 'networking'
  scope: resourceGroup(resourceGroupName)

  params: {
    location: location
    vnetName: vnetName
    vnetAddressSpace: vnetAddressSpace
    aksSubnetName: aksSubnetName
    aksSubnetPrefix: aksSubnetPrefix
    ingressSubnetName: ingressSubnetName
    ingressSubnetPrefix: ingressSubnetPrefix
  }
}

module publicIp './modules/publicip.bicep' = {
  name: 'publicIp'
  scope: rg

  params: {
    publicIpName: ingressPublicIpName
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

    aksSubnetId: networking.outputs.aksSubnetId

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
    kubeletPrincipalId: aks.outputs.kubeletIdentity.objectId
    clusterPrincipalId: aks.outputs.clusterPrincipalId
    acrId: acr.outputs.acrId
    keyVaultId: keyVault.outputs.keyVaultId
  }
}
