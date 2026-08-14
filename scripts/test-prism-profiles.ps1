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
        Instance = @("OverrideJavaArgs=true", "JvmArgs=-XX:+UseZGC -XX:+ZGenerational", "MinMemAlloc=4096", "MaxMemAlloc=10240")
        Options = @("renderDistance:14", "simulationDistance:8", 'resourcePacks:["vanilla","file/FreshAnimations_v1.10.4.zip"]')
        Dh = @("lodChunkRenderDistanceRadius = 256", 'renderingEngine = "AUTO"')
        Iris = @("enableShaders=true")
    }
    cozy = @{
        Name = "Hasencraft Cozy Beta"
        Instance = @("OverrideJavaArgs=true", "JvmArgs=-XX:+UseZGC -XX:+ZGenerational", "MinMemAlloc=3072", "MaxMemAlloc=8192")
        Options = @("renderDistance:10", "simulationDistance:6", 'resourcePacks:["vanilla","file/FreshAnimations_v1.10.4.zip"]')
        Dh = @("lodChunkRenderDistanceRadius = 128", 'renderingEngine = "AUTO"')
        Iris = @("enableShaders=true")
    }
    eco = @{
        Name = "Hasencraft Eco Beta"
        Instance = @("OverrideJavaArgs=true", "JvmArgs=-XX:+UseZGC -XX:+ZGenerational", "MinMemAlloc=3072", "MaxMemAlloc=6144")
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

$developmentPackwiz = Join-Path $env:SystemRoot "System32\cmd.exe"
$developmentUrl = [uri]"file:///C:/hasencraft-dev-test/pack.toml"
& $buildScript -PackUrl $developmentUrl -Channel dev -Profile cozy -DevelopmentPackwiz $developmentPackwiz -OutputDirectory $testOutput -Force
if (-not $?) {
    throw "Prism development archive build failed."
}

$developmentArchivePath = Join-Path $testOutput "Hasencraft-dev-cozy.zip"
if (-not (Test-Path -LiteralPath $developmentArchivePath -PathType Leaf)) {
    throw "Missing Prism development archive: $developmentArchivePath"
}

$developmentArchive = [System.IO.Compression.ZipFile]::OpenRead($developmentArchivePath)
try {
    $developmentInstance = Get-ZipText $developmentArchive "instance.cfg"
    $developmentLauncher = Get-ZipText $developmentArchive "minecraft/hasencraft-dev-bootstrap.ps1"
    if ($developmentInstance -notmatch [regex]::Escape("name=Hasencraft Cozy Dev")) {
        throw "Unexpected instance name in development archive"
    }
    if ($developmentInstance -notmatch [regex]::Escape('PreLaunchCommand=powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "${INST_MC_DIR}/hasencraft-dev-bootstrap.ps1" -JavaExecutable "${INST_JAVA}"')) {
        throw "Missing development pre-launch hook"
    }
    if ($developmentInstance -match [regex]::Escape('\hasencraft-dev-bootstrap.ps1')) {
        throw "Development pre-launch hook uses an INI-escaped Windows path separator"
    }
    if ($developmentLauncher -notmatch [regex]::Escape($developmentUrl.AbsoluteUri)) {
        throw "Local file URI was not rendered into development archive"
    }
    if ($developmentLauncher -notmatch [regex]::Escape('[string]$JavaExecutable') -or
        $developmentLauncher -notmatch [regex]::Escape('[System.IO.Path]::GetFileName($bootstrapJava) -ieq "javaw.exe"') -or
        $developmentLauncher -notmatch [regex]::Escape('& $bootstrapJava -jar $bootstrap $packTomlUri')) {
        throw "Development launcher does not wait for Prism's Java bootstrap process"
    }
    if ($developmentLauncher -match "__PACK_") {
        throw "Unrendered development launcher placeholder found"
    }
    if ($developmentLauncher -match "localhost|127\.0\.0\.1") {
        throw "Development launcher unexpectedly uses a local web server"
    }
}
finally {
    $developmentArchive.Dispose()
}

Write-Host "Validated Prism archives for $($profiles.Count) profiles and the local development hook."
