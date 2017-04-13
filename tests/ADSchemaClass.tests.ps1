Describe "ADSchema Class Functions" {
    Context "Get-ADSchemaClass"{
        It "exists a function in the module" {
            (Get-Command Get-ADSchemaClass).count | should be 1
        }
    }

    Context "New-ADSchemaClass"{
        It "exists as a function in the module" {
            (Get-Command New-ADSchemaClass).count | should be 1
            
        }
    }

}
