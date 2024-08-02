<#
    .SYNOPSIS
       Mirror Computer AD Group and Copy to another computer. This script takes the old workstation name and new workstation name from standardinputer
       
    .DESCRIPTION
       The old workstation hostname is passed to the MemberOf Parameter of Get-ADComputer ${c retrived parameters as commar delimiated distinguished names using call MemberOf object of the grouped expression call to cmdlet Get-AddComputer
       Author: Charles Vasquez, 20234
    .INPUTS 
      Old Hostname
    .OUTPUT
      Old Hostname Group Memembership 
#>

## Prompt for old workstation hostname ##

$oldWks = Read-Host 'Enter Old Hostname'
$newWks = ''

## Diplay the groups from the old workstation ##
$GroupNames = ((Get-ADComputer $oldWks -properties memberof).MemberOf | get-adgroup).name

## Display old workstation group ##
Write-Host $GroupName

### Prompt user for new workstation hostname ##
$newWks = Read-Host "Enter New Workstation Hostname"

## Copy groups from old workstation to new workstation ##
Add-ADPrincipalGroupMembership -Identity (Get-ADComputer $newWks) -MemberOf ((Get-ADComputer $oldWks -properties memberof).MemberOf | get-adgroup).name
