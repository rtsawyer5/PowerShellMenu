Function Confirm ($Message)
{
	#Param Check
	if(!$Message){$Message = Read-Host "What would you like to confirm?"}
	Do
	{
		$Confirm = Read-Host "$Message (Y)es or (N)o"
		If($Confirm -match "Y"){Return $True}
		If($Confirm -match "N"){Return $False}
		Write-Host "Invalid Answer. Try Again"
	}
	Until($confirm -eq "Nothing")
}