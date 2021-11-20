function Write-Log {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("INFO","WARNING","ERROR","FATAL","DEBUG")]
        [String]
        $Level = "INFO"
        ,
        [Parameter(Mandatory=$true)]
        [string]
        $Message
        ,
        [Parameter(Mandatory=$false)]
        [string]
        $LogFolderPath = "$PSScriptRoot\Logs"
        ,
        [Parameter(Mandatory=$false)]
        [string]
        $LogFile = $LogFolderPath + "\Logs\" + ($MyInvocation.MyCommand.Name) + "_" + ((Get-Date).toString("MM.dd.yyyy_HH.mm.ss")) + ".log"
        ,
        [Parameter()]
        [switch]
        $Quite
    )


    Begin { 
        ### SetUp Variables
        ###--------------------------------------------
        #$LogFile = $LogFolderPath + "\Logs\" + ($MyInvocation.MyCommand.Name) + "_" + ((Get-Date).toString("MM.dd.yyyy_HH.mm.ss")) + ".log"

        ### Create LogFile
        ###--------------------------------------------
        if (-Not (Test-Path -Path $LogFolderPath)) {
            New-Item -ItemType Directory -Path $LogFolderPath -Force
        }
        if (-Not (Test-Path -Path $LogFile)) {
            New-Item -ItemType File -Path $LogFile -Force
        }
            
    }
    
    Process { 

        #$TimeStamp = (Get-Date).toString("MM/dd/yyyy HH:mm:ss")
        $TimeStamp = (Get-Date -f g)
        $LogLine = "$TimeStamp $Level $Message"

        ###--------------------------------------------
        if($LogFile) {
            Add-Content $LogFile -Value $LogLine
        }
        else {
            Write-Output $LogLine
        }

        ###--------------------------------------------
        [pscustomobject]@{
            Time      = (Get-Date -f g)
            Message   = $Message
            Severity  = $Severity
        } | Export-Csv -Path "$env:Temp\LogFile.csv" -Append -NoTypeInformation


        ###--------------------------------------------
        if($PSScriptRoot){
            Write-Host "ScriptRoot Found. " $PSScriptRoot
        } 
        else {
            Write-Host "No Script Root."
        }

    
    }

    End { }
}


<#
try{
    get-content -Path "C:\Users\cb47067\Documents\Boone\BooneADUsers.csv1" -ErrorAction Stop
}
catch{
    #Write-Error -Message "Error: $Error[0].Exception.Message"
    
    #Write-Host "An error occurred:" $_.Exception.Message -ForegroundColor Yellow
    #Write-Host $_.ScriptStackTrace -ForegroundColor Yellow
    #Write-Host "An error occurred:" $Error[0].Exception.Message -ForegroundColor Green
    #Write-Host $Error[0].ScriptStackTrace -ForegroundColor Green

    Write-Host "An error occurred:" $_.Exception.Message "`r`n" $_.ScriptStackTrace -ForegroundColor Yellow
    #Write-Log -Message "" -Level
}

$(Get-Date -f o) 

#>