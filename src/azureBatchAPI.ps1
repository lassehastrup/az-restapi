$requiredAzureTags = @{
    'Environment'     = 'Dev'
    'Owner'           = 'John Doe'
    'Project'         = 'Alpha'
    'Department'      = 'IT'
    'CostCenter'      = 'CC1001'
    'Application'     = 'App1'
    'Version'         = '1.0.0'
    'Region'          = 'US-East'
    'Backup'          = 'Enabled'
    'Compliance'      = 'HIPAA'
    'Tier'            = 'Premium'
    'Service'         = 'WebApp'
    'Team'            = 'DevOps'
    'Priority'        = 'High'
    'Status'          = 'Active'
    'Retention'       = '30Days'
    'Schedule'        = 'Daily'
    'Contact'         = 'admin@example.com'
    'Budget'          = '10000'
    'Resource'        = 'VM'
    'Cluster'         = 'Cluster1'
    'Role'            = 'Admin'
    'Access'          = 'Full'
    'Maintenance'     = 'Monthly'
    'Support'         = '24x7'
    'OwnerEmail'      = 'john.doe@example.com'
    'ProjectCode'     = 'P12345'
    'EnvironmentType' = 'Test'
    'Release'         = 'R1'
    'Patch'           = 'P1'
    'Build'           = 'B1'
    'Instance'        = 'I1'
    'Database'        = 'DB1'
    'Storage'         = 'S1'
    'Network'         = 'N1'
    'Firewall'        = 'F1'
    'Gateway'         = 'G1'
    'LoadBalancer'    = 'LB1'
    'Cache'           = 'C1'
    'Queue'           = 'Q1'
    'Topic'           = 'T1'
    'Subscription'    = 'S1'
    'Policy'          = 'P1'
    'Rule'            = 'R1'
    'Alert'           = 'A1'
    'Metric'          = 'M1'
    'Log'             = 'L1'
    'Audit'           = 'A1'
}

$resourceId = "/subscriptions/66f3e6a0-7eb6-4995-8de5-361818850658/resourceGroups/NetworkWatcherRG"

$requests = @()
foreach ($tag in $requiredAzureTags.GetEnumerator() | Select-Object -First 20) {
    $tagUpdatePayload = @{
        operation  = "Merge"
        properties = @{
            tags = $tag
        }
    }

    $request = @{
        httpMethod = 'PATCH'
        name       = (New-Guid).Guid
        url        = "$resourceId/providers/Microsoft.Resources/tags/default?api-version=2021-04-01"
        content    = $tagUpdatePayload
    }
    $requests += $request
}

$batchRestBody = @{
    Method  = 'POST'
    Uri     = "https://management.azure.com/batch?api-version=2020-06-01"
    Headers = $Headers
    body    = @{
        requests = $requests
    } | ConvertTo-Json -Depth 20
}
$horse = Invoke-RestMethod @batchRestBody
