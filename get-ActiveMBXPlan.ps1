$Report = [System.Collections.Generic.List[Object]]::new()
$MbxPlans = Get-MailboxPlan
ForEach ($Plan in $MbxPlans) { 
    $Dn = (Get-MailboxPlan -Identity $Plan.Name).DistinguishedName
    [Array]$Mbx = Get-ExoMailbox -Filter "MailboxPlan -eq '$Dn'" -Properties MailboxPlan -ResultSize Unlimited 
    
    # Find mailboxes with the plan 
    If ($Mbx) {
        ForEach ($M in $Mbx) {
            $ReportLine = [PSCustomObject][Ordered]@{
                Name = $M.DisplayName
                UPN = $M.UserPrincipalName 
                Plan = $Plan.DisplayName
            } 
            $Report.Add($ReportLine)
        }
    }
}
#End ForEach
$Report | Group-Object Plan | Format-Table Name, Count