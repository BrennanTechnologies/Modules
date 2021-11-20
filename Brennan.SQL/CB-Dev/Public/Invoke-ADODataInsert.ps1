function Invoke-ADODataInsert {
    <#
    .SYNOPSIS
    Invoke a .NET ADO Database Connection & Runs a SQL Query to Insert a record.
    
    .DESCRIPTION
    Invoke a .NET ADO Database Connection & Runs a SQL Query to Insert a record.
    
    .PARAMETER ServerInstance
    Invoke a .NET ADO Database Connection & Runs a SQL Query to return a data table object.
    
    .PARAMETER Database
    Specifies the name of a database. This cmdlet connects to this database in the instance that is specified in the ServerInstance parameter.
    
    .PARAMETER Query
    Specifies the SQL query that this function will run. 
    
    .EXAMPLE
    Invoke-ADODataInsert -ServerInstance $ServerInstance -Database $Database -Query $Query

    .OUTPUTS
    ExitCode: Success
    ExitCode: Error
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False)]
        [string]$ServerInstance = "nymgmtdodb01.management.corp\MSSQLSERVER,1433"
        ,
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Database
        ,
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Query
        ,
        [Parameter(Mandatory = $False)]
        [switch]$Quiet
        )
    Begin {
        ### Create Database Connection String
        ###----------------------------------
        $ConnectionString = "Data Source=$ServerInstance;Initial Catalog=$Database;Integrated Security=true;"
        ### Open DB Connection
        ###----------------------------------
        $Connection = New-Object System.Data.SqlClient.SqlConnection
        $Connection.ConnectionString = $ConnectionString
        $Connection.Open()
        ### SQL Command
        ###----------------------------------
        $SQLCommand = New-Object System.Data.SqlClient.SqlCommand
        $SQLCommand.Connection = $Connection
        $SQLCommand.CommandText = $Query

        # Create Exit Code Object 
        ###----------------------------------
        $ExitCode = New-Object PSObject -Property @{Status = ""}
    }
    Process {
        ### Execute the SQL Query
        ###----------------------------------
        try {
            $SQLCommand.ExecuteNonQuery() | Out-Null
            $Status.ExitCode = $True
        } catch {
            Write-Warning -Message ("ERROR EXECUTING SQL: " + $((Get-PSCallStack)[0].Command) + "`n`r" + $global:Error[0].Exception.Message) 
            $Status.ExitCode = $False
        }
        if(-Not $Quiet){
            return $ExitCode
        }
    }
    End {
        ### Close DB Connection
        ###----------------------------------
        $Connection.Close()
        if(-Not $Quiet){
            Write-Host "Data Connection Closed: " $Connection.Database
        }
    }
}
