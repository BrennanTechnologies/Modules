If (!(test-path -pathtype Container C:\PDQScripts)) {New-item -itemtype directory -force -path c:\PDQScripts}
Start-Transcript c:\PDQScripts\AbacusChocolateyPackagesTranscript.log
$ChocoPath = "C:\ProgramData\chocolatey\bin\choco.exe"

### Determine OS Version Type

$WMIOSType = Get-WmiObject -Query "SELECT ProductType, CSName FROM Win32_OperatingSystem"

## Install default packages depending on OS type

#### Desktops

if ($WMIOSType.ProductType -eq 1) {

##Add Desktop installs here

C:\ProgramData\chocolatey\bin\choco.exe upgrade abacus_automateagent -s abacus-chocolatey-beta -y -force

}

#### Servers

<#if ($WMIOSType.ProductType -ge 2) {

    ##Add Server Installs here
    
    C:\ProgramData\chocolatey\bin\choco.exe upgrade abacuspackagesserver -s abacus-chocolatey-beta -y -force
    
    }#>



