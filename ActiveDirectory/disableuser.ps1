# Import the AD Module
Import-Module -Name ActiveDirectory 
<# 
    
    Instructions: Edit the file O365Users.csv located in c:\temp 
    under the field same name include the username, that is the first inital of the firstname and lastname

    Run this script. 

    The users will be diabled and two reports written
    the 1st will be a search of all disabled users account and the second a check to ensure all user accounts in list ware diabled


#>
# Import Comma seperated file and assign it to a variable
$csv = Import-csv -Path "C:\Users\Administrator\Documents\disableusers.csv"

# Function to Search for Disabled users in all OUs exculding the disabled folder
function ADSearch {

#Search the AD for disabled user accounts
Search-ADAccount -AccountDisabled | Where {$_.DistinguishedName -notlike “*OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local*”}

}

# This report will have data only if a user account is not moved to the OU=Disabled_Users directory
# Seach the AD for Deleted account and save report with date and time
ADSearch| Select-Object Name, UserPrincipalName,Enabled | Export-CSV c:\temp\$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss'))_ADSearchDelUsr.csv


# Disable the users based on the imported CSV file
$csv | ForEach-Object {(set-AdUser -Identity $_.samaccount -Enable $false)}

# Report any users disabled
# Compares the CSV list with the users in the AD to find users accounts that are deleted. If the account was found to be deleted then the field "Sidecare" will contain a double equal sign ==
$ad =  Get-ADUser -filter "Enabled -eq 'False'" 
Compare-Object -ReferenceObject $csv.samAccount -DifferenceObject $ad.samAccountName -IncludeEqual -ExcludeDifferent  | Export-Csv -Path c:\temp\$((Get-Date).ToString('Mm-dd-yyy_hh-mm-ss'))_compListDelUsers.csv    -NoTypeInformation


# Move all disabled AD users from others OU to the disabled users OU
ADSearch | Move-ADObject -TargetPath “OU=Disabled_Users,OU=Sites,DC=arcmon,DC=local” 

