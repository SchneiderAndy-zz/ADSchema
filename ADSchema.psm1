$Scripts  = @( Get-ChildItem -Path $PSScriptRoot\Scripts\*.ps1  )
    

#Dot source the files
    Foreach($Script in @($Scripts))
    {
        Try
        {
            Write-Verbose "Importing $($Script.Fullname)"
            . $Script.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }



Export-ModuleMember -Function $Scripts.Basename