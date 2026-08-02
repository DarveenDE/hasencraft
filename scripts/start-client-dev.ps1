[CmdletBinding()]
param(
    [ValidateSet("fluffy", "cozy", "eco")]
    [string]$Profile = "cozy",

    [string]$Packwiz = "packwiz",

    [switch]$Import,

    [string]$PrismLauncher
)

$ErrorActionPreference = "Stop"

function Resolve-PrismLauncher([string]$RequestedPath) {
    if (-not [string]::IsNullOrWhiteSpace($RequestedPath)) {
        if (-not (Test-Path -LiteralPath $RequestedPath -PathType Leaf)) {
            throw "Prism Launcher was not found: $RequestedPath"
        }
        return (Resolve-Path -LiteralPath $RequestedPath).Path
    }

    $candidates = @(
        (Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) "Programs\PrismLauncher\prismlauncher.exe"),
        (Join-Path ([Environment]::GetFolderPath("ProgramFiles")) "PrismLauncher\prismlauncher.exe")
    )
    $programFilesX86 = ${env:ProgramFiles(x86)}
    if (-not [string]::IsNullOrWhiteSpace($programFilesX86)) {
        $candidates += Join-Path $programFilesX86 "PrismLauncher\prismlauncher.exe"
    }
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    $command = Get-Command prismlauncher.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $command -and $command.CommandType -in @("Application", "ExternalScript")) {
        return $command.Source
    }
    return $null
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$validatePack = Join-Path $PSScriptRoot "validate-pack.ps1"
$buildPrism = Join-Path $PSScriptRoot "build-prism.ps1"
$packFile = (Resolve-Path -LiteralPath (Join-Path $repoRoot "pack.toml")).Path
$packUrl = [uri]$packFile
$devOutput = Join-Path $repoRoot "build\dev-client"
$profileNames = @{ fluffy = "Fluffy"; cozy = "Cozy"; eco = "Eco" }
$profileName = $profileNames[$Profile]

try {
    $packwizCommand = Get-Command $Packwiz -ErrorAction Stop
}
catch {
    $goPackwiz = Join-Path $env:USERPROFILE "go\bin\packwiz.exe"
    if ($Packwiz -eq "packwiz" -and (Test-Path -LiteralPath $goPackwiz -PathType Leaf)) {
        $packwizCommand = Get-Command $goPackwiz -ErrorAction Stop
    }
    else {
        throw "Packwiz was not found. Install the CI version with 'go install github.com/packwiz/packwiz@dfd8b68a4796' or pass -Packwiz with its path."
    }
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
& $buildPrism -PackUrl $packUrl -Channel dev -Profile $Profile -DevelopmentPackwiz $packwizCommand.Source -OutputDirectory $devOutput -Force
if ($LASTEXITCODE -ne 0) {
    throw "Prism development archive build failed."
}

$archive = Join-Path $devOutput ("Hasencraft-dev-{0}.zip" -f $Profile)
Write-Host ""
Write-Host "Built local development archive: $archive" -ForegroundColor Green

if ($Import) {
    $prism = Resolve-PrismLauncher $PrismLauncher
    if ($null -eq $prism) {
        throw "Prism Launcher was not found. Install it or pass -PrismLauncher with its executable path."
    }
    Start-Process -FilePath $prism -ArgumentList ('--import "{0}"' -f $archive)
    Write-Host "Prism Launcher was opened to import the Hasencraft $profileName Dev instance."
}
else {
    Write-Host "Import it once in Prism, or rerun this command with -Import to open Prism automatically."
}

Write-Host "After the first import, start Hasencraft $profileName Dev directly in Prism; no terminal or local web server is needed."
