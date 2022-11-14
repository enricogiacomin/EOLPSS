$EOLRec = Get-Recipient -ResultSize unlimited

$EOLROutput = $EOLRec | ForEach-Object { 
    [PSCustomObject]@{
        "DisplayName" = $_.DisplayName
        "FirstName" = $_.FirstName
        "LastName" = $_.LastName
        "Identity" = $_.Identity
        "City" = $_.City
        "StateOrProvince" = $_.StateOrProvince
        "Company" = $_.Company
        "Department" = $_.Department
        "Office" = $_.Office
        "Manger" = $_.Manger
        "Notes" = $_.Notes
        "CustomAttribute1" = $_.CustomAttribute1
        "CountryOrRegion" = $_.CountryOrRegion
        "RecipientType" = $_.RecipientType
        "RecipientTypeDetails" = $_.RecipientTypeDetails
        "PrimarySmtpAddress" = $_.PrimarySmtpAddress
        "EmailAddresses" = $_.EmailAddresses -join ','
        "AddressListMembership" = $_.AddressListMembership -join ','
    }
}
$EOLROutput | export-csv C:\Agg\EOLRecipients.csv -delimiter ";" -force -notypeinformation