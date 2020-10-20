#Install-Module Selenium
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\Selenium.psm1"
#Note had a heck of a time getting the Driver compatible with the current browser
#turns out, as always, it's super simple https://github.com/adamdriscoll/selenium-powershell/blob/master/Public/Update-SeDriver.ps1
#That function isn't implemented yet but should be enough to get it working...
#The Useful bits
<#
$LatestChromeStableRelease = Invoke-WebRequest 'https://chromedriver.storage.googleapis.com/LATEST_RELEASE' | Select-Object -ExpandProperty Content
$Build = "chromedriver_win32"
$BuildFileName = "$Build.zip"
Write-Verbose "Downloading: $BuildFileName"
Invoke-WebRequest -OutFile "$($TempDir + $BuildFileName)" "https://chromedriver.storage.googleapis.com/$LatestChromeStableRelease/$BuildFileName" 
"$($TempDir + $BuildFileName)"
$AssembliesDir = Join-path (Split-path -Parent (get-module Selenium).path) '/assembiles'
Expand-Archive -Path "$($TempDir + $BuildFileName)" -DestinationPath $AssembliesDir -Force
#>

#C:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\assemblies was the path to put the new driver
$Driver = Start-SeChrome
enter-seurl "https://wiotcentral.wodongatafe.edu.au/T1Production/CiAnywhere/Web/PRODUCTION/Public/LogOn/RECRUIT_GUEST" -driver $driver
$element = Find-SeElement -Driver $Driver -id "Ci2Function1" #Finding which element to click will be torture if they've got generic names like this...
#... Found a fix -CssSelector "[title*='My Leave']" see below for demo
Invoke-SeClick -element $element
$element = Find-SeElement -Driver $Driver -id "UserNavigation"
Invoke-SeClick -element $element
$element = Find-SeElement -Driver $Driver -id "LogonName"
Send-SeKeys -Element $Element -Keys "bhaslett"


$Driver = Start-SeChrome
enter-seurl "https://wiotcentral.wodongatafe.edu.au/T1Production/CiAnywhere/Web/PRODUCTION/Workplace" -driver $driver
#loginmanually here
$element = Find-SeElement -CssSelector "[title*='My Leave']" -driver $driver
Invoke-SeClick -element $element

#still having trouble clicking certain things but presumably will figure it out
#not sure if the driver is waiting for a page to load before going to the next thing...
#Now we've just discovered a thing called "data-t1-control" ugh. We'll be parsing lots of junk...


