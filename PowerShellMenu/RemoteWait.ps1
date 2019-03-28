#Waits for computer to restart and for the CMRCService to fully start, then launches remote control

Function RemoteWait ($Computer, $Service)
{
	if(!$Computer)
	{
		clear
		Write-Host "*******************************************" -ForegroundColor Green
		Write-Host "* Remote Waiter                           *" -ForegroundColor Green
		Write-Host "*******************************************" -ForegroundColor Green
		Write-Host ""
		$Computer = Read-host "What computer would you like to connect to?"
	}

	Write-Host "Waiting for Remote Service to start" -ForegroundColor Magenta
	while(!(PingComp $Computer)){}
	$service = tasklist /s $Computer /fi "IMAGENAME eq CmRcService.exe"
	While($service -match "INFO:"){$service = tasklist /s $Computer /fi "IMAGENAME eq CmRcService.exe"}
	
	cd "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\i386"
	./CmRcViewer.exe $Computer
	clear
}