Function NavMenu
{
	$global:List = @{}
	clear
	do
	{
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Finding Microsoft Dynamics Nav                        *" -ForegroundColor Green
		Write-Host "* By: Bob Sawyer                                        *" -ForegroundColor Green
		Write-Host "* Date: 05/22/2015                                      *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host ""
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Make a choice from the options below.                 *" -ForegroundColor Green
		Write-Host "* 1 - Search the entire Domain for NAV Clients          *" -ForegroundColor Green
		Write-Host "* 2 - Search a list of computers for NAV                *" -ForegroundColor Green
		Write-Host "* 3 - Search individual computers for NAV               *" -ForegroundColor Green
		Write-Host "* 4 - Display results                                   *" -ForegroundColor Green
		Write-Host "* 5 - Write the results to an Excel Spreadsheet         *" -ForegroundColor Green
		Write-Host "* 6 - Change the server for a Computer and Users        *" -ForegroundColor Green
		Write-Host "* 7 - View the NAV Server info on a computer and users  *" -ForegroundColor Green
		Write-Host "* M - Back to Start Menu                                *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		$response = Read-Host "Type Option and press enter -->"
		
		switch ($response)
		{
			1 {Domain}
			2 {List}
			3 {Individual}
			4 {Display}
			5 {Excel}
			6 {SRServer}
			7 {ServerInfo}
			"M" {}
			default 
			{
				clear
				Write-Host "Invalid Choice" -ForegroundColor Red
			}
		}
	}
	until ($response -eq "M")
	clear
}


Function Domain
{
	clear
	Write-Host "Loading..."
	import-module ActiveDirectory
	Write-Host "Done Loading."
	
	$found = 0
    $Current = 0
	
	#Get full list of computers from AD 
	$Computers = Get-ADComputer  -Filter {(enabled -eq "true")} |
    Select-Object -ExpandProperty Name
	$Total = $Computers.length
	
	foreach ($comp in $Computers)
	{
		$Current++
        clear
        [int]$Perc = ([int]$Current / [int]$Total) * 100
		$found = $global:List.count
		Write-Host "Searching for Microsoft Dynamics NAV on entire Domain"
        Write-Host "$Current out of $Total Computers"
        Write-Host "$Perc% Complete"
        Write-Host "Found = $found"

		if (PingComp $comp)
        {    
			if (Installed $comp)
			{
				$Version = Version $comp
				$global:List[$comp] = $Version
			}
		}
	}
	clear
	Write-Host "*********************************************************" -ForegroundColor Green
	Write-Host "Done searching for computers: $found computers were found" -ForegroundColor Green
	Write-Host "*********************************************************" -ForegroundColor Green
	Write-Host ""
}


Function List
{
	$SearchList = @()
	do
	{
		clear
		foreach ($comp in $SearchList)
		{
			Write-Host $comp
		}
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Type the NAME of the computer you wish to             *" -ForegroundColor Green
		Write-Host "* search for then press enter.                          *" -ForegroundColor Green
		Write-Host "* Type RUN to execute the search                        *" -ForegroundColor Green
		Write-Host "* Type CLEAR to clear the search list                   *" -ForegroundColor Green
		Write-Host "* Type MENU to return to starting menu                  *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		$Computer = Read-Host "Computer Name -->"
		Write-Host ""
		Write-Host ""

		
		if ($Computer -eq "MENU") 
		{
			$SearchList = @()
			Return
		}
		elseif ($Computer -eq "RUN")
		{
			clear
			foreach ($comp in $SearchList)
			{
				if (PingComp $comp)
        			{    
					if (Installed $comp)
					{
						$Version = Version $comp
						$global:List[$comp] = $Version
					}
					else {$Version = "Not Installed"}
				}
				else {$Version = "Not Found"}
				Write-Host "$comp : $Version"
			}
			clear
			Write-Host "*********************************************************" -ForegroundColor Green
			Write-Host "Done searching through the List" -ForegroundColor Green
			Write-Host "*********************************************************" -ForegroundColor Green
			Write-Host ""
		}
		elseif ($Computer -eq "CLEAR")
		{
			$SearchList = @()
		}
		else
		{
			$SearchList += $Computer
		}
	}
	until ($Computer -eq "MENU" -Or $Computer -eq "RUN")
}

