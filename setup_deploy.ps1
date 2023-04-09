<# 
setx.exe 'BICEP_TRACE' '1'
setx.exe 'BICEP_TRACE_LEVEL' 'Verbose'
Write-Output 'requires restart'
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
