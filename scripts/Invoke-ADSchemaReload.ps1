<#
.SYNOPSIS
    Reloads the Active Directory Schema
.DESCRIPTION
    After the schema has been updated, it needs to be reloaded so your updates
    can be seen immediately. 
.EXAMPLE
	To administer Active Directory:
    PS C:\> Invoke-ADSchemaReload
	To administer ADLDS
    PS C:\> Invoke-ADSchemaReload -ADLDS $True -ADLDSService myadldsservice:1234
#>

Function Invoke-ADSchemaReload {
	param(
	[Parameter(Mandatory=$False)]
    [Boolean]$ADLDS,
    [Parameter(Mandatory=$False)]
    [String]$ADLDSService
	)
	If (!$ADLDS)
    {
	$dse =  Get-ADRootDSE
	$dse.schemaUpdateNow = $true
	}
	ElseIf ($ADLDS -eq $True) 
    {
        If (!$ADLDSService)
        {
            $ADLDSService = 'localhost:389'
        }
	$DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schema = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $schema.RefreshSchema = $true
	}
}