If (!(test-path -pathtype Container C:\PDQScripts)) {New-item -itemtype directory -force -path c:\PDQScripts}
Start-Transcript c:\PDQScripts\InstallAbacusChocolateyTranscript.log
$ChocoPath = "C:\ProgramData\chocolatey\bin\choco.exe"
$ChocoInstalled = [System.IO.File]::Exists($ChocoPath)

if ($ChocoInstalled -match "False") {
    Write-Output "Chocolatey not installed"
    #Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

### Add repository from full chocolatey path
$SourceList = C:\ProgramData\chocolatey\bin\choco.exe source list

### Check if abacus feed is installed
$AbacusSourceList = $SourceList -match "accessabacus"

if ($AbacusSourceList.count -lt 1) {
    Write-Output "Missing"
    $Password = Get-Content "C:\PDQScripts\Password.txt" | ConvertTo-SecureString -Key (Get-Content "C:\PDQScripts\AES.key")
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    C:\ProgramData\chocolatey\bin\choco source add -n=abacus-chocolatey-beta -s="https://pkgs.dev.azure.com/accessabacus/Chocolatey/_packaging/beta/nuget/v2" -u="srv-chocolatey@accessabacus.com" -p="$PlainPassword"
}

### Determine OS Version Type
$WMIOSType = Get-WmiObject -Query "SELECT ProductType, CSName FROM Win32_OperatingSystem"

### Install default packages depending on OS type
    ### Desktops ###
if ($WMIOSType.ProductType -eq 1) {
    ##Add Desktop installs here
    C:\ProgramData\chocolatey\bin\choco.exe upgrade abacus_automateagent -s abacus-chocolatey-beta -y -force
}

    ### Servers ###
<#
if ($WMIOSType.ProductType -ge 2) {
    ##Add Server Installs here
    C:\ProgramData\chocolatey\bin\choco.exe upgrade abacuspackagesserver -s abacus-chocolatey-beta -y -force
}
#>