Function Individual
{
	clear
	do
	{
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Type the NAME of the computer you wish to             *" -ForegroundColor Green
		Write-Host "* search for then press enter.                          *" -ForegroundColor Green
		Write-Host "* Type MENU to return to starting menu                  *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		$Computer = Read-Host "Computer Name -->"
		
		if ($Computer -eq "MENU") {Return}
		if (PingComp $Computer)
	    {    
			if (Installed $Computer)
			{
				$Version = Version $Computer
				Write-Host "Microsoft Dynamics NAV version $Version is installed on $Computer." -ForegroundColor Magenta
				Read-Host "Press ENTER to continue..."
				clear
			}
			else
			{
				Write-Host "Microsoft Dynamics NAV is not installed on $Computer" -ForegroundColor Red
				Read-Host "Press ENTER to continue..."
				clear
			}
		}
		else
		{
			Write-Host "Computer is either not powered on, spelled wrong, or not on the network" -ForegroundColor Red
			Read-Host "Press ENTER to continue..."
			clear
		}
	}
	until($Computer -eq "MENU")
}


Function Display
{
	#Display all results
	clear
	$global:List.GetEnumerator() | Sort-Object Name
	Read-Host "Press ENTER to continue..."
	clear
}

Function Excel
{
	#Write to Excel Spreadsheet
	if($global:List.count -ge 1)
	{
		$Excel = New-Object -Com Excel.Application
		$Excel.Visible = $False
		$Excel.Workbooks.Add()

		clear
		Write-Host "Writing to Excel" -ForegroundColor Green
		$Sheet = $Excel.Worksheets.Item(1)
		$Sheet.Cells.Item(1,1) = "Unit Name"
		$Sheet.Cells.Item(1,2) = "Version"
		$CRow = 1
		$global:List.GetEnumerator() | % { 
			$CRow++
			$Sheet.Cells.Item($CRow,1) = "{0}" -f $_.key
			$Sheet.Cells.Item($CRow,2) = "{1}" -f $_.key, $_.value
		}
		Write-Host "All results have been writen to an Excel Spreadsheet." -ForegroundColor Magenta
		Read-Host "Press ENTER key to continue..."
		$Excel.Visible = $True
	}
	else
	{
		clear
		Write-Host "Nothing is contained in the Results List" -ForegroundColor Red
	}
}

Function Installed ($Computer)
{
	Write-Host "Finding Application" -ForegroundColor Magenta
	$Installed = Get-WMIObject Win32_Product -Computer $Computer | Select-Object -Property Name | Sort-Object Name | Select-String "Microsoft Dynamics NAV Setup"
	Return ,$Installed
}

Function Version ($Computer)
{
	Write-Host "Finding Version" -ForegroundColor Magenta
	$Path = Path $Computer
	$Version = (Get-Item \\$Computer\c$\$Path).VersionInfo.ProductVersion
	Return ,$Version
}

Function Path ($Computer)
{
	$Arch = (Get-WmiObject Win32_OperatingSystem -computername $Computer).OSArchitecture
	If($Arch -eq "64-bit") {$Path = "Program Files (x86)\Microsoft Dynamics NAV\71\RoleTailored Client\Microsoft.Dynamics.Nav.Client.exe"}
	Elseif($Arch -eq "32-Bit") {$Path = "Program Files\Microsoft Dynamics NAV\71\RoleTailored Client\Microsoft.Dynamics.Nav.Client.exe"}
	Return ,$Path
}

