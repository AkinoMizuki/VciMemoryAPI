-- このファイルはVCIから取り出したコピーです。
-- 有効にするにはファイル名先頭の'_'を削除してください 
-- このファイルはVCIから取り出したコピーです。
-- 有効にするにはファイル名先頭の'_'を削除してください 
---<summary>
---Name : DebugDfoltCube
---Soft : DebugTest
---<summary>
local MemoryAPI = require("MemoryAPI")
----------------------------------------
--SUBアイテム宣言
----------------------------------------
local GetID_obj = vci.assets.GetTransform("GetID_obj")
local Read_obj = vci.assets.GetTransform("Read_obj")
local Write_obj = vci.assets.GetTransform("Write_obj")
----------------------------------------
--変数
----------------------------------------
--ステート一覧
local list

if vci.assets.IsMine then

    list = MemoryAPI.ini

end

----------------------------------------
--グリップ処理
----------------------------------------
---[SubItemの所有権&Use状態]アイテムをグラッブしてグリップボタンを押すと呼ばれる。
---@param use string @押されたアイテムのSubItem名
function onUse(use)
--グリップ処理

    if use == "GetID_obj" then
    --IDをリクエストします。

        MemoryAPI.Slave.GetID()

    elseif use == "Read_obj" then
    --Readします

        if not(nil == vci.state.Get("listIndex")) then
        --idリスト

            list = vci.state.Get("listIndex")

            --Readします
            MemoryAPI.Slave.Read(list ,"StateTest")

        end--END_idリスト

    elseif use == "Write_obj" then
    --Writeします

        if not(nil == vci.state.Get("listIndex")) then
        --idリスト

            list = vci.state.Get("listIndex")

            --Readします
            MemoryAPI.Slave.Write(list, "StateTest", "Test")

        end--END_idリスト
        
    end--END_グリップセレクター

end--END_グリップ処理
