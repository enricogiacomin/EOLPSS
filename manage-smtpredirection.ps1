<# 
    Script creato per SIAC che recupera tutte le mailbox utente con primary smtp address di dominio diverso da kk-cab.com,
    recupera l'indirizzo del dominio siacitaliaspa.onmicrosoft.com e configura un redirect allo stesso indirizzo di
    posta sul dominio siac-cab.com.

    Autore: Enrico Giacomin
    Data ultima modifica: 20230223

    # DISCLAIMER:
    # THIS CODE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    # THE SOFTWARE.
#>

function configureRedirect($mbx) {
    $addr = $mbx.primarysmtpaddress.replace('@siac-cab.eu','@siac-cab.com')
    Write-Host -ForegroundColor Green ("Inoltro le mail destinate a $mbx.displayName all'indirizzo $addr")
    Set-Mailbox $mbx -ForwardingSmtpAddress $addr -DeliverToMailboxAndForward $false -Verbose -Force
}

$ModulesLoaded = Get-Module | Select Name
If (!($ModulesLoaded -match "ExchangeOnlineManagement")) {Write-Host "Please connect to the Exchange Online Management module and then restart the script"; break}

# Connect-ExchangeOnline -UserPrincipalName "smeupics@siacitaliaspa.onmicrosoft.com"

$mbxRedirect = Get-EXOMailbox -RecipientTypeDetails UserMailbox  -Properties ForwardingSmtpAddress  | Where-Object {!($_.primarysmtpaddress -like "*kk-cab.com")}

foreach ($m in $mbxRedirect){
    configureRedirect($m)
}


