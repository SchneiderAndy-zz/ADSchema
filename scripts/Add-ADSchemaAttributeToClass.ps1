Function Add-ADSchemaAttributeToClass {
param(
    $Attribute,
    $Class
)
    $schemaPath = (Get-ADRootDSE).schemaNamingContext  
    $Schema = get-adobject -SearchBase $schemapath -Filter "name -eq `'$Class`'"
    $Schema | Set-ADObject -Add @{mayContain = $Attribute}
}