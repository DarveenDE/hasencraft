[CmdletBinding()]
param(
    [string]$Destination
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$hostingRoot = Join-Path $repoRoot "hosting"
$releasesRoot = Join-Path $hostingRoot "releases"
$channelFile = Join-Path $hostingRoot "channels.json"
$pagesSource = Join-Path $hostingRoot "pages"
$buildRoot = Join-Path $repoRoot "build"

if ([string]::IsNullOrWhiteSpace($Destination)) {
    $Destination = Join-Path $buildRoot "pages"
}

function Assert-ChildPath([string]$Candidate, [string]$Parent) {
    $candidateFull = [System.IO.Path]::GetFullPath($Candidate)
    $parentFull = [System.IO.Path]::GetFullPath($Parent).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    if (-not $candidateFull.StartsWith($parentFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing path outside expected parent: $candidateFull"
    }
}

function Test-Release([string]$Version) {
    if ($Version -notmatch '^[0-9A-Za-z][0-9A-Za-z._-]*$') {
        throw "Unsafe release version: $Version"
    }

    $release = Join-Path $releasesRoot $Version
    foreach ($required in @("pack.toml", "index.toml", "SHA256SUMS")) {
        if (-not (Test-Path -LiteralPath (Join-Path $release $required) -PathType Leaf)) {
            throw "Release $Version is incomplete: missing $required"
        }
    }

    foreach ($line in Get-Content -LiteralPath (Join-Path $release "SHA256SUMS")) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        if ($line -notmatch '^([0-9a-fA-F]{64})  (.+)$') {
            throw "Malformed SHA256SUMS line in $Version`: $line"
        }

        $expected = $Matches[1].ToLowerInvariant()
        $relative = $Matches[2].Replace('/', [System.IO.Path]::DirectorySeparatorChar)
        $candidate = Join-Path $release $relative
        Assert-ChildPath $candidate $release
        if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            throw "Manifest target missing in $Version`: $relative"
        }
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $candidate).Hash.ToLowerInvariant()
        if ($actual -ne $expected) {
            throw "SHA-256 mismatch in $Version`: $relative"
        }
    }

    return $release
}

if (-not (Test-Path -LiteralPath $channelFile -PathType Leaf)) {
    throw "Missing channel configuration: $channelFile"
}

$channels = Get-Content -Raw -LiteralPath $channelFile | ConvertFrom-Json
foreach ($name in @("stable", "beta")) {
    if (-not $channels.PSObject.Properties.Name.Contains($name)) {
        throw "Missing channel: $name"
    }
    Test-Release ([string]$channels.$name) | Out-Null
}

$destinationFull = [System.IO.Path]::GetFullPath($Destination)
Assert-ChildPath $destinationFull $buildRoot
if (Test-Path -LiteralPath $destinationFull) {
    Remove-Item -LiteralPath $destinationFull -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $destinationFull | Out-Null

Copy-Item -Path (Join-Path $pagesSource "*") -Destination $destinationFull -Recurse -Force
Copy-Item -LiteralPath $channelFile -Destination (Join-Path $destinationFull "channels.json")
Copy-Item -LiteralPath $releasesRoot -Destination $destinationFull -Recurse -Force

$stableVersion = [string]$channels.stable
$repository = "DarveenDE/hasencraft"
$fluffyUrl = "https://github.com/$repository/releases/download/v$stableVersion/Hasencraft-stable-fluffy.zip"
$cozyUrl = "https://github.com/$repository/releases/download/v$stableVersion/Hasencraft-stable-cozy.zip"
$indexFile = Join-Path $destinationFull "index.html"
$index = Get-Content -Raw -LiteralPath $indexFile
$index = $index.Replace("__STABLE_VERSION__", $stableVersion)
$index = $index.Replace("__FLUFFY_IMPORT_URL__", $fluffyUrl)
$index = $index.Replace("__COZY_IMPORT_URL__", $cozyUrl)
[System.IO.File]::WriteAllText($indexFile, $index, [System.Text.UTF8Encoding]::new($false))

$publishedChannels = Join-Path $destinationFull "channels"
New-Item -ItemType Directory -Force -Path $publishedChannels | Out-Null
foreach ($name in @("stable", "beta")) {
    $source = Join-Path $releasesRoot ([string]$channels.$name)
    $target = Join-Path $publishedChannels $name
    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
}

[System.IO.File]::WriteAllText((Join-Path $destinationFull ".nojekyll"), "", [System.Text.UTF8Encoding]::new($false))

Write-Host "Built GitHub Pages artifact at $destinationFull"
Write-Host "stable -> $($channels.stable)"
Write-Host "beta   -> $($channels.beta)"
