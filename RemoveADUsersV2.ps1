<#
    .SYNOPSIS
        Deactivate Active directory Users. Move Deactivated AD users to Disabled Users Directory
    .DESCRIPTION
        This script searches the AD for a users or list of users. To Search a list
        Bulk users: Import a comma deliminated file
        
#>

# Import the AD Module
Import-Module -Name ActiveDirectory 

# Function to Searches the Active Directory for disabled users in all OUs exculding the your disabled OU
function ADSearch {
  #Search the AD for disabled user accounts
  Search-ADAccount -AccountDisabled | Where {$_.DistinguishedName -notlike “*OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local*”}| Select-Object Name, DistinguishedName | export-csv c:\temp\$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))_SearchADforDelUsrs.csv
}
# List all accounts which are already disabled on your AD and save report
ADSearch 

# Import list of users
$csv = Import-csv -Path "c:\temp\O365Users.csv"

# Disable User Account
$csv | ForEach-Object {(set-AdUser -Identity $_.samaccount -Enable $false)}

# Report of disabled users
$csv | ForEach-Object {(get-aduser  -Identity $_.samaccount -filter {Enabled -eq $false} | select samAcGivenName)}

# Move all disabled AD users from others OU to the disabled users OU
ADSearch | Move-ADObject -TargetPath “OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local” | Export-CSV -Path c:\temp\$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))_MovADdisabledUsr.csv
