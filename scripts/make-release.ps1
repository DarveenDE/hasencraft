[CmdletBinding()]
param(
    [string]$Version
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$packFile = Join-Path $repoRoot "pack.toml"
$indexFile = Join-Path $repoRoot "index.toml"
$pack = Get-Content -Raw -Encoding utf8 -LiteralPath $packFile

if (-not $Version) {
    if ($pack -notmatch '(?m)^version = "([^"]+)"$') {
        throw "Could not read version from pack.toml"
    }
    $Version = $Matches[1]
}
if ($Version -notmatch '^[0-9A-Za-z][0-9A-Za-z._-]*$') {
    throw "Unsafe release version: $Version"
}

$releaseRoot = Join-Path $repoRoot "hosting\releases"
$release = Join-Path $releaseRoot $Version
$fullRelease = [System.IO.Path]::GetFullPath($release)
$fullRoot = [System.IO.Path]::GetFullPath($releaseRoot).TrimEnd('\') + '\'
if (-not $fullRelease.StartsWith($fullRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing release path outside hosting/releases: $fullRelease"
}

if (Test-Path -LiteralPath $release) {
    throw "Immutable release already exists: $release"
}

$declaredIndexHash = if ($pack -match '(?ms)^\[index\].*?^hash = "([0-9a-fA-F]+)"$') { $Matches[1].ToLowerInvariant() } else { "" }
$actualIndexHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $indexFile).Hash.ToLowerInvariant()
if ($declaredIndexHash -ne $actualIndexHash) {
    throw "pack.toml does not match index.toml; run packwiz refresh first."
}

$index = Get-Content -Raw -Encoding utf8 -LiteralPath $indexFile
$listed = [regex]::Matches($index, '(?m)^file = "([^"]+)"$') |
    ForEach-Object { $_.Groups[1].Value }
$staging = Join-Path $releaseRoot (".{0}.staging.{1}.{2}" -f $Version, $PID, [guid]::NewGuid().ToString("N"))
$fullStaging = [System.IO.Path]::GetFullPath($staging)
if (-not $fullStaging.StartsWith($fullRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing staging path outside hosting/releases: $fullStaging"
}

New-Item -ItemType Directory -Path $releaseRoot -Force | Out-Null
New-Item -ItemType Directory -Path $staging | Out-Null
try {
    Copy-Item -LiteralPath $packFile -Destination (Join-Path $staging "pack.toml")
    Copy-Item -LiteralPath $indexFile -Destination (Join-Path $staging "index.toml")

    foreach ($relative in $listed) {
        if ([System.IO.Path]::IsPathRooted($relative) -or $relative -match '(^|/|\\)\.\.($|/|\\)') {
            throw "index.toml contains unsafe path: $relative"
        }
        $source = Join-Path $repoRoot ($relative.Replace('/', '\'))
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
            throw "index.toml references missing file: $relative"
        }
        $destination = Join-Path $staging ($relative.Replace('/', '\'))
        $fullDestination = [System.IO.Path]::GetFullPath($destination)
        $stagingPrefix = $fullStaging.TrimEnd('\') + '\'
        if (-not $fullDestination.StartsWith($stagingPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing destination outside staging directory: $relative"
        }
        $parent = Split-Path -Parent $destination
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $destination
    }

    $manifest = Get-ChildItem -LiteralPath $staging -Recurse -File | Sort-Object FullName | ForEach-Object {
        $relative = $_.FullName.Substring($staging.Length).TrimStart('\', '/').Replace('\', '/')
        $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
        "$hash  $relative"
    }
    [System.IO.File]::WriteAllText(
        (Join-Path $staging "SHA256SUMS"),
        (($manifest -join "`n") + "`n"),
        [System.Text.UTF8Encoding]::new($false)
    )

    foreach ($line in $manifest) {
        $parts = $line -split '  ', 2
        $candidate = Join-Path $staging ($parts[1].Replace('/', '\'))
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $candidate).Hash.ToLowerInvariant()
        if ($actual -ne $parts[0]) { throw "Release verification failed for $($parts[1])" }
    }

    if (Test-Path -LiteralPath $release) {
        throw "Immutable release appeared while building: $release"
    }
    Move-Item -LiteralPath $staging -Destination $release
}
finally {
    if (Test-Path -LiteralPath $staging) {
        Remove-Item -LiteralPath $staging -Recurse -Force
    }
}

Write-Host "Built immutable release snapshot: $release"
