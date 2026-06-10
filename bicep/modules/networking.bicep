@description('Azure Region')
param location string

@description('Virtual Network Name')
param vnetName string

@description('VNet Address Space')
param vnetAddressSpace array

@description('AKS Subnet Name')
param aksSubnetName string

@description('AKS Subnet Prefix')
param aksSubnetPrefix string

@description('Ingress Subnet Name')
param ingressSubnetName string

@description('Ingress Subnet Prefix')
param ingressSubnetPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }

    subnets: [
      {
        name: aksSubnetName
        properties: {
          addressPrefix: aksSubnetPrefix
        }
      }

      {
        name: ingressSubnetName
        properties: {
          addressPrefix: ingressSubnetPrefix
        }
      }
    ]
  }
}

resource aksSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  parent: vnet
  name: aksSubnetName
}

output vnetId string = vnet.id
output aksSubnetId string = aksSubnet.id
