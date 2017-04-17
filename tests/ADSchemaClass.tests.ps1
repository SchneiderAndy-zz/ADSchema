


Describe "ADSchema Class Functions" {
    Context "Get-ADSchemaClass" {
        It "exists as a function in the module" {
            (Get-Command Get-ADSchemaClass).count | should be 1
        }

        It "returns a schema object - test uses user class" {
            (Get-ADSchemaClass -Class 'User').Oid | Should Be '1.2.840.113556.1.5.9'
        }

        It "accepts wildcards" {
            ((Get-ADSchemaClass -class use*) | 
                    Where-Object {$_.Name -eq 'User'}).count | 
                Should Be 1
        }
    }

    Context "New-ADSchemaAttribute" {
        It "exists as a function in the module" {
            (Get-Command New-ADSchemaClass).count | should be 1        
        }
    }

}
