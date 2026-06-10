using '../main.bicep'

// param environment = 'stage'

param location = 'centralindia'

param resourceGroupName = 'telematicsrgstgcin01'

param clusterName = 'telematicsaksstgcin01'

param dnsPrefix = 'telematicsstgcin01'

param kubernetesVersion = '1.35.5'

param networkPlugin = 'azure'
param networkPluginMode = 'overlay'
param networkPolicy = 'none'

param serviceCidr = '10.1.0.0/16'
param dnsServiceIP = '10.1.0.10'
param podCidr = '10.245.0.0/16'

param acrName = 'telematicsacrstgcin01'
param keyVaultName = 'telematicskvstgcin01'
param logAnalyticsWorkspaceName = 'telematicslawstgcin01'

param systemNodePool = {
  name: 'agentpool'
  vmSize: 'Standard_D4ds_v5'
  mode: 'System'
  minCount: 1
  maxCount: 2
  enableAutoScaling: true
  osDiskSizeGB: 150
  osDiskType: 'Ephemeral'
  availabilityZones: [
    '1'
    '2'
    '3'
  ]
}

param userNodePool = {
  name: 'userpool'
  vmSize: 'Standard_D2ds_v5'
  mode: 'User'
  minCount: 1
  maxCount: 2
  enableAutoScaling: true
  osDiskSizeGB: 128
  osDiskType: 'Managed'
  availabilityZones: [
    '1'
    '2'
    '3'
  ]
}
