Function DisableIPv6
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Disable IPv6                            *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	
	$Computer = Read-host "Disable IPv6 on what computer?"
	if(PingComp $Computer)
	{
		#Find out if the Remote Registry Service is currently running or not.
		Write-Host "Checking Remote Registry Service" -ForegroundColor Magenta
		$Status = RemoteRegActivate $Computer
				
		#Check if Registry Value already exists
		$reg = reg query "\\$Computer\HKLM\System\CurrentControlSet\services\TCPIP6\Parameters"
		if($reg -match "DisabledComponents")
		{
			Write-Host "IPv6 has already been disabled"
		}
		else
		{
			Write-Host "Writing Registry Value to disable IPv6" -ForegroundColor Green
			reg add "\\$Computer\HKLM\System\CurrentControlSet\services\TCPIP6\Parameters" /v DisabledComponents /t REG_DWORD /d 0xffffffff
		}
		
		#Disable the service if it was disabled to begin with.
		RemoteRegDeactivate $Status $Computer
		
		Reboot $Computer
		Countdown 120 "Waiting for Computer to restart"
	}
	else	
	{
		Write-Host "Computer $Computer not found!" -foregroundColor Red
		Return
	}
	ending	
}