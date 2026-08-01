[CmdletBinding()]
param(
    [string]$Packwiz = "packwiz"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$packwizCommand = Get-Command $Packwiz -ErrorAction Stop

Push-Location $repoRoot
try {
    $metadata = foreach ($relativeRoot in @("mods", "resourcepacks", "shaderpacks")) {
        $root = Join-Path $repoRoot $relativeRoot
        if (Test-Path -LiteralPath $root -PathType Container) {
            Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.pw.toml"
        }
    }
    $metadata = @($metadata | Sort-Object FullName)

    foreach ($file in $metadata) {
        $stem = $file.Name -replace '\.pw\.toml$', ''
        & $packwizCommand.Source pin $stem
        if ($LASTEXITCODE -ne 0) {
            throw "packwiz pin failed for $stem"
        }
    }

    & $packwizCommand.Source refresh
    if ($LASTEXITCODE -ne 0) {
        throw "packwiz refresh failed"
    }
}
finally {
    Pop-Location
}

Write-Host "Pinned $($metadata.Count) pack entries and refreshed index.toml."
