#On win7 the IE10 dependency may have left the machine in a pending reboot state
#If the Boxstarter.Chocolaty module is imported, go ahead nd reboot if this is the case
if(Get-Module Boxstarter.Chocolatey){
    if(Test-PendingReboot){
        Invoke-Reboot
    }
}

$ieKey="HKLM:\Software\Microsoft\Internet Explorer"
if(Get-ItemProperty -Path $ieKey -Name "svcVersion" -ErrorAction SilentlyContinue){
    $ieVersion=(Get-ItemProperty -Path $ieKey -Name "svcVersion").svcVersion
    $majorVersion = [int]$ieVersion.Substring(0,2)
    $hasIE10 = $majorVersion -gt 9
}

if($hasIE10 -ne $true){
    throw @"
    You either do not have IE10 installed or you have just installed IE10 
    as a dependency of this package and your machine must be rebooted for the IE10 
    install to complete. Visual Studio 2013 cannot be installed until the IE10 
    installation is complete. For a fully silent install, try using 
    http://Boxstarter.org to manage the reboot automatically.
"@
}

$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
Install-ChocolateyPackage 'VisualStudio2013Ultimate' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log" 'http://download.microsoft.com/download/1/C/1/1C18413B-83AA-4108-A9F9-CE63F2990126/vs_ultimate_download.exe'
