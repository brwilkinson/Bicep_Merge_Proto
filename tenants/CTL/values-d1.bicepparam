using '../../bicep/main.bicep'

param prefix = 'AEU1'
param orgName = 'PE'
param appName = 'CTL'
param Environment = 'D'
param DeploymentId = '2'

param SubnetInfo = [
  {
    name: 'snMT01'
    NSGRuleName: 'AKS-WEB'
    prefix: '0/23'
    NSG: 1
    Route: 0
    FlowLogEnabled: 0
    FlowAnalyticsEnabled: 0
    NGW: 1
  }
  {
    name: 'snMT02'
    NSGRuleName: 'AKS-WEB'
    prefix: '0/23'
    NSG: 1
    Route: 0
    FlowLogEnabled: 1
    FlowAnalyticsEnabled: 1
    NGW: 1
  }
]

param DNSServers = []

param addressPrefixes = [
  
]
