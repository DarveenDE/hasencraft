[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [uri]$PackUrl,

    [ValidateSet("stable", "beta")]
    [string]$Channel = "stable",

    [ValidateSet("fluffy", "cozy", "eco")]
    [string]$Profile = "fluffy",

    [switch]$AllowHttp,

    [switch]$Force,

    # Intended for automated archive checks. Custom output stays inside build/.
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"

if ($PackUrl.Scheme -ne "https" -and -not ($AllowHttp -and $PackUrl.Scheme -eq "http")) {
    throw "PackUrl must use HTTPS. Use -AllowHttp only for a local development server."
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$templateRoot = Join-Path $repoRoot "launcher\templates"
$bootstrap = Join-Path $repoRoot "launcher\bootstrap\packwiz-installer-bootstrap.jar"
$icon = Join-Path $repoRoot "launcher\hasencraft.png"
$buildParent = Join-Path $repoRoot "build"
$stage = Join-Path $buildParent "prism-$Channel-$Profile"
$dist = Join-Path $repoRoot "dist"

function Assert-ChildPath([string]$Candidate, [string]$Parent) {
    $fullCandidate = [System.IO.Path]::GetFullPath($Candidate)
    $fullParent = [System.IO.Path]::GetFullPath($Parent).TrimEnd("\") + "\"
    if (-not $fullCandidate.StartsWith($fullParent, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing path outside expected parent: $fullCandidate"
    }
}

if (-not (Test-Path -LiteralPath $bootstrap)) {
    throw "Missing packwiz bootstrap: $bootstrap"
}

$bootstrapHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bootstrap).Hash.ToLowerInvariant()
if ($bootstrapHash -ne "a8fbb24dc604278e97f4688e82d3d91a318b98efc08d5dbfcbcbcab6443d116c") {
    throw "Unexpected packwiz bootstrap SHA-256: $bootstrapHash"
}

if (-not [string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $dist = [System.IO.Path]::GetFullPath($OutputDirectory)
    Assert-ChildPath $dist $buildParent
}
$archive = Join-Path $dist "Hasencraft-$Channel-$Profile.zip"

New-Item -ItemType Directory -Force -Path $buildParent, $dist | Out-Null
Assert-ChildPath $stage $buildParent

if (Test-Path -LiteralPath $stage) {
    Remove-Item -LiteralPath $stage -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $stage | Out-Null

Copy-Item -Path (Join-Path $templateRoot "common\*") -Destination $stage -Recurse -Force
Copy-Item -Path (Join-Path $templateRoot "$Profile\*") -Destination $stage -Recurse -Force
Copy-Item -LiteralPath $bootstrap -Destination (Join-Path $stage "minecraft\packwiz-installer-bootstrap.jar") -Force
Copy-Item -LiteralPath $icon -Destination (Join-Path $stage "hasencraft.png") -Force

$instanceTemplate = Join-Path $stage "instance.cfg.in"
$instanceFile = Join-Path $stage "instance.cfg"
$profileNames = @{
    fluffy = "Hasencraft Fluffy"
    cozy   = "Hasencraft Cozy"
    eco    = "Hasencraft Eco"
}
$profileName = $profileNames[$Profile]
if ($Channel -eq "beta") { $profileName += " Beta" }

$instance = Get-Content -Raw -LiteralPath $instanceTemplate
$instance = $instance.Replace("__PACK_URL__", $PackUrl.AbsoluteUri)
$instance = $instance.Replace("__INSTANCE_NAME__", $profileName)
[System.IO.File]::WriteAllText($instanceFile, $instance, [System.Text.UTF8Encoding]::new($false))
Remove-Item -LiteralPath $instanceTemplate

if (Test-Path -LiteralPath $archive) {
    if (-not $Force) {
        throw "Archive already exists: $archive (use -Force to replace it)"
    }
    Assert-ChildPath $archive $dist
    Remove-Item -LiteralPath $archive -Force
}

Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $archive -CompressionLevel Optimal
Write-Host "Built $archive"
