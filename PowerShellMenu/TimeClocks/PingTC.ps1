Function PingAll
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Ping and Test all Time Clocks           *" -ForegroundColor Green
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
	PingTC $COMPUTERS
}

Function PingOne
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Ping and Test a Time Clock             *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	$Computer = Read-Host "What TimeClock would you like to Ping?"
	$COMPUTERS = @($Computer)
	
	PingTC $COMPUTERS
}

Function PingTC ($COMPUTERS)
{
	foreach ($Comp in $COMPUTERS)
	{
		if (PingComp $Comp)
		{
			Write-Host "$Comp is found!" -ForegroundColor Green
			ProcessCheck $Comp "LSStart.exe"
			ProcessCheck $Comp "Microsoft.Dynamics.Nav*"
		}
		else
		{
			Write-Host "$Comp is missing!" -ForegroundColor Red
		}
	}
	Write-Host ""
	Write-Host "Thank you and have a nice day!" -ForegroundColor Magenta
	ending
}