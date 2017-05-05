# ADSchema
A PowerShell Module that can be used to update the schema in Active Directory

# Installation
Copy module files to PSModulePath, typically C:\Program Files\WindowsPowerShell\Modules\

In a new PowerShell instance, import the module for use:
    `Import-Module ADSchema`
# Example

```
New-ADSchemaAttribute -Name asFavColor -Description 'User Favorite Color' -AttributeType String
New-ADSchemaClass asPerson -AdminDescription 'Person Class to host custom attributes' -Category Auxiliary
Add-ADSchemaAttributeToClass -Attribute asFavColor -Class asPerson
Add-ADSchemaAuxiliaryClassToClass -AuxiliaryClass asPerson -Class user
set-aduser andy -add @{'asFavColor' = 'blue'}
get-aduser andy -properties asFavColor
```
# Overview
The purpose of this module is to allow users to easily add attributes and classes to the schema of Active Directory. Editing the schema is often a daunting task and requires knowledge of several  details that most people do not think about on a regular basis. 
    
There is also a lot of fear when it comes to manually adding attributes, because it is a task that cannot be undone. Attributes in AD can be disabled, but they cannot be deleted.

Most of the time, an AD Administrator will want to add a handful of attributes to either user or computer objects for some reason or another. Maybe you want to store a computer's warranty expiration date in AD or you want to put some data you have in your HR System in AD for users,but there isn't a good fit with the out of the box attributes. Attributes should typically be named with a prefix. If I was creating a warranty expiration attribute for my computers, I would use soemthing like as-warrantyDate. 

Usually, the best practice is to create your new attributes, and then also create a new class. The new class should be an Auxiliary class. This essentially means that it can extend an existing class. 

Once you create the Auxiliary class, you can bind it to an existing class. This is actually something that can be undone, so it reeduces the fear and worry of really messing up your Active Directory.

Last, a quick note about Object Identifiers, also known as OID. OID's are what are used as unique identifiers of schema attributes and classes in Active Directory. They are also used in MIB's for networking. For development purposes, you can generate your own OID's. There is even a function in this module that will do it for you. However, if you are going to extend your production schema, you should register for a Private Enterprise Number. Information on this can be found at http://pen.iana.org/pen/PenApplication.page. 
