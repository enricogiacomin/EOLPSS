function Get-CalendarInformation
{
    <#
    .SYNOPSIS
        Script in powershell per recuperare le informazioni degli appuntamenti in calendario da una mailbox
    .DESCRIPTION
        Script in powershell per recuperre le informazioni degli appuntamenti in calendario da una mailbox.
        E' necessario che l'utente dal quale viene lanciato lo script abbia diritti di accesso alla mailbox
    .EXAMPLE
        PS C:\> Get-CalendarInformation -Identity "user@microsoft.com" -days 3 -path c:\temp\appuntamenti.txt
        Esporta un un pst gli appuntamenti dei prossimi tre giorni presenti nella mailbox user@microsoft.com
    .NOTES
        Lo script è stato creato partendo da
        https://social.technet.microsoft.com/wiki/contents/articles/37360.retrieve-calendar-information-using-ews-managed-api-2-2-and-powershell.aspx
        Thanks to Chendrayan Venkatesan a.k.a Chen V
        Prerequisiti:
        E' necessario che sull'host nel quale si esegue lo script siamo installati gli Exchange Web Services API 2.2 o superiori
        https://www.microsoft.com/en-us/download/details.aspx?id=42951
		
		Adattato per Cromodora Wheels da Enrico Giacomin (Nanosoft Srl) 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        $Identity,
  
        [Parameter()]
        $Days,

        [Parameter(Mandatory)]
        $Path,
  
        [Parameter()]
        [System.Management.Automation.CredentialAttribute()]
        [pscredential]
        $Credential
    )
     
    begin
    {
        Import-Module 'C:\Program Files\Microsoft\Exchange\Web Services\2.2\Microsoft.Exchange.WebServices.dll'
        #$Identity="sala.test@cromodorawheels.com"
        #$Days=5
    }
     
    process
    {
        $Service = [Microsoft.Exchange.WebServices.Data.ExchangeService]::new()
        if($PSBoundParameters.ContainsKey('Credential'))
        {
            $Service.Credentials = [System.Net.NetworkCredential]::new($Credential.UserName,$Credential.Password)
        }
        else
        {
            $Service.UseDefaultCredentials = $true
        }
        $Service.Url = "https://postacdw01.ghedi.cromodorawheels.it/EWS/Exchange.asmx"
        $Mailbox=New-Object Microsoft.Exchange.WebServices.Data.Mailbox($Identity)
        $folderid= new-object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar,$Mailbox) 
        $Folder = [Microsoft.Exchange.WebServices.Data.CalendarFolder]::Bind($Service,$folderid)
        $View = [Microsoft.Exchange.WebServices.Data.CalendarView]::new([datetime]::Now,[datetime]::Now.AddDays($Days))
        $View.PropertySet = [Microsoft.Exchange.WebServices.Data.PropertySet]::new([Microsoft.Exchange.WebServices.Data.AppointmentSchema]::Subject,
            [Microsoft.Exchange.WebServices.Data.AppointmentSchema]::Start,[Microsoft.Exchange.WebServices.Data.AppointmentSchema]::End,
            [Microsoft.Exchange.WebServices.Data.AppointmentSchema]::DateTimeSent,[Microsoft.Exchange.WebServices.Data.AppointmentSchema]::Location,
            [Microsoft.Exchange.WebServices.Data.AppointmentSchema]::Organizer)
        $Folder.FindAppointments($View) | Select-Object -Property Start,End,Location,Subject,Organizer,DateTimeSent | export-csv -Path $Path
    }
     
    end
    {
        $appointment=import-csv -Path $Path

        foreach ($a in $appointment){
        $pos = $a.organizer.IndexOf(" <")
        $a.organizer = $a.organizer.Substring(0, $pos)
        }
        $appointment | export-csv -Path $Path

    }
}

Get-CalendarInformation -Identity sala.test@cromodorawheels.com -Days 1 -Path C:\temp\_uno.txt