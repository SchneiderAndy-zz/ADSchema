Function Invoke-ADSchemaReload {
   $dse =  Get-ADRootDSE
   $dse.schemaUpdateNow = $true
}