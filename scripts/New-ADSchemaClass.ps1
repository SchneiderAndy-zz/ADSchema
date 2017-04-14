Function New-ADSchemaClass {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        $Name,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [Alias('DisplayName')]
        $LDAPDisplayName,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        $AdminDisplayName,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [Alias('Description')]
        $AdminDescription,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [ValidateSet("Auxiliary","Abstract","Structural","88 Class")]
        $Category,

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
            ldapDisplayName = $LDAPDisplayName
            adminDisplayName =  $AdminDisplayName
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
          #  $userSchema = get-adobject -SearchBase $schemapath -Filter 'name -eq "user"'
          #  $userSchema | Set-ADObject -Add @{mayContain = $Name}
        }
    }

    END {}
    
}

#New-ADSchemaClass -Name asTestClass -LDAPDisplayName asTestClass -Category Auxiliary -AdminDisplayName asTestClass -AdminDescription asTestClass -AttributeID (new-adschematestOID) 