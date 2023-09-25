chcp 65001
@echo off
setlocal enabledelayedexpansion

:: ディレクトリの変数定義
set "steamvrDir=C:\Program Files (x86)\Steam\steamapps\common\SteamVR"
set "firmwareDir=%steamvrDir%\drivers\indexhmd\resources\firmware\radio\gd_1558748372_dfu"

::ディレクトリを削除
if exist "firmware" (
    rmdir /s /q "firmware"
)

if exist "%firmwareDir%" (
    rmdir /s /q "%firmwareDir%"
)

:: ディレクトリ作成
mkdir "firmware"
mkdir "%firmwareDir%"

:: ファイルの解凍
powershell -Command "Expand-Archive -Path '%firmwareDir%.zip' -DestinationPath '%firmwareDir%'"

:: アドレスの書き換え
powershell -Command "$filePath = '%firmwareDir%\temp_app_stamped.bin'; $newValue = 0xB9; $offset = 0x1839D; $bytes = [System.IO.File]::ReadAllBytes($filePath); $bytes[$offset] = $newValue; [IO.File]::WriteAllBytes($filePath, $bytes)"

:: ファイル名変更
rename "%firmwareDir%\temp_app_stamped.bin" "temp_app_stamped_lyx.bin"

:: ファイルの変換(アプリ)
srec_cat.exe "%firmwareDir%\temp_app_stamped_lyx.bin" -Binary -offset 0x26000 -o "firmware\temp_app_stamped_lyx.hex" -Intel

:: ファイルの変換(ソフトデバイス)
srec_cat.exe "%firmwareDir%\s140_nrf52_6.1.1_softdevice.bin" -Binary -offset 0x1000 -o "firmware\s140_nrf52_6.1.1_softdevice.hex" -Intel

echo ファームウェアを生成しました。

pause