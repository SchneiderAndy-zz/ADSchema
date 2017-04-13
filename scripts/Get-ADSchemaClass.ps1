<#
.Synopsis
   Gets classes in an AD Schema
.DESCRIPTION
   Gets classes in an AD Schema
.EXAMPLE
   Get-ADSchemaClass -Name User
.EXAMPLE
   Get-ADSchemaClass User
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