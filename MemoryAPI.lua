-- Memory.lua 
-- MIT License / AkinoMizuki 2022
--メモリーカード記憶API
----------------------------------------
--定義
----------------------------------------
--メモリーカード記憶API
local MemoryAPI = {}

----------------------------------------
--initialize
----------------------------------------
---@param listIndex string[] @データラベル一覧
---@param listCount num @データ数
function MemoryAPI.ini()
--initialize

    local listIndex = "list"

    if nil == vci.state.Get("listIndex") then
        vci.state.Set("listIndex", listIndex)
    else
        listIndex = vci.state.Get("listIndex")
    end

    return {
        listIndex = listIndex
    }

end--END_initialize

----------------------------------------
--Export
----------------------------------------
function MemoryAPI.Export_All()
--Export
    return 0
end--END_Export

----------------------------------------
--Import
----------------------------------------
function MemoryAPI.Import_All()
--Import
    return 0
end--END_Import

----------------------------------------
--コンソール関数
----------------------------------------
MemoryAPI = {}
MemoryAPI.Debug = function()
    print("Memory API Deng")
end


MemoryAPI.tools = {}
function MemoryAPI.tools.info()
--インフォメーション

    local Info_Name = "AkinoMizuki"            --自分の名前を入れてね
    local Info_Soft = "MemoryAPI"  --ソフト名を入れてね
    local Info_ver = "ver:1.0"          --ソフトバージョンを入れてね
    local Info_Day = "2022/07/03"         --ソフト更新日入れてね
    local Info_SYSVer= "VirtualCast ver:" .. vci.me.GetSystemVersion() --VCのバージョンが自動で入るよ
    local Info_HMD = "HMD Name:"..vci.me.GetHeadMountedDisplayName()
    local My_Language = vci.me.GetLanguageCode()
    local Info_Language = "Language Code: ".. My_Language

    return{

        Info_Name = Info_Name,      --自分の名前を入れてね
        Info_Soft = Info_Soft,      --ソフト名を入れてね
        Info_ver = Info_ver,       --ソフトバージョンを入れてね
        Info_Day = Info_Day,       --ソフト更新日入れてね
        Info_SYSVer = Info_SYSVer,    --VCのバージョンが自動で入るよ
        Info_HMD = Info_HMD,
        My_Language = My_Language,
        Info_Language = Info_Language
        
    }

end--END_インフォメーション

----------------------------------------
--ユーザー取得
----------------------------------------
function MemoryAPI.tools.User()
--ユーザー取得

    --所有者
    local Owner = vci.studio.GetOwner()

    --所有者名
    local Owner_Name = ""
    if(Owner ~= nil) then
        Owner_Name = Owner.GetName()
    end

    return{
        VciID = vci.assets.GetInstanceId(),   --VCI_ID
        Owner_Name = Owner_Name
    }

end--END_ユーザー取得

----------------------------------------
--インフォメーション確認v2
----------------------------------------
function MemoryAPI.tools.RequestInfoMessage(sender, name, message)
    --Vキャスからコメント受信

     local info = MemoryAPI.tools.info()
     local SysMode = MemoryAPI.tools.User()

    if(vci.assets.IsMine) then
        --代表者が送信
        vci.message.Emit("OutoInfoMessage", info.Info_Soft .. "™" .. 
                                                                info.Info_Name .. "™" .. 
                                                                info.Info_ver .. "™" .. 
                                                                info.Info_Day .. "™" .. 
                                                                info.Info_SYSVer .. "™" .. 
                                                                info.Info_HMD .. "™" ..
                                                                info.Info_Language .. "™" .. 
                                                                SysMode.VciID .. "™" .. 
                                                                vci.assets.GetInstanceId()
        )

    end

end--END_Vキャスからコメント受信
vci.message.On("RequestInfoMessage", MemoryAPI.tools.RequestInfoMessage)

