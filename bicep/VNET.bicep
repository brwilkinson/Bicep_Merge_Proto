param deployment string
param deploymentID string
param vNETName string
param DNSServers array
param SubnetInfo array
param setVNETCurrent bool
param AllowMergeConfig bool


resource VNET 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vNETName
}

var currentAddress = setVNETCurrent ? VNET.properties.addressSpace.addressPrefixes: []
var currentDNS = setVNETCurrent ? VNET.properties.dhcpOptions.dnsServers : []
var currentSubnet = setVNETCurrent ? VNET.properties.subnets : []

module dp_Deployment_VNET 'VNET-vnet.bicep' = {
  name: 'dp${deployment}-VNET-union'
  params: {
    deployment: deployment
    deploymentID: deploymentID
    vNETName: vNETName
    DNSServers: AllowMergeConfig ? union(DNSServers,currentDNS) : DNSServers
    SubnetInfo: SubnetInfo
    SubnetInfoCurrent: AllowMergeConfig ? currentSubnet : []
    addressPrefixesCurrent: AllowMergeConfig ? currentAddress : []
  }
}

output mergedDNSServers array = dp_Deployment_VNET.outputs.mergedDNSServers
output mergedSubnets array = dp_Deployment_VNET.outputs.mergedSubnets
output mergedAddressPrefix array = dp_Deployment_VNET.outputs.mergedAddressPrefix
