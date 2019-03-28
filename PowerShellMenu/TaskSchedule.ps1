#Utility to create a custom task scheduled for reboot or shutdown.

Function TaskSchedule
{
	clear
	Write-Host "*********************************" -ForegroundColor Green
	Write-Host "Task Scheduler Script " -ForegroundColor Green
	Write-Host ""
	Write-Host "(1) - Schedule Reboot" -ForegroundColor Green
	Write-Host "(2) - Schedule Shutdown" -ForegroundColor Green
	Write-Host "*********************************" -ForegroundColor Green
	Write-Host ""
	
	do {
		$TaskNum = Read-Host "What task number?"
		IF(($TaskNum -ne 1) -and ($TaskNum -ne 2))
		{
			Write-Host "Invalid Task Number." -ForegroundColor Red
		}
	} until(($TaskNum -eq 1) -or ($TaskNum -eq 2))
	
	
	do {
		$compfound = 0
		$Computer = Read-Host "Enter the name of the Computer"
		if (PingComp $Computer)
		{
			$compFound = 1
		} Else 
		{
			Write-Host "Computer $Computer was not found." -ForegroundColor Red
		}
	} until($compFound -eq 1)
	
	
	do {
		$Frequency = Read-Host "How Often? (O)ne Time, (D)aily, (W)eekly, or (M)onthly"
		IF(($Frequency -ne "O") -and ($Frequency -ne "D") -and ($Frequency -ne "W") -and ($Frequency -ne "M"))
		{
			Write-Host "Invalid Scheduling Option." -ForegroundColor Red
		}
	} until (($Frequency -eq "O") -or ($Frequency -eq "D") -or ($Frequency -eq "W") -or ($Frequency -eq "M"))
	
	$Trigger = Read-Host "When to execute? (T)imed or (N)ow?"
	IF($Trigger -eq "T"){
		$Time = Read-Host "What time do you want this to run? (HH:mm)"
	}ELSE{$Time = ""}
	
	$RunAsUser = "System"

	if($TaskNum -eq "1")
	{
		$TaskName = "Scheduled_Restart"
		$TaskRun = '"shutdown.exe /r /f /t 000"'
	}
	if($TaskNum -eq "2")
	{
		$TaskName = "Scheduled_Shutdown"
		$TaskRun = '"shutdown.exe /f /t 000"'
	}

	if($Frequency -eq "O")
	{
		$Frequency = "ONCE"
	}
	if($Frequency -eq "D")
	{
		$Frequency = "DAILY"
	}
	if($Frequency -eq "W")
	{
		$Frequency = "WEEKLY"
	}
	if($Frequency -eq "M")
	{
		$Frequency = "MONTHLY"
	}
	
	if($Trigger -eq "T")
	{
		$Trigger = "$Time"
	}
	else
	{
		$Trigger = Get-Date -Format "HH:mm"
	}
	
	write-host ""
	
	do {
		Write-Host "Do you want to create a $TaskName on $Computer..." -Foreground Magenta
		Write-Host "To run $Frequency, at $Trigger..." -Foreground Magenta
		$Response = Read-Host "(Y)es or (N)o? "
	} Until(($Response -eq "Y") -or ($Response -eq "N"))
	Write-Host ""
	If ($Response -eq "Y")
	{
		$Feedback = schtasks.exe /create /s $Computer /ru $RunAsUser /tn $TaskName  /tr $TaskRun /sc $Frequency /ST $Trigger /F
		
		If ($Feedback.StartsWith("SUCCESS:"))
		{
			Write-Host $Feedback -ForegroundColor Green
			do {
				Write-Host "Do you want to run this task right now?" -Foreground Magenta
				$Response = Read-Host "(Y)es or (N)o? "
			} Until(($Response -eq "Y") -or ($Response -eq "N"))
			
			If ($Response -eq "Y")
			{
				Write-Host ""
				Write-Host "Running Task Now." -ForegroundColor Green
				schtasks.exe /run /s $Computer /tn $TaskName
			}
		} Else 
		{
			Write-Host $Feedback -ForegroundColor Red
		}
	} Else
	{
		Write-Host "Operation Aborted!" -ForegroundColor Red
	}
	
	Ending
}