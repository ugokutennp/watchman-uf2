:: Fw_gen.bat
:: ver 3.0

@echo off
setlocal enabledelayedexpansion

:: SteamVR directory settings
set "steamvrDir=C:\Program Files (x86)\Steam\steamapps\common\SteamVR"

:: Delete old directories
if exist "firmware" (
    rmdir /s /q "firmware"
)
if exist "gd_1558748372_dfu" (
    rmdir /s /q "gd_1558748372_dfu"
)

:: Create new directories
echo Creating directories...
mkdir "firmware"
mkdir "gd_1558748372_dfu"

:: File unpacking
echo Unpacking firmware...
powershell -Command "Expand-Archive -Path '%steamvrDir%\drivers\indexhmd\resources\firmware\radio\gd_1558748372_dfu.zip' -DestinationPath 'gd_1558748372_dfu'"

:: File copying
copy gd_1558748372_dfu\temp_app_stamped.bin gd_1558748372_dfu\temp_app_stamped_fix.bin > nul

:: Binary rewriting (USB device name to "Watchaman Radio")
powershell -Command "$filePath = 'gd_1558748372_dfu\temp_app_stamped_fix.bin'; $newValues = 0x57,0x61,0x74,0x63,0x68,0x6D,0x61,0x6E,0x20,0x52,0x61,0x64,0x69,0x6F; $offset = 0x162E0; $bytes = [System.IO.File]::ReadAllBytes($filePath); for ($i = 0; $i -lt $newValues.Length; $i++) { $bytes[$offset + $i] = $newValues[$i] }; [IO.File]::WriteAllBytes($filePath, $bytes)"

:: Boot mode select
set /p mode="Please select boot mode (LYM, RYB, LYX, DYX): "

:: Binary rewriting (change boot mode)
if /i "%mode%"=="LYM" (
    echo Selected mode is LYM
    set mode_small=lym

) else if /i "%mode%"=="RYB" (
    echo Selected mode is RYB
    set mode_small=ryb
    powershell -Command "$filePath = 'gd_1558748372_dfu\temp_app_stamped_fix.bin'; $newValue = 0xB9; $offset = 0x18385; $bytes = [System.IO.File]::ReadAllBytes($filePath); $bytes[$offset] = $newValue; [IO.File]::WriteAllBytes($filePath, $bytes)"

) else if /i "%mode%"=="LYX" (
    echo Selected mode is LYX
    set mode_small=lyx
    powershell -Command "$filePath = 'gd_1558748372_dfu\temp_app_stamped_fix.bin'; $newValue = 0xB9; $offset = 0x1839D; $bytes = [System.IO.File]::ReadAllBytes($filePath); $bytes[$offset] = $newValue; [IO.File]::WriteAllBytes($filePath, $bytes)"

) else if /i "%mode%"=="DYX" (
    echo Selected mode is DYX
    set mode_small=dyx
    powershell -Command "$filePath = 'gd_1558748372_dfu\temp_app_stamped_fix.bin'; $newValue = 0xB9; $offset = 0x18391; $bytes = [System.IO.File]::ReadAllBytes($filePath); $bytes[$offset] = $newValue; [IO.File]::WriteAllBytes($filePath, $bytes)"

) else (
    echo Correct mode was not selected
    pause
    exit /b

)

:: Convert bin to uf2
set args=%*
powershell "iex((@('')*3+(cat '%~f0'|select -skip 80))-join[char]10)"

:: Rename file
rename "gd_1558748372_dfu\temp_app_stamped_fix.bin" "temp_app_stamped_%mode_small%.bin"
rename "firmware\temp_app_stamped_fix.uf2" "temp_app_stamped_%mode_small%.uf2"
echo Output file : firmware\temp_app_stamped_%mode_small%.uf2

:: Exit
pause
exit /b





:: The following is powershell script
Set-Location $PSScriptRoot

$UF2_MAGIC_START0 = 0x0A324655  # "UF2\n"
$UF2_MAGIC_START1 = 0x9E5D5157  # Randomly selected
$UF2_MAGIC_END    = 0x0AB16F30  # Ditto
$appstartaddr     = 0x26000     # offset
$familyid         = 0xADA52840  # nrf52840
$inputFile        = "gd_1558748372_dfu\temp_app_stamped_fix.bin"
$outputFile       = "firmware\temp_app_stamped_fix.uf2"

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

Write-Host "Firmware generation completed"

