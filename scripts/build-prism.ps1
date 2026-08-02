[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [uri]$PackUrl,

    # `dev` only labels a local development archive; it is not a published channel.
    [ValidateSet("stable", "beta", "dev")]
    [string]$Channel = "stable",

    [ValidateSet("fluffy", "cozy", "eco")]
    [string]$Profile = "fluffy",

    [switch]$AllowHttp,

    [switch]$Force,

    # Intended for automated archive checks. Custom output stays inside build/.
    [string]$OutputDirectory,

    # Required only for `-Channel dev`; embedded exclusively in the ignored dev archive.
    [string]$DevelopmentPackwiz
)

$ErrorActionPreference = "Stop"

if ($Channel -eq "dev" -and $PackUrl.Scheme -ne "file") {
    throw "A dev archive requires a local file URI for pack.toml."
}
if ($Channel -ne "dev" -and $PackUrl.Scheme -ne "https" -and -not ($AllowHttp -and $PackUrl.Scheme -eq "http")) {
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

function ConvertTo-PowerShellLiteral([string]$Value) {
    return "'" + $Value.Replace("'", "''") + "'"
}

if (-not (Test-Path -LiteralPath $bootstrap)) {
    throw "Missing packwiz bootstrap: $bootstrap"
}

$bootstrapHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bootstrap).Hash.ToLowerInvariant()
if ($bootstrapHash -ne "a8fbb24dc604278e97f4688e82d3d91a318b98efc08d5dbfcbcbcab6443d116c") {
    throw "Unexpected packwiz bootstrap SHA-256: $bootstrapHash"
}

$developmentTemplate = $null
$developmentPackwizPath = $null
if ($Channel -eq "dev") {
    if ([string]::IsNullOrWhiteSpace($DevelopmentPackwiz)) {
        throw "DevelopmentPackwiz is required when building a dev archive."
    }
    $developmentPackwizPath = (Resolve-Path -LiteralPath $DevelopmentPackwiz -ErrorAction Stop).Path
    if (-not (Test-Path -LiteralPath $developmentPackwizPath -PathType Leaf)) {
        throw "DevelopmentPackwiz must point to a file: $developmentPackwizPath"
    }
    $developmentTemplate = Join-Path $templateRoot "dev\hasencraft-dev-bootstrap.ps1.in"
    if (-not (Test-Path -LiteralPath $developmentTemplate -PathType Leaf)) {
        throw "Missing development launcher template: $developmentTemplate"
    }
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

if ($Channel -eq "dev") {
    $developmentLauncher = Get-Content -Raw -Encoding utf8 -LiteralPath $developmentTemplate
    $developmentLauncher = $developmentLauncher.Replace("__PACK_ROOT__", (ConvertTo-PowerShellLiteral $repoRoot))
    $developmentLauncher = $developmentLauncher.Replace("__PACKWIZ_EXECUTABLE__", (ConvertTo-PowerShellLiteral $developmentPackwizPath))
    $developmentLauncher = $developmentLauncher.Replace("__PACK_TOML_URI__", (ConvertTo-PowerShellLiteral $PackUrl.AbsoluteUri))
    [System.IO.File]::WriteAllText(
        (Join-Path $stage "minecraft\hasencraft-dev-bootstrap.ps1"),
        $developmentLauncher,
        [System.Text.UTF8Encoding]::new($false)
    )
}

$instanceTemplate = Join-Path $stage "instance.cfg.in"
$instanceFile = Join-Path $stage "instance.cfg"
$profileNames = @{
    fluffy = "Hasencraft Fluffy"
    cozy   = "Hasencraft Cozy"
    eco    = "Hasencraft Eco"
}
$profileName = $profileNames[$Profile]
if ($Channel -eq "beta") { $profileName += " Beta" }
elseif ($Channel -eq "dev") { $profileName += " Dev" }

$preLaunchCommand = '"$INST_JAVA" -jar packwiz-installer-bootstrap.jar ' + $PackUrl.AbsoluteUri
if ($Channel -eq "dev") {
    $preLaunchCommand = 'powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$INST_MC_DIR\hasencraft-dev-bootstrap.ps1"'
}

$instance = Get-Content -Raw -LiteralPath $instanceTemplate
$instance = $instance.Replace("__PRE_LAUNCH_COMMAND__", $preLaunchCommand)
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
