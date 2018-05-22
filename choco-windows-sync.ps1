# LICENSE: GNU GPL v3 - https://www.gnu.org/licenses/gpl.html
# Open to suggestions - open a GitHub issue please if you have a suggestion/request.

$CPLBver        = "2018.05.10" # Version of this script
$ConfigFile     = "packages.config"
$SaveFolderName = "zzz_WindowsSetup\Machines" # Change the subfolder name if you don't like my default
$SaveVersions   = "False" # Specify if you want to save specific version info or not
$InstChoco      = "$Env:ChocolateyInstall\lib\instchoco\tools\InstChoco.exe" # location of InstChoco.exe if it exists
# Toggle True/False if you want to backup/not backup to the locations below
$UseOneDrive    = "True"

# Check the path to save packages.config and create if it doesn't exist
Function Check-SaveLocation{
    $CheckPath = Test-Path $SavePath
  If ($CheckPath -match "False")
     {
      New-Item $SavePath -Type Directory -force | out-null
     }   
    }

# Copy InstChoco.exe if it exists to the same location as packages.config for super duper easy re-installation
Function Check-InstChoco{
    $CheckICSource = Test-Path $InstChoco
	If ($CheckICSource -match "True"){
	   $CheckICDest = Test-Path $SavePath\InstChoco.exe
	   If ($CheckICDest -match "False")
	      {
	       Copy-Item $InstChoco $SavePath -force | out-null
	      }
	   }
    }
	
# Write out the saved list of packages to packages.config
Function Write-PackageConfig{
    Check-SaveLocation
	Check-InstChoco
    Write-Output "<?xml version=`"1.0`" encoding=`"utf-8`"?>" >"$SavePath\$ConfigFile"
    Write-Output "<packages>" >>"$SavePath\$ConfigFile"
	if ($SaveVersions -match "True")
	   {
        choco list -lo -r -y | % { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />" }>>"$SavePath\$ConfigFile"
	   } else {
         choco list -lo -r -y | % { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" />" }>>"$SavePath\$ConfigFile"
		 }
    Write-Output "</packages>" >>"$SavePath\$ConfigFile"
	Write-Host "$SavePath\$ConfigFile SAVED!" -ForegroundColor green 
    }

Write-Host "dpeh-windows-sync.ps1 v$CPLBver" - Performing Save of Current Chocolately Packages. -ForegroundColor white

#Backup Chocolatey package names on local computer to packages.config file in OneDrive directory if it exists
if ($UseOneDrive -match "True" -and (Test-Path $Env:USERPROFILE\OneDrive))
   {
    $SavePath = "$Env:USERPROFILE\OneDrive\$SaveFolderName\$Env:ComputerName"
    Write-PackageConfig
   }       

Write-Host "TO RE-INSTALL YOUR CHOCOLATEY PACKAGES:" -ForegroundColor magenta 
Write-Host "1> Go to the location of your saved PACKAGES.CONFIG file and type CINST PACKAGES.CONFIG -Y" -ForegroundColor magenta 