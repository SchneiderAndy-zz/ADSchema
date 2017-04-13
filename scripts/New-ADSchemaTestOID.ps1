Function New-ADSchemaTestOID {
    param(
        [Parameter()]    
        $Prefix = "1.2.840.113556.1.8000.2554",

        [Parameter()]
        [ValidateRange(1,6)]
        $OidGroups = 2
    )
 
    $guid = (New-Guid).Guid
    
    $parts = @()
    
    for ($i = 0; $i -lt $OidGroups * 5 + 1; $i+=5) {
      if($i -eq 0)  {$parts += [UInt64]::Parse($guid.SubString($i , 4), "AllowHexSpecifier")}
      else {$parts += [UInt64]::Parse($guid.SubString($i-1 , 4), "AllowHexSpecifier")} 
    }
    
    return $prefix + '.' + ($parts -join '.')
    
}


New-ADSchemaTestOID -OidGroups 4