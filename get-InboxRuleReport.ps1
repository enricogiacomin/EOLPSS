<#
.Synopsis
  Get a list of all the inbox rule configured in Exchange Online
.DESCRIPTION
  This script will get a human readable list of all the inbox rule configured in one
  or more mailboxes
.NOTES
  Name: Get-InboxRuleReport.ps1
  Author: E. Giacomin - Smeup ics
  Version: 0.1
  DateCreated: Feb 2022
  Purpose/Change: Sintentic list of all inbox mail rule of certain or any users
  Thanks to: R. Mens
.EXAMPLE
  Get-InboxRuleReport | out-gridview
  Get a list of the inbox rule of alla the mailboxes of licensed users
#>

param(
  [Parameter(
    Mandatory = $false,
    ParameterSetName  = "UserPrincipalName",
    HelpMessage = "Enter a single UserPrincipalName or a comma separted list of UserPrincipalNames",
    Position = 0
    )]
  [string[]]$UserPrincipalName
)

#### Istanzio la classe per ospitare i risultati
#$UserPrincipalName = "e.giacomin@nanosoft365.com","e.giacomin@jacknet.biz"

#### Ricerca delle regole attive in ciascuna mailbox
if ($PSBoundParameters.ContainsKey('UserPrincipalName')) {
  foreach ($upn in $UserPrincipalName){
      $tempRule = Get-InboxRule -Mailbox $upn
      foreach ($t in $tempRule){
        [PSCustomObject]@{
          "nome Regola" = $t.name
          "descrizione Regola" = $t.DESCRIPTION
          "nome Mailbox" = $upn.ToString()
        }
      }

  }
}
else {
  $MsolUsers = Get-MsolUser -EnabledFilter EnabledOnly -All | Where-Object {$_.IsLicensed -eq $true} | Sort-Object UserPrincipalName
  foreach ($upn in $MsolUsers){
    $tempRule = Get-InboxRule -Mailbox $upn.UserPrincipalName
    foreach ($t in $tempRule){
      [PSCustomObject]@{
        "nome Regola" = $t.name
        "descrizione Regola" = $t.DESCRIPTION
        "nome Mailbox" = $upn.UserPrincipalName
      }
    }
  }
}

