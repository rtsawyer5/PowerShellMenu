
Function TCShellFix
{
	Clear
	$Computer = Read-Host "TimeClock Name -->"
	$Username = $Computer
	Write-Host "Getting SID for $Computer" -ForegroundColor Green
	$sid = (Get-WMIObject -Class win32_useraccount -Filter "name='$Username' AND domain='SUNDAYRIVER'").SID
	while(!$sid)
	{
		Write-Host "TimeClock User $Username was not found" -ForegroundColor Red
		$Username = Read-Host "Re-enter the correct username -->"
		$sid = (Get-WMIObject -Class win32_useraccount -Filter "name='$Username' AND domain='SUNDAYRIVER'").SID
	}
	
	$Status = RemoteRegActivate $Computer
	
	Write-Host "Writing Registry Value for Shell" -ForegroundColor Green
	reg add "\\$Computer\HKU\$sid\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d "C:\Program Files (x86)\LS Retail\NAV\LSStart\LSStart.bat" /f

	RemoteRegDeactivate $Status $Computer

	Write-Host "Copying Startup Batch file" -ForegroundColor Green
	Copy-Item -Path "\\srfile\users-secure\it\cenium\timeclocks\LSStart.bat" -Destination "\\$Computer\C$\Program Files (x86)\LS Retail\NAV\LSStart\"
	
	Write-Host "Removing old startup shortcut" -ForegroundColor Green
	Remove-Item -Path "\\$Computer\C$\users\$Username\appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*.*" -force
	Remove-Item -Path "\\$Computer\C$\programdata\Microsoft\Windows\Start Menu\Programs\Startup\*.*" -force
	
	Reboot $Computer
	
	Clear
	Write-Host "Computer has been restarted" -ForegroundColor Magenta
	Countdown 120 "Waiting for Computer to restart"
	
	While (!{PingComp $Computer})
	{
		Write-Progress -Activity "Waiting for Computer to restart"  -status "Waiting..." -id 1
	}

	Clear
	Write-Host "Computer has restarted" -ForegroundColor Green
	VerifyFix $Computer
}

Function VerifyFix ($Computer)
{
	Write-Host "Verifying Changes" -ForegroundColor Magenta
	$Checked = $null
	do
	{
		ProcessCheck $Computer "explorer.exe"
		ProcessCheck $Computer "LSStart.exe"
		$Checked = Read-Host "Continue Checking: (Y)es or (N)o?"
	}
	until($Checked -match "N")
	Write-Host ""
	
	$Remote = Read-Host "Do you want to remote into $Computer to verify? (Y)es or (N)o"
	If($Remote -match "Y")
	{
		Write-Host "Waiting for Remote Service to start" -ForegroundColor Magenta
		$service = tasklist /s $Computer /fi "IMAGENAME eq CmRcService.exe"
		While($service -match "INFO:")
		{$service = tasklist /s $Computer /fi "IMAGENAME eq CmRcService.exe"}
		cd "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\i386"
		./CmRcViewer.exe $Computer
	}
	u:
	Write-Host "Thank you and have a nice day!" -ForegroundColor Magenta
	ending
}

Function ReverseShellFix
{
	Clear
	$Computer = Read-Host "Computer Name -->"
		
	Write-Host "Getting SID for $Computer" -ForegroundColor Green
	$sid = (Get-WMIObject -Class win32_useraccount -Filter "name='$Computer' AND domain='SUNDAYRIVER'").SID
	
	Write-Host "Enabling Remote Registry Service" -ForegroundColor Green
	Set-Service remoteregistry -Computer $Computer -StartMode Manual
	Set-Service remoteregistry -Computer $Computer -Status Running
	
	Write-Host "Writing Registry Value for Shell" -ForegroundColor Green
	reg delete "\\$Computer\HKU\$sid\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f

	Write-Host "Disabling Remote Registry Service" -ForegroundColor Green
	Set-Service remoteregistry -Computer $Computer -StartMode Disabled
	
	Write-Host "Removing Startup Batch file" -ForegroundColor Green
	Remove-Item -Path "\\$Computer\C$\Program Files (x86)\LS Retail\NAV\LSStart\LSStart.bat" -force
	
	Write-Host "Copying Startup Shortcut file" -ForegroundColor Green
	Copy-Item -Path "\\srfile\users-secure\it\cenium\timeclocks\LSStart - Shortcut.lnk" -Destination "\\$Computer\C$\users\$Username\appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
	
	Read-Host "Press ENTER to restart the computer. CTRL+C to Cancel"
	shutdown /m \\$Computer /r /f /t 000
	
}


