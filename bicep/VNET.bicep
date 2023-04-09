param deployment string
param deploymentID string
param vNETName string
param DNSServers array
param SubnetInfo array
param addressPrefixes array
param setVNETCurrent bool


resource VNET 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vNETName
}

var currentAddress = setVNETCurrent ? VNET.properties.addressSpace.addressPrefixes: []
var currentDNS = setVNETCurrent ? VNET.properties.dhcpOptions.dnsServers : []

module dp_Deployment_VNET 'VNET-vnet.bicep' = {
  name: 'dp${deployment}-VNET-union'
  params: {
    deployment: deployment
    deploymentID: deploymentID
    vNETName: vNETName
    DNSServers: union(DNSServers,currentDNS)
    addressPrefixes: union(addressPrefixes,currentAddress)
    SubnetInfo: SubnetInfo
    SubnetInfoCurrent: setVNETCurrent ? VNET.properties.subnets : []
  }
}