function MemoryAPI.tools.OutoInfoMessage(sender, name, message)
--Vキャスからコメント受信

    local RxMessage = MemoryAPI.tools.Explode("™", message)
    
    if RxMessage[9] == vci.assets.GetInstanceId() then
    
        --インフォメーション
        print("")
        print("=== Info Messages ===")
        print(RxMessage[1])
        print(RxMessage[2])
        print(RxMessage[3])
        print(RxMessage[4])
        print(RxMessage[4])
        print(RxMessage[5])
        print(RxMessage[6])
        print(RxMessage[7])
        print("Owner:" .. RxMessage[8])
        print("=== END Info Messages ===")
        print("")

    end

end--END_Vキャスからコメント受信
vci.message.On("OutoInfoMessage", MemoryAPI.tools.OutoInfoMessage)

----------------------------------------
--受信関数(らーめんs)
----------------------------------------
function MemoryAPI.tools.Explode(explodeCode, str)
--受信関数(らーめんs)

    local result = {}
    --区切りがない場合は、新たに配列を作成して返す
    if(string.find(str,explodeCode) == nil) then
        result[1] = str
        return result
    end

    local maxIndex = #str
    local index=1
    local resultID = 1

    while (index<=maxIndex) do
        local findIndex = string.find(str,explodeCode,index)
        if(findIndex~=nil) then
            result[resultID] = string.sub(str,index,findIndex-1)
            resultID = resultID + 1
            index = findIndex + 1
        else
            result[resultID] = string.sub(str,index)
            break
        end
    end

    return result
end--END_受信関数(らーめんs)

------------------------------------------
----          保存する側
------------------------------------------
--保存する側
MemoryAPI.Master = {}
----------------------------------------
--マスター側コマンド
----------------------------------------
function MemoryAPI.Master.RecCmd()
--リクエストコマンド
    return{
        GetMyID = "GetMyID",
        Read = "Read",
        Write = "Write",
        ReSync = "ReSync",
        List = "List"
    }

end--END_リクエストコマンド
    
---      [ 1  ,2 ,3   ,4   ,5      ]
---VCI_ID[Time,ID,Name,Mode,Message]
function MemoryAPI.Master.FD_Controller_Message(sender, name, message)
--Vキャスからコメント受信

    local MemCom = MemoryAPI.Master.RecCmd()
    local SysMode = MemoryAPI.tools.User()

    local RxMessage = MemoryAPI.tools.Explode("™", message)

    if RxMessage[4] == MemCom.GetMyID then   
    --IDを照会します

        if not(RxMessage[2] == SysMode.VciID) then
        --自身のVCIに照会しないようにする

            MemoryAPI.Master.MyID(RxMessage[2])

        end--END_自身のVCIに照会しないようにする

    end--END_IDを照会します

    if RxMessage[2] == vci.assets.GetInstanceId() then
    --VCI_ID称号

        if RxMessage[4] == MemCom.List then
        --保存名前一覧転送

        elseif RxMessage[4] == MemCom.ReSync then
        --Stateを再同期します。

        elseif RxMessage[4] == MemCom.Read then
        --ステートの読み出し
            MemoryAPI.Master.Read(RxMessage[5],RxMessage[6])
        elseif RxMessage[4] == MemCom.Write then
        --ステートの書き込み
            MemoryAPI.Master.Write(RxMessage[5], RxMessage[6])
        end

    end--END_VCI_ID称号

end--END_Vキャスからコメント受信
vci.message.On("FD_Controller", MemoryAPI.Master.FD_Controller_Message)

----------------------------------------
--ID照会
----------------------------------------
---@param VciID string @受信元のVciID
function MemoryAPI.Master.MyID(VciID)
--ID照会

    local Sysinfo = MemoryAPI.tools.User()
    local MemCom = MemoryAPI.Master.RecCmd()

    --時間取得
    local NewTimeUser = os.date("%Y,%m,%d,%H,%M,%S")
    local SysMode = {}
    SysMode[1] = NewTimeUser--送信時刻
    SysMode[2] = Sysinfo.VciID
    SysMode[3] = Sysinfo.Owner_Name
    SysMode[4] = MemCom.GetMyID     --モード(コマンド)
    SysMode[5] = VciID --Message
    print("MemoryAPI_Master <= MyID : ".. Sysinfo.VciID)
    vci.message.Emit("FD_Controller_Tx", SysMode[1] .. "™" .. SysMode[2] .. "™" .. SysMode[3] .. "™" .. SysMode[4] .. "™" .. SysMode[5])

