### Brennan.ps1

<#
	Description:
	Boot Strap Script - "Login Script"
	
	Version:
	11.20.22

	RequiredModules:
	$RequiredModules = @("Brennan")

	Author:
	Chris Brennan
	Brennan Technologies
	mailto:cbrennan@brennantechnologies.com
	https://www.brennantechnologies.com

	Copyright:
	(c) 2021 Brennan Technologies, LLC. "All rights reserved, for Use with Permission Only"
#>

function Set-PSModulePath {
	[CmdletBinding()]
	param (
		[Parameter()]
		[string[]]
		$ModulePaths = @(
			#"C:\WindowsPowerShell\Modules"
			"C:\Users\brenn\OneDrive\___CB Docs\_PowerShell\WindowsPowerShell\Modules"
		)
		,
		[Parameter()]
		[string]
		$LogLevel = "DeveloperMode"
	)
	begin { 
		Write-Host "Function: " $((Get-PSCallStack)[0].Command) -ForegroundColor DarkGray
		if($logLevel -eq "DeveloperMode"){
			foreach($ModulePath in $ModulePaths){
				Write-Host "Adding Module Path: " $ModulePath -ForegroundColor DarkGray
			}
		}
	}
	process {
		foreach($ModulePath in $ModulePaths){
			if((Test-Path $ModulePath)){
				if($env:PSModulePath.Split(";").Contains($ModulePath) -eq $false){                                        ### If the path is not already in the PSModulePath, add it.
					Write-Host "Adding ModulePath"  $ModulePath -ForegroundColor Green
					$env:PSModulePath = "$($env:PSModulePath -split ';' -notmatch "\\\\" -join ";");$ModulePath"          ### Remove any UNC paths & Add my Paths.
				} else {
					Write-Host "Skipping: Module Path already in PSModulePath" -ForegroundColor Cyan
				}
			} else {
				Write-Host "Module Path does not exist" -ForegroundColor Red
			}
		}
	}
	end {
		if($logLevel -eq "DeveloperMode") {
			foreach($path in $env:PSModulePath.Split(';')){
				Write-Host "ModulePath`t $path" -ForegroundColor DarkGray
			}
			
		}
	}
}
function Import-RequiredModules {
	[CmdletBinding()]
	param (
		[Parameter()]
		[string[]]
		$RequiredModules = @(
			"Brennan"
			#,
			#"Brennan.Core"
			#,
			#"Brennan.CodeSigning"
		)
		,
		[Parameter()]
		[switch]
		$Force
	)
	begin {
		Write-Host "Function: " $((Get-PSCallStack)[0].Command) -ForegroundColor DarkGray
	}
	process {
		### Import Required Modules.
		###------------------------------------------------
		foreach($module in $requiredModules){
			try {
				if( [bool](Get-Module -Name $module -ListAvailable) -eq $true ){
					Write-Host "Importing Module: " $module -ForegroundColor Magenta
					if($force){
						Get-Module -Name $module -ListAvailable | Import-Module -Force
						Get-Module -Name $module
					} else {
						Get-Module -Name $module -ListAvailable | Import-Module
					}
				}
				else {
					Write-Error -Message "Required Module $RequiredModule isnt available." 
				}
			}
			catch {
				Write-Warning -Message ("ERROR Importing required module: $RequiredModule" + $global:Error[0].Exception.Message) -ErrorAction Stop
			}
		}
	}
	end {}
}

### Run the script
&{
	begin {
		### Set-PSModulePath
		###------------------------------------------------
		$modulePaths = "C:\Users\brenn\OneDrive\___CB Docs\_PowerShell\WindowsPowerShell\Modules"
		Set-PSModulePath -ModulePaths  $modulePaths                               	### Modify $PSModulepath:   Adds Custom $PSModulepath, removes UNC paths

		### Import-RequiredModules                                              	### Imports an array of Custom modules
		###------------------------------------------------
		[string[]]$RequiredModules = @(
			"Brennan"
			#,
			#"Schwab.VCE"
			#,
			#"VMWare.Vim"
			#,
			#"VMware.VimAutomation.Core"
		)
		
		### Import-RequiredModules                                              ### Manually import VMWare modules as needed
		Import-RequiredModules -RequiredModules $RequiredModules -Force

		### Manaually Import VMware Modules: (as needed)
		###------------------------------------------------
		#Get-Module vmware.vim* -ListAvailable | Import-Module
	}
	process {

		############################
		### Testing:
		############################

		### Info
		#Write-Log -Msg “This is a Test” -Cat “Info” -Color “White” -WriteToFile $true -WriteToConsole $true -LogFilePath “$PSScriptRoot\logs\” -LogFileName “$LogFilePath\log.txt” -debugMode $true
		
		### Warning
		#Write-Log -Msg “This is a Warning" -Cat "Warning" -Color “White” -WriteToFile $true -WriteToConsole $true -LogFilePath “$PSScriptRoot\logs\” -LogFileName “$LogFilePath\log.txt”

	}
	end {}
}

### original
<#
function Import-RequiredModules {
	[CmdletBinding()]
	param (
		[Parameter()]
		[string[]]
		$RequiredModules = @(
			"Brennan"
			"Brennan.Core",
			"Brennan.CodeSigning"
		)
	)
	### Import Required Modules.
	###------------------------------------------------
	foreach($RequiredModule in $RequiredModules){
		try {
			if( [bool](Get-Module -Name $RequiredModule -ListAvailable) -eq $true ){
				Write-Host "Importing Module: " $RequiredModule -ForegroundColor Magenta
				Import-Module -Name $RequiredModule -Force
				Get-Module -Name $RequiredModule
			}    
			else {
				Write-Error -Message "Required Module $RequiredModule isnt available." 
			}
		}
		catch {
			Write-Warning -Message ("ERROR Importing required module: $RequiredModule" + $global:Error[0].Exception.Message) -ErrorAction Stop
		}
	}
}


[string[]]$RequiredModules = @(
	#"Brennan"
	"Brennan.Core",
	"Brennan.CodeSigning",
	"Brennan.SQL",
	"Brennan.Reporting"
)
Import-RequiredModules -RequiredModules $RequiredModules

#Import-RequiredModules

#>
