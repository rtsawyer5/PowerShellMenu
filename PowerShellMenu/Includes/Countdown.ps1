Function Countdown ($Time,$Message)
{
	#Param Check
	if(!$Time){$Time = Read-Host "How many seconds do you want the timer for?"}
	if(!$Message){$Message = Read-Host "What message do you want displayed?"}
	$Time = (($Time/2)*1000) 
	for ($i = $Time; $i -gt 0; $i--)
	{
		$Remaining = [math]::Round(($i/1000)*2)
		Write-Progress -Activity "$Message" -status "Waiting $Remaining seconds to continue"
	}
	Write-Progress -Activity "$Message" -status "Waiting $Remaining to continue" -Complete
}