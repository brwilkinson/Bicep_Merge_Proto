# Bicep_Merge_Proto

Prototype for merging current and new config in Bicep

Sample merging VNET configurations

I would not recommend to do this, however it does work.

I do use a similar approach to merge a single Object, such as App Configuration on App Service.

- https://github.com/brwilkinson/AzureDeploymentFramework/blob/main/ADF/bicep/x.appServiceSettings.bicep

This prototype does rely on the ability to detect if a resource exists via the DeploymentScript.
- By using this it works on a new or existing scenario.