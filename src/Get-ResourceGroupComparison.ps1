<#
    The AzCmdlet way using Az.Resources PowerShell Module
#>


Connect-AzAccount -TenantId $fesDevTenantId
Measure-Command {
    $subs = Get-AzSubscription -TenantId $fesdevTenantId
    foreach ($sub in $subs) {
        Set-AzContext -SubscriptionId $sub.Id -TenantId $fesDevTenantId
        $rg = Get-AzResourceGroup
        # Write-Host $rg.count
    }
}

# Result: 32 seconds


<#
    The management REST API way
#>
Get-Headers -TenantId $fesDevTenantId -ResourceTypeName Arm
Measure-Command {
    $subscriptions = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions?api-version=2020-01-01" -Headers $Headers -Method GET
    foreach ($sub in $subscriptions.value) {
        $resourceGroups = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$($sub.subscriptionId)/resourcegroups?api-version=2020-01-01" -Headers $Headers -Method GET
        # Write-Host $resourceGroups.value.count
    }
}

# Result: 9.2 seconds

<#
    Using the Azure Resource Graph
#>
Measure-Command {
    Search-AzGraph -Query "resourcecontainers | where type == 'microsoft.resources/subscriptions/resourcegroups' | project name, location, subscriptionId" -First 1000
}

# Result: 0.8 seconds
