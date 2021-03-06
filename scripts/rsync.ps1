param(
  [Parameter(Mandatory=$true)]
  [String] $localPath,
  [Parameter(Mandatory=$true)]
  [String] $remoteServer,
  [Parameter(Mandatory=$true)]
  [String] $remotePath,
  [Parameter(Mandatory=$true)]
  [String] $username,
  [Parameter(Mandatory=$true)]
  [String] $password
)

$ErrorActionPreference = "stop"

$port = 5985
$awsInstanceName = "biztalk-server"
$ip = $remoteServer
Write-Host "-- Creating Session to $ip..."
Enable-PSRemoting -force
Write-Host "-- Adding IP $ip to trusted hosts ..."
winrm set winrm/config/client "@{TrustedHosts=`"$ip`"}"
$passwordSecure = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username,$passwordSecure)
$session = New-PSSession -ComputerName $ip -Port $port -Credential $cred -Authentication Basic
Write-Host "-- COPY --"
Write-Host "-- FROM $localPath"
Write-Host "-- TO $ip"
Write-Host "-- DIR: $remotePath"
# TODO remove remote directory if exists, before creation
Copy-Item -Verbose -Force -ToSession $session -Path "$localPath/*" -Destination $remotePath -Recurse -Exclude ".*"
