Describe "ADSchema Class Functions" {
    
    Context "Help for functions" {
        foreach ($command in Get-Command -Module ADSchema) {
            It "$command has examples in the help" {
            $help = get-help -Full $command
            $help.examples.example | should not be $null
        }
        }
    }
}