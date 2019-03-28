#Verifies that specific process is running on a remote computer.

Function ProcessCheck ($Computer, $Process)
{
	#Param Check
	if((!$Computer) -or (!$Process))
	{
		clear
		Write-Host "*******************************************" -ForegroundColor Green
		Write-Host "* Process Checker                         *" -ForegroundColor Green
		Write-Host "*******************************************" -ForegroundColor Green
		Write-Host ""
		if(!$Computer){$Computer = Read-Host "What computer would you like to search?"}else{Write-Host "Computer = $Computer"}
		$Process = Read-Host "What process do you want to check?"
		ProcessFinder $Computer $Process
		Ending
	}
	else
	{ProcessFinder $Computer $Process}
}

Function ProcessFinder ($Computer, $Process)
{
	#Find Computer
	if(PingComp $Computer)
	{
		#Write-Host "Looking for $Process on $Computer" -ForegroundColor Magenta
		$Result = tasklist /s $Computer /fi "IMAGENAME eq $Process"
		if($Result -match "INFO:")
		{
			Write-Host "$Process is not running on $Computer" -ForegroundColor Red
		}
		if($Result -match "$Process")
		{
			Write-Host "$Process is running on $Computer" -ForegroundColor Green
		}
	}
	Else
	{
		Write-Host "Unable to find $Computer" -ForegroundColor Red
	}
}