Function AutoLogin ()
{

	$RegTree = "HKLM"
	$LongTreeName = "LocalMachine"
	$RegPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
	$RegKey = "AutoAdminLogon"
		
	
	do
	{
		clear
		Write-Host "*********************************************************" -ForegroundColor Green
		Write-Host "* Type the NAME of the computer you wish to             *" -ForegroundColor Green
		Write-Host "* check for $RegKey then press enter.            *" -ForegroundColor Green
		Write-Host "* Type MENU to return to starting menu                  *" -ForegroundColor Green
		Write-Host "*********************************************************" -ForegroundColor Green
		$Computer = Read-Host "Computer Name -->"
		
		if ($Computer -eq "MENU") {Return}
		if (PingComp $Computer)
	    {
			#Find out if the Remote Registry Service is currently running or not.
			Write-Host "Checking Remote Registry Service" -ForegroundColor Magenta
			$Status = RemoteRegActivate $Computer
			
			$reg  = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LongTreeName, $Computer)
            $key  = $reg.OpenSubKey($RegPath)
            $value = $key.GetValue($RegKey)
			if ($value -eq 1)
			{
				Write-Host "`n$Computer is currently setup to $RegKey with the following settings" -ForegroundColor Magenta
				$temp = $key.GetValue("DefaultUserName")
				Write-Host "DefaultUserName : $temp" -ForegroundColor Green
				$temp = $key.GetValue("DefaultPassword")
				Write-Host "DefaultPassword : $temp" -ForegroundColor Green
				$temp = $key.GetValue("DefaultDomainName")
				Write-Host "DefaultDomainName : $temp" -ForegroundColor Green
				Write-Host ""
				
				do{$Response = Read-Host "Do you want to disable $RegKey for $Computer? [Y]es or [N]o"}until ($Response -eq "Y" -or $Response -eq "N")	
					
				if ($Response -eq "Y")
				{
					reg add \\$Computer\$RegTree\$RegPath /v $RegKey /t REG_SZ /d 0 /f
					reg delete \\$Computer\$RegTree\$RegPath /v "DefaultUserName" 
					reg delete \\$Computer\$RegTree\$RegPath /v "DefaultPassword" 
					Write-Host "$RegKey has been disabled" -ForegroundColor Magenta
					pause
				}	
					
			}
			else
			{
				Write-Host "`nAuto Logon is currently not setup on $Computer" -ForegroundColor Red

				do{$Response = Read-Host "`nDo you want to Enable $RegKey for $Computer? [Y]es or [N]o"}until ($Response -eq "Y" -or $Response -eq "N")
				
				if ($Response -eq "Y")
				{
					do{$Response = Read-Host " `n[R]TP `n[D]igital Dining `nWhich $RegKey do you wish to Enable?"}until ($Response -eq "R" -or $Response -eq "D")
					if ($Response -eq "R")
					{
						$user = "srrtp"
						$pass = Read-Host "What is the password for srrtp account?"
						$domain = "sundayriver.boyne.com"
					}
					if ($Response -eq "D")
					{
						$user = "ddpos"
						$pass = Read-Host "What is the password for ddpos account?"
						$domain = "sundayriver.boyne.com"
					}
					
					reg add \\$Computer\$RegTree\$RegPath /v $RegKey /t REG_SZ /d 1 /f
					reg add \\$Computer\$RegTree\$RegPath /v "DefaultUserName" /t REG_SZ /d $user /f
					reg add \\$Computer\$RegTree\$RegPath /v "DefaultPassword" /t REG_SZ /d $pass /f
					reg add \\$Computer\$RegTree\$RegPath /v "DefaultDomainName" /t REG_SZ /d $domain /f
				}
			}
			
			#Disable the service if it was disabled to begin with.
			RemoteRegDeactivate $Status $Computer

			do{$Response = Read-Host "`nDo you wish to Restart $Computer? [Y]es [N]o"}until ($Response -eq "Y" -or $Response -eq "N")
			if ($Response -eq "Y"){Reboot $Computer}
		}
		else
		{
			Write-Host "Computer is either not powered on, spelled wrong, or not on the network" -ForegroundColor Red
			pause
		}
	}
	until($Computer -eq "MENU")
	clear
}