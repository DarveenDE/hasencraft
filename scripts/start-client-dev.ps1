[CmdletBinding()]
param(
    [ValidateSet("fluffy", "cozy", "eco")]
    [string]$Profile = "cozy",

    [ValidateRange(1024, 65535)]
    [int]$Port = 8080,

    [string]$Packwiz = "packwiz"
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$validatePack = Join-Path $PSScriptRoot "validate-pack.ps1"
$buildPrism = Join-Path $PSScriptRoot "build-prism.ps1"
$packUrl = [uri]("http://127.0.0.1:{0}/pack.toml" -f $Port)

try {
    $packwizCommand = Get-Command $Packwiz -ErrorAction Stop
}
catch {
    throw "Packwiz was not found. Install the CI version with 'go install github.com/packwiz/packwiz@dfd8b68a4796' or pass -Packwiz with its path."
}
if ([System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners().Port -contains $Port) {
    throw "Port $Port is already in use. Choose another port with -Port."
}
if ($packwizCommand.CommandType -notin @("Application", "ExternalScript")) {
    throw "Packwiz must resolve to an executable: $Packwiz"
}
if (-not (Test-Path -LiteralPath $validatePack -PathType Leaf)) {
    throw "Missing validation script: $validatePack"
}
if (-not (Test-Path -LiteralPath $buildPrism -PathType Leaf)) {
    throw "Missing Prism build script: $buildPrism"
}

Write-Host "Refreshing and validating the Hasencraft pack..."
& $validatePack -Packwiz $packwizCommand.Source
if ($LASTEXITCODE -ne 0) {
    throw "Pack validation failed."
}

Write-Host "Building the local $Profile Prism development archive..."
& $buildPrism -PackUrl $packUrl -AllowHttp -Channel dev -Profile $Profile -Force
if ($LASTEXITCODE -ne 0) {
    throw "Prism development archive build failed."
}

$archive = Join-Path $repoRoot ("dist\Hasencraft-dev-{0}.zip" -f $Profile)
Write-Host ""
Write-Host "Import this archive once in Prism: $archive" -ForegroundColor Green
Write-Host "Keep this window open while starting the Hasencraft Dev instance."
Write-Host "The local pack URL is $packUrl and only works on this computer."
Write-Host ""
Write-Host "Starting the local packwiz development server (Ctrl+C stops it)..."

Push-Location $repoRoot
try {
    & $packwizCommand.Source serve --port $Port
}
finally {
    Pop-Location
}
