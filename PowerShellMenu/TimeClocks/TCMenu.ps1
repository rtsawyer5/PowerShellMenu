. $TimeClocks\PingTC.ps1
. $TimeClocks\RebootTC.ps1
. $TimeClocks\TCShellFix.ps1
. $TimeClocks\CheckTasks.ps1

Function TCMenu
{
	do
	{
		Write-Host "                 ***************************" -ForegroundColor Green
		Write-Host "                 * Time Clock Scripts Menu *" -ForegroundColor Green
		Write-Host "                 * By: Bob Sawyer          *" -ForegroundColor Green
		Write-Host "                 * Date: 06/12/2015        *" -ForegroundColor Green
		Write-Host "                 ***************************" -ForegroundColor Green
		Write-Host ""
		Write-Host "**************************************************************" -ForegroundColor Green
		Write-Host "* Commands that are available are:                           *" -ForegroundColor Green
		Write-Host "* (1) - Ping and get status from all TimeClocks              *" -ForegroundColor Green
		Write-Host "* (2) - Ping and get status from one TimeClock               *" -ForegroundColor Green
		Write-Host "* (3) - Reboots all TimeClocks                               *" -ForegroundColor Green
		Write-Host "* (4) - Reboots one TimeClocks                               *" -ForegroundColor Green
		Write-Host "* (5) - Fix the Shell property on TimeClocks                 *" -ForegroundColor Green
		Write-Host "* (6) - Checks for Scheduled_Restart task on all             *" -ForegroundColor Green
		Write-Host "* (M) - Back to Start Menu                                   *" -ForegroundColor Green
		Write-Host "**************************************************************" -ForegroundColor Green
		$Command = Read-Host "Type Command and press enter -->"
		Clear
		switch ($Command)
		{
			2{PingOne}
			1{PingAll}
			3{RebootAll}
			4{RebootOne}
			5{TCShellFix}
			6{CheckTasks}
			M{Write-Host "Thank you - Have a great day!" -ForegroundColor Magenta}
			default 
			{
				clear
				Write-Host "Invalid Choice" -ForegroundColor Red
			}
		}
	}
	until($Command -eq "m")
}