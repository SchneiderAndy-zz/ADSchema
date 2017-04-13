Function Get-ADSchemaClass {
    param(
        [Parameter()]
        $Class = '*'
    )
    
    $schema = [directoryservices.activedirectory.activedirectoryschema]::getcurrentschema()
    $classes = $schema.FindAllClasses()
    return $classes | Where-Object {$_.Name -like $Class}
}