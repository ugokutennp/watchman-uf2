## 注意
このbatファイルはValve Indexのファームウェアを使用しています。   
使用は自己責任でお願いします。

# FWの書き込み

## 必要な物

- SteamVRがインストールされたWindowsPC
- USB2.0ケーブル
- ドングル
 
## FWの生成

 - FW_gen.batをダウンロードして実行します。  
   ※起動モードはDYXを選択します。   
   ※Powershellを実行できる環境で使用してください。  
   ※SteamVRを標準以外のディレクトリにインストールしている場合はbatファイル内部の"steamvrDir"を変更してください。

## 書き込み(初回)

 1. ドングルをUSB経由でPCに接続します。  
    ※正常に接続されると"FLOW_UF2"ドライブがＷindowsで認識されます。  
    ※正常に認識されない場合、もしくは二回目以降の書き込みの場合は"書き込み(二回目以降)"をご覧ください。

 3.  生成した"temp_app_stamped_dyx.uf2"を"FLOW_UF2"ドライブにDnDまたはコピーします。  
     ※書き込みは一つずつ行ってください。  
     ※書き込みが終了するとドライブは表示されなくなります。

 4. ドングルを再接続します。  
     ※正常に書き込みが行われると"Watchman Radio"として認識されます。

 ## 書き込み(二回目以降)
 
 - ドングルを接続した状態でドングル本体にあるリセットボタンをダブルクリックします。(以降は同じ)

# Feature

 - A bat file that modifies the Index HMD firmware and creates Watchman Dongle firmware for nrf52840.
 - Generate uf2 and bin files.
 - Index HMD's four boot modes can be changed without hardware modification.
