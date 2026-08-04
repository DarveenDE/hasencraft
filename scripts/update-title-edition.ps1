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
    # Minecraft positions edition.png across the lower edge of the main logo
    # and scales this 512x64 texture down. Keep the upper half transparent so
    # the label cannot cover the Hasencraft wordmark at smaller window sizes.
    $labelFont = [System.Drawing.Font]::new("Bahnschrift SemiBold", 14, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $labelText = "$Version | GEM$([char]0x00DC)TLICH BAUEN | WEIT ENTDECKEN"
    $labelY = 34
    $gold = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#FFD166"))
    $shadow = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml("#071E1C"))

    try {
        $size = $graphics.MeasureString($labelText, $labelFont)
        $x = [math]::Round((512 - $size.Width) / 2)
        $graphics.DrawString($labelText, $labelFont, $shadow, $x + 1, $labelY + 1)
        $graphics.DrawString($labelText, $labelFont, $gold, $x, $labelY)
    }
    finally {
        $gold.Dispose()
        $shadow.Dispose()
        $labelFont.Dispose()
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
