$workingDir = (Get-Location).Path


if(-not $env:PSScriptRoot)
{
	$ScriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
} else {
	$ScriptPath = $env:PSScriptRoot
}

Write-Host "PSScriptRoot : " $env:PSScriptRoot
Write-Host "ScriptPath   : " $ScriptPath