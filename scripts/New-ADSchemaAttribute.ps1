<#
.SYNOPSIS
   Create a new attribute in the Active Directory Schema

.DESCRIPTION
   New-ADSchemaAttribute will add a new attribute to the AD Schema. Once the new attribute
   is created, you will need to add it to a class. AD Schema best practices suggest
   that you create a new auxiliary class, add your attribute to that class, and then
   make your auxiliary class and auxiliary class of the class you want to see the 
   attribute in. See help about_adschema for more details

.PARAMETER Name
  The name of the attribute you are creating. This will be the CN and the LDAP
  Display Name. Using a standard prefix is a good practice to follow.

.PARAMETER Description
  The admin description is a short description that is added as metadata to the
  attribute. Should not be much more than 3 or 4 words.

.PARAMETER IsSingleValued
  Determine whether the new attribute can hold one value or an array of values. 

.PARAMETER AttributeType
  Determines what type of attribute you are creating. Use a DN to create an attribute
  that will hold a reference to another object in Active Directory. One example of an 
  existing DN attribute is a user's manager, or a group's "ManagedBy" attribute.
  Strings are case-insenstive.

.PARAMETER AttributeID
  AttributeID is the Object Identifier (OID) for the new attribute. OIDs have a 
  specific syntax that looks something like '1.2.840.113556.1.8000.2554.13769.13577.20614'
  You can use the New-ADSchemaTestOid to generate one. However, in production, you should
  use your own OID based on your company's defined OID structure and your Private Enterprise
  Number. For more inforation, please look at help about_ADSchema. 

 .PARAMETER SchemaAttributeHashTable
   This parameter is the rope that will let you hang yourself if you are not careful. It is
   for advanced users that want to generate highly customized attributes. Any of the attributes 
   found in  https://technet.microsoft.com/en-us/library/cc961746.aspx could be used. 
   You will need to store them in a hashtable with their corresponding values. Using a custom
   hashtable, you can specify any of the attributes in attributeSchema objects and use any
   attributeSyntax you want. 

.EXAMPLE
   $oid = New-ADSchemaTestOID
   New-ADSchemaAttribute -Name as-favoriteColor -Description 'Favorite Color' -IsSingleValued $true -AttributeType String -AtributeID $oid
   
.EXAMPLE
   $hash - Get-ADSchemaClass com*
#>

Function New-ADSchemaAttribute {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(

        [Parameter(Mandatory,ValueFromPipelinebyPropertyName, ParameterSetName = 'basic')]
        [String]
        $Name,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName, ParameterSetName = 'basic')]
        [Alias('AdminDescription')]
        [String]
        $Description,

        [Parameter(ValueFromPipelinebyPropertyName, ParameterSetName = 'basic')]
        [Alias('SingleValued')]
        [Boolean]
        $IsSingleValued = $true,

        [Parameter(Mandatory, ValueFromPipelinebyPropertyName, ParameterSetName = 'basic')]
        [ValidateSet('String','DN','Int','GeneralizedTime','Boolean','CaseInsensitiveString')]
        [String]
        $AttributeType ,

        [Parameter(ValueFromPipelinebyPropertyName,ParameterSetName = 'basic')]
        [Alias('OID')]
        [String]
        $AttributeID = (New-ADSchemaTestOID),

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName = 'advanced')]
        [String]
        $SchemaAttributeHashTable
    )

    BEGIN {}

    PROCESS {
  
        $schemaPath = (Get-ADRootDSE).schemaNamingContext       
        $type = 'attributeSchema'
        if($SchemaAttributeHashTable){
            $attributes = $SchemaAttributeHashTable
        }
        else {
             # based on https://technet.microsoft.com/en-us/library/cc961740.aspx
            switch ($AttributeType) {
                'String'            {$attributeSyntax = '2.5.5.4';  $omSyntax = 20}
                'DN'                {$attributeSyntax = '2.5.5.1';  $omSyntax = 127}
                'Int'               {$attributeSyntax = '2.5.5.9';  $omSyntax = 2}
                'GeneralizedTime'   {$attributeSyntax = '2.5.5.11'; $omSyntax = 24}
                'Boolean'           {$attributeSyntax = '2.5.5.8';  $omSyntax = 1}
                Default {}
            }
            
            $attributes = @{
            lDAPDisplayName = $Name;
            attributeId = $AttributeID;
            oMSyntax = $omSyntax;
            attributeSyntax = $attributeSyntax;
            isSingleValued = $IsSingleValued;
            adminDescription = $Description;
            searchflags = 1
        }
        }
        
    
        $ConfirmationMessage = "$schemaPath. This cannot be undone"
        $Caption = "Updating Active Directory Schema. Creating attribute $Name"
        if($AttributeID.StartsWith('1.2.840.113556.1.8000.2554')){
           Write-Warning 'You are using a test OID. For Production use, use an OID with your registered PEN. See help about_adschema for more details. ' 
        }
       
        if ($PSCmdlet.ShouldProcess($ConfirmationMessage, $Caption)) {
            New-ADObject -Name $Name -Type $type -Path $schemapath -OtherAttributes $attributes 
        }
    }

    END {}
    
}