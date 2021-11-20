### SaveAs: Brennan PSM Template.psm1

<#
	### Boot Strap Module
	###------------------------------------------------

	Chris Brennan
	Brennan Technologies
	mailto:cbrennan@brennantechnologies.com
	https://www.brennantechnologies.com

	v.11.19.21

	Copyright = (c) 2021 Brennan Technologies. "All rights reserved, for Use with Permission Only"
#>

### Set Paths
$publicPath = "$PSScriptRoot\Public\*.ps1"                                                                  ### Set thr path to the PUBLIC function files. (.ps1's)
$privatePath = "$PSScriptRoot\Private\*.ps1"                                                                ### Set thr path to the PRIVATE function files. (.ps1's)

### Import Public Functions                                                                                 ### Dot Source Imports all .ps1 files in the PUBLIC $publicPath
if ( $true -eq [boolean]$(Test-Path -Path $publicPath -ErrorAction SilentlyContinue) ){
	[array]$public  = $(Get-ChildItem -Path $publicPath -ErrorAction SilentlyContinue)
	if ($null -ne $public){
		foreach($import in $public | Sort-Object -Descending -Property Name){
			try
			{
				. $import.FullName | Out-Null
			}
			catch {
				Write-Warning -Message "(Public Import): Failed to import function $($import.Fullname): $_"
			}
		}
	}
	### DO: Export Public Functions
	Export-ModuleMember -Function $public.Basename -Alias *
}

### Import Private Functions                                                                                ### Dot Source Imports all .ps1 files in the PRIVATE $privatePath
if ( $true -eq [boolean]$(Test-Path -Path $privatePath -ErrorAction SilentlyContinue) ){
	[array]$private = $(Get-ChildItem -Path $privatePath -ErrorAction SilentlyContinue)
	if ($null -ne $private){
		foreach($import in $private){
			try
			{
				. $import.FullName | Out-Null
			}
			catch {
				Write-Warning -Message "(Private Import): Failed to import function $($import.Fullname): $_"
			}
		}
	}
	### DON'T: Export Private Functions
}

