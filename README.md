# VciMemoryAPI
VCIアイテムvci.stateを使った拡張保存メモリのAPIです

# 使い方
「VCI Object」の「Scripts」の数字を増やして本「MemoryAPI.lua」を追加し出力してください。
また先頭の方でLuaモジュールで「MemoryAPI」を呼んだ後に「MemoryAPI.ini」で初期化してからお使いください

```lua
local MemoryAPI = require("MemoryAPI")
```

# API一覧
|API|機能|
|---|-----|
|MemoryAPI.ini|初期化します|
|MemoryAPI.Slave.GetID()|相手先のIDを照会します|
|MemoryAPI.Slave.Read(VciID ,name)|保存先にあるデータから復帰します|
|MemoryAPI.Slave.Write(VciID, name, data)|保存先にデータを保存します|

# MemoryAPI.ini
下記のコードで本APIを初期化できます。
値は、vci.stateの「listIndex」に前回使用時のVCIのIDが有れば取得します。
```lua
local MemoryAPI = require("MemoryAPI")
local list
if vci.assets.IsMine then
    --初期化します
    list = MemoryAPI.ini
end
```


# MemoryAPI.Slave.GetID()
相手先のIDを照会します
返り値は「vci.state」の「listIndex」に入ります
```lua
  --IDを照会します
  MemoryAPI.Slave.GetID()
```   

# MemoryAPI.Slave.Read(VciID ,name)
- VciID string @保存先のVCIのID 
- name string @ステートのラベル 

保存先に保存しておいた任意のステートデータを送信元のVCIに「vci.state」データを復帰します
```lua
local list
if not(nil == vci.state.Get("listIndex")) then
  --idリスト
  list = vci.state.Get("listIndex")
  --Readします
  MemoryAPI.Slave.Read(list ,"StateTest")
end--END_idリスト
```      


# MemoryAPI.Slave.Write(VciID, name, data)
- VciID string @保存先のVCIのID
- name string @ステートのラベル
- data string @文字列データ 

値を保存先します
```lua
local list
if not(nil == vci.state.Get("listIndex")) then
  --idリスト
  list = vci.state.Get("listIndex")
  --Writeします
  MemoryAPI.Slave.Write(list, "StateTest", "Test")
end--END_idリスト
```      
