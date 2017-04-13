

Describe "ADSchema Attribute Functions" {
    Context "Get-ADSchemaAttribute" {
        It "exists as a function in the module" {
            (Get-Command Get-ADSchemaAttribute).count | should be 1
        }

        It "returns a schema object - test use CN Attribute" {
            (Get-ADSchemaAttribute -class User -Attribute cn).Oid | Should Be '2.5.4.3'
        }

        It "accepts wildcards" {
            ((Get-ADSchemaAttribute -class User -Attribute c*) | 
                    Where-Object {$_.Name -eq 'CN'}).count | 
                Should Be 1
        }
    }

    Context "New-ADSchemaAttribute" {
        It "exists as a function in the module" {
            (Get-Command New-ADSchemaAttribute).count | should be 1
            
        }
    }

}
