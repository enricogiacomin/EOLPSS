Start-Transcript C:\AGG\aliasadd.txt
$alias = Get-Recipient -Filter { company -eq 'Lucchini LBX' } | Select-Object -Property alias, primarysmtpaddress
foreach ($a in $alias) {
    Get-Mailbox $a.Alias
    $addr = $a.primarysmtpaddress.replace("lbx.be", "lucchinirs.mail.onmicrosoft.com")
    Write-Host $addr
    Set-Mailbox $a.alias -EmailAddresses @{Add = "$addr" }
}
stop-Transcript