Function SRServer ()
{
	$PathAll = "ProgramData\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
	$Path = "AppData\Roaming\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
	clear
	do
	{
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Type the NAME of the computer you wish to             *" -ForegroundColor Green
		Write-Host "* change the server on then press enter.                *" -ForegroundColor Green
		Write-Host "* Type MENU to return to starting menu                  *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		$Computer = Read-Host "Computer Name -->"
		
		if ($Computer -eq "MENU") {Return}
		if (PingComp $Computer)
	    {    
			if (Get-ChildItem \\$Computer\c$\$PathAll)
			{
                Do
                {
				    clear                
    				$x = [XML] (Get-Content \\$Computer\c$\$PathAll -force)
    				$x2 = $x.configuration.appSettings.add | Where-Object {$_.key -eq "ServerInstance"}
    				$DefaultServer = $x2.value
    				
                    $NAVServer = @()
                    $NAVUsers = @()
    				$Users = Get-ChildItem \\$Computer\c$\Users
    				$Users | foreach {
    					if (Get-ChildItem \\$Computer\c$\Users\$_\$Path) {
    						$i++
    						$xml = [Xml] (Get-Content \\$Computer\c$\Users\$_\$Path)
    						$x2 = $xml.configuration.appSettings.add | Where-Object {$_.key -eq "ServerInstance"}
    						$NAVServer += $x2.value
    						$NAVUsers += $_.Name
    					}
    				}
                    
                    Write-Host "*********************************" -ForegroundColor Green
                    Write-Host "NAV Server settings for $Computer" -ForegroundColor Green
                    Write-Host "*********************************" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "[D] The Default Server is set to $DefaultServer for new users." -ForegroundColor Magenta
                    Write-Host ""
    				Write-Host "**********************************************" -ForegroundColor Green
                    Write-Host "NAV Server settings for All Users on $Computer" -ForegroundColor Green
                    Write-Host "**********************************************" -ForegroundColor Green
                    Write-Host ""
                    for ($i=0; $i -lt $NAVUsers.Count; $i++)
                    {
                        $User = $NAVUsers[$i]
                        $Server = $NAVServer[$i]
                        Write-Host "[$i] $User`t= $Server" -ForegroundColor Magenta
                    }
                    Write-Host ""
                    Write-Host "[A] All Users and System Default" -ForegroundColor Magenta
                    Write-Host "[B] Back" -ForegroundColor Green
                    Write-Host ""
                    $Response = Read-Host "Who would you like to change?"
                    if ($Response -eq "D" -Or $Response -eq "A" -Or $Response -le $NAVUsers.Count) {
                        if($Response -eq "D") { SRChange $Computer $DefaultServer "Default" }
                        if($Response -le $NAVUsers.Count) { SRChange $Computer $NAVServer[$Response] $NAVUsers[$Response] }
                        if($Response -eq "A") {
                            Write-Host "[1] - SR" -ForegroundColor Green
                            Write-Host "[2] - SRTRAIN" -ForegroundColor Green
                            $Q = Read-Host "Please pick which server to change everything to."
                            if($Q -eq 1 -Or $Q -eq 2)
                            {
                                if($Q -eq 1){$Server = "SRTRAIN"}
                                if($Q -eq 2){$Server = "SR"}
                                SRChange $Computer $Server "Default"
                                for ($i = 0; $i -lt $NAVUsers.Count; $i++)
                                {
                                    $User = $NAVUsers[$i]
                                    SRChange $Computer $Server $User
                                }
                            } Else {
                                Write-Host "Invalid Selection" -ForegroundColor Red
                                Read-Host "Press ENTER to continue"
                            }
                        }
                    }
                }
                until($Response -eq "B")
                $Computer = "MENU"				
			}
			else
			{
				Write-Host "Unable to find the Default Config Settings file."
                Read-Host "Press ENTER to continue..."
                clear
			}
		}
		else
		{
			Write-Host "Computer is either not powered on, spelled wrong, or not on the network" -ForegroundColor Red
			Read-Host "Press ENTER to continue..."
			clear
		}
	}
	until($Computer -eq "MENU")
	clear
}



