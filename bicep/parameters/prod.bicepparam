using '../main.bicep'

// param environment = ''

param location = 'centralindia'

param resourceGroupName = 'telematicsrgprodcin01'

param clusterName = 'telematicsaksprodcin01'

param dnsPrefix = 'telematicsprodcin01'

param ingressPublicIpName = 'telematicsprodingresspipcin01'

param kubernetesVersion = '1.35.5'

param networkPlugin = 'azure'
param networkPluginMode = 'overlay'
param networkPolicy = 'none'

param serviceCidr = '10.0.0.0/16'
param dnsServiceIP = '10.0.0.10'
param podCidr = '10.246.0.0/16'

param acrName = 'telematicsacrprodcin01'
param keyVaultName = 'telematicskvprodcin01'
param logAnalyticsWorkspaceName = 'telematicslawprodcin01'

param eventHubNamespaceName = 'telematicsehprodcin01'
param eventHubName = 'prod_telematics_platform'

param eventHubSkuName = 'Standard'
param eventHubCapacity = 10
param eventHubZoneRedundant = true
param eventHubKafkaEnabled = true
param eventHubAutoInflateEnabled = false
param eventHubMaximumThroughputUnits = 0
param eventHubMinimumTlsVersion = '1.2'
param eventHubPublicNetworkAccess = 'Enabled'
param eventHubDisableLocalAuth = false

param eventHubPartitionCount = 32
param eventHubMessageRetentionInDays = 1

param systemNodePool = {
  name: 'agentpool'
  vmSize: 'Standard_D4ads_v5'
  mode: 'System'
  enableAutoScaling: true
  minCount: 1
  maxCount: 2
  osDiskSizeGB: 150
  osDiskType: 'Ephemeral'
  availabilityZones: [
    '1'
  ]
}

param userNodePool = {
  name: 'userpool'
  vmSize: 'Standard_D2ads_v5'
  mode: 'User'
  enableAutoScaling: true
  minCount: 1
  maxCount: 2
  osDiskSizeGB: 75
  osDiskType: 'Ephemeral'
  availabilityZones: [
    '1'
  ]
}

param tags = {
  Environment: 'Production'
  Project: 'Telematics'
  ManagedBy: 'Bicep'
  Owner: 'DevOps'
}

param vnetName = 'telematicsvnetprodcin01'

param vnetAddressSpace = [
  '10.30.0.0/16'
]

param aksSubnetName = 'telematicsakssnetprodcin01'
param aksSubnetPrefix = '10.30.0.0/22'

param ingressSubnetName = 'telematicsingresssnetprodcin01'
param ingressSubnetPrefix = '10.30.4.0/24'