end--END_ID照会

----------------------------------------
--ステートの読み出し
----------------------------------------
---@param VciID string @受信元のVciID
---@param data string @文字列データ
function MemoryAPI.Master.Read(VciID, data)
--Read

    local Sysinfo = MemoryAPI.tools.User()
    local MemCom = MemoryAPI.Master.RecCmd()
    local GetState = "";

    if vci.state.Get(data) == nil then
        GetState = "NotState"
    else
        GetState = vci.state.Get(data)
    end

    --時間取得
    local NewTimeUser = os.date("%Y,%m,%d,%H,%M,%S")
    local SysMode = {}
    SysMode[1] = NewTimeUser        --送信時刻
    SysMode[2] = VciID
    SysMode[3] = Sysinfo.Owner_Name
    SysMode[4] = MemCom.Read       --モード(コマンド)
    SysMode[5] = data               --state名
    SysMode[6] = GetState           --Message

    print("MemoryAPI_Master <= ".. GetState)
    vci.message.Emit("FD_Controller_Tx", SysMode[1] .. "™" .. SysMode[2] .. "™" .. SysMode[3] .. "™" .. SysMode[4] .. "™" .. SysMode[5] .. "™" .. SysMode[6])

end--Read

----------------------------------------
--ステートの書き込み
----------------------------------------
---@param name string @ステートのラベル
---@param data string @文字列データ
---@param Sysinfo string[] @infoデータ
function MemoryAPI.Master.Write(name, data)
--Write

    local Sysinfo = MemoryAPI.tools.User()
    local MemCom = MemoryAPI.Master.RecCmd()
    --stateにセット
    vci.state.Set(name, data)

    --時間取得
    local NewTimeUser = os.date("%Y,%m,%d,%H,%M,%S")
    local SysMode = {}
    SysMode[1] = NewTimeUser        --送信時刻
    SysMode[2] = Sysinfo.VciID
    SysMode[3] = Sysinfo.Owner_Name
    SysMode[4] = MemCom.Write       --モード(コマンド)
    SysMode[5] = "Write_OK"         --Message
    print("MemoryAPI_Master <= Write_OK")
    vci.message.Emit("FD_Controller_Tx", SysMode[1] .. "™" .. SysMode[2] .. "™" .. SysMode[3] .. "™" .. SysMode[4] .. "™" .. SysMode[5])

end--END_Write

----------------------------------------
--使用ツール
----------------------------------------
MemoryAPI.Slave = {}
----------------------------------------
--リクエストコマンド
----------------------------------------
function MemoryAPI.Slave.ReqCmd()
--リクエストコマンド
    return{
        GetMyID = "GetMyID",
        Read = "Read",
        Write = "Write",
        ReSync = "ReSync",
        List = "List"
    }

end--END_リクエストコマンド

----------------------------------------
--IDをリクエスト
----------------------------------------
function MemoryAPI.Slave.GetID()
--IDをリクエスト

    local Sysinfo = MemoryAPI.tools.User()
    local MemAPICmd = MemoryAPI.Slave.ReqCmd()

    --時間取得
    local NewTimeUser = os.date("%Y,%m,%d,%H,%M,%S")
    local SysMode = {}
    SysMode[1] = NewTimeUser--送信時刻
    SysMode[2] = Sysinfo.VciID
    SysMode[3] = Sysinfo.Owner_Name
    SysMode[4] = MemAPICmd.GetMyID
    SysMode[5] = Sysinfo.VciID

    print("MemoryAPI_Slave => IDを照会します")
    vci.message.Emit("FD_Controller", SysMode[1] .. "™" .. SysMode[2] .. "™" .. SysMode[3] .. "™" .. SysMode[4] .. "™" .. SysMode[5])

