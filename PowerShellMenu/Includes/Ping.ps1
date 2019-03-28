Function PingComp ($Computer)
{
	#Param Check
	if(!$Computer){$Computer = Read-Host "What computer would you like to Ping?"}
	$ping = Test-Connection -Computer $Computer -Count:1 -Quiet
	Return ,$ping
}