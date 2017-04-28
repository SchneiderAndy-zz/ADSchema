<#
.Synopsis
   Gets attributes in an ADLDS Schema (default server:port = localhost:389)
.DESCRIPTION
   Gets attributes in an ADLDS Schema (default server:port = localhost:389)
.EXAMPLE
   Get-ADSchemaAttribute -class User -Attribute c*
.EXAMPLE
   Get-ADSchemaAttribute -class asTestClass -attribute asFavoriteColor
.EXAMPLE
   Get-ADSchemaAttribute -ADLDSService myserver.mydomain:1036 -class asTestClass -attribute asFavoriteColor
#>
Function Get-ADLDSSchemaAttribute {
    param(
        
        [Parameter()]
        $ADLDSService = 'localhost:389',

        [Parameter()]
        $Attribute = '*',

        [Parameter()]
        $Class = 'user'
    )
    $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schema = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $attributes = $schema.FindClass($Class).mandatoryproperties 
    $attributes += $schema.FindClass($Class).optionalproperties
    return $attributes | Where-Object {$_.Name -like $Attribute}
}