end--END_IDをリクエスト

----------------------------------------
--ステートを読みだします
----------------------------------------
---@param VciID string @保存先のVCIのID 
---@param name string @ステートのラベル 
function MemoryAPI.Slave.Read(VciID ,name)
--ステートを読みだします

    local Sysinfo = MemoryAPI.tools.User()
    local MemAPICmd = MemoryAPI.Slave.ReqCmd()

    --時間取得
    local NewTimeUser = os.date("%Y,%m,%d,%H,%M,%S")
    local SysMode = {}
    SysMode[1] = NewTimeUser--送信時刻
    SysMode[2] = VciID
    SysMode[3] = Sysinfo.Owner_Name
    SysMode[4] = MemAPICmd.Read
    SysMode[5] = Sysinfo.VciID
    SysMode[6] = name

    print("MemoryAPI_Slave => ステートを読みだします")
    vci.message.Emit("FD_Controller", SysMode[1] .. "™" .. SysMode[2] .. "™" .. SysMode[3] .. "™" .. SysMode[4] .. "™" .. SysMode[5] .. "™" .. SysMode[6])

end--END_ステートを読みだします

----------------------------------------
--ステートを読みだします
----------------------------------------
---@param VciID string @保存先のVCIのID 
---@param name string @ステートのラベル
---@param data string @文字列データ 
function MemoryAPI.Slave.Write(VciID, name, data)
--ステートを読みだします

    local Sysinfo = MemoryAPI.tools.User()
    local MemAPICmd = MemoryAPI.Slave.ReqCmd()

    --時間取得
    local NewTimeUser = os.date("%Y,%m,%d,%H,%M,%S")
    local SysMode = {}
    SysMode[1] = NewTimeUser--送信時刻
    SysMode[2] = VciID
    SysMode[3] = Sysinfo.Owner_Name
    SysMode[4] = MemAPICmd.Write
    SysMode[5] = name
    SysMode[6] = data

    print("MemoryAPI_Slave => ステートを書き込みます")
    vci.message.Emit("FD_Controller", SysMode[1] .. "™" .. SysMode[2] .. "™" .. SysMode[3] .. "™" .. SysMode[4] .. "™" .. SysMode[5] .. "™" .. SysMode[6])

end--END_ステートを読みだします

----------------------------------------
--受け取り
----------------------------------------
---      [ 1  ,2 ,3   ,4   ,5      ]
---VCI_ID[Time,ID,Name,Mode,Message]
function MemoryAPI.Slave.FD_Controller_TxMessage(sender, name, message)
--Vキャスからコメント受信

    local Sysinfo = MemoryAPI.tools.User()
    local MemAPICmd = MemoryAPI.Slave.ReqCmd()

    local RxMessage = MemoryAPI.tools.Explode("™", message)

    if RxMessage[4] == MemAPICmd.GetMyID then  
    --IDを照会します

        if not(RxMessage[2] == vci.assets.GetInstanceId()) then 

            print("MemoryAPI_Slave <= YouID:" .. RxMessage[2])
            vci.state.Set("listIndex", RxMessage[2])

        end

    end

    if RxMessage[2] == vci.assets.GetInstanceId() then
    --VCI_ID称号


        if RxMessage[4] == MemAPICmd.List then
        --保存名前一覧転送

        elseif RxMessage[4] == MemAPICmd.ReSync then
        --Stateを再同期します。

        elseif RxMessage[4] == MemAPICmd.Read then
        --ステートの読み出し
            print("MemoryAPI_Slave <= Read:" .. RxMessage[5] .. " : ".. RxMessage[6])
            vci.state.Set(RxMessage[5], RxMessage[6])
        elseif RxMessage[4] == MemAPICmd.Write then
        --ステートの書き込み
            print("MemoryAPI_Slave <= Write:" .. RxMessage[5])
        end
    end

end--END_Vキャスからコメント受信
vci.message.On("FD_Controller_Tx", MemoryAPI.Slave.FD_Controller_TxMessage)

return MemoryAPI --END_メモリーカード記憶API