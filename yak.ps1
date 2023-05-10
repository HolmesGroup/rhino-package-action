param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,
    [string]$OutputDir = ".\"
)

$manifest = Get-Content -Path $Path\manifest.yml

# this assumes the YAML is formatted as expected
$name = $manifest | Select-String -Pattern "^name: *(.*)$" | ForEach-Object { $_.Matches.Groups[1].Value }
$version = $manifest | Select-String -Pattern "^version: *(.*)$" | ForEach-Object { $_.Matches.Groups[1].Value }

# TODO: make distrubution platform configurable
$packageName = $name + "-" + $version + "-rh7-win.yak"

$packagePath = Join-Path -Path $OutputDir -ChildPath $packageName

Write-Host "Creating package $packagePath"

# Yak files are just a zip file with a different extension
# https://developer.rhino3d.com/guides/yak/the-anatomy-of-a-package/#package-structure

Compress-Archive -Path $Path\* -DestinationPath $packagePath -Force

