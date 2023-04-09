param deployment string
param deploymentID string
param vNETName string
param DNSServers array
param addressPrefixesCurrent array
param SubnetInfo array
param SubnetInfoCurrent array

var AppId = 6
var regionNumber = 9
var network = {
  first: 10
  second: 248
  third: 248
}

var networkId = {
  upper: '${network.first}.${network.second - (8 * int(regionNumber)) + AppId}'
  lower: '${network.third - (8 * int(deploymentID))}'
}

var addressPrefixes = [
  '${networkId.upper}.${networkId.lower}.0/21'
]

var lowerLookup = {
  snWAF01: 1
  AzureFirewallSubnet: 1
  snFE01: 2
  snMT01: 4
  snBE01: 6
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = [for (sn, index) in SubnetInfo: {
  name: '${deployment}-nsg${sn.name}'
}]

var SNCurrent = [for (item, index) in SubnetInfoCurrent: {
  name: item.name
  properties: {
    addressPrefix: item.properties.addressPrefix
    networkSecurityGroup: item.properties.?networkSecurityGroup //optional
    natGateway: item.properties.?natGateway //optional
    privateEndpointNetworkPolicies: item.properties.?privateEndpointNetworkPolicies //optional
    privateLinkServiceNetworkPolicies: item.properties.?privateLinkServiceNetworkPolicies //optional
    // serviceEndpoints: item.properties.serviceEndpoints
    // delegations: item.properties.delegations
    // routeTable: item.properties.routeTable
  }
}]

// Ensure propeties above and below match to ensure success in union()

var subnetsNew = [for (sn, index) in SubnetInfo: {
  name: sn.name
  properties: {
    addressPrefix: '${networkId.upper}.${contains(lowerLookup, sn.name) ? int(networkId.lower) + (1 * lowerLookup[sn.name]) : networkId.lower}.${sn.Prefix}'
    networkSecurityGroup: !(contains(sn, 'NSG') && bool(sn.NSG)) ? null : /*
        */ {
      id: contains(sn, 'NSGID') ? sn.NSGID : NSG[index].id
    }
    natGateway: !(contains(sn, 'NGW') && bool(sn.NGW)) ? null : /*
        */ {
      id: resourceId('Microsoft.Network/natGateways', '${deployment}-ngwNAT01')
    }
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
    // serviceEndpoints: contains(sn, 'serviceEndpoints') ? serviceEndpoints[sn.serviceEndpoints] : serviceEndpoints.default
    // delegations: contains(sn, 'delegations') ? delegations[sn.delegations] : delegations.default
    // routeTable: contains(sn, 'Route') && bool(sn.Route) ? RouteTableGlobal : null
  }
}]

resource VNET 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vNETName
  #disable-next-line no-loc-expr-outside-params
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: union(addressPrefixes,addressPrefixesCurrent)
    }
    dhcpOptions: {
      dnsServers: array(DNSServers)
    }
    subnets: union(SNCurrent, subnetsNew)
  }
}

output vNETName string = vNETName
output addressPrefixes array = addressPrefixes
output SubnetInfo array = SubnetInfo
output DNSServers array = DNSServers
output SNCurrent array = SNCurrent
output subnetsNew array = subnetsNew
output merged array = union(SNCurrent, subnetsNew)
output mergedAddressPrefix array = union(addressPrefixes,addressPrefixesCurrent)
