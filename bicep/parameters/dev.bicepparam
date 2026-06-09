using '../main.bicep'

param environment = 'dev'

param location = 'centralindia'

param resourceGroupName = 'telematics-dev-rg'

param clusterName = 'Telematics_Dev_AKS'

param dnsPrefix = 'TelematicsDev'

param kubernetesVersion = '1.35.4'

param networkPlugin = 'azure'
param networkPluginMode = 'overlay'
param networkPolicy = 'none'

param serviceCidr = '10.0.0.0/16'
param dnsServiceIP = '10.0.0.10'
param podCidr = '10.244.0.0/16'

param acrName = 'telematicsdevacr'
param keyVaultName = 'telematics-dev-kv'

param systemNodePool = {
  name: 'agentpool'
  vmSize: 'Standard_D2ds_v5'
  mode: 'System'
  minCount: 1
  maxCount: 1
  enableAutoScaling: true
  osDiskSizeGB: 128
  osDiskType: 'Managed'
  availabilityZones: [
    '1'
  ]
}

param userNodePool = null
