@description('Azure region')
param location string

@description('AKS cluster name')
param clusterName string

@description('DNS Prefix')
param dnsPrefix string

@description('Kubernetes version')
param kubernetesVersion string

param networkPlugin string
param networkPluginMode string
param networkPolicy string

param serviceCidr string
param dnsServiceIP string
param podCidr string

param systemNodePool object
param userNodePool object?

param logAnalyticsWorkspaceId string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }

  sku: {
    name: 'Base'
    tier: 'Standard'
  }

  properties: {
    kubernetesVersion: kubernetesVersion

    dnsPrefix: dnsPrefix

    enableRBAC: true

    oidcIssuerProfile: {
      enabled: true
    }

    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }

    autoUpgradeProfile: {
      upgradeChannel: 'stable'
      nodeOSUpgradeChannel: 'NodeImage'
    }

    networkProfile: {
      networkPlugin: networkPlugin
      networkPluginMode: networkPluginMode
      networkPolicy: networkPolicy

      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      podCidr: podCidr

      loadBalancerSku: 'standard'
    }

    agentPoolProfiles: [
      {
        name: systemNodePool.name
        mode: systemNodePool.mode
        count: systemNodePool.minCount

        vmSize: systemNodePool.vmSize

        enableAutoScaling: systemNodePool.enableAutoScaling
        minCount: systemNodePool.minCount
        maxCount: systemNodePool.maxCount

        osDiskSizeGB: systemNodePool.osDiskSizeGB
        osDiskType: systemNodePool.osDiskType

        availabilityZones: systemNodePool.availabilityZones

        type: 'VirtualMachineScaleSets'
      }
    ]

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    }
  }
}

resource userPool 'Microsoft.ContainerService/managedClusters/agentPools@2024-05-01' = if (userNodePool != null) {
  name: userNodePool!.name
  parent: aksCluster

  properties: {
    mode: userNodePool!.mode

    vmSize: userNodePool!.vmSize

    enableAutoScaling: userNodePool!.enableAutoScaling
    minCount: userNodePool!.minCount
    maxCount: userNodePool!.maxCount

    osDiskSizeGB: userNodePool!.osDiskSizeGB
    osDiskType: userNodePool!.osDiskType

    availabilityZones: userNodePool!.availabilityZones

    type: 'VirtualMachineScaleSets'
  }
}

output clusterName string = aksCluster.name
output kubeletIdentity object = aksCluster.properties.identityProfile.kubeletidentity
