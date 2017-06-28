<#
.Synopsis
   Gets attributes in an AD Schema
.DESCRIPTION
   Gets attributes in an AD Schema

.PARAMETER Attribute
    The attribute that you wish to search for. 

.PARAMETER Class
    The Structural Class you wish to query. 

.PARAMETER ADLDS
    Boolean - $True to administer ADLDS 

.PARAMETER ADLDSService
    Hostname and port in format hostname:port
    Defaults to localhost:389

.EXAMPLE
   Get-ADSchemaAttribute -class User -Attribute c*
.EXAMPLE
   Get-ADSchemaAttribute -class asTestClass -attribute asFavoriteColor
.EXAMPLE
   Get-ADSchemaAttribute -class User -Attribute c* -ADLDS $True -ADLDSService myadldsservice:1234
.EXAMPLE
   Get-ADSchemaAttribute -class asTestClass -attribute asFavoriteColor -ADLDS $True -ADLDSService myadldsservice:1234
#>
Function Get-ADSchemaAttribute {
    param(
    [Parameter(Mandatory=$False)]
    [String]$Attribute = '*',
    [Parameter(Mandatory=$False)]
    [String]$Class = 'user',
    [Parameter(Mandatory=$False)]
    [Boolean]$ADLDS,
    [Parameter(Mandatory=$False)]
    [String]$ADLDSService
    )
    If ($ADLDS -eq $NULL)
    {
    $schema = [directoryservices.activedirectory.activedirectoryschema]::getcurrentschema()
    $attributes = $schema.FindClass($Class).mandatoryproperties 
    $attributes += $schema.FindClass($Class).optionalproperties
    return $attributes | Where-Object {$_.Name -like $Attribute}
    }
    ElseIf ($ADLDS -eq $True) 
    {
        If (!$ADLDSService)
        {
            $ADLDSService = 'localhost:389'
        }
    $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schema = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $attributes = $schema.FindClass($Class).mandatoryproperties 
    $attributes += $schema.FindClass($Class).optionalproperties
    return $attributes | Where-Object {$_.Name -like $Attribute}
    }
}