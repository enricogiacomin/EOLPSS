Connect-ExchangeOnline

$dl = Import-Csv -Path C:\Users\e.giacomin-n365\Downloads\gruppi2SIAC.csv

foreach ($d in $dl){
    switch ($d.Esterno) {
        "Si" { $auth =  $false }
        Default { $auth = $true}
    }
    #Remove-DistributionGroup -Identity $d.NomeM365 -Confirm:$false
    new-DistributionGroup -Name $d.NomeM365 -Description $d.descrizione -DisplayName $d.NomeM365 -RequireSenderAuthenticationEnabled $auth -Alias $d.email.Replace("@siac-cab.eu","") -PrimarySmtpAddress $d.email -Verbose
}