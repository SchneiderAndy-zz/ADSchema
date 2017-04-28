<#
.SYNOPSIS
   Gets classes in an ADLDS Schema (default server:port = localhost:389)

.DESCRIPTION
   Use this function to list or search for existing classes in the ADLDS Schema (default server:port = localhost:389)

.PARAMETER Class
  The name of the class you want to search for. Supports wildcards

.EXAMPLE
   Get-ADSchemaClass -Name User
   
.EXAMPLE
   Get-ADSchemaClass com*

.EXAMPLE
   Get-ADSchemaClass -ADLDSService myserver.mydomain:1036 -Name User
#>
Function Get-ADLDSSchemaClass {
    param(

        [Parameter()]
        $ADLDSService = 'localhost:389',

        [Parameter()]
        $Class = '*'
    )
    
    $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schema = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $classes = $schema.FindAllClasses()
    return $classes | Where-Object {$_.Name -like $Class}
}