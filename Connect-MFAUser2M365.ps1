$AdminUsername = Read-Host -Prompt "Azure/Office 365 Admin User Account"
$AdminPassword = Read-Host -Prompt "Password" -AsSecureString

$adminCredentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $AdminUsername, $AdminPassword
Import-Module msonline -ErrorAction SilentlyContinue
Import-Module MicrosoftTeams
Import-Module AZ
import-module ExchangeOnlineManagement
import-module 'C:\Program Files\Common Files\Skype for Business Online\Modules\SkypeOnlineConnector\SkypeOnlineConnector.psd1' 
Login-AzureRmAccount -Credential $adminCredentials
Connect-AzureAD -Credential $adminCredentials 
Connect-ExchangeOnline -Credential $adminCredentials