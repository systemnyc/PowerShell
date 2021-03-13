# Import the AD Module
Import-Module -Name ActiveDirectory 

# Function to Search for Disabled users in all OUs exculding the disabled folder
function ADSearch {

#Search the AD for disabled user accounts
Search-ADAccount -AccountDisabled | Where {$_.DistinguishedName -notlike “*OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local*”}

}

# Import Comma seperated file and assign it to a variable
$csv = Import-csv -Path "c:\temp\O365Users.csv"

# Disable the users based on the imported comma seperated file
$csv | ForEach-Object {(set-AdUser -Identity $_.samaccount -Enable $false)}

# Check if users in list were disabled
$csv | ForEach-Object {(get-aduser  -Identity $_.samaccount -filter {Enabled -eq $false} | select samAcGivenName)}


# List all accounts which are already disabled on your AD
#Search-ADAccount -AccountDisabled -SearchBase "OU=Sites,DC=arcmon,DC=local" | Select-Object Name, DistinguishedName | export-csv c:\temp\ADdisabledUsers
ADSearch
#Seach the AD for Deletd account
ADSearch | Select-Object Name, DistinguishedName | export-csv c:\temp\$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))_SearchADforDelUsr.csv

# Move all disabled AD users from others OU to the disabled users OU
# $DisabledUsers = Search-ADAccount -AccountDisabled | Where {$_.DistinguishedName -notlike “*OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local*”}
# Write-output $DisabledUsers | Export-CSV -Path c:\temp\$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))_ADdisabledUsers.csv
ADSearch | Move-ADObject -TargetPath “OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local” | Export-CSV -Path c:\temp\$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))_MovADdisabledUsr.csv


