@description('Azure location')
param location string

@description('Event Hub namespace name')
param eventHubNamespaceName string

@description('Event Hub namespace SKU')
param skuName string

@description('Event Hub namespace capacity in throughput units')
param capacity int

@description('Enable zone redundancy')
param zoneRedundant bool

@description('Enable Kafka protocol')
param kafkaEnabled bool

@description('Enable auto inflate')
param autoInflateEnabled bool

@description('Maximum throughput units')
param maximumThroughputUnits int

@description('Minimum TLS version')
param minimumTlsVersion string

@description('Public network access')
param publicNetworkAccess string

@description('Disable local/SAS authentication')
param disableLocalAuth bool

@description('Event Hub name')
param eventHubName string

@description('Number of partitions')
param partitionCount int

@description('Message retention in days')
param messageRetentionInDays int

@description('Resource tags')
param tags object = {}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2026-01-01' = {
  name: eventHubNamespaceName
  location: location

  sku: {
    name: skuName
    tier: skuName
    capacity: capacity
  }

  properties: {
    isAutoInflateEnabled: autoInflateEnabled
    maximumThroughputUnits: maximumThroughputUnits
    kafkaEnabled: kafkaEnabled
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: disableLocalAuth
    zoneRedundant: zoneRedundant
  }

  tags: tags
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2026-01-01' = {
  parent: eventHubNamespace
  name: eventHubName

  properties: {
    messageRetentionInDays: messageRetentionInDays
    partitionCount: partitionCount
  }
}

resource basicAccessPolicy 'Microsoft.EventHub/namespaces/authorizationRules@2026-01-01' = {
  parent: eventHubNamespace
  name: 'basicaccesspolicy'

  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}
