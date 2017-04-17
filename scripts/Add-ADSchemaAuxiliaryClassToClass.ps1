<#
.SYNOPSIS
    Adds an auxiliary class to class

.DESCRIPTION
    Add a new custom class to an existing structural class in AD. For example,
    if you want to add attributes to the user class, you should craete a new
    auxiliary class, add attributes to that, and then assign the new class as 
    an aux class to the user class.

.PARAMETER AuxiliaryClass
    The class that will be holding the new attributes you are creating.This 
    will be an auxiliary class of the structural class.

.PARAMETER Class
    The structural class you are adding an aux class to. 

.EXAMPLE
    PS> Add-ADSchemaAuxiliaryClassToClass -AuxiliaryClass asTest -Class User
    Set the asTest class as an aux class of the User class.

#>
Function Add-ADSchemaAuxiliaryClassToClass {
    param(
        [Parameter()]
        $AuxiliaryClass,

        [Parameter()]
        $Class
    )

    $schemaPath = (Get-ADRootDSE).schemaNamingContext  
    $auxClass = get-adobject -SearchBase $schemapath -Filter "name -eq `'$AuxiliaryClass`'" -Properties governsID
    $classToAddTo  = get-adobject -SearchBase $schemapath -Filter "name -eq `'$Class`'"
    $classToAddTo | Set-ADObject -Add @{auxiliaryClass = $($auxClass.governsID)}
}