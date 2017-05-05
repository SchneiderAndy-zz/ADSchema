<#
.SYNOPSIS
    Reloads the ADLDS Schema
.DESCRIPTION
    After the schema has been updated, it needs to be reloaded so your updates
    can be seen immediately. 

.EXAMPLE
    Using the default server and port (localhost:389)
    PS C:\> Invoke-ADSchemaReload

.EXAMPLE
    Using a custom server and port
    PS C:\> Invoke-ADSchemaReload -ADLDSService myserver.mydomain:1036
#>

Function Invoke-ADLDSSchemaReload {
    param(
        [Parameter()]
        $ADLDSService = 'localhost:389'
    )

    $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schema = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $schema.RefreshSchema = $true
}