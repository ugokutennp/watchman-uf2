# FWの書き込み

## 事前準備

 - githubよりFW_gen.batを作業用のディレクトリにダウンロードします。
 - SRecordをダウンロードし、Srecord/...のsrec_cat.exeをFW_gen.batと同じディレクトリに配置します。
 - nRF Connect for Desktopをダウンロード&インストールし、内部のProgrammerツールをインストールします。
 - 
## FWの生成
 - ダウンロードしたFW_gen.batを実行します。

## 書き込み(初回)
 1. ドングルをUSB経由でPCに接続します。
→正常に接続されると"OpenDFU Bootloader"がwindowsで認識されます。
→正常に認識されない場合、二回目以降の書き込みの場合は##書き込み(二回目以降)をご覧ください。
 2. nRF Connect for Desktop のProgrammerを起動し、"Open DFU Bootloader"を選択します。
 3. Openfileより生成されたファームウェア(アプリ、ソフトデバイス)を選択します。
 4. erace&writeボタンで書き込みを行います。
 →正常に書き込みが終わると"dongle"と認識されます。
 

# トラブルシューティング

# 仕様
