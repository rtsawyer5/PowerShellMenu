#Used to search For a specific AD Group and list the members

Function SearchGroup
{
	clear
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host "* Exchange Group Lister                   *" -ForegroundColor Green
	Write-Host "*******************************************" -ForegroundColor Green
	Write-Host ""
	$GroupName = Read-Host "Enter Group Name"
	Try
	{	
		$Groups = Get-ADGroup -filter {Name -like $GroupName } | Select-Object Name
		ForEach ($Group in $Groups) 
		{
			$users = Get-ADGroupMember -identity $($group.name) -recursive | Get-ADUser -Properties Name, mail, Title | Select-Object Name, mail, Title
		}
	}
	Catch
	{
		Write-Host "$GroupName is invalid" -ForegroundColor "Red"
		Ending
		Return
	}
	$Excel = New-Object -Com Excel.Application
	$Excel.Visible = $True
	$Excel.Workbooks.Add()
	clear
	$Sheet = $Excel.Worksheets.Item(1)
	$Sheet.Cells.Item(1,1) = "Name"
	$Sheet.Cells.Item(1,2) = "Email"
	$Sheet.Cells.Item(1,3) = "Title"
	$CRow = 1
	ForEach ($user in $users) 
	{
		$CRow++
		$Sheet.Cells.Item($CRow,1) = $user.Name
		$Sheet.Cells.Item($CRow,2) = $user.mail
		$Sheet.Cells.Item($CRow,3) = $user.Title
	}
	$Sheet.UsedRange.EntireColumn.AutoFit() | Out-Null
	$found = $users.Count
	Write-Host "$found users found" -ForegroundColor "Green"
	ending	
}