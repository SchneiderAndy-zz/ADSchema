<#
.SYNOPSIS
   Gets classes in an AD Schema

.DESCRIPTION
   Use this function to list or search for existing classes in the Active Directory Schema

.PARAMETER Class
  The name of the class you want to search for. Supports wildcards

.EXAMPLE
	To administer Active Directory:
	Get-ADSchemaClass -Name User
	To administer ADLDS:
	Get-ADSchemaClass -Name User -ADLDS $True -ADLDSService myadldsservice:1234
.EXAMPLE
	To administer Active Directory:
	Get-ADSchemaClass com*
	To administer ADLDS:
	Get-ADSchemaClass com* -ADLDS $True -ADLDSService myadldsservice:1234
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