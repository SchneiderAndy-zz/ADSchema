<#
.SYNOPSIS
    Adds an attribute to a class.

.DESCRIPTION
    Add a New Custom Class to an existing Structural Class in Active Directory.
    
    For example if you want to add attributes to the User Class:
    1. Create a new Auxiliary Class.
    2. Add Attributes to that new Auxiliary Class.
    3. Assign the new class as an Auxiliary Class to the User Class.

.PARAMETER AuxiliaryClass
    The class that will be holding the new attributes you are creating.
    This will be an Auxiliary Class of the structural class.

.PARAMETER Class
    The Structural Class you are adding an Auxiliary Class to. 

.PARAMETER ADLDS
    Boolean - $True to administer ADLDS 

.PARAMETER ADLDSService
    Hostname and port in format hostname:port
    Defaults to localhost:389

.EXAMPLE
    Add-ADSchemaAttributeToClass -Attribute asFavoriteColor -Class User
    Active Directory: Add the attribute 'asFavoriteColor' to the User Class 

.EXAMPLE
    Add-ADSchemaAttributeToClass -AuxiliaryClass asTest -Class User -ADLDS $True
    ADLDS:  Add the attribute 'asFavoriteColor' to the User Class in the default ADLDS instance on localhost:389

.EXAMPLE
    Add-ADSchemaAttributeToClass -AuxiliaryClass asTest -Class User -ADLDS $True -ADLDSService myadldsservice:1234
    ADLDS:  Add the attribute 'asFavoriteColor' to the User Class of an ADLDS instance named myadldsservice:1234
#>

Function Add-ADSchemaAttributeToClass {
param(
    [Parameter(Mandatory=$True)]
    [String]$Attribute,
    [Parameter(Mandatory=$True)]
    [String]$Class,
    [Parameter(Mandatory=$False)]
    [Boolean]$ADLDS,
    [Parameter(Mandatory=$False)]
    [String]$ADLDSService
)
If (!$ADLDS)
    {
        $schemaPath = (Get-ADRootDSE).schemaNamingContext  
        $Schema = Get-ADObject -SearchBase $schemaPath -Filter "name -eq `'$Class`'"
        $Schema | Set-ADObject -Add @{mayContain = $Attribute}
    }
    ElseIf ($ADLDS -eq $True) 
    {
        If (!$ADLDSService)
        {
            $ADLDSService = 'localhost:389'
        }
        $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
        $schemaPath = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)  
        $Schema = Get-ADObject -Server $ADLDSService -SearchBase $schemaPath -Filter "name -eq `'$Class`'"
        $Schema | Set-ADObject -Add @{mayContain = $Attribute}
    }
}