<#
.SYNOPSIS
    Reloads the Active Directory Schema
.DESCRIPTION
    After the schema has been updated, it needs to be reloaded so your updates
    can be seen immediately. 
.EXAMPLE
    PS C:\> Invoke-ADSchemaReload
#>

Function Invoke-ADSchemaReload {
   $dse =  Get-ADRootDSE
   $dse.schemaUpdateNow = $true
}