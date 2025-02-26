# Arbejde med Azure og DevOps via. kode

## Målsætning: Demystify REST-API'er i og omkring Azure

## Fordele ved REST-API over Azure Powershell CMDlets

[Resource Group Comparison](../src/Get-ResourceGroupComparison.ps1)

1. Performance
2. Ikke tage højde for sin az context
3. API-versioner
4. Ofte bedre dokumenteret, da det er en direkte del af Azure Resource Manager (ARM) og powershell cmdlets er et lag ovenpå (forskellige teams)

## Ulemper ved REST-API over Azure Powershell CMDlets

1. Kompleksiteten (steep learning curve)
2. Ingen intellisense
3. Længere kode

### Azure Resource Graph

- Kører i baggrunden i Azure og indsamler konstant metadata fra Azure ARM - nærmest realtime
- Bruger KQL syntax
- Parallelitet er indbygget, og derfor er hastigheden markant højere
- Kan bruges til at lave queries på tværs af subscriptions

[Azure Resource Graph](../src/azureResourceGraph.ps1)

[Azure Portal](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade)

### Azure DevOps

Hvis Azure Resource Graph kan det hele, hvorfor så overhovedet nævne REST-API'er og andre ting?

Fordele ved at have kendskab til Tokens og REST-API'er.

- Teknologier, som er bygget omkring og I azure er ofte ret standardiserede
- Hvis du ét af deres API'er er du ret langt i forhold til at kunne bruge andre API'er

Eksmepel:

Hente alle Azure devOps projekter ud fra en organisation

GET https://dev.azure.com/{organization}/_apis/projects?api-version=7.1

Invoke-restMethod -Uri "https://dev.azure.com/fellowminddk/_apis/projects?api-version=7.1" -Headers $headers -Method Get
