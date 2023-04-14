<# 
setx.exe 'BICEP_TRACE' '1'
setx.exe 'BICEP_TRACING_VERBOSITY' 'Full'
Write-Output 'requires restart'

I opted not to create the User assigned identity in this project

bicep/main.bicep#L33 <-- create this User assigned identity and provide it read access to your resource e.g. RG

#>

$Base = $PSScriptRoot
$ParamsBase = "$Base\tenants\CTL\values-d1"
$splat = @{
    Name                  = 'Bicep_Merge_Proto'
    ResourceGroupName     = 'AEU1-PE-CTL-RG-D1'
    TemplateFile          = "$Base\bicep\main.bicep"
    TemplateParameterFile = "${ParamsBase}.json" # bicepparam compilation not supported as yet
}

# test out bicep params, manually build
bicep build-params "${ParamsBase}.bicepparam"
New-AzResourceGroupDeployment @splat -Verbose
