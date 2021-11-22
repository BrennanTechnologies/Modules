### Write-Log.ps1
function Write-Log {
    [alias("Write-ScreenAndLog")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [alias("cat")]
        [string]
        $Category = "INFO"
        ,
        [Parameter(Mandatory=$true)]
        [alias("msg")]
        [string]
        $Message
        ,
        [Parameter(Mandatory=$false)]
        [alias("log")]
        [string]
        $LogFile = "$PSScriptRoot\logs\log_$(Get-Date -Format "MM.dd.yyyy_HH.mm.ss").txt"
        ,
        [Parameter(Mandatory=$false)]
        [alias("col")]
        #[System.ConsoleColor]
        [string[]]
        $Color = [System.Enum]::GetValues([System.ConsoleColor])
    )

    <#
        .SYNOPSIS
        Short description
        
        .DESCRIPTION
        Long description
        
        .PARAMETER Category
        Parameter description
        
        .PARAMETER Message
        Parameter description
        
        .PARAMETER LogFile
        Parameter description
        
        .PARAMETER Color
        Parameter description
        
        .EXAMPLE
        An example
        
        .NOTES

        ToDo:
        -----
            - Add a parameter to specify the log file name
            - Add a parameter to specify the log file path

        v11.20.20.0:
        -----------
            - 1st commit to git

        v11.20.21.0:
        -----------
            - Add support for logging to a file.
            - Add support for logging to a database.

        Notes:
        ------
            - using System.IO;
            - Microsoft.Windows.PowerShell.Gui.Internal

    #>

    begin {
        
        Enum Category
        {
            INFO    = 0
            WARN    = 1
            ERROR   = 2
        }


        #$colors = [enum]::GetValues([System.ConsoleColor])
        
        <#
        ### Set Color
        ###--------------------------
        if(!$color) {
            switch($category) {
                "INFO" {
                    $color  = "White"
                }
                "PROMPT" {
                    $color  = "Yellow"
                }
                "WARN" {
                    $color  = "DarkYellow"
                }
                "ERROR" {
                    $color  = "Red"
                }
                "DEBUG" {
                    $color  = "White"
                }
                default {
                    $color  = "White"
                }
            }
        }
        #>

        ### Set the $InformationAction Level
        ###--------------------------
        ###     InformationAction   : SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend, or Break
        ###     Write-Log function  : INFO, WARN, ERROR, PROMPT
        ###--------------------------
        switch($category) {
            "INFO" {
                [int]$logLevel      = 0
                $informationAction  = "SilentlyContinue"
                if($!color){
                    $color          = "White"
                }
            }
            "WARN" {
                [int]$logLevel      = 1
                $informationAction  = "Continue"
                if($!color){
                    $color          = "DarkYellow"
                }
            }
            "PROMPT" {
                [int]$logLevel      = 2
                $informationAction  = "Inquire"
                if($!color){
                    $color          = "Yellow"
                }
            }
            "ERROR" {
                [int]$logLevel      = 3
                $informationAction  = "Stop"
                if($!color){
                    $color          = "Red"
                }
            }
            "DEBUG" {
                [int]$logLevel      = 4
                $informationAction  = "SilentlyContinue"
                if($!color){
                    $color          = "White"
                }
            }
            default {
                [int]$logLevel      = 0
                $informationAction  = "SilentlyContinue"
                if($!color){
                    $color          = "White"
                }
            }
        }
    }
    process {

        ###===============
        ### Write-host                                                                                      ### Write to Screen
        ###===============
        <#
         Note

            Starting in Windows PowerShell 5.0, Write-Host is a wrapper for Write-Information 
            
            This allows you to use Write-Host to emit output to the information stream. 
            
            This enables the capture or suppression of data written using Write-Host while preserving backwards compatibility.

            The $InformationPreference preference variable and InformationAction common parameter do not affect Write-Host messages. 
            
            The exception to this rule is -InformationAction Ignore, which effectively suppresses Write-Host output. (see "Example 5")

            $InformationPreference
                - The $InformationPreference variable lets you set information stream preferences that you want displayed to users. 
                - Specifically, informational messages that you added to commands or scripts by adding the Write-Information cmdlet. 
                - If the InformationAction parameter is used, its value overrides the value of the $InformationPreference variable. 
                - Write-Information was introduced in PowerShell 5.0.

                The $InformationPreference variable takes one of the ActionPreference enumeration values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend, or Break.

                The valid values are as follows:

                    Stop        :   Stops a command or script at an occurrence of the Write-Information command.
                    Inquire     :   Displays the informational message that you specify in a Write-Information command, then asks whether you want to continue.
                    Continue    :   Displays the informational message, and continues running.
                                    Suspend is only available for workflows which aren't supported in PowerShell 6 and beyond.
                SilentlyContinue:   (Default) No effect. The informational messages aren't displayed, and the script continues without interruption.
        #>

        #Write-Host $category ": " $message -ForegroundColor $color

        ### values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend, or Break
        #Write-Host "This is a test." -InformationAction $informationAction -ForegroundColor $color
        Write-Host $Message -InformationAction $informationAction -ForegroundColor $color

        <#
        ###===============
        ### Write to Log
        ###===============
        if ($logFile) {                                                                                     ### if $LogFile Parameter was used.
            try {
                ### Build Log Record String
                ###----------------------------------
                [string]$logString = "$(Get-Date -Format "MM/dd/yyyy HH:mm:ss") - $category : $message"     ### Build Log Record String

                ### Check if Log File & Path Exists, if not create it.
                ###----------------------------------
                if( -not $(Test-Path -Path $logPath) ) {                                                    ### Check if log file exits
                    try {
                        New-Item -Path $logPath -ItemType File -Force                                       ### If Not, Create it
                    } catch {
                        Write-Warning -Message $global:Error[0].Exception.Message -ErrorAction Continue
                    }
                }
                ### Add Log Record
                ###----------------------------------
                try {
                    Add-Content -Path $logFile -Value $logString                                            ### Write Log Record to the $LogFile
                } catch {
                    Write-Warning -Message $global:Error[0].Exception.Message -ErrorAction Continue
                }
            } catch {
                Write-Warning -Message $global:Error[0].Exception.Message -ErrorAction Continue
            }
        }
        #>
    }
    end {}
 }