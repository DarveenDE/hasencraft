[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildScript = Join-Path $PSScriptRoot "build-prism.ps1"
$testUrl = [uri]"https://example.invalid/hasencraft/pack.toml"
$testOutput = Join-Path $repoRoot "build\prism-profile-tests"

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-ZipText([System.IO.Compression.ZipArchive]$Archive, [string]$Name) {
    $entry = $Archive.Entries |
        Where-Object { $_.FullName.Replace('\', '/') -eq $Name } |
        Select-Object -First 1
    if ($null -eq $entry) {
        throw "Missing ZIP entry: $Name"
    }

    $reader = [System.IO.StreamReader]::new($entry.Open())
    try {
        return $reader.ReadToEnd()
    }
    finally {
        $reader.Dispose()
    }
}

$profiles = @{
    fluffy = @{
        Name = "Hasencraft Fluffy Beta"
        Instance = @("MinMemAlloc=4096", "MaxMemAlloc=10240")
        Options = @("renderDistance:14", "simulationDistance:8", 'resourcePacks:["vanilla","file/FreshAnimations_v1.10.4.zip"]')
        Dh = @("lodChunkRenderDistanceRadius = 256", 'renderingEngine = "AUTO"')
        Iris = @("enableShaders=true")
    }
    cozy = @{
        Name = "Hasencraft Cozy Beta"
        Instance = @("MinMemAlloc=3072", "MaxMemAlloc=8192")
        Options = @("renderDistance:10", "simulationDistance:6", 'resourcePacks:["vanilla","file/FreshAnimations_v1.10.4.zip"]')
        Dh = @("lodChunkRenderDistanceRadius = 128", 'renderingEngine = "AUTO"')
        Iris = @("enableShaders=true")
    }
    eco = @{
        Name = "Hasencraft Eco Beta"
        Instance = @("MinMemAlloc=3072", "MaxMemAlloc=6144")
        Options = @("graphicsMode:0", "maxFps:60", "mipmapLevels:2", "particles:2", "renderDistance:8", "simulationDistance:5", 'resourcePacks:["vanilla"]')
        Dh = @("lodChunkRenderDistanceRadius = 64", 'renderingEngine = "AUTO"')
        Iris = @("enableShaders=false")
    }
}

foreach ($profile in $profiles.Keys | Sort-Object) {
    & $buildScript -PackUrl $testUrl -Channel beta -Profile $profile -OutputDirectory $testOutput -Force
    if (-not $?) {
        throw "Prism build failed for profile: $profile"
    }

    $archivePath = Join-Path $testOutput "Hasencraft-beta-$profile.zip"
    if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
        throw "Missing Prism archive: $archivePath"
    }

    $archive = [System.IO.Compression.ZipFile]::OpenRead($archivePath)
    try {
        if ($null -ne $archive.GetEntry("instance.cfg.in")) {
            throw "Unrendered instance template found in $profile archive"
        }

        $contents = @{
            Instance = Get-ZipText $archive "instance.cfg"
            Options = Get-ZipText $archive "minecraft/options.txt"
            Dh = Get-ZipText $archive "minecraft/config/DistantHorizons.toml"
            Iris = Get-ZipText $archive "minecraft/config/iris.properties"
        }
        if ($contents.Instance -notmatch [regex]::Escape("name=$($profiles[$profile].Name)")) {
            throw "Unexpected instance name in $profile archive"
        }
        if ($contents.Instance -notmatch [regex]::Escape($testUrl.AbsoluteUri)) {
            throw "Pack URL was not rendered into $profile archive"
        }
        foreach ($group in @("Instance", "Options", "Dh", "Iris")) {
            foreach ($expected in $profiles[$profile][$group]) {
                if ($contents[$group] -notmatch [regex]::Escape($expected)) {
                    throw "Missing '$expected' in $profile archive $group"
                }
            }
        }
    }
    finally {
        $archive.Dispose()
    }
}

Write-Host "Validated Prism archives for $($profiles.Count) profiles."
