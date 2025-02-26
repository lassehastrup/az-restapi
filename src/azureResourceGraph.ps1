<#
    Azure Management REST API til at query mod Azure Resource Graph
    https://learn.microsoft.com/en-us/azure/governance/resource-graph/first-query-rest-api?tabs=powershell
#>

Get-Headers -TenantId $fesdevTenantId -ResourceTypeName Arm

$restSplat = @{
    body    = @{
        query = "resourcecontainers | where type == 'microsoft.resources/subscriptions/resourcegroups' | project name, location"
    } | ConvertTo-Json -Depth 3
    headers = $headers
    Uri     = "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2021-03-01"
    Method  = 'Post'
}
$result = Invoke-RestMethod @restSplat


<#
    Azure Management REST API til at query mod Azure Resource Graph
#>


