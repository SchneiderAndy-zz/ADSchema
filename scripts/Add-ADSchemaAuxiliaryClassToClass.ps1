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
	To administer Active Directory:
    PS> Add-ADSchemaAuxiliaryClassToClass -AuxiliaryClass asTest -Class User
	To administer ADLDS:
	PS> Add-ADSchemaAuxiliaryClassToClass -AuxiliaryClass asTest -Class User -ADLDS $True -ADLDSService myadldsservice:1234
    Set the asTest class as an aux class of the User class.

#>

Function Add-ADSchemaAuxiliaryClassToClass {
    param(
	[Parameter(Mandatory=$True)]
    [String]$AuxiliaryClass,
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
		$auxClass = Get-ADObject -SearchBase $schemaPath -Filter "name -eq `'$AuxiliaryClass`'" -Properties governsID
		$classToAddTo  = Get-ADObject -SearchBase $schemaPath -Filter "name -eq `'$Class`'"
		$classToAddTo | Set-ADObject -Add @{auxiliaryClass = $($auxClass.governsID)}
	}
ElseIf ($ADLDS -eq $True) 
    {
        If (!$ADLDSService)
        {
            $ADLDSService = 'localhost:389'
        }
	    $DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
		$schemaPath = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
		$auxClass = Get-ADObject -SearchBase $schemaPath -server $ADLDSService -Filter "name -eq `'$AuxiliaryClass`'" -Properties governsID
		$classToAddTo  = Get-ADObject -SearchBase $schemaPath -server $ADLDSService -Filter "name -eq `'$Class`'"
		$classToAddTo | Set-ADObject -Add @{auxiliaryClass = $($auxClass.governsID)}
	}
}