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

param serviceBusNamespaceName = 'telematicssbprodcin01'
param serviceBusSkuName = 'Standard'
param serviceBusCapacity = 0
param serviceBusZoneRedundant = true
param serviceBusMinimumTlsVersion = '1.2'
param serviceBusPublicNetworkAccess = 'Enabled'
param serviceBusDisableLocalAuth = false
param serviceBusPublicNetworkAccessIpAddressType = 'IPv4'
param serviceBusPremiumMessagingPartitions = 0

param serviceBusAuthorizationRuleName = 'SASKeyTelematicsProd'

param serviceBusQueues = [
  {
    name: 'email-notifications'
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    maxMessageSizeInKilobytes: 256
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    deadLetteringOnMessageExpiration: false
  }
  {
    name: 'inapp-notifications'
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    maxMessageSizeInKilobytes: 256
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    deadLetteringOnMessageExpiration: false
  }
  {
    name: 'push-notifications'
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    maxMessageSizeInKilobytes: 256
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    deadLetteringOnMessageExpiration: false
  }
  {
    name: 'report-requests'
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    maxMessageSizeInKilobytes: 256
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    deadLetteringOnMessageExpiration: false
  }
  {
    name: 'sms-notifications'
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
    maxMessageSizeInKilobytes: 256
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    deadLetteringOnMessageExpiration: false
  }
]

param serviceBusTopics = [
  {
    name: 'notification-events'
    defaultMessageTimeToLive: 'P14D'
    maxSizeInMegabytes: 1024
    maxMessageSizeInKilobytes: 256
    requiresDuplicateDetection: false
    enablePartitioning: false
    enableExpress: false
    enableBatchedOperations: true
    supportOrdering: false
  }
]

param serviceBusSubscriptions = [
  {
    name: 'notification-orchestrator-sub'
    topicName: 'notification-events'
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    defaultMessageTimeToLive: 'P14D'
    deadLetteringOnMessageExpiration: false
    deadLetteringOnFilterEvaluationExceptions: false
    requiresSession: false
  }
]

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
