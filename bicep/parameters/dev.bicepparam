using '../main.bicep'

// param environment = 'dev'

param location = 'centralindia'

param resourceGroupName = 'telematicsrgdevcin01'

param clusterName = 'telematicsaksdevcin01'

param dnsPrefix = 'telematicsdevcin01'

param kubernetesVersion = '1.35.5'

param networkPlugin = 'azure'
param networkPluginMode = 'overlay'
param networkPolicy = 'none'

param serviceCidr = '10.0.0.0/16'
param dnsServiceIP = '10.0.0.10'
param podCidr = '10.244.0.0/16'

param acrName = 'telematicsacrdevcin01'
param keyVaultName = 'telematicskvdevcin01'
param logAnalyticsWorkspaceName = 'telematicslawdevcin01'

param systemNodePool = {
  name: 'agentpool'
  vmSize: 'Standard_D4ds_v5'
  mode: 'System'
  minCount: 1
  maxCount: 3
  enableAutoScaling: true
  osDiskSizeGB: 128
  osDiskType: 'Managed'
  availabilityZones: [
    '1'
  ]
}

param tags = {
  Environment: 'Development'
  Project: 'Telematics'
  ManagedBy: 'Bicep'
  Owner: 'DevOps'
}

param userNodePool = null

param vnetName = 'telematicsvnetdevcin01'

param vnetAddressSpace = [
  '10.10.0.0/16'
]

param aksSubnetName = 'telematicsakssnetdevcin01'
param aksSubnetPrefix = '10.10.0.0/22'

param ingressSubnetName = 'telematicsingresssnetdevcin01'
param ingressSubnetPrefix = '10.10.4.0/24'
