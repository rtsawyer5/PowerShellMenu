#Applies the reg fix for Windows 7 using UVNC
Function UVNCFix
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Fix CTRL+ALT+DEL for Win 7 and UltraVNC *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	
	$Computer = Read-host "Apply fix on what computer?"
	if(!$Computer){ 
		Write-Host "Invalid Input" -ForegroundColor Red
		ending
		break
	}
	if(PingComp $Computer)
	{
		#Make sure Remote Registry Service is enabled
		$Status = RemoteRegActivate $Computer
		
		#Check if Registry Value already exists
		$reg = reg query "\\$Computer\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
		if($reg -match "SoftwareSASGeneration")
		{
			Write-Host "Fix has already been applied"
		}
		else
		{
			Write-Host "Writing Registry Value to Fix CTRL+ALT+DEL for UltraVNC" -ForegroundColor Green
			reg add "\\$Computer\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v SoftwareSASGeneration /t REG_DWORD /d 1 /f 
		}
		
		#Deactivate Remote Registry when completed
		RemoteRegDeactivate $Status $Computer
	}
	else	
	{
		Write-Host "Computer $Computer not found!" -foregroundColor Red
		Return
	}
	ending	
}