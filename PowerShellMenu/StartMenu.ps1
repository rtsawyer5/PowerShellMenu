$erroractionpreference = "silentlycontinue"
#$PSDrive = "U:"
$PSFolder = "c:\users\rsawyer\documents\PowerShellMenu"
#$PSFolder = "U:\Documents\PowerShell Scripts"
$include = "$PSFolder\Includes"
$NAV = "$PSFolder\NAV"
$TimeClocks = "$PSFolder\TimeClocks"

#Loading Include Scripts (Custom small operations)
. $include\Pause.ps1
. $include\Confirm.ps1
. $include\Countdown.ps1
. $include\Ping.ps1
. $include\Reboot.ps1
. $include\RemoteReg.ps1

#Loading Menu Scripts
. $NAV\Nav.ps1
. $TimeClocks\TCMenu.ps1

#Loading Stand Alone Scripts
. $PSFolder\ProcessCheck.ps1
. $PSFolder\DisableIPv6.ps1
. $PSFolder\SearchGroup.ps1
. $PSFolder\RemoteWait.ps1
. $PSFolder\ViewIP.ps1
. $PSFolder\UVNCWin7Fix.ps1
. $PSFolder\CompDetails.ps1
. $PSFolder\SMSShortcut.ps1
. $PSFolder\TaskSchedule.ps1
. $PSFolder\FindSerial.ps1
. $PSFolder\AutoLogin.ps1

Function StartMenu
{
	do
	{
		clear
		Write-Host "                 ***************************" -ForegroundColor Green
		Write-Host "                 * PowerShell Scripts Menu *" -ForegroundColor Green
		Write-Host "                 * By: Bob Sawyer          *" -ForegroundColor Green
		Write-Host "                 * Date: 06/10/2015        *" -ForegroundColor Green
		Write-Host "          *****************************************" -ForegroundColor Green
		Write-Host "          *               Start Menu              *" -ForegroundColor Green
		Write-Host "**************************************************************" -ForegroundColor Green
		Write-Host "* Commands that are available are:                           *" -ForegroundColor Green
		Write-Host "* (1) - A List of TimeClock Functions                        *" -ForegroundColor Green
		Write-Host "* (2) - A List of NAV Functions                              *" -ForegroundColor Green
		Write-Host "* (3) - Applies CTRL+ALT+DEL fix for UltraVNC on Win 7       *" -ForegroundColor Green
		Write-Host "* (4) - Display IP Address Information                       *" -ForegroundColor Green
		Write-Host "* (5) - Reboot a computer remotely                           *" -ForegroundColor Green
		Write-Host "* (6) - Disable IPv6 on select computer                      *" -ForegroundColor Green
		Write-Host "* (7) - Checks if a Process is running on Computer           *" -ForegroundColor Green
		Write-Host "* (8) - Searches Exchange Groups and gives Members           *" -ForegroundColor Green
		Write-Host "* (9) - Launch remote when the computer restarts             *" -ForegroundColor Green
		Write-Host "*(10) - Get details of a list of computers                   *" -ForegroundColor Green
		Write-Host "*(11) - Place SMS shortcut on Desktop                        *" -ForegroundColor Green
		Write-Host "*(12) - Schedule a task                                      *" -ForegroundColor Green
		Write-Host "*(13) - Enable/Disable AutoAdminLogon                        *" -ForegroundColor Green
		Write-Host "* (Q) - Bye Bye                                              *" -ForegroundColor Green
		Write-Host "**************************************************************" -ForegroundColor Green
		$Command = Read-Host "Type Command and press enter -->"
		Clear
		switch ($Command)
		{
			1 {TCMenu}
			2 {NavMenu}
			3 {UVNCFix}
			4 {ViewIP}
			5 {Reboot}
			6 {DisableIPv6}
			7 {ProcessCheck}
			8 {SearchGroup}
			9 {RemoteWait}
			10 {CompDetails}
			11 {SMSShortcut}
			12 {TaskSchedule}
			13 {AutoLogin}
			Q {}
			default 
			{
				clear
				Write-Host "Invalid Choice" -ForegroundColor Red
				pause
			}
		}
	}
	until($Command -eq "q")
}
StartMenu

