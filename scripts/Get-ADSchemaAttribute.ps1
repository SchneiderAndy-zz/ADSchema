<#
.Synopsis
   Gets attributes in an AD Schema
.DESCRIPTION
   Gets attributes in an AD Schema
.EXAMPLE
   Get-ADSchemaAttribute -class User -Attribute c*
.EXAMPLE
   Get-ADSchemaAttribute -class asTestClass -attribute asFavoriteColor
#>
Function Get-ADSchemaAttribute {
    param(
        
        [Parameter()]
        $Attribute = '*',

        [Parameter()]
        $Class = 'user'
    )
    $schema = [directoryservices.activedirectory.activedirectoryschema]::getcurrentschema()
    $attributes = $schema.FindClass($Class).mandatoryproperties 
    $attributes += $schema.FindClass($Class).optionalproperties
    return $attributes | Where-Object {$_.Name -like $Attribute}
}