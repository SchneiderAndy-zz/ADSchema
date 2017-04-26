<#
.SYNOPSIS
    Adds an Auxiliary Class to a Structural Class.

.DESCRIPTION
    Add a new Custom Class to an existing Structural Class in Active Directory.
    
    For example if you want to add attributes to the user class, you should:
    
    1) Create a new Auxiliary Class.
    2) Add attributes to that Auxiliary Class.
    3) Finally assign the New Class as an Auxiliary Class to the User Class.

.PARAMETER AuxiliaryClass
    The class that will be holding the new attributes you are creating.
    This will be an auxiliary class of the structural class.

.PARAMETER Class
    The structural class you are adding an Auxiliary Class to.. 

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
    $auxClass = Get-ADObject -SearchBase $schemaPath -Filter "name -eq `'$AuxiliaryClass`'" -Properties governsID
    $classToAddTo  = Get-ADObject -SearchBase $schemaPath -Filter "name -eq `'$Class`'"
    $classToAddTo | Set-ADObject -Add @{auxiliaryClass = $($auxClass.governsID)}
}