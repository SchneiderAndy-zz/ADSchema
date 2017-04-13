Function New-ADSchemaAttribute {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        $Name,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [Alias('DisplayName')]
        $LDAPDisplayName,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [Alias('Description')]
        $AdminDescription,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName)]
        [Alias('SingleValued')]
        $IsSingleValued,

        [Parameter(ValueFromPipelinebyPropertyName)]
        [Alias('OID')]
        $AttributeID 
    )

    BEGIN {}

    PROCESS {
  
        $schemaPath = (Get-ADRootDSE).schemaNamingContext       
        $type = 'attributeSchema'
        switch ($isSingleValued) {
            'True' {$IsSingleValued = $true}
            'False' {$IsSingleValued = $false}
            default {$IsSingleValued = $true}
        }

        $attributes = @{
            lDAPDisplayName = $Name;
            attributeId = $AttributeID;
            oMSyntax = 20;
            attributeSyntax = "2.5.5.4";
            isSingleValued = $IsSingleValued;
            adminDescription = $AdminDescription;
            searchflags = 1
        }
    
        $ConfirmationMessage = "$schemaPath. This cannot be undone"
        $Caption = 'Updating Active Directory Schema'
    
        if ($PSCmdlet.ShouldProcess($ConfirmationMessage, $Caption)) {
            New-ADObject -Name $Name -Type $type -Path $schemapath -OtherAttributes $attributes 
          #  $userSchema = get-adobject -SearchBase $schemapath -Filter 'name -eq "user"'
          #  $userSchema | Set-ADObject -Add @{mayContain = $Name}
        }
    }

    END {}
    
}