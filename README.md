# FWの書き込み

## 事前準備

 - SteamVRがインストールされていない場合はインストールします。
 - githubよりFW_gen.batを作業用のディレクトリにダウンロードします。
 - [SRecord(.zip)](https://sourceforge.net/projects/srecord/files/srecord-win32/)をダウンロードし、bin/srec_cat.exeをFW_gen.batと同じディレクトリに配置します。
 - [nRF Connect for Desktop](https://www.nordicsemi.com/Products/Development-tools/nrf-connect-for-desktop)をダウンロード&インストールし、内部のProgrammerツールをインストールします。
 
## FWの生成
 - ダウンロードしたFW_gen.batを実行します。
 ※SteamVRを標準以外のディレクトリにインストールしている場合はbatファイル内部の"steamvrDir"を変更してください。

## 書き込み(初回)
 - ドングルをUSB経由でPCに接続します。
→正常に接続されると"OpenDFU Bootloader"がwindowsで認識されます。
→正常に認識されない場合、二回目以降の書き込みの場合は##書き込み(二回目以降)をご覧ください。
 - nRF Connect for Desktop のProgrammerを起動し、左上のプルダウンから"Open DFU Bootloader"を選択します。
 - Add fileよりfirmwareディレクトリ内のtemp_app_stamped_lyx.hex、s140_nrf52_6.1.1_softdevice.hexを選択します。
 - Erace & writeボタンで書き込みを行います。
 →正常に書き込みが終わると"Kawaii dongle"として認識されます。
 
 ## 書き込み(二回目以降)
 
 - ドングルの裏面にあるボタンを押しながらUSBを接続します。(以降は同じ)

 

# トラブルシューティング

# 仕様
