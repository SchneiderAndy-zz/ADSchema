<#
.SYNOPSIS
   Gets classes in an AD Schema

.DESCRIPTION
   Use this function to list or search for existing classes in the Active Directory Schema

.PARAMETER Class
  The name of the class you want to search for. Supports wildcards

.PARAMETER ADLDS
    Boolean - $True to administer ADLDS 

.PARAMETER ADLDSService
    Hostname and port in format hostname:port
    Defaults to localhost:389
	
.EXAMPLE
	Get-ADSchemaClass -Name User
 	Active Directory: Get the user class
 .EXAMPLE
	Get-ADSchemaClass com*
	Active Directory: Get classes starting with "com"

.EXAMPLE	
	Get-ADSchemaClass -Name User -ADLDS $True -ADLDSService myadldsservice:1234
	ADLDS: Get the user class from the ADLDS instance named myadldsservice:1234

.EXAMPLE	
	Get-ADSchemaClass -Name User -ADLDS $True
	ADLDS: Get the user class from the default ADLDS instance on localhost:389
#>
Function Get-ADSchemaClass {
        param(
		[Parameter(Mandatory=$True)]
		[String]$Class = '*',
		[Parameter(Mandatory=$False)]
		[Boolean]$ADLDS,
		[Parameter(Mandatory=$False)]
		[String]$ADLDSService      
		)
If (!$ADLDS)
	{
	$schema = [directoryservices.activedirectory.activedirectoryschema]::getcurrentschema()
    $classes = $schema.FindAllClasses()
    return $classes | Where-Object {$_.Name -like $Class}
	}
	ElseIf ($ADLDS -eq $True) 
    {
        If (!$ADLDSService)
        {
            $ADLDSService = 'localhost:389'
        }
	$DirectoryContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::DirectoryServer, $ADLDSService)
    $schema = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetSchema($DirectoryContext)
    $classes = $schema.FindAllClasses()
    return $classes | Where-Object {$_.Name -like $Class}
	}
}