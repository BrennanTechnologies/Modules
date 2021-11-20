<#
.SYNOPSIS
Executes the UnBlock-File command on a single file or a folder of files.

.DESCRIPTION
Executes the UnBlock-File command on a single file or a folder of files.

.PARAMETER File
Full Path and Filename of a Single File.

.PARAMETER Path
Fulee Path of a Folder.

.EXAMPLE
$File = "C:\Users\P3032489\Documents\WindowsPowerShell\Scripts\Misc\Unblock-Files.ps1"
UnBlock-Files -File $File

$Path = "C:\Users\P3032489\Documents\WindowsPowerShell\Scripts\Misc\"
UnBlock-Files -Path $Path

.NOTES
General notes
#>
function UnBlock-Files{
    [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true,
            ParameterSetName = 'File')]
            [string]
            $File
            ,
            [Parameter(Mandatory = $true,
            ParameterSetName = 'Path')]
            [string]
            $Path
            ,
            [Parameter()]
            [switch]
            $Confirm
        )
    if($File){
        Unblock-File -Path $File -Verbose
    }
    if($Path){
        if($Path.Substring($Path.Length - 1) -ne "\" ){
            $Path = $Path + "\"
        }
        $Files = (Get-ChildItem -Path $Path -File -Recurse).FullName
        foreach($File in $Files){
            if($Confirm){
                Unblock-File -Path $File -Verbose -Confirm:$true
            } else {
                Unblock-File -Path $File -Verbose -Confirm:$false
            }
        }
    }
}





