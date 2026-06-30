param publicIpName string
param location string

resource ingressPublicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIpName
  location: location

  sku: {
    name: 'Standard'
  }

  zones: [
    '1'
    '2'
    '3'
  ]

  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

output publicIpId string = ingressPublicIp.id
output publicIpAddress string = ingressPublicIp.properties.ipAddress
