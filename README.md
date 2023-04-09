# Bicep_Merge_Proto

Prototype for merging current and new config in Bicep

Sample merging VNET configurations, with option to overwrite.

I would not recommend to do this, however it does work.

I do use a similar approach to merge a single Object, such as App Configuration on App Service.

- https://github.com/brwilkinson/AzureDeploymentFramework/blob/main/ADF/bicep/x.appServiceSettings.bicep

This prototype does rely on the ability to detect if a resource exists via the DeploymentScript.
- By using this it works on a new or existing scenario.
- You can opt to merge or replace configuratons

---

```powershell
pwsh> . 'D:\repos\Bicep_Merge_Proto\setup_deploy.ps1'
VERBOSE: Using Bicep v0.15.152
VERBOSE: Performing the operation "Creating Deployment" on target "AEU1-PE-CTL-RG-D1".
VERBOSE: 7:06:00 PM - Template is valid.
VERBOSE: 7:06:02 PM - Create template deployment 'Bicep_Merge_Proto'
VERBOSE: 7:06:02 PM - Checking deployment status in 5 seconds
VERBOSE: 7:06:08 PM - Resource Microsoft.Resources/deployments 'testResourcExists-AEU1-PE-CTL-D2-vn' provisioning status is running
VERBOSE: 7:06:08 PM - Resource Microsoft.Resources/deploymentScripts 'testsExists-AEU1-PE-CTL-D2-vn' provisioning status is running
VERBOSE: 7:06:08 PM - Checking deployment status in 11 seconds
VERBOSE: 7:06:20 PM - Checking deployment status in 15 seconds
VERBOSE: 7:06:36 PM - Checking deployment status in 14 seconds
VERBOSE: 7:06:51 PM - Checking deployment status in 14 seconds
VERBOSE: 7:07:06 PM - Checking deployment status in 15 seconds
VERBOSE: 7:07:27 PM - Resource Microsoft.Resources/deploymentScripts 'testsExists-AEU1-PE-CTL-D2-vn' provisioning status is succeeded
VERBOSE: 7:07:27 PM - Resource Microsoft.Resources/deploymentScripts 'testsExists-AEU1-PE-CTL-D2-vn' provisioning status is succeeded
VERBOSE: 7:07:28 PM - Checking deployment status in 8 seconds
VERBOSE: 7:07:37 PM - Resource Microsoft.Resources/deployments 'dpAEU1-PE-CTL-D2-VNET' provisioning status is running
VERBOSE: 7:07:37 PM - Resource Microsoft.Resources/deployments 'testResourcExists-AEU1-PE-CTL-D2-vn' provisioning status is succeeded
VERBOSE: 7:07:37 PM - Resource Microsoft.Resources/deployments 'testResourcExists-AEU1-PE-CTL-D2-vn' provisioning status is succeeded
VERBOSE: 7:07:37 PM - Checking deployment status in 15 seconds
VERBOSE: 7:07:55 PM - Resource Microsoft.Resources/deployments 'dpAEU1-PE-CTL-D2-VNET-union' provisioning status is succeeded
VERBOSE: 7:07:55 PM - Resource Microsoft.Network/virtualNetworks 'AEU1-PE-CTL-D2-vn' provisioning status is succeeded
VERBOSE: 7:07:55 PM - Resource Microsoft.Resources/deployments 'dpAEU1-PE-CTL-D2-VNET-union' provisioning status is succeeded
VERBOSE: 7:07:55 PM - Checking deployment status in 12 seconds
VERBOSE: 7:08:11 PM - Resource Microsoft.Resources/deployments 'dpAEU1-PE-CTL-D2-VNET' provisioning status is succeeded
VERBOSE: 7:08:11 PM - Resource Microsoft.Resources/deployments 'dpAEU1-PE-CTL-D2-VNET' provisioning status is succeeded

DeploymentName          : Bicep_Merge_Proto
ResourceGroupName       : AEU1-PE-CTL-RG-D1
ProvisioningState       : Succeeded
Timestamp               : 4/9/2023 2:08:06 AM
Mode                    : Incremental
TemplateLink            : 
Parameters              : 
                          Name                Type                       Value     
                          ==================  =========================  ==========
                          prefix              String                     "AEU1"
                          orgName             String                     "PE"
                          appName             String                     "CTL"
                          environment         String                     "D"
                          deploymentId        String                     "2"
                          subnetInfo          Array                      [{"name":"snMT01","NSGRuleName":"AKS-WEB","prefix":"0/23","NSG":0,"Route":0,"FlowLogEnabled":0,"FlowAnalyticsEnabled":0,"NGW":0},{"name":"snMT02","NSGRuleName":"AKS-WEB","prefix":"0/23","NSG":0,"Route":0,"FlowLogEnabled":0,"FlowAnalyticsEnabled":0,"NGW":0}]
                          dnsServers          Array                      []
                          allowMergeConfig    Bool                       true

Outputs                 : 
                          Name                   Type                       Value
                          =====================  =========================  ==========
                          exists                 Bool                       false
                          resourceId             String                     "/subscriptions/4185fa9b-f470-466a-b3ae-8e6c3314a543/resourceGroups/AEU1-PE-CTL-RG-D1/providers/Microsoft.Network/virtualNetworks/AEU1-PE-CTL-D2-vn"
                          mergedDNSServers       Array                      []
                          mergedSubnets          Array                      [{"name":"snMT01","properties":{"addressPrefix":"10.182.236.0/23","networkSecurityGroup":null,"natGateway":null,"privateEndpointNetworkPolicies":"Disabled","privateLinkServiceNetworkPolicies":"Disabled"}},{"name":"snMT02","properties":{"addressPrefix":"10.182.232.0/23","networkSecurityGroup":null,"natGateway":null,"privateEndpointNetworkPolicies":"Disabled","privateLinkServiceNetworkPolicies":"Disabled"}}]
                          mergedAddressPrefix    Array                      ["10.182.232.0/21"]
```