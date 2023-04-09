@description('region prefix e.g. acu1 or aeu1')
param prefix string
@description('your org name e.g. PE or HR or INF 2 or 3 letter org name')
param orgName string
@description('your org name e.g. TST or ADF or CTL 2 or 3 letter org name')
param appName string
@description('Environment e.g. d,t,u or p')
param Environment string
@description('Id for enviroment e.g. 1,2,3,4,5,6,7,8')
param DeploymentId string

param SubnetInfo array
param DNSServers array

var deployment = '${prefix}-${orgName}-${appName}-${Environment}${DeploymentId}'
var vNETName = '${deployment}-vn'

resource VNET 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vNETName
}

// This is currently blocked with extensibility, however works without extensibility
// https://github.com/Azure/bicep/issues/10097
// cannot lookup to see if existing exists or not, since the resource is always evaluated.


module testResourcExists 'x.testResourceExists.ps1.bicep' = {
  name: 'testResourcExists-${vNETName}'
  params: {
    resourceId: VNET.id
    userAssignedIdentityName: 'AEU1-PE-CTL-D1-uaiReader'
  }
}

module dp_Deployment_VNET 'VNET.bicep' = {
  name: 'dp${deployment}-VNET'
  params: {
    deployment: deployment
    deploymentID: DeploymentId
    vNETName: vNETName
    SubnetInfo: SubnetInfo
    DNSServers: DNSServers
    setVNETCurrent: testResourcExists.outputs.Exists
  }
}

output exists bool = testResourcExists.outputs.Exists
output ResourceId string = testResourcExists.outputs.ResourceId
output vnetid string = VNET.id

