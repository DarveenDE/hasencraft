[CmdletBinding()]
param(
    [string]$TitleEditionFile
)

$ErrorActionPreference = "Stop"

if (-not $TitleEditionFile) {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    $TitleEditionFile = Join-Path $repoRoot "kubejs\assets\minecraft\textures\gui\title\edition.png"
}

if (-not (Test-Path -LiteralPath $TitleEditionFile -PathType Leaf)) {
    throw "Missing Hasencraft title edition texture"
}

Add-Type -AssemblyName System.Drawing
$titleEdition = [System.Drawing.Bitmap]::new($TitleEditionFile)
try {
    if ($titleEdition.Width -ne 512 -or $titleEdition.Height -ne 64) {
        throw "Hasencraft title edition texture must be 512x64 pixels"
    }

    $visibleMinY = $titleEdition.Height
    $visibleMaxY = -1
    for ($y = 0; $y -lt $titleEdition.Height; $y++) {
        for ($x = 0; $x -lt $titleEdition.Width; $x++) {
            if ($titleEdition.GetPixel($x, $y).A -gt 0) {
                $visibleMinY = [Math]::Min($visibleMinY, $y)
                $visibleMaxY = [Math]::Max($visibleMaxY, $y)
            }
        }
    }

    if ($visibleMaxY -lt 0) {
        throw "Hasencraft title edition texture contains no visible label"
    }
    if ($visibleMinY -lt 32) {
        throw "Hasencraft title edition label overlaps the reserved transparent logo area"
    }
    if ($visibleMaxY -ge 63) {
        throw "Hasencraft title edition label is clipped at the bottom edge"
    }

    Write-Host "Validated Hasencraft title edition texture ($visibleMinY..$visibleMaxY)."
}
finally {
    $titleEdition.Dispose()
}
