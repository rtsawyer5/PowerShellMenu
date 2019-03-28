function RemoteRegActivate($Computer){
    if(!$Computer){$Computer = Read-Host "What computer would you like to activate Remote Registry on?"}
    #Find out if the Remote Registry Service is currently running or not.
    Write-Host "Checking Remote Registry Service" -ForegroundColor Magenta
    if((get-service remoteregistry -Computer $Computer).Status -eq "Stopped")
    {
        #Activate the service 
        $Status = "Stopped"
        Write-Host "Enabling Remote Registry Service" -ForegroundColor Green
        Set-Service remoteregistry -Computer $Computer -StartMode Manual
        Set-Service remoteregistry -Computer $Computer -Status Running
    }
    else
    {
        $Status = "Running"
    }

    Return ,$Status
}

function RemoteRegDeactivate($Status,$Computer){
    if(!$Computer){$Computer = Read-Host "What computer would you like to deactivate Remote Registry on?"}
    
    if($Status -eq "Stopped"){
        #Disable the service if it was disabled to begin with.
        Write-Host "Disabling Remote Registry Service" -ForegroundColor Green
        Set-Service remoteregistry -Computer $Computer -StartMode Disabled
    }
}
