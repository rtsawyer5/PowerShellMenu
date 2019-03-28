Function Reboot ($Computer)
{
	#Param Check
	if(!$Computer){$Computer = Read-Host "What computer would you like to reboot?"}
	if (PingComp $Computer)
	{
		Write-Host "Rebooting $Computer" -ForegroundColor Magenta
		shutdown /m \\$Computer /r /f /t 000
	}
	else
	{
		Write-Host "$Computer is missing!" -ForegroundColor Red
	}
}