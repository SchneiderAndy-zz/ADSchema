<#
.SYNOPSIS
   Gets classes in an AD Schema

.DESCRIPTION
   Use this function to list  or search for existing classes in the Active Directory Schema

.PARAMETER Class
  The name of the class you want to search for. Supports wildcards

.EXAMPLE
   Get-ADSchemaClass -Name User
   
.EXAMPLE
   Get-ADSchemaClass com*
#>
Function Get-ADSchemaClass {
    param(
        [Parameter()]
        $Class = '*'
    )
    
    $schema = [directoryservices.activedirectory.activedirectoryschema]::getcurrentschema()
    $classes = $schema.FindAllClasses()
    return $classes | Where-Object {$_.Name -like $Class}
}