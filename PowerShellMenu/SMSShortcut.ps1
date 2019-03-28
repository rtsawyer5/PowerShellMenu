#This creates a shortcut icon on the public desktop of a list of computers. 

Function SMSShortcut
{
	$complist = @()
	do
	{ 
		clear
		Write-Host "*********************************" -ForegroundColor Green
		Write-Host "SMS Icon Placement Script " -ForegroundColor Green
		Write-Host "*********************************" -ForegroundColor Green
		Write-Host ""
		Write-Host $complist
		$strResponse = Read-Host "Enter a computer name, RUN to search, CLEAR to empty the list or EXIT to quit:" 
		If($strResponse -eq "EXIT"){
			Ending
			return $null
		}
		ELSEIF($strResponse -eq "CLEAR"){$complist = $null}
		ELSEIF($strResponse -eq "RUN"){
			SMSShortcutPlacement $complist
			return $null
		}
		ELSE{$complist += $strResponse}
	}
	until($strResponse -eq "exit")
}

Function SMSShortcutPlacement ($complist)
{
	$TargetFile = "\\srfile\users\SMS-New.rdp"
	$ShortcutFile = "\c$\Users\Public\Desktop\SMS.lnk"
	
	Write-Host ""
	Write-Host ""
	Write-Host ""
	Write-Host ""
	Write-Host ""
	Write-Host ""
	foreach($strComputer in $complist)
	{
		Write-Progress -Activity "Querying Computer: $strComputer"  -status "Running..." -id 1
		$System = Get-WMIObject Win32_ComputerSystem -Computer $strComputer
		
		IF($System -eq $null){Write-Host "Computer $strComputer Not Found" -ForegroundColor Red}
		ELSE 
		{
			$WScriptShell = New-Object -ComObject WScript.Shell
			$Shortcut = $WScriptShell.CreateShortcut("\\"+$strComputer+$ShortcutFile)
			$Shortcut.TargetPath = $TargetFile
			$Shortcut.Save()
			Write-Host "SMS shortcut placed on $strComputer"
		}
	}
	Ending
}
		
			