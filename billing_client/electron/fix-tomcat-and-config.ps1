$ErrorActionPreference = 'Stop'
Copy-Item -Force 'd:\MYFILES\billing\JASXBILL\billing_client\electron\desktop-config.json' 'C:\Program Files\JASXBILL\desktop-config.json'
Start-Service Tomcat10
Start-Sleep -Seconds 3
$svc = Get-Service Tomcat10
Write-Output "Tomcat10=$($svc.Status)"
Write-Output (Get-Content 'C:\Program Files\JASXBILL\desktop-config.json' -Raw)
