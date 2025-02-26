# Importing required modules
$Modules = @('Terminal-Icons')
$Modules | ForEach-Object { Import-Module $_ }


# Configuring alias
New-Alias -Value '/opt/homebrew/bin/brew' -Name Brew
New-Alias -Name 'Sysinfo' -Value 'neofetch'
New-Alias -Name 'python' -Value python3
New-Alias -Name 'clip' -Value Set-Clipboard

# Setting variables

$code = "/Users/lasse/code/"
$fmp = "/Users/lasse/Code/fmp/"
$notes = "/Users/lasse/code/personal/lha-notes/"

#tenantID for various customers
$fesdevTenantId = 'xxx'
$fmdktenantId = 'xxx'
$fmdkDevTenantId = 'xxx'

# Environment variables
$env:PYTHONIOENCODING = 'utf-8'

# Terminal configuration

# Set-PSReadLineOption -PredictionSource 'HistoryAndPlugin'
Set-PSReadLineOption -PredictionViewStyle 'ListView' -HistorySearchCursorMovesToEnd
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/kushal.omp.json' | Invoke-Expression

# Custom Functions
function Get-Headers {
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('(\{|\()?[A-Za-z0-9]{4}([A-Za-z0-9]{4}\-?){4}[A-Za-z0-9]{12}(\}|\()?')]
        [string]$TenantId,

        [ValidateSet("AadGraph", "AnalysisServices", "Arm", "Attestation", "Batch", "DataLake", "KeyVault", "MSGraph", "OperationalInsights", "ResourceManager", "Storage", "Synapse", "DevOps")]
        [Parameter()][string]$ResourceTypeName = "Arm"
    )
    begin {
        Write-Information ("Getting Azure Bearer Token of type: {0} for tenant: {1}" -f $ResourceTypeName, $TenantId)
        if ($ResourceTypeName -eq "DevOps") {
            $Token = (Get-AzAccessToken -Resource '499b84ac-1321-427f-aa17-267ca6975798' -TenantId $TenantId -ErrorAction 'Stop').Token
        }
        else {
            try {
                $Token = (Get-AzAccessToken -ResourceTypeName $ResourceTypeName -TenantId $TenantId -ErrorAction 'Stop').Token
            }
            catch {
                Connect-AzAccount -TenantId $TenantId
                $Token = (Get-AzAccessToken -ResourceTypeName $ResourceTypeName -TenantId $TenantId -ErrorAction 'Stop').Token
            }
        }
    }
    process {
        if ($null -eq $Token) {
            throw "Unable to get Azure Bearer Token for tenant: $TenantId of type: $ResourceTypeName"
        }
        if (Get-Variable 'Headers' -ErrorAction SilentlyContinue) {
            Remove-Variable -Name Headers -Scope global
        }
        New-Variable -Name 'Headers' -Scope 'Global' -Value @{"Authorization" = "Bearer $Token"; "Content-Type" = "application/json" }
    }
}
