Function CheckTasks
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Checking Tasks                          *" -ForegroundColor Green
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
	
	foreach ($Computer in $COMPUTERS)
	{
		Write-Host "----------------------------------------------------------"
		Write-Host $Computer -ForegroundColor Magenta
		schtasks /query /s $Computer /nh /tn Scheduled_Restart
	}
	
	Write-Host ""
	Write-Host "Operation Complete"
	ending
}