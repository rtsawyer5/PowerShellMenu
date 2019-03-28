Function CompDetails
{
	$complist = @()
	do
	{ 
		clear
		Write-Host "*********************************" -ForegroundColor Green
		Write-Host "Computer System Inventory Script " -ForegroundColor Green
		Write-Host "*********************************" -ForegroundColor Green
		Write-Host ""
		Write-Host $complist
		$strResponse = Read-Host "Enter a computer name, RUN to search, CLEAR to empty the list or EXIT to quit:" 
		If($strResponse -eq "EXIT"){
			Ending
			return $null
		}
		ELSEIF($strResponse -eq "CLEAR"){$complist = $null}
		ELSEIF($strResponse -eq "RUN"){
			FindCompDetails $complist
			return $null
		}
		ELSE{$complist += $strResponse}
	}
	until($strResponse -eq "exit")
}

Function FindCompDetails ($complist)
{
	Write-Host ""
	Write-Host ""
	Write-Host ""
	Write-Host ""
	Write-Host ""
	Write-Host ""
	$CRow = 1
	$Excel = New-Object -Com Excel.Application
	clear
	$Excel.Visible = $False
	$Excel.Workbooks.Add()
	clear
	$Excel.Worksheets.Add()
	clear
	$Sheet = $Excel.Worksheets.Item(1)
	$Sheet.Cells.Item(1,1) = "Unit Name"
	$Sheet.Cells.Item(1,2) = "Model"
	$Sheet.Cells.Item(1,3) = "Serial"
	$Sheet.Cells.Item(1,4) = "BIOS"
	$Sheet.Cells.Item(1,5) = "CPU"
	$Sheet.Cells.Item(1,6) = "Cores"
	$Sheet.Cells.Item(1,7) = "Mem(MB)"
	$Sheet.Cells.Item(1,8) = "Mem(MHz)"
	$Sheet.Cells.Item(1,9) = "HDD(GB)"
	$Sheet.Cells.Item(1,10) = "Windows Version"
	clear
	foreach($strComputer in $complist)
	{
		$attempt = 1
		do
		{
			Write-Progress -Activity "Querying Computer: $strComputer - Attempt $attempt"  -status "Running..." -id 1
			$System = Get-WMIObject Win32_ComputerSystem -Computer $strComputer
			IF($System -eq $null){ $attempt++ }
			ELSE{ $attempt = 11 }
		}
		while ($attempt -le 10)
		
		IF($System -eq $null){Write-Host "Computer $strComputer Not Found" -ForegroundColor Red}
		ELSE 
		{
			$CRow++
			Write-Progress -Activity "Computer Found: $strComputer - Pulling Information"  -status "Running..." -id 1
			$OS = Get-WMIObject Win32_OperatingSystem -Computer $StrComputer
			$CPU = Get-WMIObject Win32_Processor -Computer $StrComputer
			$Mem = Get-WMIObject Win32_PhysicalMemory -Computer $StrComputer
			$BIOS = Get-WMIObject Win32_BIOS -Computer $StrComputer
			$HDD = Get-WMIObject Win32_DiskDrive -Computer $StrComputer
			$Sheet.Cells.Item($CRow,1) = $StrComputer
			$Sheet.Cells.Item($CRow,2) = $System.Manufacturer+" "+$System.Model
			$Sheet.Cells.Item($CRow,3) = $BIOS.SerialNumber
			$Sheet.Cells.Item($CRow,4) = $BIOS.SMBIOSBIOSVersion
			$Sheet.Cells.Item($CRow,5) = $CPU.name
			$Sheet.Cells.Item($CRow,6) = $CPU.NumberOfCores
			$TotalMem = 0
			foreach ($objItem in $Mem)
			{
				$TotalMem = $TotalMem + $objItem.Capacity
				$MemSpeed = $objItem.Speed
			}
			$Sheet.Cells.Item($CRow,7) = $TotalMem/1024/1024
			$Sheet.Cells.Item($CRow,8) = $MemSpeed/2
			foreach ($objItem in $HDD)
			{
				if($objItem.DeviceID -eq "\\.\PHYSICALDRIVE0")
				{
					$Sheet.Cells.Item($CRow,9) = $objItem.Size/1024/1024/1024
				}
			}
			$Sheet.Cells.Item($CRow,10) = $OS.Version
			Write-Host "Done writing $strComputer"  -ForegroundColor Green
		}
	}
	$Excel.visible = $True
	Ending
}
