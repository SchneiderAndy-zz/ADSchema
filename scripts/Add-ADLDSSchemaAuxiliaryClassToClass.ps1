<#
.SYNOPSIS
    Adds an Auxiliary Class to a Structural Class.

.DESCRIPTION
    Add a new Custom Class to an existing Structural Class in ADLDS.
    
    For example if you want to add attributes to the user class, you should:
    
    1) Create a new Auxiliary Class.
    2) Add attributes to that Auxiliary Class.
    3) Finally assign the New Class as an Auxiliary Class to the User Class.

.PARAMETER ADLDSService
    Hostname and port in format hostname:port
    Defaults to localhost:389
    
.PARAMETER AuxiliaryClass
    The class that will be holding the new attributes you are creating.
    This will be an auxiliary class of the structural class.

.PARAMETER Class
    The structural class you are adding an Auxiliary Class to.. 

.EXAMPLE
    PS> Add-ADSchemaAuxiliaryClassToClass -AuxiliaryClass asTest -Class User
    Set the asTest class as an aux class of the User class.

.EXAMPLE
    PS> Add-ADSchemaAuxiliaryClassToClass -ADLDSService myserver.mydomain:1036 -AuxiliaryClass asTest -Class User
    On a non-default server, set the asTest class as an aux class of the User class.
#>

Function Add-ADLDSSchemaAuxiliaryClassToClass {
    param(
                
        [Parameter()]
        $ADLDSService = 'localhost:389',

        [Parameter()]
        $AuxiliaryClass,

        [Parameter()]
        $Class
    )

    $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schemaPath = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $auxClass = Get-ADObject -SearchBase $schemaPath -server $ADLDSService -Filter "name -eq `'$AuxiliaryClass`'" -Properties governsID
    $classToAddTo  = Get-ADObject -SearchBase $schemaPath -server $ADLDSService -Filter "name -eq `'$Class`'"
    $classToAddTo | Set-ADObject -Add @{auxiliaryClass = $($auxClass.governsID)}
}