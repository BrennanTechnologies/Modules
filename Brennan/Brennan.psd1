### SaveAs: Brennan PSM Template.psd1

<#
	### Boot Strap Module Manifest
	###------------------------------------------------

	Chris Brennan
	Brennan Technologies
	<a href=mailto:cbrennan@brennantechnologies.com>
	https://www.brennantechnologies.com

	v.11.19.21
    Copyright = '(c) 2021 Brennan Technologies. "All rights reserved, Use with Permission Only
#>

@{
	### https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7.2
	
	# Script module or binary module file associated with this manifest.
	<#
		RootModule
		-----------
		Type: String    <empty string>
			
			- Script module or binary module file associated with this manifest. 
				Previous versions of PowerShell called this element the ModuleToProcess.
			- Possible types for the root module can be empty, which creates a Manifest module, the name of a script module (.psm1), or the name of a binary module (.exe or .dll). 
				Placing the name of a module manifest (.psd1) or a script file (.ps1) in this element causes an error.
			
			Example: RootModule = 'ScriptModule.psm1'
	#>
	RootModule = 'Brennan.psm1'
	
	# Version number of this module.
	<#
		ModuleVersion
		--------------
		Type: Version   '0.0.1' 
		
			- Version number of this module. If a value isn't specified, New-ModuleManifest uses the default. The string must be able to convert to the type Version for example #.#.#.#. Import-Module loads the first module it finds on the $PSModulePath that matches the name, and has at least as high a ModuleVersion, as the MinimumVersion parameter. To import a specific version, use the Import-Module cmdlet's RequiredVersion parameter.
		
			Example: ModuleVersion = '1.0'
	#>
	ModuleVersion = '11.19.21'
	
	# Description of the functionality provided by this module
	Description = 'Template for New Modules'

	# Modules that must be imported into the global environment prior to importing this module
	<#
		RequiredModules
		-------------------
		Type: Object[]  @() 
		
			- Modules that must be imported into the global environment prior to importing this module. 
				This loads any modules listed unless they've already been loaded. 
				For example, some modules may already be loaded by a different module. 
				It's possible to specify a specific version to load using RequiredVersion rather than ModuleVersion. 
				When ModuleVersion is used it will load the newest version available with a minimum of the version specified. 
				You can combine strings and hash tables in the parameter value.
		
			Example: RequiredModules = @("MyModule", @{ModuleName="MyDependentModule"; ModuleVersion="2.0"; GUID="cfc45206-1e49-459d-a8ad-5b571ef94857"})
		
			Example: RequiredModules = @("MyModule", @{ModuleName="MyDependentModule"; RequiredVersion="1.5"; GUID="cfc45206-1e49-459d-a8ad-5b571ef94857"})
	#>
	RequiredModules = @(
		"Brennan"
		#,
		#"Brennan.Core"
		#,
		#"Brennan.Common"
		#,
		#"Brennan.SQL"
		#,
		#"Brennan.Reporting"
		#,
		#"Brennan.CodeSigning"
	)

	# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
	<#
		NestedModules 
		---------------
		Type: Object[]  @()  - Object Array
			- Modules to import as nested modules of the module specified in RootModule (alias:ModuleToProcess).

			- Adding a module name to this element is similar to calling Import-Module from within your script or assembly code. 
				The main difference by using a manifest file is that it's easier to see what you're loading. And, if a module fails to load, you will not yet have loaded your actual module.

			- In addition to other modules, you may also load script (.ps1) files here. 
				These files will execute in the context of the root module. This is equivalent to dot sourcing the script in your root module.

			- Example: NestedModules = @("script.ps1", @{ModuleName="MyModule"; ModuleVersion="1.0.0.0"; GUID="50cdb55f-5ab7-489f-9e94-4ec21ff51e59"})
	#>
	 NestedModules = @(
		#"Brennan"
		#,
		#"Brennan.Core"
		#,
		#"Brennan.Common"
		#,
		#"Brennan.SQL"
		#,
		#"Brennan.Reporting"
		#,
		#"Brennan.CodeSigning"
		)

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	<#
		ScriptsToProcess "Login Script"
		Type: String[]  @() - String Array

			- Script (.ps1) files that are run in the caller's session state when the module is imported. 
				This could be the global session state or, for nested modules, the session state of another module. You can use these scripts to prepare an environment just as you might use a log in script.

			- These scripts are run before any of the modules listed in the manifest are loaded.
		
			Example: ScriptsToProcess = @("script1.ps1", "script2.ps1", "script3.ps1")
	#>
	ScriptsToProcess = @(
		"Brennan.ps1"
		#,
		#"Brennan.Core"
		#,
		#"Brennan.Common"
		#,
		#"Brennan.SQL"
		#,
		#"Brennan.Reporting"
		#,
		#"Brennan.CodeSigning"
		)

	#FunctionsToExport = '*'
	<#
		FunctionsToExport
		------------------
		Type: String[]  @() - String Array

			- Specifies the functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export. 
				By default, no functions are exported. 
				You can use this key to list the functions that are exported by the module.

			- The module exports the functions to the caller's session state. 
				The caller's session state can be the global session state or, for nested modules, the session state of another module. When chaining nested modules, 
				all functions that are exported by a nested module will be exported to the global session state unless a module in the chain restricts the function by using the FunctionsToExport key.

			- If the manifest exports aliases for the functions, this key can remove functions whose aliases are listed in the AliasesToExport key, but this key cannot add function aliases to the list.
		
			Example: FunctionsToExport = @("function1", "function2", "function3")
	#>
	FunctionsToExport = @(
		"*"
		,
		"Brennan.*"
		#,
		#"Brennan.Common"
		#,
		#"Brennan.SQL"
		#,
		#"Brennan.Reporting"
		#,
		#"Brennan.CodeSigning"
		)
	
	CmdletsToExport = '*'
	VariablesToExport = '*'
	AliasesToExport = '*'

	# ID used to uniquely identify this module
	GUID = 'e483d2c5-272e-48dc-a9c4-623faaa4de80'

	# Author of this module
	Author = 'Chris Brennan'

	# Company or vendor of this module
	CompanyName = 'Brennan Technologies'

	# Copyright statement for this module
	Copyright = '(c) 2021 Brennan Technologies. "All rights reserved, Use with Permission Only'

	
	
	###########################################

		# List of all modules packaged with this module
	# ModuleList = @()

	# Supported PSEditions
	# CompatiblePSEditions = @()
	
	# Minimum version of the Windows PowerShell engine required by this module
	# PowerShellVersion = ''
	
	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ''
	
	# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
	# DotNetFrameworkVersion = ''
	
	# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
	# CLRVersion = ''
	
	# Processor architecture (None, X86, Amd64) required by this module
	# ProcessorArchitecture = ''
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @()
	
	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @()
	

	
	# DSC resources to export from this module
	# DscResourcesToExport = @()
	
	# List of all modules packaged with this module
	# ModuleList = @()
	
	# List of all files packaged with this module
	# FileList = @()
	
	# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
	
		PSData = @{
	
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
	
			# A URL to the license for this module.
			# LicenseUri = ''
	
			# A URL to the main website for this project.
			# ProjectUri = ''
	
			# A URL to an icon representing this module.
			# IconUri = ''
	
			# ReleaseNotes of this module
			# ReleaseNotes = ''
	
		} # End of PSData hashtable
	
	} # End of PrivateData hashtable
	
	# HelpInfo URI of this module
	# HelpInfoURI = ''
	
	# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ''
	
	}


