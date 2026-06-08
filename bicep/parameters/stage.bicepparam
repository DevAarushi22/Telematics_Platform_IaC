using '../main.bicep'

param environment = 'stage'

param location = 'centralindia'

param resourceGroupName = 'telematics-stage-rg'

param clusterName = 'Telematics_Stage_AKS'

param dnsPrefix = 'TelematicsStage'

param kubernetesVersion = '1.35.4'

param networkPlugin = 'azure'
param networkPluginMode = 'overlay'
param networkPolicy = 'none'

param serviceCidr = '10.0.0.0/16'
param dnsServiceIP = '10.0.0.10'
param podCidr = '10.244.0.0/16'

param acrName = 'telematicsplatform'

param keyVaultName = 'telematics-stage-kv'

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
