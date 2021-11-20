If (!(test-path -pathtype Container C:\PDQScripts)) {New-item -itemtype directory -force -path c:\PDQScripts}
Start-Transcript c:\PDQScripts\InstallAbacusChocolateyTranscript.log
$ChocoPath = "C:\ProgramData\chocolatey\bin\choco.exe"


$ChocoInstalled = [System.IO.File]::Exists($ChocoPath)

if ($ChocoInstalled -match "False") {

    Write-Output "Chocolatey not installed"
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

}

# Add repository from full chocolatey path

$SourceList = C:\ProgramData\chocolatey\bin\choco.exe source list

### Check if abacus feed is installed

$AbacusSourceList = $SourceList -match "accessabacus"

if ($AbacusSourceList.count -lt 1) {Write-Output "Missing"



#C:\ProgramData\chocolatey\bin\choco source add -n=abacus-chocolatey-beta -s="https://pkgs.dev.azure.com/accessabacus/Chocolatey/_packaging/beta/nuget/v2" -u="srv-chocolatey@accessabacus.com" -p="gclok3r7djlffuguebnn3jr5y6b564m6gxizaf44itmohrkt6e3q"

$password = Get-Content .\password.txt | ConvertTo-SecureString -Key (Get-Content .\aes.key)
C:\ProgramData\chocolatey\bin\choco source add -n=abacus-chocolatey-beta -s="https://pkgs.dev.azure.com/accessabacus/Chocolatey/_packaging/beta/nuget/v2" -u="srv-chocolatey@accessabacus.com" -p=$Password

}