Function SRChange ($Computer, $Server, $User)
{
    if ($User -eq "Default") {
	$Path = "ProgramData\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
    } Else {
	$Path = "Users\$User\AppData\Roaming\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
	}
    
    if ($Server -eq "SR") { $NewServer = "SRTRAIN" }
    if ($Server -eq "SRTRAIN") { $NewServer = "SR" }
    
	#Replace Default Help Server for Users first logging into NAV
	$xml = [Xml] (Get-Content \\$Computer\c$\$Path -force)
	$xml.configuration.appSettings.add | foreach { 
		if ($_.key -eq 'HelpServer') { $_.value = "navhelp.boyneresorts.com" }
		if ($_.key -eq 'Server') { $_.value = "nav.sundayriver.boyne.com" }
		if ($_.key -eq 'ServerInstance') { $_.value = $NewServer }
		if ($_.key -eq 'ClientServicesPort') { $_.value = "7046" }
		if ($_.key -eq 'UrlHistory') { $_.value = "nav.sundayriver.boyne.com:7046/$NewServer" }
	}
	$xml.Save("\\$Computer\c$\$Path")
}


function ServerInfo ()
{
	$PathAll = "ProgramData\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
	$Path = "AppData\Roaming\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
	clear
	do
	{
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Type the NAME of the computer you wish to             *" -ForegroundColor Green
		Write-Host "* view the server info on then press enter.             *" -ForegroundColor Green
		Write-Host "* Type MENU to return to starting menu                  *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		$Computer = Read-Host "Computer Name -->"
		
		if ($Computer -eq "MENU") {Return}
		if (PingComp $Computer)
	    {    
			if (Get-ChildItem \\$Computer\c$\$PathAll)
			{
				clear                
				
				$DefaultServer = Get-NavServer $Computer "Default"
				
				$NAVServer = @()
				$NAVUsers = @()
				$Users = Get-ChildItem \\$Computer\c$\Users
				$Users | foreach {
					if (Get-ChildItem \\$Computer\c$\Users\$_\$Path) {
						$i++
						$NAVServer += Get-NavServer $Computer $_.Name
						$NAVUsers += $_.Name
					}
				}
				
				Write-Host "*********************************" -ForegroundColor Green
				Write-Host "NAV Server settings for $Computer" -ForegroundColor Green
				Write-Host "*********************************" -ForegroundColor Green
				Write-Host ""
				Write-Host "Default = $DefaultServer" -ForegroundColor Magenta
				Write-Host ""
				Write-Host "**********************************************" -ForegroundColor Green
				Write-Host "NAV Server settings for All Users on $Computer" -ForegroundColor Green
				Write-Host "**********************************************" -ForegroundColor Green
				Write-Host ""
				for ($i=0; $i -lt $NAVUsers.Count; $i++)
				{
					$User = $NAVUsers[$i]
					$Server = $NAVServer[$i]
					Write-Host "$User`t= $Server" -ForegroundColor Magenta
				}
				Write-Host ""
				pause
				clear
			}
			else
			{
				Write-Host "Unable to find the Default Config Settings file."
                pause
				clear
			}
		}
		else
		{
			Write-Host "Computer is either not powered on, spelled wrong, or not on the network" -ForegroundColor Red
			pause
			clear
		}
	}
	until($Computer -eq "MENU")
	clear
}

Function Get-NavServer ($Computer, $User)
{
    if ($User -eq "Default") {
	$Path = "ProgramData\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
    } Else {
	$Path = "Users\$User\AppData\Roaming\Microsoft\Microsoft Dynamics NAV\71\ClientUserSettings.config"
	}
	$x = [XML] (Get-Content \\$Computer\c$\$Path -force)
	$x.configuration.appSettings.add | foreach {
		if ($_.key -eq 'HelpServer') { $HlpSvr = $_.value }
		if ($_.key -eq 'Server') { $Svr = $_.value }
		if ($_.key -eq 'ServerInstance') { $SvrIns = $_.value }
		if ($_.key -eq 'ClientServicesPort') { $Port = $_.value }
		if ($_.key -eq 'UrlHistory') { $URLHis = $_.value }
	}
	$Result = "$Svr`:$Port/$SvrIns"
	Return ,$Result
}