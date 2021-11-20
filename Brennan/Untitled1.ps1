    cls

    if(-not $PSScriptRoot)
    {
        $PAth = Split-Path $MyInvocation.MyCommand.Path -Parent
    }
    #$ModuleRoot = 

    cls
    Write-Host "PSScriptRoot           : " $PSScriptRoot -ForegroundColor Magenta
    Write-Host "MyInvocation.MyCommand : " $MyInvocation.MyCommand.Path -ForegroundColor Magenta
    Write-Host "MyInvocation.MyCommand : " $(Split-Path $MyInvocation.MyCommand.Path -Parent) -ForegroundColor Magenta
    Write-Host "Path                   : " $PAth -ForegroundColor Magenta

