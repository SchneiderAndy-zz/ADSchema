<#
.SYNOPSIS
   Create a new class in the Active Directory Schema

.DESCRIPTION
   New-ADSchemaClass will add a new class to the AD Schema. The majority of
   the time, any new classes will likely be an Auxiliary Class. It is a best
   practice to create an auxiliary class and add it as an auxliary class to 
   an existing class.

.PARAMETER Name
  The name of the attribute you are creating. This will be the CN and the LDAP
  Display Name, and Admin Display Name. Using a standard prefix is a good
  practice to follow.

.PARAMETER AdminDescription
  This is the description of the class being created. Usually, a 3 or 4 word
  description is sufficient.

.PARAMETER Category
  99% of the time, you will chose an Auxiliary class. Becuase of this, the
  default value is automatically set to Auxililary. Please see 
  https://technet.microsoft.com/en-us/library/cc961751.aspx for info
  on other categories if you wish to overwrite.

.EXAMPLE
  $oid = New-ADSchemaTestOID
  New-ADSchemaClass -Name asPerson -AdminDescription 'host custom user attributes' -Category Auxiliary -AttributeID $oid
#>
Function New-ADSchemaClass {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        $Name,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [Alias('Description')]
        $AdminDescription,

        [Parameter(ValueFromPipelinebyPropertyName)]
        [ValidateSet("Auxiliary","Abstract","Structural","88 Class")]
        $Category = 'Auxiliary',

        [Parameter(ValueFromPipelinebyPropertyName)]
        [Alias('OID')]
        $AttributeID 
    )

    BEGIN {}

    PROCESS {
  
        $schemaPath = (Get-ADRootDSE).schemaNamingContext       
        

        switch ($Category) {
            'Auxiliary'     {$ObjectCategory = 3}
            'Abstract'      {$ObjectCategory = 2}
            'Structural'    {$ObjectCategory = 1}
            '88 Class'      {$ObjectCategory = 0}
        }

        $attributes = @{
            governsId = $AttributeID
            adminDescription = $AdminDescription
            objectClass =  'classSchema'
            ldapDisplayName = $Name
            adminDisplayName =  $Name
            objectClassCategory = $ObjectCategory
            systemOnly =  $FALSE
            # subclassOf: top
            subclassOf = "2.5.6.0"
            # rdnAttId: cn
            rdnAttId = "2.5.4.3"
        }
    
        $ConfirmationMessage = "$Name in $schemaPath. This cannot be undone"
        $Caption = 'Adding a new class to Active Directory Schema'
    
        if ($PSCmdlet.ShouldProcess($ConfirmationMessage, $Caption)) {
            New-ADObject -Name $Name -Type 'classSchema' -Path $schemapath -OtherAttributes $attributes  
        }
    }

    END {}
    
}
