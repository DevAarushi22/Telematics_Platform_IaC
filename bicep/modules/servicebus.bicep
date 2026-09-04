@description('Azure location')
param location string

@description('Service Bus namespace name')
param serviceBusNamespaceName string

@description('Service Bus namespace SKU')
param serviceBusSkuName string

@description('Service Bus namespace capacity')
param serviceBusCapacity int

@description('Enable zone redundancy')
param serviceBusZoneRedundant bool

@description('Minimum TLS version')
param serviceBusMinimumTlsVersion string

@description('Public network access')
param serviceBusPublicNetworkAccess string

@description('Disable local/SAS authentication')
param serviceBusDisableLocalAuth bool

@description('Public network access IP address type')
param serviceBusPublicNetworkAccessIpAddressType string

@description('Premium messaging partitions')
param serviceBusPremiumMessagingPartitions int

@description('Service Bus queues')
param serviceBusQueues array

@description('Service Bus topics')
param serviceBusTopics array

@description('Service Bus topic subscriptions')
param serviceBusSubscriptions array

@description('Namespace authorization rule name')
param serviceBusAuthorizationRuleName string

@description('Resource tags')
param tags object = {}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: serviceBusNamespaceName
  location: location

  sku: {
    name: serviceBusSkuName
    tier: serviceBusSkuName
    capacity: serviceBusCapacity
  }

  properties: {
    minimumTlsVersion: serviceBusMinimumTlsVersion
    publicNetworkAccess: serviceBusPublicNetworkAccess
    disableLocalAuth: serviceBusDisableLocalAuth
    publicNetworkAccessIpAddressType: serviceBusPublicNetworkAccessIpAddressType
    premiumMessagingPartitions: serviceBusPremiumMessagingPartitions
    zoneRedundant: serviceBusZoneRedundant
  }

  tags: tags
}

resource queues 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = [
  for queue in serviceBusQueues: {
    parent: serviceBusNamespace
    name: queue.name

    properties: {
      lockDuration: queue.lockDuration
      maxDeliveryCount: queue.maxDeliveryCount
      maxSizeInMegabytes: queue.maxSizeInMegabytes
      defaultMessageTimeToLive: queue.defaultMessageTimeToLive
      maxMessageSizeInKilobytes: queue.maxMessageSizeInKilobytes
      requiresDuplicateDetection: queue.requiresDuplicateDetection
      requiresSession: queue.requiresSession
      enablePartitioning: queue.enablePartitioning
      enableExpress: queue.enableExpress
      enableBatchedOperations: queue.enableBatchedOperations
      deadLetteringOnMessageExpiration: queue.deadLetteringOnMessageExpiration
    }
  }
]

resource topics 'Microsoft.ServiceBus/namespaces/topics@2024-01-01' = [
  for topic in serviceBusTopics: {
    parent: serviceBusNamespace
    name: topic.name

    properties: {
      defaultMessageTimeToLive: topic.defaultMessageTimeToLive
      maxSizeInMegabytes: topic.maxSizeInMegabytes
      maxMessageSizeInKilobytes: topic.maxMessageSizeInKilobytes
      requiresDuplicateDetection: topic.requiresDuplicateDetection
      enablePartitioning: topic.enablePartitioning
      enableExpress: topic.enableExpress
      enableBatchedOperations: topic.enableBatchedOperations
      supportOrdering: topic.supportOrdering
    }
  }
]

resource subscriptions 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2024-01-01' = [
  for subscription in serviceBusSubscriptions: {
    parent: topics[indexOf(serviceBusTopics, filter(serviceBusTopics, topic => topic.name == subscription.topicName)[0])]
    name: subscription.name

    properties: {
      lockDuration: subscription.lockDuration
      maxDeliveryCount: subscription.maxDeliveryCount
      defaultMessageTimeToLive: subscription.defaultMessageTimeToLive
      deadLetteringOnMessageExpiration: subscription.deadLetteringOnMessageExpiration
      deadLetteringOnFilterEvaluationExceptions: subscription.deadLetteringOnFilterEvaluationExceptions
      requiresSession: subscription.requiresSession
    }
  }
]

resource authorizationRule 'Microsoft.ServiceBus/namespaces/authorizationRules@2024-01-01' = {
  parent: serviceBusNamespace
  name: serviceBusAuthorizationRuleName

  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}
