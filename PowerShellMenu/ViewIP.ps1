Function ViewIP
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* View IP Address Information             *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	
	$Computer = Read-host "What Computer do you wish to search for?"
	Write-Host ""
	if(PingComp $Computer)
	{
		$wmi = Get-WmiObject win32_networkadapterconfiguration -Computer $Computer -filter "ipenabled = 'true'"
		Write-Host ""	
		Write-Host "************ NIC Information *************"
		Write-Host "    NIC Description : " $wmi.Description
		Write-Host "        MAC Address : " $wmi.MACAddress
		
		Write-Host ""
		Write-Host "********** Address Information ***********"			
		Write-Host "         IP Address : " $wmi.IPAddress
		Write-Host "             Subnet : " $wmi.IPSubnet
		Write-Host "    Default Gateway : " $wmi.DefaultIPGateway
		
		Write-Host ""	
		Write-Host "************ DNS Information *************"
		Write-Host "         DNS Domain : " $wmi.DNSDomain
		Write-Host "      DNS Host Name : " $wmi.DNSHostName
		Write-Host "        DNS Servers : " $wmi.DNSServerSearchOrder
			
		Write-Host ""	
		Write-Host "************ DHCP Information ************"
		Write-Host "       DHCP Enabled : " $wmi.DHCPEnabled
		Write-Host "DHCP Lease Obtained : " (DateTimeConvert $wmi.DHCPLeaseObtained)
		Write-Host " DHCP Lease Expires : " (DateTimeConvert $wmi.DHCPLeaseExpires)
		Write-Host "        DHCP Server : " $wmi.DHCPServer
	}
	else
	{
		Write-Host "Unable to find $Computer" -ForegroundColor Red
	}
	Ending
}

Function DateTimeConvert ($String)
{
	$year = $String.Substring(0,4)
	$month = $String.Substring(4,2)
	$day = $String.Substring(6,2)
	$hour = $String.Substring(8,2)
	$minute = $String.Substring(10,2)
	$second = $string.Substring(12,2)
	$DateTime = "$month \ $day \ $year   $hour : $minute : $second"
	Return $DateTime	
}