
###########################################################
## Mirror Computer AD Group and Copy to another computer
## This script takes the old workstation name and new workstation name from standardinputer
## 1. The old workstation hostname is used to diplay the groups to standard output
## 2. The new workstation name is passed to the Identity Parameter of Add-ADPrincipalGroupMembership
## 3. The old workstation hostname is passed to the MemberOf Parameter to retrived parameters as commar delimiated distinguished names using call MemberOf object of the grouped expression call to cmdlet Get-AddComputer
## Author: Charles Vasquez 
## Date 11/13/2023
###########################################################

# Prompt for old workstation hostname

$oldWks = Read-Host 'Enter Old Hostname'
$newWks = ''

# Diplay the groups from the old workstation
$oGroupNames = ((Get-ADComputer $oldWks -properties memberof).MemberOf | get-adgroup).name

## Display old workstation group
Write-Host $oGroupNames

#prompt for new workstation 
$newWks = Read-Host "Enter New Workstation Hostname"

## Copy groups from old workstation to new workstation
Add-ADPrincipalGroupMembership -Identity (Get-ADComputer $newWks) -MemberOf ((Get-ADComputer $oldWks -properties memberof).MemberOf | get-adgroup).name

## Get new workstation hostnames
# Diplay the groups from the old workstation
$nGroupNames = ((Get-ADComputer $newWks -properties memberof).MemberOf | get-adgroup).name


## Display old workstation group
Write-Host $nGroupNames
