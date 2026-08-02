[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$packToml = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot "pack.toml")
$packVersion = if ($packToml -match '(?m)^version = "([^"]+)"$') { $Matches[1] } else { "unbekannt" }
$metadataRoots = @("mods", "resourcepacks", "shaderpacks")
$metadata = foreach ($relativeRoot in $metadataRoots) {
    $root = Join-Path $repoRoot $relativeRoot
    if (Test-Path -LiteralPath $root -PathType Container) {
        Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.pw.toml"
    }
}
$metadata = @($metadata | Sort-Object FullName)

$rows = foreach ($file in $metadata) {
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    $name = if ($content -match '(?m)^name = "([^"]+)"') { $Matches[1] } else { $file.BaseName }
    $filename = if ($content -match '(?m)^filename = "([^"]+)"') { $Matches[1] } else { "" }
    $side = if ($content -match '(?m)^side = "([^"]+)"') { $Matches[1] } else { "both" }

    if ($content -match '(?m)^mod-id = "([^"]+)"') {
        $source = "[Modrinth](https://modrinth.com/project/$($Matches[1]))"
    }
    elseif ($content -match '(?m)^project-id = ([0-9]+)') {
        $source = "CurseForge #$($Matches[1])"
    }
    else {
        $source = "Direktdownload"
    }

    $relative = $file.FullName.Substring($repoRoot.Length + 1).Replace("\", "/")
    $kind = $relative.Split("/")[0]
    [pscustomobject]@{ Name = $name; Side = $side; File = $filename; Source = $source; Kind = $kind }
}

$clientCount = @($rows | Where-Object Side -eq "client").Count
$serverCount = @($rows | Where-Object Side -eq "server").Count
$bothCount = @($rows | Where-Object Side -eq "both").Count

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Modliste")
$lines.Add("")
$lines.Add("Automatisch aus den Packwiz-Metadaten erzeugt. Stand: Hasencraft ``$packVersion``.")
$lines.Add("")
$lines.Add("- Gesamt: $($rows.Count) verwaltete Eintraege")
$lines.Add("- beide Seiten: $bothCount")
$lines.Add("- nur Client: $clientCount")
$lines.Add("- nur Server: $serverCount")
$lines.Add("")
$lines.Add("## Kuratierter Kern")
$lines.Add("")
$lines.Add("- Tiere: Naturalist, Critters and Companions, Doggy Talents Next, Adorable Hamster Pets, Snuffles, Ribbits, Friends & Foes, Productive Bees, Ecologics, Aquaculture 2, Redomesticate und sechs Animal-Garden-Module.")
$lines.Add("- Tech: Create mit ausgewaehlten Integrationen, Immersive Engineering, Applied Energistics 2, Applied Mekanistics und Mekanism.")
$lines.Add("- Magie: Ars Nouveau und Ars Creo.")
$lines.Add("- Erkundung: Tectonic, Regions Unexplored, Dungeons and Taverns, zehn YUNG-Erweiterungen, Aether, Twilight Forest und Bumblezone.")
$lines.Add("- Atmosphaere: Distant Horizons, Iris, Complementary Reimagined, Fresh Animations, AmbientSounds und Falling Leaves.")
$lines.Add("")
$lines.Add("## Vollstaendige Eintraege")
$lines.Add("")
$lines.Add("| Name | Seite | Datei | Quelle |")
$lines.Add("|---|---|---|---|")

foreach ($row in ($rows | Sort-Object Kind, Name)) {
    $safeName = $row.Name.Replace("|", "\|")
    $safeFile = $row.File.Replace("|", "\|")
    $lines.Add(('| {0} | `{1}` | `{2}` | {3} |' -f $safeName, $row.Side, $safeFile, $row.Source))
}

$output = Join-Path $repoRoot "docs\MODLIST.md"
[System.IO.File]::WriteAllLines($output, $lines, [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote $output ($($rows.Count) entries)"
