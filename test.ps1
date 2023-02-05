# Connect-ExchangeOnline
$CheckName = Read-Host "Enter Name of mailbox to add"
Try { 
    $Mbx = Get-ExoMailbox -Identity $CheckName -ErrorAction Stop | Select -ExpandProperty PrimarySmtpAddress
}
Catch {
    Write-Host "No mailbox can be found called" $CheckName
    break 
}