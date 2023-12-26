:: Sd_gen.bat
:: ver 1.0

@echo off
setlocal enabledelayedexpansion

:: SteamVR directory settings
set "steamvrDir=C:\Program Files (x86)\Steam\steamapps\common\SteamVR"

:: Delete old directories
if exist "softdevice" (
    rmdir /s /q "softdevice"
)
if exist "gd_1558748372_dfu" (
    rmdir /s /q "gd_1558748372_dfu"
)

:: Create new directories
echo Creating directories...
mkdir "softdevice"
mkdir "gd_1558748372_dfu"

:: File unpacking
echo Unpacking softdevice...
powershell -Command "Expand-Archive -Path '%steamvrDir%\drivers\indexhmd\resources\firmware\radio\gd_1558748372_dfu.zip' -DestinationPath 'gd_1558748372_dfu'"

:: Convert bin to uf2
set args=%*
powershell "iex((@('')*3+(cat '%~f0'|select -skip 40))-join[char]10)"


:: Exit
pause
exit /b




:: The following is powershell script
Set-Location $PSScriptRoot

$UF2_MAGIC_START0 = 0x0A324655  # "UF2\n"
$UF2_MAGIC_START1 = 0x9E5D5157  # Randomly selected
$UF2_MAGIC_END    = 0x0AB16F30  # Ditto
$appstartaddr     = 0x1000     # offset
$familyid         = 0xADA52840  # nrf52840
$inputFile        = "gd_1558748372_dfu\s140_nrf52_6.1.1_softdevice.bin"
$outputFile       = "softdevice\s140_nrf52_6.1.1_softdevice.uf2"

Write-Host "Converting bin to uf2..."

$file_content = Get-Content -LiteralPath $inputFile -Encoding Byte
$numblocks = ($file_content.Length + 0xFF) -shr 8
$outp = @()

foreach ($blockno in @(0..($numblocks - 1))) {
    $ptr = 0x100 * $blockno
    $chunk = $file_content[$ptr..($ptr + 0xFF)]
    $flags = 0
    if ($familyid) {
        $flags = $flags -bor 0x2000
    }
    $block = @(
        [System.BitConverter]::GetBytes([Int32]$UF2_MAGIC_START0),
        [System.BitConverter]::GetBytes([Int32]$UF2_MAGIC_START1),
        [System.BitConverter]::GetBytes([Int32]$flags),
        [System.BitConverter]::GetBytes([Int32]($ptr + $appstartaddr)),
        [System.BitConverter]::GetBytes([Int32]256),
        [System.BitConverter]::GetBytes([Int32]$blockno),
        [System.BitConverter]::GetBytes([Int32]$numblocks),
        [System.BitConverter]::GetBytes([Int32]$familyid),
        $chunk,
        (@([Byte]0x00) * (0x200 - (32 + $chunk.Length + 4))),
        [System.BitConverter]::GetBytes([Int32]$UF2_MAGIC_END)
    ) | ForEach-Object { $_ }
    $outp += $block
}

$outp | Set-Content -LiteralPath $outputFile -Encoding Byte

Write-Host "Softdevice generation completed"

