Function RebootTC ($COMPUTERS)
{
	IF((Confirm "Are you sure you wish to Reboot the Time Clocks Selected?") -eq $False)
	{
		Write-Host "Operation Canceled" -ForegroundColor Red
		Return
	}
	Write-Host "Reboot is going to happen." -ForegroundColor Magenta
	Pause
	
	foreach ($Computer in $COMPUTERS){Reboot $Computer}
	
	Write-Host ""
	Write-Host "Operation Complete"
	ending
}

Function RebootAll
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* All Time Clock Reboot                   *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	$COMPUTERS = @("TSRADMINCLOCK",
					"TSRBARKERBASE",
					"TSRBARKERGARAGE",
					"TSRBARKERPUMP",
					"TRSRSRCAFE",
					"TSREVENTS",
					"TSRGRANDSUMMIT",
					"TSRSRGROCER",
					"TSRGROUPSALES",
					"TSRJORDAN",
					"TSRLIFTMAINT",
					"TSRMNTOPS",
					"TSRNORTHPEAKLAN",
					"TSRSRSKIPATROL",
					"TSRSNOWCAPDORMS",
					"TSRSRWELCOME",
					"TSRWHITECAP",
					"TSRWWTF")
	RebootTC $COMPUTERS
}

Function RebootOne
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Single Time Clock Reboot                *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	$Computer = Read-Host "What TimeClock would you like to Reboot?"
	$COMPUTERS = @($Computer)
	
	RebootTC $COMPUTERS
}
