### Schwab.VCE.BootStrap.ps1

<#
	Description:
	Schwab Boot Strap - "Login Script"

	Version: 
	11.20.21

	Required Modules:
	$RequiredModules = @("Schwab.VCE")
	
	NOTES:
	-------
		Questions for Meeting:  Mon 11-22-21
		- Is VDI Backed Up?
		- BitBucket?
		- GitHub login
			- Sync VSCode Settings
		- Can we build out own Developer Workstation VDI????
			- What do the other Schwab developers use??? What dept?

	- Need updates to WriteLogandScreen
		- special because it is used everywhere

	- Need to work on WriteScreenandLog to return an Object (object has more control than a string array)
		- will work with Matt and Dave on this
#>

function Set-PSModulePath {
	[CmdletBinding()]
	param (
		[Parameter()]
		[string[]]
		$ModulePaths = @()
		,
		[Parameter()]
		[string]
		$LogLevel  # = "debug"
	)
	begin { 
		Write-Host "Function: " $((Get-PSCallStack)[0].Command) -ForegroundColor DarkGray
		if($logLevel -eq "DEBUG"){
			foreach($ModulePath in $ModulePaths){
				Write-Host "Adding Module Path: " $ModulePath -ForegroundColor DarkGray
			}
		}
	}
	process {
		foreach($ModulePath in $ModulePaths){
			if((Test-Path $ModulePath)){
				if($env:PSModulePath.Split(";").Contains($ModulePath) -eq $false){                                        ### If the path is not already in the PSModulePath, add it.
					Write-Host "Adding New ModulePath"  $ModulePath -ForegroundColor Green
					$env:PSModulePath = "$($env:PSModulePath -split ';' -notmatch "\\\\" -join ";");$ModulePath"          ### Remove any UNC paths & Add my Paths.
				} else {
					Write-Host "Skipping: Module Path already in PSModulePath: $ModulePath" -ForegroundColor Cyan
				}
			} else {
				Write-Host "Module Path does not exist" -ForegroundColor Red
			}
		}
	}
	end {
		if($logLevel -eq "DEBUG") {
			foreach($path in $env:PSModulePath.Split(';')){
				Write-Host "Current ModulePath`t $path" -ForegroundColor DarkGray
			}
			
		}
	}
}
function Import-RequiredModules {
        <#
    .SYNOPSIS
    #

    .DESCRIPTION
    Long description

    .PARAMETER RequiredModules
    Parameter description

    .PARAMETER DebugMode
    Parameter description

    .EXAMPLE
    An example

    .NOTES
        ### Get Commands
        ### Get-Command -Module Schwab.VCE
    #>
	[CmdletBinding()]
	param (
		[Parameter()]
		[string[]]
		$RequiredModules = @(
			"All"
			,
			"Schwab.VCE"
			#,
			#"VMWare.Vim*"
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

		### Set-ModulePath                                                      ### Modify $PSModulepath:   Adds Custom $PSModulepath, removes UNC paths
		###------------------------------------------------
		Set-PSModulePath -ModulePaths @(
										#"C:\WindowsPowerShell\Modules"                                     ### Schwab Lab
										#,
										"C:\Users\brenn\OneDrive\___CB Docs\_Repo\Clients\Schwab"           ### My Lab
									)

		### Import-RequiredModules                                              ### Imports an array of Custom modules
		###------------------------------------------------
		[string[]]$RequiredModules = @(
			"Schwab.VCE.All"
			,
			"Schwab.VCE"
		)

		### Import-RequiredModules                                              ### Manually import VMWare modules as needed
		Import-RequiredModules -RequiredModules $RequiredModules -Force

		### Import VMWare Modules                                               ### Skip  if already loaded
		function Import-VMWareModules {
			if(-not $(Get-Module vmware.vim*)){
				Write-Host "Importing VMWare Modules" -ForegroundColor Magenta
				#Get-Module vmware.vim* -ListAvailable | Import-Module
			}
		} #Import-VMWareModules
		

	}
	process {
		#get-enumValues -enum "System.Diagnostics.Eventing.Reader.StandardEventLevel"
		#cls
		#$msg = "INFO: HA is Enabled on this Cluster: $ClusterName haCheck: $haCheck"
		#Write-ScreenAndLog "INFO" $msg -Color Green
		#exit

		### RACKADD
		$buildType = "RACKADD1"
		if ($buildType -eq "RACKADD") {
			$clusterName = "PDC1-C-LAB-HCI-TEST"
			$clusterHA = Get-VCE.ClusterHA -ClusterName $clusterName
			$clusterHA
		}

		### NEWBUILD
		if ($buildType -eq "NEWBUILD1") {
			$clusterName = "PDC1-C-LAB-HCI-TEST"
			$clusterHA = Set-VCE.ClusterHA -ClusterName $clusterName
			$clusterHA
		}

        Write-Log -Category Info -Message "This is a test" -Color Green
        Write-Log -Category WARN -Message "This is a test" -Color Red 
        Exit

		###-----------------------------------------------------------------------------------------------------
		###  Get-ClusterHA: Retry Loop
		###-----------------------------------------------------------------------------------------------------
		$clusterName = "PDC1-C-LAB-HCI-TEST"
		
		### Istantiate the Check Variable 
		$haCheck = ""
		do {
			if ($haCheck[2] -eq $false) { 															### IF HA Return value is false
				Write-ScreenAndLog "INFO" "Retry Setting HA on cluster $clusterName?`r`n"			### Options Prompt
				Write-ScreenAndLog "INFO" "1)    Yes"
				Write-ScreenAndLog "INFO" "2)    No (ends the script)"
				$user_input = InputAndCheck -numOptions 2 											### Get user input

				if ($user_input -eq 2) {															### User input is EXIT
					Write-ScreenAndLog "INFO" "User ended the script early."
					EXIT
				}
			}
			### Set HA on the Cluster
			### ---------------------------
			$haCheck = 	Get-VCE.ClusterHA -ClusterName $clusterName 								### Set-VCE.ClusterHA -ClusterName $clusterName
			Write-ScreenAndLog $haCheck[0] $haCheck[1]
		} until ($haCheck[2] -eq $true -or $skip -eq $true)	#										### Loop until the return value is true or the user ends the script

		

		###-----------------------------------------------------------------------------------------------------
		###  Set-ClusterHA: Retry Loop
		###-----------------------------------------------------------------------------------------------------
		$clusterName = "PDC1-C-LAB-HCI-TEST"
		
		### Istantiate the Check Variable 
		$haCheck = ""
		do {
			if ($haCheck[2] -eq $false) { 															### IF HA Return value is false
				Write-ScreenAndLog "INFO" "Retry Setting HA on cluster $clusterName?`r`n"			### Options Prompt
				Write-ScreenAndLog "INFO" "1)    Yes"
				Write-ScreenAndLog "INFO" "2)    No (ends the script)"
				$user_input = InputAndCheck -numOptions 2 											### Get user input

				if ($user_input -eq 2) {															### User input is EXIT
					Write-ScreenAndLog "INFO" "User ended the script early."
					EXIT
				}
			}
			### Set HA on the Cluster
			### ---------------------------
			$haCheck = 	Get-VCE.ClusterHA -ClusterName $clusterName 								### Set-VCE.ClusterHA -ClusterName $clusterName
			Write-ScreenAndLog $haCheck[0] $haCheck[1]
		} until ($haCheck[2] -eq $true -or $skip -eq $true)	#										### Loop until the return value is true or the user ends the script

		


			#Write-Log -Category Info -Message "This is a test" -Color Green
			#Write-Log -Category WARN -Message "This is a test" -Color Red 
			#Exit



		### Connect vCenter
		### ----------- --------------
		#$vCenter = "svs0604pdv.us.global.schwab.com"
		#$vCenter = Connect-VCE.vCenter -vCenter $vCenter -Credential $credential

		### Get-EVC.ClusterHA
		### ----------- --------------
		#$vmhostCluster = "PDC1-C-LAB-HCI-TEST"
		#Write-Host "Testing Cluster: " $vmhostCluster -ForegroundColor Magenta 
		#Get-EVC.ClusterHA -ClusterName $vmhostCluster
		
		#$clusterHAConfig = Get-Cluster $ClusterName | Select-Object -Property HAEnabled

		### Get Licensing Totals
		### ----------- --------------
		#Get-LicesnseTotals

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
