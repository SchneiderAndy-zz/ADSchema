<#
.SYNOPSIS
    Creates a random OID for dev and test purposes.

.DESCRIPTION
    Creates a random Object Identifier for dev and test purposes. For production uses,
    use an OID with your company OID prefix and Private Enterprise Number.
    See help about_adschema for more information.

.EXAMPLE
    PS> New-ADSchemaTestOID
        1.2.840.113556.1.8000.2554.9398

.EXAMPLE
   PS> New-ADSchemaTestOID -Parts 5 -Prefix 1.2.3
       1.2.3.6317.60671.47166.17019.42042

.EXAMPLE       
   PS> New-ADSchemaTestOID -Parts 4 -Prefix 1.2.3
       1.2.3.7279.9696.19673.18618

.EXAMPLE
   PS> New-ADSchemaTestOID -Parts 6
       1.2.840.113556.1.8000.2554.59800.33270.113.17098.41534.37654
#>
Function New-ADSchemaTestOID {
    param(
        [Parameter()]    
        $Prefix = "1.2.840.113556.1.8000.2554",

        [Parameter()]
        [ValidateRange(1,6)]
        $Parts = 2
    )
 
    $guid = (New-Guid).Guid
    
    $p = @()
    
    for ($i = 0; $i -lt $Parts * 5 ; $i+=5) {
      if($i -eq 0)  {$p += [UInt64]::Parse($guid.SubString($i , 4), "AllowHexSpecifier")}
      else {$p += [UInt64]::Parse($guid.SubString($i-1 , 4), "AllowHexSpecifier")} 
    }
    
    return $prefix + '.' + ($p -join '.')
    
}

