<#
.SYNOPSIS
    Adds an attribute to a class

.DESCRIPTION
    Add a new custom class to an existing structural class in Active Directory.
    
    For example if you want to add attributes to the User Class:
    1. Create a new Auxiliary Class
    2. Add Attributes to that new Auxiliary Class.
    3. Assign the new class as an Auxiliary Class to the User Class.

.PARAMETER AuxiliaryClass
    The class that will be holding the new attributes you are creating.
    This will be an Auxiliary Class of the structural class.

.PARAMETER Class
    The structural class you are adding an Auxiliary Class to. 

.EXAMPLE
    PS> Add-ADSchemaAuxiliaryClassToClass -AuxiliaryClass asTest -Class User
    Set the 'asTest' class as an Auxiliary Class of the User Class.
#>

Function Add-ADSchemaAttributeToClass {
param(
    $Attribute,
    $Class
)
    $schemaPath = (Get-ADRootDSE).schemaNamingContext  
    $Schema = Get-ADObject -SearchBase $schemaPath -Filter "name -eq `'$Class`'"
    $Schema | Set-ADObject -Add @{mayContain = $Attribute}
}