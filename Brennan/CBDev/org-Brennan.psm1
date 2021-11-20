#Get public and private function definition files.
$PublicPath = "$PSScriptRoot\Public\*.ps1"
$PrivatePath = "$PSScriptRoot\Private\*.ps1"

# Check & Import Public
if (   $true -eq [Boolean]$(Test-Path -Path $PublicPath -ErrorAction SilentlyContinue)   ){
    [Array]$Public  = $(Get-ChildItem -Path $PublicPath -ErrorAction SilentlyContinue)
    if ($Null -ne $Public){
        foreach($Import in $Public | Sort-Object -Descending -Property Name){
            try
            {
                . $Import.FullName | Out-Null
            }
            catch {
                Write-Warning -Message "(Public Import): Failed to import function $($Import.Fullname): $_"
            }
        }
    }
    # Export Public Functions
    Export-ModuleMember -Function $Public.Basename -Alias *
}

# Check & Import Private
if (   $true -eq [Boolean]$(Test-Path -Path $PrivatePath -ErrorAction SilentlyContinue)   ){
    [Array]$Private = $(Get-ChildItem -Path $PrivatePath -ErrorAction SilentlyContinue)
    if ($Null -ne $Private){
        foreach($Import in $Private){
            try
            {
                . $Import.FullName | Out-Null
            }
            catch {
                Write-Warning -Message "(Private Import): Failed to import function $($Import.Fullname): $_"
            }
        }
    }
}
