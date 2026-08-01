[CmdletBinding()]
param(
    [string]$Packwiz = "packwiz",
    [switch]$SkipRefresh
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ValidationError([string]$Message) {
    $errors.Add($Message)
}

$packFile = Join-Path $repoRoot "pack.toml"
$indexFile = Join-Path $repoRoot "index.toml"
if (-not (Test-Path -LiteralPath $packFile)) { Add-ValidationError "Missing pack.toml" }
if (-not (Test-Path -LiteralPath $indexFile)) { Add-ValidationError "Missing index.toml" }

if (-not $SkipRefresh) {
    $packwizCommand = Get-Command $Packwiz -ErrorAction Stop
    Push-Location $repoRoot
    try {
        & $packwizCommand.Source refresh
        if ($LASTEXITCODE -ne 0) { Add-ValidationError "packwiz refresh failed" }
    }
    finally {
        Pop-Location
    }
}

$metadata = foreach ($relativeRoot in @("mods", "resourcepacks", "shaderpacks")) {
    $root = Join-Path $repoRoot $relativeRoot
    if (Test-Path -LiteralPath $root -PathType Container) {
        Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.pw.toml"
    }
}
$metadata = @($metadata | Sort-Object FullName)
$filenames = @{}
$sideCounts = @{ both = 0; client = 0; server = 0 }

foreach ($file in $metadata) {
    $content = Get-Content -Raw -Encoding utf8 -LiteralPath $file.FullName
    $relative = $file.FullName.Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')

    if ($content -notmatch '(?m)^pin = true$') {
        Add-ValidationError "$relative is not pinned"
    }
    if ($content -notmatch '(?m)^side = "(both|client|server)"$') {
        Add-ValidationError "$relative has no valid side"
    }
    else {
        $sideCounts[$Matches[1]]++
    }
    if ($content -notmatch '(?m)^filename = "([^"]+)"$') {
        Add-ValidationError "$relative has no filename"
    }
    else {
        $downloadName = $Matches[1]
        if ($filenames.ContainsKey($downloadName)) {
            Add-ValidationError "Duplicate download filename '$downloadName' in $relative and $($filenames[$downloadName])"
        }
        else {
            $filenames[$downloadName] = $relative
        }
    }
    $usesHttps = $content -match '(?m)^url = "https://'
    $usesCurseForgeMetadata =
        $content -match '(?m)^mode = "metadata:curseforge"$' -and
        $content -match '(?m)^file-id = [0-9]+$' -and
        $content -match '(?m)^project-id = [0-9]+$'
    if (-not $usesHttps -and -not $usesCurseForgeMetadata) {
        Add-ValidationError "$relative has no approved HTTPS or CurseForge-metadata download"
    }
}

if (Test-Path -LiteralPath $indexFile) {
    $index = Get-Content -Raw -Encoding utf8 -LiteralPath $indexFile
    $listed = [regex]::Matches($index, '(?m)^file = "([^"]+)"$') |
        ForEach-Object { $_.Groups[1].Value }
    foreach ($relative in $listed) {
        $candidate = Join-Path $repoRoot ($relative.Replace('/', '\'))
        if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            Add-ValidationError "index.toml references missing file: $relative"
        }
    }
}

$critical = @{
    "mods/distanthorizons.pw.toml" = 'filename = "DistantHorizons-3.2.0-b-1.21.1-fabric-neoforge.jar"'
    "mods/iris.pw.toml"             = 'filename = "iris-neoforge-1.8.14-beta.1+mc1.21.1.jar"'
    "mods/sodium.pw.toml"           = 'filename = "sodium-neoforge-0.8.12+mc1.21.1.jar"'
    "mods/jei.pw.toml"              = 'filename = "jei-1.21.1-neoforge-19.43.0.392.jar"'
    "mods/create.pw.toml"           = 'filename = "create-1.21.1-6.0.10.jar"'
}
foreach ($entry in $critical.GetEnumerator()) {
    $candidate = Join-Path $repoRoot ($entry.Key.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $candidate)) {
        Add-ValidationError "Missing critical pin: $($entry.Key)"
    }
    elseif ((Get-Content -Raw -Encoding utf8 -LiteralPath $candidate) -notmatch [regex]::Escape($entry.Value)) {
        Add-ValidationError "Critical version changed in $($entry.Key)"
    }
}

$forbiddenNames = @("servers.dat", "whitelist.json", "ops.json", "eula.txt", "server.properties")
foreach ($name in $forbiddenNames) {
    $matches = Get-ChildItem -Path $repoRoot -Recurse -File -Filter $name |
        Where-Object { $_.FullName -notlike "*\server\server.properties.example" }
    foreach ($match in $matches) {
        Add-ValidationError "User/server-owned runtime file is present: $($match.FullName)"
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Host "ERROR: $_" -ForegroundColor Red }
    throw "Hasencraft validation failed with $($errors.Count) error(s)."
}

Write-Host "Validated $($metadata.Count) entries: $($sideCounts.both) both, $($sideCounts.client) client, $($sideCounts.server) server."
