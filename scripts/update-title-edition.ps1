[CmdletBinding()]
param(
    [string]$Version,
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$packFile = Join-Path $repoRoot "pack.toml"
$editionFile = Join-Path $repoRoot "kubejs\assets\minecraft\textures\gui\title\edition.png"
if ($OutputPath) {
    $editionFile = [System.IO.Path]::GetFullPath($OutputPath)
}
$pack = Get-Content -Raw -Encoding utf8 -LiteralPath $packFile

if ($pack -notmatch '(?m)^version = "([^"]+)"$') {
    throw "Could not read the Hasencraft version from pack.toml"
}
$declaredVersion = $Matches[1]

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = $declaredVersion
}
elseif ($Version -ne $declaredVersion) {
    throw "Version '$Version' does not match pack.toml ('$declaredVersion')"
}

if ($Version -notmatch '^[0-9A-Za-z][0-9A-Za-z._-]*$') {
    throw "Unsafe release version: $Version"
}

$bitmap = [System.Drawing.Bitmap]::new(512, 64, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::Transparent)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

try {
    $brandFont = [System.Drawing.Font]::new("Bahnschrift SemiBold", 20, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $taglineFont = [System.Drawing.Font]::new("Bahnschrift SemiBold", 14, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $brandText = "HASENCRAFT | $Version"
    $taglineText = "GEM$([char]0x00DC)TLICH BAUEN | WEIT ENTDECKEN"
    $gold = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#FFD166"))
    $shadow = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#071E1C"))

    try {
        foreach ($line in @(
            @{ Text = $brandText; Font = $brandFont; Y = 1 },
            @{ Text = $taglineText; Font = $taglineFont; Y = 34 }
        )) {
            $size = $graphics.MeasureString($line.Text, $line.Font)
            $x = [math]::Round((512 - $size.Width) / 2)
            $graphics.DrawString($line.Text, $line.Font, $shadow, $x + 1, $line.Y + 1)
            $graphics.DrawString($line.Text, $line.Font, $gold, $x, $line.Y)
        }
    }
    finally {
        $gold.Dispose()
        $shadow.Dispose()
        $brandFont.Dispose()
        $taglineFont.Dispose()
    }

    $parent = Split-Path -Parent $editionFile
    if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    $bitmap.Save($editionFile, [System.Drawing.Imaging.ImageFormat]::Png)
}
finally {
    $graphics.Dispose()
    $bitmap.Dispose()
}

Write-Host "Updated title-screen edition label for Hasencraft $Version"
