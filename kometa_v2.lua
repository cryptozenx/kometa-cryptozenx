-- // Loading Screen UI \\ --
function LoadUI()
    local Loading = Instance.new("ScreenGui")
    Loading.IgnoreGuiInset = false
    Loading.ResetOnSpawn = true
    Loading.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Loading.Name = "Loading"
    Loading.Parent = game.CoreGui

    local Main = Instance.new("Frame")
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
    Main.BackgroundTransparency = 0
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Visible = true
    Main.Name = "Main"
    Main.Parent = Loading

    local Kometa = Instance.new("ImageLabel")
    Kometa.Image = "http://www.roblox.com/asset/?id=12070230398"
    Kometa.ImageTransparency = 0
    Kometa.AnchorPoint = Vector2.new(0.5, 0.5)
    Kometa.BackgroundColor3 = Color3.new(1, 1, 1)
    Kometa.BackgroundTransparency = 1
    Kometa.BorderSizePixel = 0
    Kometa.Position = UDim2.new(0.5, 0, 0.5, 0)
    Kometa.Size = UDim2.new(1, 0, 1, 0)
    Kometa.Visible = true
    Kometa.Name = "Kometa"
    Kometa.Parent = Main

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 100)
    UICorner.Parent = Main

    Main:TweenSize(UDim2.new(0, 100, 0, 100), "InOut", "Sine", 1, true)

    task.wait(1)
    
    repeat
        task.wait()
    until game:GetService("CoreGui"):FindFirstChild('FinityUI')

    game:GetService("TweenService"):Create(Kometa, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    }):Play()

    task.wait(0.5)

    game:GetService("TweenService"):Create(UICorner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        CornerRadius = UDim.new(0, 0)
    }):Play()

    Main:TweenSize(UDim2.new(0, 900, 0, 350), "InOut", "Sine", 2, true)

    task.wait(2)

    game:GetService("CoreGui"):FindFirstChild('FinityUI').Container.Position = UDim2.new(0.5, 0, 0.5, 0)

    Loading:Destroy()
end

task.spawn(function()
    LoadUI()
end)

-- // Services \\ --
local API = loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/rewrite/API.lua"))() -- API Service
local LibraryUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/cryptozenx/kometa-cryptozenx/main/ui/finity.lua"))()

local PathfindingService = game:GetService("PathfindingService")
local QuestModule = require(game:GetService("ReplicatedStorage").Quests)
local StatsModule = require(game:GetService("ReplicatedStorage").StatModifiers)
local BuffsModule = require(game:GetService("ReplicatedStorage").Buffs)
local StatTools = require(game:GetService("ReplicatedStorage").StatTools)

-- // Instances \\ --
local SecuredFolder = Instance.new("Folder")
SecuredFolder.Name = API:GenerateRandomString(32)
SecuredFolder.Parent = game:GetService("Workspace")

local SlingshotEnd = Instance.new("Part")
SlingshotEnd.Parent = SecuredFolder
SlingshotEnd.Position = Vector3.new(164, 68, -92)
SlingshotEnd.Anchored = true
SlingshotEnd.CanCollide = false
SlingshotEnd.Transparency = 1
SlingshotEnd.Name = API:GenerateRandomString(32)

local BluePortalEnd = Instance.new("Part")
BluePortalEnd.Parent = SecuredFolder
BluePortalEnd.Position = Vector3.new(-277, 17, 379)
BluePortalEnd.Anchored = true
BluePortalEnd.CanCollide = false
BluePortalEnd.Transparency = 1
BluePortalEnd.Name = API:GenerateRandomString(32)

local RedPortalEnd = Instance.new("Part")
RedPortalEnd.Parent = SecuredFolder
RedPortalEnd.Position = Vector3.new(312, 134, 18)
RedPortalEnd.Anchored = true
RedPortalEnd.CanCollide = false
RedPortalEnd.Transparency = 1
RedPortalEnd.Name = API:GenerateRandomString(32)

local SnailBridge = Instance.new("Part")
SnailBridge.Parent = SecuredFolder
SnailBridge.Position = Vector3.new(365.812, 89.625, -115.801)
SnailBridge.Anchored = true
SnailBridge.CanCollide = true
SnailBridge.Size = Vector3.new(8.518, -50.56, -5.265)
SnailBridge.Transparency = 1
SnailBridge.Name = API:GenerateRandomString(32)

-- // Constants \\ --
local Player = API:Player()
local Character = API:Character()
local Root = API:Root()
local Humanoid = API:Humanoid()

local Flowers = game:GetService('Workspace'):WaitForChild('Flowers')
local FieldSelected = game:GetService('Workspace'):WaitForChild('FlowerZones'):WaitForChild('Ant Field')
local MonsterSpawners = game:GetService("Workspace"):WaitForChild('MonsterSpawners')
local Identity = syn and syn.set_thread_identity or setthreadcontext or setidentity
local GetAsset = getsynasset or getcustomasset

local PollenTask

local PollenBar = Player.PlayerGui.ScreenGui.MeterHUD.PollenMeter.Bar.FillBar
local RareName

local PopFolder = Instance.new("Folder", game:GetService("Workspace").Particles)
PopFolder.Name = "PopStars"

if not isfolder("kometa") then makefolder("kometa") end
if isfile('kometa.txt') == false then 
    (syn and syn.request or http_request)(
        { 
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"},
            Body = game:GetService("HttpService"):JSONEncode(
                {
                    cmd = "INVITE_BROWSER",
                    args = {code = "2a5gVpcpzv"},
                    nonce = game:GetService("HttpService"):GenerateGUID(false)
                }
            ),
            writefile('kometa.txt', "discord")
        }
    )
end

-- // Variables \\ --
local TreasuresTable = {}
local FlowersTable = {}
local FieldsTable = {}
local MaskTable = {}
local CollectorsTable = {}
local BeesTable = {}
local ToysTable = {}
local SpawnersTable = {}
local AccesoriesTable = {}
local PlayerPlanters = {}
local MonstersTable = {}
local NectarsTable = getupvalues(require(game:GetService("ReplicatedStorage").NectarTypes).GetTypes)[1]
local NectarsList = {}
local SavedTexts = {}
local DeletedObjects = {}
local FieldBoosters = { 'Field Booster', 'Red Field Booster', 'Blue Field Booster' }
local QuestsList = {
    ['Collect Pollen'] = {},
    ['Collect Goo'] = {},
    ['Defeat Monsters'] = {},
    ['Feed Bees'] = {}
}
local TaskModules = {}

for _, value in next, game:GetService("Workspace").Collectibles:GetChildren() do
    table.insert(TreasuresTable, value)
end

for _, value in next, game:GetService("Workspace").FlowerZones:GetChildren() do
    table.insert(FieldsTable, value.Name)
end

table.sort(FieldsTable)

table.remove(NectarsTable['Invigorating']['Fields'], table.find(NectarsTable['Invigorating']['Fields'], 'Ant Field')) -- онетт момент

for index, _ in next, getupvalues(require(game:GetService("ReplicatedStorage").NectarTypes).GetTypes)[1] do
    table.insert(NectarsList, index)
end

for _, value in ipairs(game:GetService("ReplicatedStorage").Quests.TaskTypes:GetChildren()) do
    if not TaskModules[value.Name] then
        TaskModules[value.Name] = function(Action, Task, Data)
            return 0
        end
    end
end

table.sort(NectarsList)

local TwoMobs = {
    ["Ladybug Bush"] = "Rhino Bush",
    ["Rhino Bush"] = "Ladybug Bush",
    ["Rhino Cave 2"] = "Rhino Cave 3",
    ["Rhino Cave 3"] = "Rhino Cave 2",
    ["Ladybug Bush 2"] = "Ladybug Bush 3",
    ["Ladybug Bush 3"] = "Ladybug Bush 2",
    ["RoseBush"] = "RoseBush2",
    ["RoseBush2"] = "RoseBush",
    ["PineappleMantis1"] = "PineappleBeetle",
    ["PineappleBeetle"] = "PineappleMantis1",
    ["ForestMantis1"] = "ForestMantis2",
    ["ForestMantis2"] = "ForestMantis1",
}

local Mutations = {
    ['AttackMul'] = "Attack %",
    ['AttackAdd'] = "Attack",
    ['Energy'] = 'Energy',
    ['ConvRateMul'] = 'Convert Amount %',
    ['ConvRateAdd'] = 'Convert Amount',
    ['AbilityRate'] = 'Ability Rate',
    ['GatherMul'] = 'Gather Amount %',
    ['GatherAdd'] = 'Gather Amount'
}

local Temptable = {
    Version = 'v2.6.0',
    CurrentTime = os.time() - 300,
    ConvetingTime = os.time(),
    ConfigName = '',
    GlobalConfigName = '',
    GlobalConfigId = '',
    GlobalConfigDescription = '',
    LastFieldColor = 'White',
    OldTool = '',
    Magnitude = 70,
    BlackField = "Ant Field",
    Dead = false,
    BugReport = '',
    WebSocket = nil,
    Path = nil,
    Waypoints = nil,
    Running = false,
    RedFields = {},
    BlueFields = {},
    WhiteFields = {},
    TokenPath = game:GetService("Workspace").Collectibles,
    Item_Names = {},
    ReadyForCrab = false,
    Converting = false,
    FoundPopStar = false,
    Crosshairs = {},
    WaitTimes = {
        ['Red Cannon Toy'] = 1.9,
        ['Yellow Cannon Toy'] = 1.4,
        ['Blue Cannon Toy'] = 1.5,
        ['Slingshot Toy'] = 1.25,
        ['Red Portal Toy'] = 0.75,
        ['Blue Portal Toy'] = 0.75
    },
    PathfindingAttempts = 0,
    DontFarm = false,
    Stats = {
        ElapsedTime = 0,
        HoneyCurrent = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer().Totals.Honey,
        HoneyStart = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer().Totals.Honey,
        CollectedTickets = 0,
        KilledMobs = 0,
        FarmedSprouts = 0,
        KilledVicious = 0,
        KilledWindy = 0,
        KilledMondo = 0,
    },
    Started = {
        KillMobs = false,
        Ant = false,
        Windy = false,
        Vicious = false,
        Commando = false
    },
    Sprouts = {
        Detected = false,
        Instances = {},
    },
    Collecting = {
        Tickets = false,
        Rares = false,
        Disk = false,
        Crosshair = false,
        Sparkles = false,
        Fireflies = false,
        Planter = false,
        Snowflake = false,
    },
    Detected = {
        Windy = false,
        Vicious = false,
    },
    Windy = nil,
    Vicious = nil,
    ['Feed'] = function(X, Y, Type, Amount)
        if not Amount then
            Amount = 1
        end
        game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(tonumber(X), tonumber(Y), Type, tonumber(Amount))
    end,
    ItemCooldowns = {
        ['Red Extract'] = 10,
        ['Blue Extract'] = 10,
        ['Glitter'] = 16,
        ['Glue'] = 10,
        ['Oil'] = 10,
        ['Enzymes'] = 10,
        ['Tropical Drink'] = 10,
        ['Purple Potion'] = 15,
        ['Super Smoothie'] = 20
    },
    FoodNames = {
        'Blueberry',
        'Strawberry',
        'Pineapple',
        'SunflowerSeed',
        'Treat'
    },
}

local Logs = {}

local Kometa = {
    Webhook = '',
    Webhooking = {
        Convert = false,
        Vicious = false,
        Windy = false,
        PlayerAdded = false,
        ConnectionLost = false,
        BalloonStats = false,
    },
    BlacklistedFields = {},
    BestFields = {
        Red = "Pepper Patch",
        White = "Coconut Field",
        Blue = "Stump Field"
    },
    Vars = {
        Field = 'Ant Field',
        ConvertAt = 100,
        ConvertAfter = 0,
        StandCrosshairAt = 100,
        WalkSpeed = 70,
        JumpPower = 70,
        DonatIt = { "Treat", 1 },
        MonsterTimer = 300,
        NpcPrefer = {},
        DispensersMode = 'Virtual Button Press',
        MobsWhitelist = {},
        AutofarmingEngine = 'k-02',
        AutokickDelay = 60,
        AutokickMode = 'Kick',
    },
    Toggles = {
        ConvertPollen = false,
        Autofarm = false,
        AutoDig = false,
        AutoSprinkler = false,
        AutoMask = false,
        FarmDuped = false,
        FarmBubbles = false,
        BloatFarm = false,
        FarmFlame = false,
        FarmDisks = false,
        CollectCrossHairs = false,
        SmartCrosshairs = false,
        FarmFuzzy = false,
        FarmBalloons = false,
        FarmClouds = false,
        FarmSnowflakes = false,
        FarmSparkles = false,
        FarmFireflies = false,
        AutoDispenser = false,
        AutoBoosters = false,
        FarmSprouts = false,
        FarmPuffshrooms = false,
        FarmTickets = false,
        FarmRares = false,
        AutoQuest = false,
        AutoDoQuests = false,
        FaceBalloons = false,
        FaceFlames = false,
        FaceCenter = false,
        KillMondo = false,
        KillVicious = false,
        KillWindy = false,
        AutoKillMobs = false,
        AvoidMobs = false,
        AutoAnt = false,
        LoopSpeed = false,
        LoopJump = false,
        TrainCrab = false,
        TrainSnail = false,
        GodMode = false,
        DisableRender = false,
        AutoDonate = false,
        DontSpawnDrop = false,
        AutoMicroConverter = false,
        AutoTicketConverter = false,
        VisualNight = false,
        FPS30Unfocus = false,
        DisableActionLogs = false,
        ToggleConvertAfter = false,
        RotateFields = false,
        KillMobsQuest = false,
        Autokick = false,
        DoAntQuests = false
    },
    Rares = {},
    BlacklistTokens = {},
    Priority = {},
    NormalDispenserSettings = {
        ['Free Royal Jelly Dispenser'] = false,
        ['Blueberry Dispenser'] = false,
        ['Strawberry Dispenser'] = false,
        ['Treat Dispenser'] = false,
        ['Coconut Dispenser'] = false,
        ['Glue Dispenser'] = false,
        ['Field Booster'] = false,
        ['Red Field Booster'] = false,
        ['Blue Field Booster'] = false,
    },
    ToysSettings = {
        ['Honeystorm'] = false,
        ['Sprout Summoner'] = false,
        ['Wealth Clock'] = false,
        ['Free Ant Pass Dispenser'] = false,
        ['Free Robo Pass Dispenser'] = false,
    },
    BeesmasDispenserSettings = {
        ['Samovar'] = false,
        ['Stockings'] = false,
        ["Onett's Lid Art"] = false,
        ['Honeyday Candles'] = false,
        ['Beesmas Feast'] = false,
        ['Snow Machine'] = false,
    },
    ItemUsingSettings = {
        ['Red Extract'] = false,
        ['Blue Extract'] = false,
        ['Glitter'] = false,
        ['Glue'] = false,
        ['Oil'] = false,
        ['Enzymes'] = false,
        ['Tropical Drink'] = false,
        ['Purple Potion'] = false,
        ['Super Smoothie'] = false
    },
    PlanterSettings = {
        {
            Type = require(game:GetService("ReplicatedStorage").PlanterTypes).INVENTORY_ORDER[1],
            Growth = 1,
            Field = FieldsTable[1],
            Nectar = 'Comforting',
            PlantMode = 'Field',
            Enabled = false,
            
        },
        {
            Type = require(game:GetService("ReplicatedStorage").PlanterTypes).INVENTORY_ORDER[1],
            Growth = 1,
            Field = FieldsTable[2],
            Nectar = 'Comforting',
            PlantMode = 'Field',
            Enabled = false,
        },
        {
            Type = require(game:GetService("ReplicatedStorage").PlanterTypes).INVENTORY_ORDER[1],
            Growth = 1,
            Field = FieldsTable[3],
            Nectar = 'Comforting',
            PlantMode = 'Field',
            Enabled = false,
        }
    },
    BeesSettings = {
        General = {
            X = 1,
            Y = 1,
            Amount = 1,
        },
        FoodType = 'Treat',
        UntilSelectedBee = {},
        UsbToggle = false,
        FoodUntilGifted = false,
        AutoFeed = false,
        Mutation = '',
        UntilMutation = false,
    },
}

local KometaWebhook = {
    Webhook = '',
}

local DefaultKometa = Kometa
local DefaultKometaWebhook = KometaWebhook

-- // Functions \\ --
local function TableFilter(Table, Function, WithKeys)
    local Result = {}
    for Key, Value in next, Table do
        if Function(Value, Key, Table) then
            if WithKeys then
                Result[Key] = Value
            else
                table.insert(Result, Value)
            end
        end
    end

    return Result
end

function GetPlayerData()
    return game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer()
end

function MaskEquip(Mask)
    game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {
        ["Mute"] = false, 
        ["Type"] = Mask, 
        ["Category"] = "Accessory"
    }) 
end

local function WebsocketConnect()
    if syn then
        pcall(function()
            Temptable.WebSocket = syn.websocket.connect("ws://api.kometa.pw:8888/") -- ws://api.kometa.pw:8888/
        end)
    elseif Krnl then
        pcall(function()
            Temptable.WebSocket = Krnl.WebSocket.connect("ws://api.kometa.pw:8888/")
        end)
    elseif identifyexecutor() and identifyexecutor() == 'ScriptWare' then
        pcall(function()
            Temptable.WebSocket = WebSocket.connect("ws://api.kometa.pw:8888/")
        end)
    end
    if Temptable.WebSocket then
        if syn or Krnl or (identifyexecutor() and identifyexecutor() == 'ScriptWare') then
            Temptable.WebSocket.OnMessage:Connect(function(msg)
                local Data = game:GetService("HttpService"):JSONDecode(msg)
                if Data.hwid == game:GetService("RbxAnalyticsService"):GetClientId() then
                    if Data.statusCode ~= "RATE_LIMITED" then
                        if Data.action == 'ConfigSave' then
                            if Data.statusCode == 'CONFIG_ALREADY_EXIST' or Data.statusCode == 'DESCRIPTION_TOO_SHORT' or Data.statusCode == 'DESCRIPTION_TOO_LONG' or Data.statusCode == 'EXCEEDING_SIZE_LIMITS' or Data.statusCode == 'INVALID_KOMETA_VERSION' or Data.statusCode == 'BANNED_WORDS_IN_DESCRIPTION' or Data.statusCode == "UNKNOWN_SAVE_CONFIG_ERROR" then
                                API:Notify("kometa", Data.message)
                            elseif Data.statusCode == "TRYING_TO_SAVE" then
                                API:Notify("kometa", Data.message, 5)
                            elseif Data.statusCode == "CONFIG_SAVED" then
                                API:Notify("kometa", Data.message, 5)
                                setclipboard(Data.configId)
                            end
                        elseif Data.action == 'ConfigLoad' then
                            if Data.statusCode == 'CONFIG_NOT_FOUND' or Data.statusCode == 'CANNOT_FIND_WITHOUT_ID' or Data.statusCode == "INVALID_CONFIG_ID" then
                                API:Notify('kometa', Data.message)
                            elseif Data.statusCode == "REQUESTING_FROM_API" then
                                API:Notify("kometa", Data.message, 5)
                            elseif Data.statusCode == "CONFIG_LOADED" then
                                API:Notify("kometa", Data.message, 5)
                                Kometa = game:GetService('HttpService'):JSONDecode(Data.config);
                            else
                                API:Notify('kometa', Data.message)
                            end
                        end
                    else
                        API:Notify('kometa', Data.message)
                    end
                end
                if Data.action == 'Notification' and Data.message then
                    task.spawn(function() 
                        if string.find(Data.message, '.mov') or string.find(Data.message, '.mp4') or string.find(Data.message, '.webm') then
                            local VideoData = (syn and syn.request or http_request)({
                                Url = Data.message,
                                Method = 'GET'
                            })
        
                            writefile('video.webm',  VideoData.Body)
        
                            local Video = Instance.new('VideoFrame')
                            local GUI = Instance.new('ScreenGui')
                            GUI.Parent = game:GetService('CoreGui')
                            GUI.Name = API:GenerateRandomString(10)
                            GUI.IgnoreGuiInset = true
                            Video.Parent = GUI
                            Video.Size = UDim2.new(0.25, 0, 0.35, 0)
                            Video.AnchorPoint = Vector2.new(0.5, 0.5)
                            Video.Position = UDim2.new(0.5, 0, 0.25, 0)
                            Video.Video = GetAsset('video.webm')
                            Video.Looped = false
                            Video.BackgroundTransparency = 1
                            Video.BorderSizePixel = 0
        
                            Video:Play()
        
                            Video.Ended:Connect(function()
                                Video:Destroy()
                                GUI:Destroy()
                                delfile('video.webm')
                            end)
                            task.wait(120)
                            if GUI then
                                GUI:Destroy()
                                Video:Destroy()
                                delfile('video.webm')
                            end
                        else
                            local oldColor = Player.PlayerGui.ScreenGui.ServerMessage.BackgroundColor3
                            Player.PlayerGui.ScreenGui.ServerMessage.BackgroundColor3 = Color3.fromRGB(164, 84, 255)
                            Player.PlayerGui.ScreenGui.ServerMessage.Visible = true 
                            Player.PlayerGui.ScreenGui.ServerMessage.TextBox.Text = Data.message
                            task.wait(120)
                            Player.PlayerGui.ScreenGui.ServerMessage.Visible = false
                            Player.PlayerGui.ScreenGui.ServerMessage.BackgroundColor3 = oldColor
                        end
                    end)
                elseif Data.action == 'KickAll' then
                    Player:Kick(Data.message)
                elseif Data.action == 'Kick' and Data.message then
                    if Data.nickname == Player.Name then
                        Player:Kick(Data.message)
                    end
                elseif Data.action == 'Blacklist' then
                    if Data.nickname == Player.Name then
                        Player:Kick(Data.message or 'This player file has been reset for exploiting.')
                    end
                elseif Data.action == 'DirectNotification' and Data.message then
                    if Data.nickname == Player.Name then
                        task.spawn(function() 
                            if string.find(Data.message, '.mov') or string.find(Data.message, '.mp4') or string.find(Data.message, '.webm') then
                                local VideoData = (syn and syn.request or http_request)({
                                    Url = Data.message,
                                    Method = 'GET'
                                })
            
                                writefile('video.webm',  VideoData.Body)
            
                                local Video = Instance.new('VideoFrame')
                                local GUI = Instance.new('ScreenGui')
                                GUI.Parent = game:GetService('CoreGui')
                                GUI.Name = API:GenerateRandomString(10)
                                GUI.IgnoreGuiInset = true
                                Video.Parent = GUI
                                Video.Size = UDim2.new(0.25, 0, 0.35, 0)
                                Video.AnchorPoint = Vector2.new(0.5, 0.5)
                                Video.Position = UDim2.new(0.5, 0, 0.25, 0)
                                Video.Video = GetAsset('video.webm')
                                Video.Looped = false
                                Video.BackgroundTransparency = 1
                                Video.BorderSizePixel = 0
            
                                Video:Play()
            
                                Video.Ended:Connect(function()
                                    Video:Destroy()
                                    GUI:Destroy()
                                    delfile('video.webm')
                                end)
                                task.wait(120)
                                if GUI then
                                    GUI:Destroy()
                                    Video:Destroy()
                                    delfile('video.webm')
                                end
                            else
                                local oldColor = Player.PlayerGui.ScreenGui.ServerMessage.BackgroundColor3
                                Player.PlayerGui.ScreenGui.ServerMessage.BackgroundColor3 = Color3.fromRGB(164, 84, 255)
                                Player.PlayerGui.ScreenGui.ServerMessage.Visible = true 
                                Player.PlayerGui.ScreenGui.ServerMessage.TextBox.Text = Data.message
                                task.wait(120)
                                Player.PlayerGui.ScreenGui.ServerMessage.Visible = false
                                Player.PlayerGui.ScreenGui.ServerMessage.BackgroundColor3 = oldColor
                            end
                        end)
                    end
                end
            end)
        end
        Temptable.WebSocket:Send(game:GetService('HttpService'):JSONEncode({ action = 'Connect', nickname = Player.Name, hwid = game:GetService("RbxAnalyticsService"):GetClientId() }))
    end
end

WebsocketConnect()

local function TweenStart(Goal, ShouldFloat)
    pcall(function()
        if ShouldFloat == nil then
            ShouldFloat = true
        end
        if ShouldFloat then
            Temptable.Float = true
        end
        local TimeToTween = API:Magnitude(Root.Position, Goal.Position) / Humanoid.WalkSpeed
        API:Tween(TimeToTween, Goal)
        if ShouldFloat then
            Temptable.Float = false
        end
    end)
end

local function ForceWalk(Goal)
    Player.DevComputerMovementMode = Enum.DevComputerMovementMode.Scriptable
    API:WalkTo(Goal)
    Humanoid.MoveToFinished:Wait()
    Player.DevComputerMovementMode = Enum.DevComputerMovementMode.UserChoice
end

local function UseToy()
    task.wait(0.5)
    VirtualPressButton('E')
    task.wait(0.5)
end

local function CreateLink(Start, End, Name, BiDirectional)
    -- if SecuredFolder:FindFirstChild(Name) then SecuredFolder[Name]:Destroy() end
    local AttachmentStart = Instance.new("Attachment", Start)
    local AttachmentEnd = Instance.new("Attachment", End)

    local Link = Instance.new("PathfindingLink", SecuredFolder)
    Link.Attachment0 = AttachmentStart
    Link.Attachment1 = AttachmentEnd
    Link.IsBidirectional = BiDirectional or false
    Link.Label = Name
    Link.Name = API:GenerateRandomString(32)
end

CreateLink(game:GetService("Workspace").Toys["Red Cannon"].Platform, game:GetService("Workspace").FlowerZones["Mountain Top Field"], "Red Cannon Toy", false)
CreateLink(game:GetService("Workspace").Toys['Slingshot'].Platform, SlingshotEnd, "Slingshot Toy", false)
CreateLink(game:GetService("Workspace").Toys["Yellow Cannon"].Platform, game:GetService("Workspace").SpawnLocation, "Yellow Cannon Toy", false)
CreateLink(game:GetService("Workspace").Toys["Blue Cannon"].Platform, game:GetService("Workspace").FlowerZones["Clover Field"], "Blue Cannon Toy", false)
-- CreateLink(game:GetService("Workspace").SpawnLocation, game:GetService("Workspace").FlowerZones["Cactus Field"], "FromMountain", false)
-- CreateLink(game:GetService("Workspace").Toys["Honey Leaderboard"].Platform, game:GetService("Workspace").FlowerZones["Cactus Field"], "FromMountain", false)
CreateLink(game:GetService("Workspace").Toys["Red Cannon"].Platform, game:GetService("Workspace").FlowerZones["Cactus Field"], "FromMountain", false)
CreateLink(game:GetService("Workspace").Toys["Red Cannon"].Platform, game:GetService("Workspace").FlowerZones["Pineapple Patch"], "FromMountain", false)
CreateLink(game:GetService("Workspace").Toys["Red Portal"].Platform, RedPortalEnd, "Red Portal Toy", false)
CreateLink(game:GetService("Workspace").Toys["Blue Portal"].Platform, BluePortalEnd, "Blue Portal Toy", false)
CreateLink(game:GetService("Workspace").FlowerZones["Clover Field"], game:GetService("Workspace").Toys['Slingshot'].Platform, 'CloverLeave', false)
CreateLink(game:GetService("Workspace").FlowerZones["Clover Field"], game:GetService("Workspace").FlowerZones["Blue Flower Field"], 'CloverLeave', false)
CreateLink(game:GetService("Workspace").FlowerZones["Stump Field"], game:GetService("Workspace").FlowerZones['Pineapple Patch'], 'Stump Field', true)
CreateLink(game:GetService("Workspace").Toys["Red Cannon"].Platform, game:GetService("Workspace").FlowerZones['Pepper Patch'], "Pepper Patch", false)
CreateLink(game:GetService("Workspace").Toys["Red Cannon"].Platform, game:GetService("Workspace").FlowerZones['Coconut Field'], "Coconut Field", false)
CreateLink(game:GetService("Workspace").Toys["Ant Challenge"].Platform.Circle, game:GetService("Workspace").FlowerZones['Ant Field'], "Ant Field", false)
CreateLink(game:GetService("Workspace").FlowerZones['Ant Field'], game:GetService("Workspace").Toys["Ant Challenge"].Platform.Circle, "Ant2 Field", false)

local function Tween(Goal, ShouldFloat)
    if Kometa.Vars.Mobility == 'Tween' then
        TweenStart(Goal, ShouldFloat)
    else
        local Success, Error = pcall(function()
            Temptable.Path = PathfindingService:CreatePath({
                AgentCanJump = true,
                WaypointSpacing = Humanoid.WalkSpeed * 0.8,
                AgentCanClimb = true,
                Costs = {
                    ['Red Cannon Toy'] = 0.5,
                    ['Yellow Cannon Toy'] = 0.5,
                    ['Slingshot Toy'] = 0.5,
                    ['Blue Cannon Toy'] = 0.5,
                    ['FromMountain'] = 1,
                    ['CloverLeave'] = 2,
                    ['Red Portal Toy'] = 0.1,
                    ['Blue Portal Toy'] = 0.1,
                    ['Stump Field'] = 1,
                    ['Coconut Field'] = 1,
                    ['Pepper Patch'] = 1,
                    ['Ant Field'] = 1,
                    ['Ant2 Field'] = 1,
                }
            })
            Temptable.Path:ComputeAsync(Root.Position, Goal.Position)
        end)
        if (Success and Temptable.Path) and Temptable.Path.Status == Enum.PathStatus.Success then
            Temptable.Waypoints = Temptable.Path:GetWaypoints()
            Temptable.PathfindingAttempts += 1
            Player.DevComputerMovementMode = Enum.DevComputerMovementMode.Scriptable
            for Index, Waypoint in ipairs(Temptable.Waypoints) do
                if Temptable.Dead then break end
                if string.find(Waypoint.Label, 'Toy') then
                    UseToy()
                    task.wait(Temptable.WaitTimes[Waypoint.Label])
                    Temptable.PathfindingAttempts = 0
                    Tween(Goal, ShouldFloat)
                    return
                elseif string.find(Waypoint.Label, 'FromMountain') then
                    -- ForceWalk(Vector3.new(-213, 4, 315))
                    -- ForceWalk(Vector3.new(-215, 17, 353))
                    -- ForceWalk(Vector3.new(-240, 17, 343))
                    UseToy()
                    task.wait(Temptable.WaitTimes['Red Cannon Toy'])
                    Temptable.PathfindingAttempts = 0
                    Tween(Goal, ShouldFloat)
                    return
                elseif string.find(Waypoint.Label, 'Ant Field') then
                    Temptable.Float = true
                    ForceWalk(game:GetService("Workspace").FlowerZones['Ant Field'].Position)
                    Temptable.Float = false
                elseif string.find(Waypoint.Label, 'Ant2 Field') then
                    Temptable.Float = true
                    ForceWalk(game:GetService("Workspace").Toys["Ant Challenge"].Platform.Circle.Position)
                    Temptable.Float = false
                elseif string.find(Waypoint.Label, 'Pepper Patch') then
                    ForceWalk(Vector3.new(-301, 17, 350))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-323, 34, 355))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-339, 46, 352))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-405, 50, 419))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-427, 60, 422))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-375, 71, 465))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-359, 81.90735626220703, 461))
                    task.wait(0.5)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-383, 97, 513))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-437, 111, 519))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(game:GetService("Workspace").FlowerZones['Pepper Patch'].Position)
                    Temptable.PathfindingAttempts = 0
                    Tween(Goal, ShouldFloat)
                    return
                elseif string.find(Waypoint.Label, 'Coconut Field') then
                    ForceWalk(Vector3.new(-301, 17, 350))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-323, 34, 355))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-339, 46, 352))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-405, 50, 419))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-427, 60, 422))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-375, 71, 465))
                    task.wait(0.25)
                    VirtualPressButton("Space")
                    ForceWalk(Vector3.new(-365, 81, 466))
                else
                    if Temptable.Waypoints == nil then break end
                    if Temptable.Waypoints[Index-1] and (Waypoint.Position.Y - Temptable.Waypoints[Index-1].Position.Y < -50) then
                        Humanoid.Jump = true
                        task.wait(0.5)
                        Humanoid.Jump = true
                    elseif Waypoint.Action == Enum.PathWaypointAction.Jump then
                        Humanoid.Jump = true
                    end
                    repeat
                        task.wait()
                        API:WalkTo(Waypoint.Position)
                    until Humanoid.MoveToFinished
                    local TimeOut = Humanoid.MoveToFinished:Wait(0.1)
                    if not TimeOut then
                        if Temptable.PathfindingAttempts < 5 then
                            Tween(Goal, ShouldFloat)
                            return
                        else
                            TweenStart(Goal, ShouldFloat)
                            Player.DevComputerMovementMode = Enum.DevComputerMovementMode.UserChoice
                            Temptable.PathfindingAttempts = 0
                            return
                        end
                    end
                end
            end
            Player.DevComputerMovementMode = Enum.DevComputerMovementMode.UserChoice
            Temptable.PathfindingAttempts = 0
            Temptable.Path = nil
            Temptable.Waypoints = nil
        else
            TweenStart(Goal, ShouldFloat)
        end
    end
end

function ToggleAntiMobs(State)
    local Camera = game:GetService('Workspace').CurrentCamera
    local CameraPos = Camera.CFrame
    local Character = Player.Character or game:GetService('Workspace'):FindFirstChild(Player.Name)
    local Humanoid = Player.Character.Humanoid
    local Copy = Humanoid:Clone()
    if State then
        Player.Character = nil
        Copy:SetStateEnabled(15, false)
        Copy:SetStateEnabled(0, false)
        Copy:SetStateEnabled(1, false)
        Copy.Parent = Character
        Humanoid:Destroy()
        Player.Character = Character
        local Tool = Character:FindFirstChildOfClass("Tool")
        if Tool then
            Tool.Parent = Player.Backpack
            Tool.Parent = Character
        end
        Camera.CameraSubject = Copy
        Camera.CFrame = CameraPos
        Copy.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Character:FindFirstChild("Animate").Disabled = true
        Character:FindFirstChild("Animate").Disabled = false
    else
        Humanoid:SetStateEnabled(15, true)
        Copy:SetStateEnabled(0, true)
        Copy:SetStateEnabled(1, true)
        Player.Character = nil
        Humanoid:ChangeState(15)
        Player.Character = Character
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
    end
end

function CheckBoost(Name)
    if BuffsModule.Get(Name) == nil then return nil end
    return StatsModule.Find(BuffsModule.Get(Name).Mods[2] or BuffsModule.Get(Name).Mods[1], GetPlayerData()) or false
end

function CheckBoostStacks(Name)
    if BuffsModule.Get(Name) == nil then return nil end
    local Boost = StatsModule.Find(BuffsModule.Get(Name).Mods[2] or BuffsModule.Get(Name).Mods[1], GetPlayerData())
    if Boost then
        return Boost.Combo or 1
    else
        return 0
    end
end

function UseItems()
    for Item, Enabled in next, Kometa.ItemUsingSettings do
        if not Enabled then continue end
        local ItemCooldown = GetPlayerData().PlayerActiveTimes[Item] or math.huge
        if (os.time() - ItemCooldown) / 60 > Temptable.ItemCooldowns[Item] and (GetPlayerData().Eggs[Item:gsub(' ', '')] or 0) > 0 then
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = Item})
        end
    end
end

function CheckPriority()
    if Temptable.Detected.Vicious and Temptable.Detected.Windy then
        return true
    end
    return false
end

function CheckCombatSettings()
    if (Temptable.Detected.Vicious and Kometa.Toggles.KillVicious) or (Temptable.Detected.Windy and Kometa.Toggles.KillWindy) or (Kometa.Toggles.KillMondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)")) or Kometa.Toggles.TrainCrab or Kometa.Toggles.TrainSnail or Temptable.Started.Ant or Temptable.Started.KillMobs or (Kometa.Toggles.KillCommando and Temptable.Started.Commando) then
        return true
    end
    return false
end

function CheckForSprout()
    if (Temptable.Sprouts.Detected and #Temptable.Sprouts.Instances > 0) and Kometa.Toggles.FarmSprouts and Temptable.Sprouts.Instances[1] ~= nil and Temptable.Sprouts.Instances[1].Coords and Temptable.Sprouts.Instances[1].Sprout then
        return true
    end
    return false
end

function CheckForPuffshrooms()
    if Kometa.Toggles.FarmPuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then
        return true
    end
    return false
end

function CheckToyCooldown(Toy)
    return (os.time() - (GetPlayerData().ToyTimes[Toy] or math.huge) ) > game:GetService("Workspace").Toys[Toy].Cooldown.Value or false
end

function CheckWindShrineCooldown()
    return (os.time() - StatTools:GetLastCooldownTime("WindShrine")) > 0
end

function VirtualPressButton(Button)
    game:GetService('VirtualInputManager'):SendKeyEvent(true, Button, false, nil)
    task.wait()
    game:GetService('VirtualInputManager'):SendKeyEvent(false, Button, false, nil)
end

function FindTimerLabel(Zone)
    for _, Object in next, Zone:GetDescendants() do
        if Object.Name == "TimerLabel" then
            return Object
        end
    end
    return nil
end

function UpdateTimer(UI, Timer)
    Timer = FindTimerLabel(Timer)
    if Timer.Visible then
        if not SavedTexts[UI] then
            SavedTexts[UI] = UI.Text
        end
        UI.Text = Timer.Text .. ' ❌'
    else
        if SavedTexts[UI] then
            UI.Text = SavedTexts[UI]
            SavedTexts[UI] = nil
        end
    end
end

for _, value in next, MonsterSpawners:GetDescendants() do
    if value.Name == "RoseBush" then
        value.Name = "ScorpionBush"
    elseif value.Name == "RoseBush2" then
        value.Name = "ScorpionBush2"
    elseif value.Name == "TimerAttachment" then
        value.Name = "Attachment"
    end
end

for _, value in next, game:GetService("Workspace").FlowerZones:GetChildren() do
    if value:FindFirstChild("ColorGroup") then
        if value:FindFirstChild("ColorGroup").Value == "Red" then
            table.insert(Temptable.RedFields, value.Name)
        elseif value:FindFirstChild("ColorGroup").Value == "Blue" then
            table.insert(Temptable.BlueFields, value.Name)
        end
    else
        table.insert(Temptable.WhiteFields, value.Name)
    end
end

for _, value in next, game:GetService("Workspace").Flowers:GetChildren() do
    table.insert(FlowersTable, value.Position)
end

for _, value in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do
    if string.match(value.Name, "Mask") then
        table.insert(MaskTable, value.Name)
    end
end

for _, value in next, getupvalues(require(game:GetService("ReplicatedStorage").Collectors).Exists) do
    for NewIndex, _ in next, value do
        table.insert(CollectorsTable, NewIndex)
    end
end

for _, value in next, game:GetService("ReplicatedStorage").BeeModels:GetChildren() do
    table.insert(BeesTable, value.Name)
end

for _, value in next, game:GetService("Workspace").Toys:GetChildren() do
    table.insert(ToysTable, value.Name)
end

for _, value in next, MonsterSpawners:GetChildren() do
    table.insert(SpawnersTable, value.Name)
end

for _, value in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do
    if value.Name ~= "UpdateMeter" then
        table.insert(AccesoriesTable, value.Name)
    end
end

for index, _ in next, GetPlayerData().Eggs do
    table.insert(Temptable.Item_Names, index)
end

for _, value in next, getupvalues(require(game:GetService("ReplicatedStorage").PlanterTypes).GetTypes) do
    for Index, Planter in next, value do 
        PlayerPlanters[Index] = Planter
    end 
end

for index, _ in next, PlayerPlanters do 
    PlayerPlanters[index] = {} 
end

for _, value in next, MonsterSpawners:GetChildren() do
    table.insert(MonstersTable, value.Name)
end

table.sort(MaskTable)
table.sort(CollectorsTable)
table.sort(BeesTable)
table.sort(ToysTable)
table.sort(SpawnersTable)
table.sort(AccesoriesTable)
table.sort(PlayerPlanters)
table.sort(MonstersTable)
table.sort(Temptable.Item_Names)

local VirtualUser = game:GetService('VirtualUser')
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function GenerateWebhookText()
    local Text = ''
    Text = Text .. "Total Honey: `"..Player.PlayerGui.ScreenGui.MeterHUD.HoneyMeter.Bar.TextLabel.Text.."`\n"
    Text = Text .. "Gained Honey: `"..API:SuffixString(Temptable.Stats.HoneyCurrent - Temptable.Stats.HoneyStart).."`\n"
    Text = Text .. "Elapsed Time: `"..API:ToHMS(Temptable.Stats.ElapsedTime).."`\n"
    Text = Text .. "Honey Per Hour: `"..API:SuffixString(math.floor((Temptable.Stats.HoneyCurrent - Temptable.Stats.HoneyStart) / Temptable.Stats.ElapsedTime * 3600)).."`\n"
    Text = Text .. "Honey Per 24 Hours: `"..API:SuffixString(math.floor((Temptable.Stats.HoneyCurrent - Temptable.Stats.HoneyStart) / Temptable.Stats.ElapsedTime * 86400)).."`\n"

    return Text
end

local function GenerateBalloonWebhookText()
    local Text = ''
    Text = Text .. "Hive Balloon Blessing: `"..(string.split(FindHiveBalloon().BalloonBody.GuiAttach.Gui.BlessingBar.TextLabel.Text, "🎈 Blessing ")[2] or "None").."`\n"
    Text = Text .. "Hive Balloon Pollen: `"..(FindHiveBalloon().BalloonBody.GuiAttach.Gui.Bar.TextLabel.Text or "None").."`\n"

    return Text
end

function PlayerRotate()
    if Kometa.Toggles.Autofarm and Kometa.Toggles.FaceBalloons and FindPlayerBalloon() and Root and not Temptable.Converting then 
        API:Teleport(CFrame.lookAt(Root.Position, Vector3.new(FindPlayerBalloon().BalloonRoot.Position.X, Root.Position.Y, FindPlayerBalloon().BalloonRoot.Position.Z)))
    end
    if Kometa.Toggles.Autofarm and Kometa.Toggles.FaceFlames and FindClosestFlame() and Root and not Temptable.Converting then 
        API:Teleport(CFrame.lookAt(Root.Position, Vector3.new(FindClosestFlame().Position.X, Root.Position.Y, FindClosestFlame().Position.Z)))
    end
    if Kometa.Toggles.Autofarm and Kometa.Toggles.FaceCenter and Root and not Temptable.Converting then 
        API:Teleport(CFrame.lookAt(Root.Position, Vector3.new(FieldSelected.Position.X, Root.Position.Y, FieldSelected.Position.Z)))
    end
end

function ConvertPollen()
    if Kometa.Toggles.AutoMicroConverter and (GetPlayerData().Eggs['Micro-Converter'] or 0) > 0 then
        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({
            ["Name"] = "Micro-Converter"
        })
        task.wait(1)
        return
    end
    if Kometa.Toggles.AutoTicketConverter then
        local ToysConverters = { "Instant Converter", "Instant Converter B", "Instant Converter C" }
        for Index = 1, #ToysConverters do
            if CheckToyCooldown(ToysConverters[Index]) then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(ToysConverters[Index])
                task.wait(0.2)
                if not CheckToyCooldown(ToysConverters[Index]) then return end
            end     
        end
    end
    if Temptable.DontFarm then return end
    Temptable.Converting = true
    Tween(Player:WaitForChild("SpawnPos").Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) * CFrame.new(0, 2, -9))
    task.wait(2)
    VirtualPressButton("E")
    local OldMask = GetPlayerData().EquippedAccessories.Hat or "None"
    if Kometa.Toggles.AutoEquipHoneyMask then
        MaskEquip("Honey Mask")
    end
    if Kometa.Webhooking.BalloonStats and FindHiveBalloon() then 
        API:ImageHook(KometaWebhook.Webhook, GenerateBalloonWebhookText(), "kometa v2 ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/d/da/White_Balloon.png/revision/latest/scale-to-width-down/40?cb=20211122063547")
    end
    repeat
        task.wait(0.5)
        if Player.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and Player.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or API:Magnitude(Player.SpawnPos.Value.Position, Root.Position) > 10 then
            VirtualPressButton("E")
            Tween(Player:WaitForChild("SpawnPos").Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) * CFrame.new(0, 2, -9))
        end
    until PollenBar.Size.X.Scale <= 0 or not Kometa.Toggles.Autofarm
    if Temptable.Converting then
        task.wait(4)
        if Kometa.Toggles.ConvertBalloons and FindHiveBalloon() and Kometa.Toggles.Autofarm then
            repeat
                task.wait(0.5)
                if Player.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and Player.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or API:Magnitude(Player.SpawnPos.Value.Position, Root.Position) > 10 then
                    VirtualPressButton("E")
                    Tween(Player:WaitForChild("SpawnPos").Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) * CFrame.new(0, 2, -9))
                end
            until FindHiveBalloon() == false or not Kometa.Toggles.ConvertBalloons or not Kometa.Toggles.Autofarm
        end
        if Kometa.Webhooking.Convert then 
            API:ImageHook(KometaWebhook.Webhook, GenerateWebhookText(), "kometa v2 ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/f/f6/HoneyDrop.png/revision/latest/scale-to-width-down/90?cb=20200521143648&path-prefix=ru")
        end
        task.wait(2)
        Temptable.Converting = false
    end
    if Kometa.Toggles.AutoEquipHoneyMask then
        MaskEquip(OldMask)
    end
end

function MakeSprinklers(Selected, Point)
    LogsModify({Action = "Add", Callback = "Placing Sprinklers"})
    local Sprinkler = GetPlayerData().EquippedSprinkler
    local Amount = 0
    if Sprinkler == "Basic Sprinkler" or Sprinkler == "The Supreme Saturator" then
        Amount = 1
    elseif Sprinkler == "Silver Soakers" then
        Amount = 2
    elseif Sprinkler == "Golden Gushers" then
        Amount = 3
    elseif Sprinkler == "Diamond Drenchers" then
        Amount = 4
    end
    if Amount == 0 then return end
    if Point then
        local JumpPower = Humanoid.JumpPower
        for Index = 1, Amount do
            if not Kometa.Toggles.Autofarm then
                break
            end
            Humanoid.JumpPower = 70
            if Amount == 1 then
                ForceWalk(Point)
                Humanoid.Jump = true
            elseif Amount ~= 2 then
                ForceWalk(Point)
                Humanoid.Jump = true
            else
                if Index == 1 then
                    ForceWalk(Point)
                    Humanoid.Jump = true
                else
                    ForceWalk(Point)
                    Humanoid.Jump = true
                end
            end
            Root.Velocity = Vector3.new(0, 0, 0)
            task.wait(0.2)
            game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
            Humanoid.JumpPower = JumpPower
            task.wait(1.3)
        end
    else
        local Field = Selected
        if CheckForSprout() and not Field then
            Field = Temptable.Sprouts.Instances[1].Field
        end
        local FieldSelect = Field or FieldSelected
        if FieldSelect then
            local FieldEdge1 = FieldSelect.Position + Vector3.new((FieldSelect.Size.X / 2) - 24, 0, (FieldSelect.Size.Z / 2) - 24)
            local FieldEdge2 = FieldSelect.Position - Vector3.new((FieldSelect.Size.X / 2) - 24, 0, (FieldSelect.Size.Z / 2) - 24)
            local FieldBounds = {
                [1] = Vector3.new(FieldEdge1.X - FieldEdge1.X % 0.000000000000001, FieldSelect.Position.Y, FieldSelect.Position.Z),
                [2] = Vector3.new(FieldSelect.Position.X, FieldSelect.Position.Y, FieldEdge1.Z - FieldEdge1.Z % 0.000000000000001),
                [3] = Vector3.new(FieldEdge2.X - FieldEdge2.X % 0.000000000000001, FieldSelect.Position.Y, FieldSelect.Position.Z),
                [4] = Vector3.new(FieldSelect.Position.X, FieldSelect.Position.Y, FieldEdge2.Z - FieldEdge2.Z % 0.000000000000001),
            }
            local JumpPower = Humanoid.JumpPower
            for Index = 1, Amount do
                if not Kometa.Toggles.Autofarm then
                    break
                end
                Humanoid.JumpPower = 70
                if Amount == 1 then
                    ForceWalk(FieldSelect.Position)
                    Humanoid.Jump = true
                elseif Amount ~= 2 then
                    ForceWalk(FieldBounds[Index])
                    Humanoid.Jump = true
                else
                    if Index == 1 then
                        ForceWalk(FieldBounds[1])
                        Humanoid.Jump = true
                    else
                        ForceWalk(FieldBounds[3])
                        Humanoid.Jump = true
                    end
                end
                Root.Velocity = Vector3.new(0, 0, 0)
                task.wait(0.2)
                game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
                Humanoid.JumpPower = JumpPower
                task.wait(1.3)
            end
        end
    end
    LogsModify({Action = "Add", Callback = "Finished Placing Sprinklers"})
end

function RefreshQuests()
    for Index, _ in next, QuestsList do
        QuestsList[Index] = {}
    end
    if not Kometa.Toggles.AutoDoQuests then return end
    for _, Quest in next, GetPlayerData().Quests.Active do
        Identity(2)
        local Success, Error = pcall(function()
            QuestModule:Progress(Quest.Name, GetPlayerData())
        end)
        Identity(7)
        if not Success then warn(Error) continue end
        if table.find(Kometa.Vars.NpcPrefer, QuestModule:Get(Quest.Name).NPC) then
            Identity(2)
            local QuestProgress = QuestModule:Progress(Quest.Name, GetPlayerData())
            Identity(7)
            if not QuestProgress or #QuestProgress == 0 then continue end
            for Index, Task in next, QuestModule:Get(Quest.Name).Tasks do
                if QuestProgress[Index][1] == 1 then
                    continue 
                end
                if Task.Type == 'Collect Pollen' or Task.Type == 'Collect Goo' then
                    if not table.find(Kometa.BlacklistedFields, Task.Zone or Kometa.BestFields[Task.Color] or '') then
                        if Task.Zone then
                            table.insert(QuestsList[Task.Type], { Task.Zone, Quest.Name, Task.Type })
                        elseif Task.Color then
                            table.insert(QuestsList[Task.Type], { Kometa.BestFields[Task.Color], Quest.Name, Task.Type })
                        end
                    end
                elseif Task.Type == 'Defeat Monsters' then
                    table.insert(QuestsList[Task.Type], { Task.MonsterType, Quest.Name, Task.Type })
                elseif Task.Type == 'Use Items' and table.find(Temptable.FoodNames, Task.Item) then
                    --table.insert(QuestsList['Feed Bees'], { Task.Item, Task.Amount(GetPlayerData()) or 1, Quest.Name, Task.Type })
                end
                task.wait()
            end
        end
        task.wait()
    end
    PollenTask = nil
end

function ClaimQuests()
    for _, NPC in next, game:GetService("Workspace").NPCs:GetChildren() do
        if NPC.Name ~= "Ant Challenge Info" and NPC.Name ~= "Bubble Bee Man 2" and NPC.Name ~= "Wind Shrine" and NPC.Name ~= "Gummy Bear" and NPC.Name ~= "Honey Bee" then
            if NPC:FindFirstChild("Platform") and NPC.Platform:FindFirstChild("AlertPos") and NPC.Platform.AlertPos:FindFirstChild("AlertGui") and NPC.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
                local Image = NPC.Platform.AlertPos.AlertGui.ImageLabel
                if Image.ImageTransparency == 0 then
                    Tween(CFrame.new(NPC.Platform.Position) * CFrame.new(0, 3, 0))
                    task.wait(1)
                    VirtualPressButton('E')
                    task.wait(2)
                    if Image.ImageTransparency == 0 then
                        Tween(CFrame.new(NPC.Platform.Position) * CFrame.new(0, 3, 0))
                        task.wait(1)
                        VirtualPressButton('E')
                    end
                    task.wait(2)
                end
            end
        end
    end
end

function MutationFeed(X, Y, Name, Amount)
    if GetPlayerData().Honeycomb['x'..X] and GetPlayerData().Honeycomb['x'..X]['y'..Y] then
        local BeeMutations = GetPlayerData().Honeycomb['x'..X]['y'..Y]['Mutas'] or { 'None' }
        for Mutation, _ in next, BeeMutations do
            if Mutations[Mutation] ~= Name then
                Temptable.Feed(X, Y, 'Atomic Treat', Amount)
            end
        end
    end
end

function HatchUntilSelected(X, Y, Name)
    -- if GetPlayerData().Honeycomb['x'..X] and GetPlayerData().Honeycomb['x'..X]['y'..Y] then
    --     local BeeType = GetPlayerData().Honeycomb['x'..X]['y'..Y]['Type'] or { 'None' }
    --     if BeeType ~= Name then
    --         Temptable.Feed(X, Y, "RoyalJelly")
    --     end
    -- end
    local CurrentBee = Player.PlayerGui.ScreenGui.BeePopUp.TypeName.Text:split(" Bee!")[1]
    if string.find(CurrentBee, 'Gifted') then
        CurrentBee = CurrentBee:split("Gifted ")[2]
    end
    if not table.find(Name, CurrentBee) then
        Temptable.Feed(X, Y, "RoyalJelly")
    end
end

function UntilGifted(X, Y, Food, Amount)
    if GetPlayerData().Honeycomb['x'..X] and GetPlayerData().Honeycomb['x'..X]['y'..Y] then
        local BeeFlags = GetPlayerData().Honeycomb['x'..X]['y'..Y]['Traits'] or { 'None' }
        if not API:TableFind(BeeFlags, 'Gifted') then
            Temptable.Feed(X, Y, Food, Amount)
        end
    end
end

function IsToken(Token)
    if not Token or not Token.Parent then return false end
    if Token then
        if Token.Orientation.Z ~= 0 and Token.Name == "C" then
            return false
        end
        if Token.Name == "C" then
            if not Token:FindFirstChild("FrontDecal") then
                return false
            end
        else
            return false
        end
        if not Token:IsA("Part") then
            return false
        end
        if Token.Transparency >= 0.5 then
            return false
        end
        return true
    end
end

function IsLinkToken(Token)
    if Token:FindFirstChildOfClass("Decal") and (Token:FindFirstChildOfClass("Decal").Texture == '1629547638' or Token:FindFirstChildOfClass("Decal").Texture == 'rbxassetid://1629547638') then
        return true
    end
    return false
end

function CollectObject(Object)
    if not Object or Temptable.Converting or (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) or Temptable.Collecting.Disk or Temptable.Collecting.Crosshair then return end
    repeat
        task.wait()
        API:WalkTo(Object.Position)
    until API:Magnitude(Object.Position, Root.Position) <= 5 or API:Magnitude(Object.Position, Root.Position) >= Temptable.Magnitude or not IsToken(Object) or Temptable.Converting or Temptable.Collecting.Disk or Temptable.Collecting.Crosshair
    -- VirtualPressButton('W')
    if IsToken(Object) and (Object:FindFirstChildOfClass("Decal").Texture == "1674871631" or Object:FindFirstChildOfClass("Decal").Texture == "rbxassetid://1674871631") then
        Temptable.Stats.CollectedTickets += 1
    end
end

local function GetTokens()
    if Kometa.Vars.AutofarmingEngine == "Classic" then
        return Temptable.TokenPath:GetChildren() or {}
    elseif Kometa.Vars.AutofarmingEngine == "k-01" then
        local TokensInstances = Temptable.TokenPath:GetChildren()
        table.sort(TokensInstances, function(A, B)
            return API:Magnitude(A.Position, Root.Position) < API:Magnitude(B.Position, Root.Position)
        end)
        return TokensInstances or {}
    else
        local TokensInstances = Temptable.TokenPath:GetChildren()
        table.sort(TokensInstances, function(A, B)
            return API:Magnitude(A.Position, Root.Position) < API:Magnitude(B.Position, Root.Position) and A.Transparency > B.Transparency
        end)
        return TokensInstances or {}
    end
end


function CollectTokens(Distance, Icons)
    local FieldPos = FieldSelected.Position or Root.Position
    local Tokens = GetTokens()
    for _, Token in ipairs(Tokens) do
        if IsToken(Token) and API:Magnitude(Token.Position, Root.Position) <= (Distance or 50) and API:Magnitude(Token.Position, FieldPos) <= (Distance or 50) and math.abs(Token.Position.Y - Root.Position.Y) <= 5 and not API:FindValue(Kometa.BlacklistTokens, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
            if IsLinkToken(Token) then
                CollectObject(Token)
            end
        end
    end
    for _, Token in ipairs(Tokens) do
        if IsToken(Token) and Icons and not Icons[Token.FrontDecal.Texture] then
            continue
        end
        if IsToken(Token) and API:Magnitude(Token.Position, Root.Position) <= (Distance or 50) and API:Magnitude(Token.Position, FieldPos) <= (Distance or 50) and math.abs(Token.Position.Y - Root.Position.Y) <= 5 and API:FindValue(Kometa.Priority, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) and not API:FindValue(Kometa.BlacklistTokens, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
            CollectObject(Token)
        end
    end
    for _, Token in ipairs(Tokens) do
        if IsToken(Token) and Icons and not Icons[Token.FrontDecal.Texture] then
            continue
        end
        if IsToken(Token) and API:Magnitude(Token.Position, Root.Position) <= (Distance or 50) and API:Magnitude(Token.Position, FieldPos) <= (Distance or 50) and math.abs(Token.Position.Y - Root.Position.Y) <= 5 and not API:FindValue(Kometa.BlacklistTokens, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
            CollectObject(Token)
        end
    end
end

function FetchTokens(Position, Distance, Icons)
    local Tokens = GetTokens()
    for _, Token in ipairs(Tokens) do
        if IsToken(Token) and API:Magnitude(Token.Position, Position) <= (Distance or 50) and API:Magnitude(Token.Position, Root.Position) <= (Distance or 50) and math.abs(Token.Position.Y - Root.Position.Y) <= 5 and not API:FindValue(Kometa.BlacklistTokens, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
            if IsLinkToken(Token) then
                CollectObject(Token)
            end
        end
    end
    for _, Token in ipairs(Tokens) do
        if IsToken(Token) and Icons and not Icons[Token.FrontDecal.Texture] then
            continue
        end
        if IsToken(Token) and API:Magnitude(Token.Position, Position) <= (Distance or 50) and API:Magnitude(Token.Position, Root.Position) <= (Distance or 50) and math.abs(Token.Position.Y - Root.Position.Y) <= 5 and API:FindValue(Kometa.Priority, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) and not API:FindValue(Kometa.BlacklistTokens, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
            CollectObject(Token)
        end
    end
    for _, Token in ipairs(Tokens) do
        if IsToken(Token) and Icons and not Icons[Token.FrontDecal.Texture] then
            continue
        end
        if IsToken(Token) and API:Magnitude(Token.Position, Position) <= (Distance or 50) and API:Magnitude(Token.Position, Root.Position) <= (Distance or 50) and math.abs(Token.Position.Y - Root.Position.Y) <= 5 and not API:FindValue(Kometa.BlacklistTokens, string.split(Token:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
            CollectObject(Token)
        end
    end
end

function FindFieldWithRay(Position, Direction)
    local Ray = Ray.new(Position, Direction)
    local Field = workspace:FindPartOnRayWithWhitelist(Ray, { workspace.FlowerZones })
    if Field then
        return Field
    end
end

function FetchFlowers(Distance, FieldPos)
	local Flowers = {}

	for _, Flower in next, FlowersTable do
		if API:Magnitude(Flower, FieldPos) <= Distance then
			table.insert(Flowers, Flower)
		end
	end

    if #Flowers == 0 then
		return nil
    else
        return Flowers
	end
end

function WalkOnField(FieldPos, Magnitude, RandomTime)
    local Timer = os.time()
    local Radius = Magnitude or 50
    local RandomPosition = FieldPos + Vector3.new(math.random(-Radius, Radius), 0, math.random(-Radius, Radius))
    if Temptable.Running == false then
        repeat
            task.wait()
            API:WalkTo(RandomPosition)
        until API:Magnitude(RandomPosition, Root.Position) <= 5 or API:Magnitude(RandomPosition, Root.Position) >= Radius or CheckCombatSettings() or Temptable.Collecting.Disk or Temptable.Collecting.Crosshair or Temptable.Converting or not Kometa.Toggles.Autofarm
    end
end

function GetPlayerBalloons()
    local Balloons = {}
    for _, Object in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if Object:FindFirstChild("BalloonRoot") and Object:FindFirstChild("PlayerName") then
            if Object:FindFirstChild("PlayerName").Value == Player.Name then
                local BalloonField = FindFieldWithRay(Object:FindFirstChild("BalloonRoot").Position, Vector3.new(0, -10, 0))
                if BalloonField and BalloonField == FieldSelected then
                    table.insert(Balloons, Object:FindFirstChild("BalloonRoot"))
                end
            end
        end
    end
    return Balloons
end

function FindHiveBalloon()
    for _, Hive in next, game:GetService("Workspace").Honeycombs:GetChildren() do
        task.wait()
        if Hive:FindFirstChild("Owner") and Hive:FindFirstChild("SpawnPos") then
            if tostring(Hive.Owner.Value) == game.Players.LocalPlayer.Name then
                for _, HiveBalloon in next, game:GetService("Workspace").Balloons.HiveBalloons:GetChildren() do
                    task.wait()
                    if HiveBalloon:FindFirstChild("BalloonRoot") then
                        if API:Magnitude(HiveBalloon.BalloonRoot.Position, Hive.SpawnPos.Value.Position) < 15 then
                            return HiveBalloon
                        end
                    end
                end
            end
        end
    end
    return false
end

local function SaveLogs()
    if isfile('kometa_logs.txt') then delfile('kometa_logs.txt') end
    writefile('kometa_logs.txt', 'kometa '..Temptable.Version..'\n\n')
    for _, Log in ipairs(Logs) do
        appendfile('kometa_logs.txt', Log..'\n')
    end
end

function LogsModify(Arguments)
    if typeof(Arguments) == "table" and not Kometa.Toggles.DisableActionLogs then
        if Arguments.Action == 'Add' then
            table.insert(Logs, '--// '..Arguments['Callback'])
        end
    end
end

function FindPlayerBalloon()
    for _, Object in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if Object:FindFirstChild("BalloonBody") and Object:FindFirstChild("BalloonRoot") and Object:FindFirstChild("PlayerName") then
            if Object:FindFirstChild("PlayerName").Value == Player.Name and Object:FindFirstChild("BalloonBody").GuiAttach.Gui.Bar.BackgroundTransparency ~= 1 then
                return Object
            end
        end
    end
end

function FindClosestFlame()
    local Flame
    local Studs = math.huge
    for _, Object in next, game:GetService("Workspace").PlayerFlames:GetChildren() do
        local Distance = API:Magnitude(Root.Position, Object.Position)
        if Distance < Studs then
            Studs = Distance
            Flame = Object
        end
    end
    return Flame
end

function UpdatePlanters()
    for _, Value in next, debug.getupvalues(require(game:GetService("ReplicatedStorage").LocalPlanters).LoadPlanter)[4] do 
        PlayerPlanters[Value.Type] = {}
        if Value.IsMine then
            if PlayerPlanters[Value.Type][1] == nil then
                PlayerPlanters[Value.Type] = {Value.Type, Value.ActorID, Value.Pos, Value.GrowthPercent}
            end
        end
    end
end

function CollectPlanters()
    UpdatePlanters()
    for _, Planter in next, PlayerPlanters do
        if Planter[1] == nil then continue end
        for Index, _ in next, Kometa.PlanterSettings do
            if Kometa.PlanterSettings[Index].Enabled and Kometa.PlanterSettings[Index].Type == Planter[1] and Kometa.PlanterSettings[Index].Growth <= Planter[4] then
                Temptable.Collecting.Planter = true
                Tween(CFrame.new(Planter[3]))
                game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(Planter[2])
                LogsModify({Action = 'Add', Callback = 'Collected '..Planter[1]..' Planter'})
                task.wait(2)
                FetchTokens(Planter[3], 70)
                task.wait(5)
                PlayerPlanters[Planter[1]] = {}
                Temptable.Collecting.Planter = false
            end
        end
    end
end

function PlantPlanters()
    UpdatePlanters()
    for _, Planter in next, Kometa.PlanterSettings do
        if Planter.Enabled then
            if PlayerPlanters[Planter.Type][1] ~= nil then continue end
            Temptable.Collecting.Planter = true
            if Planter.PlantMode == 'Field' then
                local Field = workspace.FlowerZones:FindFirstChild(Planter.Field)
                Tween(Field.CFrame)
                task.wait(1)
                local PlanterName = Planter.Type
                if PlanterName == 'Plenty' then
                    PlanterName = 'The Planter Of Plenty'
                else
                    PlanterName = PlanterName..' Planter'
                end
                game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = PlanterName})
                LogsModify({Action = 'Add', Callback = 'Planted '..Planter.Type..' Planter'})
                task.wait(1)
            elseif Planter.PlantMode == 'Nectar' then
                local Fields = NectarsTable[Planter.Nectar].Fields
                local Field = workspace.FlowerZones:FindFirstChild(Fields[math.random(1, #Fields)])
                Tween(Field.CFrame)
                task.wait(1)
                local PlanterName = Planter.Type
                if PlanterName == 'Plenty' then
                    PlanterName = 'The Planter Of Plenty'
                else
                    PlanterName = PlanterName..' Planter'
                end
                game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = PlanterName})
                LogsModify({Action = 'Add', Callback = 'Planted '..Planter.Type..' Planter'})
                task.wait(1)
            end
            Temptable.Collecting.Planter = false
        end
    end
end

function CollectDisk(Disk)
    if (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) or Temptable.Collecting.Fireflies or CheckMobsNearby() or CheckCombatSettings() or CheckForPuffshrooms() then return end
    if Temptable.Collecting.Disk then repeat task.wait() until not Temptable.Collecting.Disk end
    Temptable.Collecting.Disk = true
    repeat
        task.wait()
        API:WalkTo(Disk.Position)
    until not Disk or not Disk.Parent
    Temptable.Collecting.Disk = false
end

function CollectPreciseCH(Crosshair, Gifted)
    if (Kometa.Toggles.SmartCrosshairs and not Gifted and CheckBoostStacks('Precision') == 10) or (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) or Temptable.Collecting.Disk or Temptable.Collecting.Fireflies or CheckMobsNearby() or CheckCombatSettings() or CheckForPuffshrooms() then return end
    if Temptable.Collecting.Crosshair then repeat task.wait() until not Temptable.Collecting.Crosshair end
    Temptable.Collecting.Crosshair = true
    if Kometa.Toggles.SmartCrosshairs and Gifted and CheckBoostStacks('Precision') == 10 then
        repeat
            task.wait()
            API:WalkTo(Crosshair.Position)
        until not Crosshair or not Crosshair.Parent or API:Magnitude(Crosshair.Position, Root.Position) <= 4 and not (PollenBar.Size.X.Scale * 100 >= Kometa.Vars.StandCrosshairAt) or Temptable.Collecting.Disk
        Temptable.Collecting.Crosshair = false
        return
    else
        repeat
            task.wait()
            API:WalkTo(Crosshair.Position)
        until not Crosshair or not Crosshair.Parent or API:Magnitude(Crosshair.Position, Root.Position) <= 4 or Temptable.Collecting.Disk
        local CrosshairConnection
        CrosshairConnection = Crosshair:GetPropertyChangedSignal("BrickColor"):Connect(function()
            if Crosshair and Crosshair.Parent and Crosshair.BrickColor == BrickColor.new('Royal purple') then
                while task.wait() do
                    API:WalkTo(Crosshair.Position)
                    if not Crosshair or not Crosshair.Parent or not (PollenBar.Size.X.Scale * 100 >= Kometa.Vars.StandCrosshairAt) then
                        break
                    end
                end
            end
            CrosshairConnection:Disconnect()
        end)
    end
    Temptable.Collecting.Crosshair = false
    LogsModify({Action = 'Add', Callback = 'Collected Crosshair'})
end

function CollectFuzzyBombs()
    for _, Object in next, workspace.Particles:GetChildren() do
        if Object.Parent and Object.Name == "DustBunnyInstance" and API:Magnitude(Object:FindFirstChild("Plane").Position, Root.Position) <= 50 and Kometa.Toggles.Autofarm then
            local Plane = Object:FindFirstChild("Plane")
            if Plane then
                repeat
                    task.wait(0.15)
                    API:WalkTo(Plane.Position)
                until not Plane or not Plane.Parent or API:Magnitude(Plane.Position, Root.Position) >= Temptable.Magnitude or not Kometa.Toggles.Autofarm
            end
        end
        if PollenBar.Size.X.Scale >= 1 then
            break
        end
    end
end

function CollectBubbles()
    for _, Bubble in next, game.Workspace.Particles:GetChildren() do
        if string.find(Bubble.Name, 'Bubble') and API:Magnitude(Bubble.Position, Root.Position) <= 50 and Kometa.Toggles.Autofarm then 
            repeat
                task.wait()
                API:WalkTo(Bubble.Position)
            until not Bubble or not Bubble.Parent or not Kometa.Toggles.FarmBubbles or API:Magnitude(Bubble.Position, Root.Position) <= 4 or API:Magnitude(Bubble.Position, Root.Position) >= Temptable.Magnitude or Temptable.Collecting.Disk or Temptable.Collecting.Crosshair or not Kometa.Toggles.Autofarm
        end
        if PollenBar.Size.X.Scale >= 1 then
            break
        end
    end
end

function CollectFlames()
    pcall(function()
        for _, Flame in next, game:GetService("Workspace").PlayerFlames:GetChildren() do
            if API:Magnitude(Flame.Position, Root.Position) <= Temptable.Magnitude / 1.4 then
                repeat
                    API:WalkTo(Flame.Position)
                    task.wait()
                until GetPlayerData().ModifierCaches.Value.FlameHeat['_'] >= 0.9 or not Flame or not Flame.Parent or (not Flame:FindFirstChild('PF').Enabled and not Flame:FindFirstChild('PS').Enabled) or API:Magnitude(Flame.Position, Root.Position) >= Temptable.Magnitude or not Kometa.Toggles.FarmFlame or not Kometa.Toggles.Autofarm or Temptable.Collecting.Disk or Temptable.Collecting.Crosshair
                break
            end
        end
    end)
end

function CollectUnderBalloons()
    local Balloons = GetPlayerBalloons()
    if #Balloons > 0 then
        for _, Balloon in next, Balloons do
            FetchTokens(Balloon.Position, 30)
            task.wait()
            if PollenBar.Size.X.Scale >= 1 then
                break
            end
        end
    end
end

function CollectClouds()
    for _, Value in next, game:GetService("Workspace").Clouds:GetChildren() do
        local Cloud = Value:FindFirstChild("Plane")
        if Cloud and not (CheckBoost('Cloud Boost') or CheckBoost('Cloud Boost+')) then
            local Field = FindFieldWithRay(Cloud.Position, Vector3.new(0, -20, 0))
            if (Field and Field.Name == Kometa.Vars.Field) and Kometa.Toggles.Autofarm then
                local WalkTimer = os.time()
                repeat
                    task.wait()
                    API:WalkTo(Cloud.Position)
                until (os.time() - WalkTimer) >= 3 or not Cloud or not Cloud.Parent or not Kometa.Toggles.Autofarm or Temptable.Collecting.Disk or Temptable.Collecting.Crosshair
            end
        end
    end
end

function CollectDuped()
    for _, Glitch in next, game:GetService("Workspace").Camera.DupedTokens:GetChildren() do
        if Glitch and API:Magnitude(Glitch.Position, Root.Position) <= 100 and Glitch:FindFirstChild('FrontDecal') and string.find(Glitch:FindFirstChild('FrontDecal').Texture, "5877939956") and Kometa.Toggles.Autofarm then
            repeat
                task.wait()         
                API:WalkTo(Glitch.Position)
            until not Glitch or not Glitch.Parent or not Kometa.Toggles.Autofarm
        end
    end
    if not Kometa.Toggles.CollectOnlyFaces then
        for _, Glitch in next, game:GetService("Workspace").Camera.DupedTokens:GetChildren() do
            if Glitch and API:Magnitude(Glitch.Position, Root.Position) <= 50 and Kometa.Toggles.Autofarm and Kometa.Toggles.Autofarm then
                repeat
                    task.wait()       
                    API:WalkTo(Glitch.Position)    
                until not Glitch or not Glitch.Parent or not Kometa.Toggles.Autofarm
            end
        end
    end
end

function CollectFireflies()
    if Temptable.Collecting.Fireflies then return end
    Temptable.Collecting.Fireflies = true
    repeat
        task.wait()
        for _, Bee in next, workspace.NPCBees:GetChildren() do
            if Bee.Name == "Firefly" and Bee.Velocity.Magnitude < 1.5 and Kometa.Toggles.FarmFireflies and FindFieldWithRay(Bee.Position, Vector3.new(0, -10, 0)) then
                if API:Magnitude(Bee.Position, Root.Position) >= 100 then
                    Tween(CFrame.new(Bee.Position) * CFrame.new(0, 2, 0))
                else
                    API:WalkTo(Bee.Position)
                end
                repeat
                    task.wait()
                    API:WalkTo(Bee.Position)
                until not Kometa.Toggles.FarmFireflies or API:Magnitude(Bee.Position, Root.Position) <= 4 or math.abs(Root.Position.Y - Bee.Position.Y) >= 5
                FetchTokens(Root.Position, 50, {
                    ["rbxassetid://2306224708"] = true
                })
            end
        end
    until not workspace.NPCBees:FindFirstChild("Firefly") or not Kometa.Toggles.FarmFireflies or not Kometa.Toggles.Autofarm or CheckCombatSettings()
    Temptable.Collecting.Fireflies = false
end

function CollectSparkles()
    if Temptable.Collecting.Sparkles then return end
    Temptable.Collecting.Sparkles = true
    for _, Object in next, Flowers:GetDescendants() do
        if Object.Name == "Sparkles" and Object.Parent then
            Tween(CFrame.new(Object.Parent.Position + Vector3.new(0, 2, 0)))
            task.wait(2.5)
            FetchTokens(Root.Position, 15)
            if not Kometa.Toggles.FarmSparkles or CheckCombatSettings() then
                break
            end
        end
    end
    Temptable.Collecting.Sparkles = false
end

function CollectPuffshrooms()
    local FieldPos
    local FieldPosition
    local PuffShroom
    if API:GetPartWithName("Mythic", game.Workspace.Happenings.Puffshrooms) then
        FieldPos = API:GetPartWithName("Mythic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
        FieldPosition = FieldPos.Position
        PuffShroom = API:GetPartWithName("Mythic", game.Workspace.Happenings.Puffshrooms)
    elseif API:GetPartWithName("Legendary", game.Workspace.Happenings.Puffshrooms) then
        FieldPos = API:GetPartWithName("Legendary", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
        FieldPosition = FieldPos.Position
        PuffShroom = API:GetPartWithName("Legendary", game.Workspace.Happenings.Puffshrooms)
    elseif API:GetPartWithName("Epic", game.Workspace.Happenings.Puffshrooms) then
        FieldPos = API:GetPartWithName("Epic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
        FieldPosition = FieldPos.Position
        PuffShroom = API:GetPartWithName("Epic", game.Workspace.Happenings.Puffshrooms)
    elseif API:GetPartWithName("Rare", game.Workspace.Happenings.Puffshrooms) then
        FieldPos = API:GetPartWithName("Rare", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
        FieldPosition = FieldPos.Position
        PuffShroom = API:GetPartWithName("Rare", game.Workspace.Happenings.Puffshrooms)
    else
        FieldPos = API:GetBiggestModel(game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
        FieldPosition = FieldPos.Position
        PuffShroom = API:GetBiggestModel(game.Workspace.Happenings.Puffshrooms)
    end
    Tween(FieldPos)
    LogsModify({Action = 'Add', Callback = 'Tweening To Puffshroom'})
    MakeSprinklers(nil, FieldPosition)
    repeat
        task.wait()
        if API:Magnitude(FieldPosition, Root.Position) >= 50 then
            Tween(FieldPos)
        end
        WalkOnField(FieldPosition, 15, math.random(2, 3))
        FetchTokens(FieldPosition, 25)
    until not PuffShroom or not PuffShroom.Parent or not Kometa.Toggles.Autofarm or not Kometa.Toggles.FarmPuffshrooms or Temptable.Converting or (PollenBar.Size.X.Scale * 100 >= Kometa.Vars.ConvertAt) or CheckCombatSettings()
    task.wait(2)
    for _ = 1, 10 do
        FetchTokens(FieldPosition, 25)
    end
    LogsModify({Action = 'Add', Callback = 'Collected Tokens From Puffshroom'})
end

function UseDispensers()
    if require(game:GetService("ReplicatedStorage").StatTools).CheckIfRoboBearChallengeRoundIsRunning(GetPlayerData()) or Temptable.Collecting.Planter or CheckCombatSettings() or Temptable.Converting or Temptable.Started.KillMobs then return end
    for DispenserName, DispenserToggle in next, Kometa.BeesmasDispenserSettings do
        if DispenserToggle and game:GetService("Workspace").Toys:FindFirstChild(DispenserName):FindFirstChild("ModelAfter") and CheckToyCooldown(DispenserName) then
            if Temptable.Collecting.Tickets or Temptable.Collecting.Rares then continue end
            Temptable.DontFarm = true
            Tween(CFrame.new(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position) * CFrame.new(0, 10, 0))
            LogsModify({Action = 'Add', Callback = 'Tweening To '..DispenserName..' Dispenser'})
            if game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform") then
                local DispenserTime = os.time()
                repeat 
                    task.wait() 
                    if Kometa.Vars.Mobility == 'Tween' then
                        Tween(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0))) 
                    end
                    Root.Velocity = Vector3.new(0, 0, 0)
                    TweenStart(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0)))
                    if API:Magnitude(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0), Root.Position) < 10 then
                        VirtualPressButton('E') 
                    end
                until not CheckToyCooldown(DispenserName) or (os.time() - DispenserTime >= 10)
                LogsModify({Action = 'Add', Callback = 'Used '..DispenserName..' Dispenser'})
            end
            task.wait(2)
            for _ = 1, 10 do
                FetchTokens(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position, 50)
                task.wait(0.1)
            end
            task.wait(2)
            Temptable.DontFarm = false
        end
        task.wait(0.5)
    end
    for DispenserName, DispenserToggle in next, Kometa.ToysSettings do
        if DispenserToggle and DispenserName == "Free Ant Pass Dispenser" and (GetPlayerData().Eggs.AntPass or 0) >= 10 then continue end 
        if DispenserToggle and DispenserName == "Free Robo Pass Dispenser" and (GetPlayerData().Eggs.RoboPass or 0) >= 10 then continue end
        if DispenserToggle and CheckToyCooldown(DispenserName) then
            Temptable.DontFarm = true
            if game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform") then
                local Time = API:Magnitude(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position + Vector3.new(0, 10, 0), Root.Position) / Humanoid.WalkSpeed
                local DispenserTime = os.time()
                LogsModify({Action = 'Add', Callback = 'Tweening To '..DispenserName..' Dispenser'})
                Tween(CFrame.new(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position) * CFrame.new(0, 10, 0))
                repeat 
                    task.wait() 
                    if Kometa.Vars.Mobility == 'Tween' then
                        Tween(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0))) 
                    end
                    Root.Velocity = Vector3.new(0, 0, 0)
                    TweenStart(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0)))
                    if API:Magnitude(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0), Root.Position) < 10 then
                        VirtualPressButton('E') 
                    end
                until not CheckToyCooldown(DispenserName) or (os.time() - DispenserTime >= 10)
                LogsModify({Action = 'Add', Callback = 'Used '..DispenserName..' Dispenser'})
            end
            task.wait(2)
            Temptable.DontFarm = false
        end
        task.wait(0.5)
    end
    if Kometa.Toggles.AutoDispenser then
        for DispenserName, DispenserToggle in next, Kometa.NormalDispenserSettings do
            if DispenserToggle and not table.find(FieldBoosters, DispenserName) and CheckToyCooldown(DispenserName) then
                Temptable.DontFarm = true
                if game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform") then
                    local DispenserTime = os.time()
                    LogsModify({Action = 'Add', Callback = 'Tweening To '..DispenserName..' Dispenser'})
                    Tween(CFrame.new(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position) * CFrame.new(0, 10, 0))
                    repeat 
                        task.wait() 
                        if DispenserName ~= 'Glue Dispenser' then
                            if Kometa.Vars.Mobility == 'Tween' then
                                Tween(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0))) 
                            end
                        else
                            API:Tween(10, CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0))) 
                        end
                        Root.Velocity = Vector3.new(0, 0, 0)
                        TweenStart(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0)))
                        if API:Magnitude(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0), Root.Position) < 15 then
                            VirtualPressButton('E') 
                        end
                    until not CheckToyCooldown(DispenserName) or (os.time() - DispenserTime >= 20)
                    if DispenserName == 'Glue Dispenser' then
                        API:Tween(10, CFrame.new(3, 86, 489))
                    end
                    LogsModify({Action = 'Add', Callback = 'Used '..DispenserName..' Dispenser'})
                end
                task.wait(2)
                Temptable.DontFarm = false
            end
        end
        task.wait(0.5)
    end
    if Kometa.Toggles.AutoBoosters then
        for DispenserName, DispenserToggle in next, Kometa.NormalDispenserSettings do
            if DispenserToggle and table.find(FieldBoosters, DispenserName) and CheckToyCooldown(DispenserName) then
                Temptable.DontFarm = true
                LogsModify({Action = 'Add', Callback = 'Tweening To '..DispenserName..' Dispenser'})
                local Time = API:Magnitude(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position + Vector3.new(0, 10, 0), Root.Position) / Humanoid.WalkSpeed
                Tween(CFrame.new(game:GetService("Workspace").Toys:FindFirstChild(DispenserName).Platform.Position) * CFrame.new(0, 10, 0))
                if game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform") then
                    local DispenserTime = os.time()
                    repeat 
                        task.wait() 
                        if Kometa.Vars.Mobility == 'Tween' then
                            Tween(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0))) 
                        end
                        Root.Velocity = Vector3.new(0, 0, 0)
                        TweenStart(CFrame.new(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0)))
                        if API:Magnitude(game:GetService('Workspace').Toys:FindFirstChild(DispenserName):FindFirstChild("Platform").Position + Vector3.new(0, 3, 0), Root.Position) < 10 then
                            VirtualPressButton('E') 
                        end
                    until not CheckToyCooldown(DispenserName) or (os.time() - DispenserTime >= 10)
                    LogsModify({Action = 'Add', Callback = 'Used '..DispenserName..' Dispenser'})
                end
                task.wait(2)
                Temptable.DontFarm = false
            end
        end
        task.wait(0.5)
    end
end

function KillVicious()
    if Temptable.Started.Vicious then return end
    Temptable.Started.Vicious = true
    Temptable.Float = true
    local Vicious = Temptable.Vicious
    local OldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 40 
    local OptimalPosition = CFrame.new(Vicious.Position) * CFrame.new(0, 10, 0)
    TweenStart(OptimalPosition, false)
    Temptable.Float = true
    LogsModify({Action = 'Add', Callback = 'Tweening To Vicious'})
    repeat
        task.wait()
        API:WalkTo(Vicious.Position)
        if API:Magnitude(Vicious.Position, Root.Position) > 70 then
            TweenStart(OptimalPosition, false)
            Temptable.Float = true
        end
    until not Vicious or not Vicious.Parent or not Kometa.Toggles.KillVicious
    LogsModify({Action = 'Add', Callback = 'Killed Vicious!'})
    task.wait(1)
    Humanoid.WalkSpeed = OldSpeed
    Temptable.Float = false
    Temptable.Started.Vicious = false
end

function KillWindy()
    if Temptable.Started.Windy then return end
    Temptable.Started.Windy = true
    local Windy = Temptable.Windy
    local WindyLevel = nil
    for _, Monster in next, workspace.Monsters:GetChildren() do
        if string.find(Monster.Name, "Windy") then
            WindyLevel = Monster.Name
        end
    end
    TweenStart(CFrame.new(Windy.Position) * CFrame.new(0, 5, 0))
    task.wait(1)
    Temptable.Float = true
    repeat
        task.wait()
        TweenStart(CFrame.new(Windy.Position) * CFrame.new(0, 25, 0))
        Temptable.Float = true
        for _, Monster in next, workspace.Monsters:GetChildren() do
            if string.find(Monster.Name, "Windy") and WindyLevel ~= Monster.Name then
                task.wait(3)
                TweenStart(CFrame.new(Windy.Position) * CFrame.new(0, 2, 0))
                task.wait(0.5)
                Temptable.Float = false
                task.wait(4)
                WindyLevel = Monster.Name
                for _ = 1, 15 do
                    FetchTokens(Root.Position, 70)
                end
                task.wait(0.5)
            end
        end
    until not Kometa.Toggles.KillWindy or not Windy or not Windy.Parent
    Temptable.Float = false
    Temptable.Started.Windy = false
end

function KillMondo()
    if game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") then
        local Monster = game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)")
        local Primary = Monster.Head
        if Primary and Monster.Parent then
            local OldSpeed = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = 40 
            Temptable.Float = true
            TweenStart(workspace.FlowerZones['Mountain Top Field'].CFrame * CFrame.new(0, 27, 0))
            task.wait(2)
            API:Tween(4, CFrame.new(Primary.Position - Vector3.new(0, 55, 0)))
            task.wait(2)
            LogsModify({Action = 'Add', Callback = 'Killing Mondo Chick'})
            repeat
                task.wait()
                if API:Magnitude(Root.Position, Primary.Position - Vector3.new(0, 55, 0)) > 50 then
                    TweenStart(CFrame.new(Primary.Position - Vector3.new(0, 55, 0)))
                    Temptable.Float = true
                else
                    API:WalkTo(Primary.Position)
                end
                FetchTokens(Primary.Position - Vector3.new(0, 55, 0), 50)
            until not Monster or not Monster.Parent or not Primary or Humanoid.Health == 0 or not Kometa.Toggles.KillMondo
            Temptable.Float = false
            Humanoid.WalkSpeed = OldSpeed
            LogsModify({Action = 'Add', Callback = 'Killed Mondo Chick!'})
            if Kometa.Toggles.KillMondo then
                API:Tween(4, workspace.FlowerZones['Mountain Top Field'].CFrame * CFrame.new(0, 10, 0))
                task.wait(2)
                local MondoTimer = os.time()
                repeat
                    task.wait()
                    FetchTokens(workspace.FlowerZones['Mountain Top Field'].Position, 100)
                until os.time() - MondoTimer >= 40 or not Kometa.Toggles.KillMondo
                LogsModify({Action = 'Add', Callback = 'Collected Tokens From Mondo Chick!'})
                Temptable.Stats.KilledMondo += 1
            end
        end
    end
end

local function KillCommando()
    if Temptable.Started.Commando then return end
    Temptable.Started.Commando = true
    Temptable.Float = true
    TweenStart(CFrame.new(564, 52, 160), false)
    repeat 
        task.wait()
        Temptable.Float = true
        if API:Magnitude(Root.Position, Vector3.new(564, 52, 160)) > 50 then
            TweenStart(CFrame.new(564, 52, 160), false)
        end
        FetchTokens(Root.Position, 100)
        ForceWalk(Vector3.new(564, 52, 160))
        Root.Velocity = Vector3.new(0, 0, 0)
    until not Kometa.Toggles.KillCommando or MonsterSpawners['Commando Chick'].Attachment.TimerGui.TimerLabel.Visible
    if MonsterSpawners['Commando Chick'].Attachment.TimerGui.TimerLabel.Visible then
        TweenStart(MonsterSpawners['Commando Chick'].Territory.Value.CFrame, true)
    end
    Temptable.Float = false
    task.wait(5)
    for _ = 1, 10 do
        FetchTokens(Root.Position, 100)
    end
    Temptable.Started.Commando = false
end

function AvoidMobs()
    for _, Monster in next, game:GetService("Workspace").Monsters:GetChildren() do
        if Monster:FindFirstChild("HumanoidRootPart") and Monster:FindFirstChild("Target") and not string.find(Monster.Name, "Mondo Chick") and not string.find(Monster.Name, "Commando Chick") and not string.find(Monster.Name, "Coconut Crab") and not string.find(Monster.Name, "Stump Snail") and not string.find(Monster.Name, "Stick Bug") and not string.find(Monster.Name, "King Beetle") and not string.find(Monster.Name, "Tunnel Bear") then
            if Monster:FindFirstChild("Target").Value == nil or not Monster:FindFirstChild('AimingDir') then continue end
            if tostring(Monster:FindFirstChild("Target").Value) == tostring(Player.Name) and API:Magnitude(Monster.HumanoidRootPart.Position, Root.Position) < 70 and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                if API:Magnitude(Monster.HumanoidRootPart.Position, Root.Position) <= Monster.Config.TargetingDistance.Value and not string.find(Monster.Name, "Mantis") then
                    -- API:WalkTo(Monster.HumanoidRootPart.Position + Vector3.new(Monster.AimingDir.Value.X * Monster.Config.TargetingDistance.Value * 1.5, 0, Monster.AimingDir.Value.Z * Monster.Config.TargetingDistance.Value * 1.5))
                    Humanoid.Jump = true
                elseif API:Magnitude(Monster.HumanoidRootPart.Position, Root.Position) <= Monster.Config.TargetingDistance.Value and string.find(Monster.Name, "Mantis") then
                    API:WalkTo(Monster.HumanoidRootPart.Position + Vector3.new(Monster.AimingDir.Value.X * Monster.Config.TargetingDistance.Value * 0.75, 0, Monster.AimingDir.Value.Z * Monster.Config.TargetingDistance.Value * 0.75))
                    Humanoid.Jump = true
                end
            end
        end
    end
end

function CheckMobsNearby()
    for _, Monster in next, game:GetService("Workspace").Monsters:GetChildren() do
        if Monster:FindFirstChild("Head") and Monster:FindFirstChild("Target") and not string.find(Monster.Name, "Mondo Chick") and not string.find(Monster.Name, "Commando Chick") and not string.find(Monster.Name, "Coconut Crab") and not string.find(Monster.Name, "Stump Snail") and not string.find(Monster.Name, "Stick Bug") and not string.find(Monster.Name, "King Beetle") and not string.find(Monster.Name, "Tunnel Bear") then
            if Monster:FindFirstChild("Target").Value == nil then continue end
            if tostring(Monster:FindFirstChild("Target").Value) == tostring(Player.Name) and API:Magnitude(Monster.Head.Position, Root.Position) < 70 and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                return true
            end
        end
    end
    return false
end

function KillMobs()
    for _, Monster in next, MonsterSpawners:GetChildren() do
        if Monster:FindFirstChild("Territory") and Kometa.Toggles.AutoKillMobs or (Kometa.Toggles.AutoDoQuests and Kometa.Toggles.KillMobsQuest) then
            if Monster.Name ~= "Commando Chick" and Monster.Name ~= "CoconutCrab" and Monster.Name ~= "StumpSnail" and Monster.Name ~= "TunnelBear" and Monster.Name ~= "King Beetle Cave" and not Monster.Name:match("CaveMonster") and not Monster:FindFirstChild("TimerLabel", true).Visible and (table.find(Kometa.Vars.MobsWhitelist, Monster.MonsterType.Value) or (#QuestsList['Defeat Monsters'] > 0 and #TableFilter(QuestsList['Defeat Monsters'], function(Value) return Monster.MonsterType.Value == Value[1] end) > 0 and Kometa.Toggles.KillMobsQuest)) then
                local MonsterPart
                if Monster.Name:match("Werewolf") then
                    MonsterPart = game:GetService("Workspace").Territories.WerewolfPlateau.w
                elseif Monster.Name:match("Mushroom") then
                    MonsterPart = game:GetService("Workspace").Territories.MushroomZone.Part
                else
                    MonsterPart = Monster.Territory.Value
                end
                -- Temptable.Float = true
                -- TweenStart(Root.CFrame * CFrame.new(0, 50, 0))
                -- TweenStart(MonsterPart.CFrame * CFrame.new(0, 50, 0))
                -- TweenStart(MonsterPart.CFrame * CFrame.new(0, 10, 0))
                -- Temptable.Float = false
                Tween(MonsterPart.CFrame, true)
                local TimerLabel = FindTimerLabel(Monster)
                local TimerLabel2 = TimerLabel
                if TwoMobs[Monster.Name] then
                    TimerLabel2 = FindTimerLabel(workspace.MonsterSpawners[TwoMobs[Monster.Name]])
                end
                task.wait(1)
                LogsModify({Action = 'Add', Callback = 'Killing ' .. Monster.Name .. '!'})
                repeat
                    task.wait()
                    AvoidMobs()   
                    if API:Magnitude(MonsterPart.Position, Root.Position) > 70 then
                        Tween(MonsterPart.CFrame, true)
                    end
                until (TimerLabel.Visible and TimerLabel2.Visible) or Humanoid.Health == 0 or (not Kometa.Toggles.AutoKillMobs and (Kometa.Toggles.AutoDoQuests and not Kometa.Toggles.KillMobsQuest))
                task.wait(2)
                --API:Tween(4, MonsterPart.CFrame * CFrame.new(0, 10, 0))
                for _ = 1, 10 do
                    FetchTokens(MonsterPart.Position, 70)
                end
                LogsModify({Action = 'Add', Callback = 'Killed ' .. Monster.Name .. ' and collected tokens!'})
                task.wait(0.15)
            end
        end
    end
end

function KillAnts()
    Temptable.Started.Ant = true
    -- TweenStart(workspace.FlowerZones['Ant Field'].CFrame * CFrame.new(0, 10, 0), true)
    Tween(game:GetService("Workspace").FlowerZones["Ant Field"].CFrame * CFrame.new(0, 10, 0), true)
    Temptable.Float = true
    Kometa.Toggles.AutoDig = true
    local Sides = {Left = true, Right = false}
    local Left_Side = Vector3.new(127, 48, 547)
    local Right_Side = Vector3.new(65, 48, 534)
    Temptable.OldTool = GetPlayerData()['EquippedCollector']
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true, ["Type"] = "Spark Staff", ["Category"] = "Collector"})
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    MakeSprinklers(workspace.FlowerZones['Ant Field'])
    TweenStart(Root.CFrame * CFrame.new(0, 15, 0), false)
    repeat
        task.wait()
        for _, Ant in next, game.Workspace.Toys["Ant Challenge"].Obstacles:GetChildren() do
            if Ant:FindFirstChild("Root") then
                if API:Magnitude(Ant.Root.Position, Root.Position) <= 40 and Sides.Left then
                    API:WalkTo(Left_Side)
                    Sides.Left = false 
                    Sides.Right = true
                    task.wait(4)
                elseif API:Magnitude(Ant.Root.Position, Root.Position) <= 40 and Sides.Right then
                    API:WalkTo(Left_Side)
                    Sides.Left = true 
                    Sides.Right = false
                    task.wait(5)
                end
            end
        end
    until game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value == false or Humanoid.Health == 0
    task.wait(1)
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true, ["Type"] = Temptable.OldTool, ["Category"] = "Collector"})
    Temptable.Float = false
    Temptable.Started.Ant = false
end

game:GetService("Workspace").Particles.ChildAdded:Connect(function(Object)
    if Kometa.Toggles.Autofarm and not Temptable.Converting then
        if Object.Name == 'WarningDisk' and Kometa.Toggles.FarmDisks then
            task.wait(0.2)
            if Object.Color == Color3.fromRGB(50, 255, 50) and API:Magnitude(Object.Position, Root.Position) <= 100 then
                CollectDisk(Object)
            end 
        elseif Object.Name == 'Crosshair' and Kometa.Toggles.CollectCrossHairs then
            task.wait(0.5)
            if Object.BrickColor ~= BrickColor.new('Flint') and API:Magnitude(Object.Position, Root.Position) <= 100 then
                CollectPreciseCH(Object, Object.Color == Color3.fromRGB(119, 85, 255))
            end
        end
    end
end)

game:GetService("Workspace").Particles:FindFirstChild('PopStars').ChildAdded:Connect(function(PopStar)
    task.wait(0.5)
    if API:Magnitude(PopStar.Position, Root.Position) < 20 then
        Temptable.FoundPopStar = true
    end
end)

game:GetService("Workspace").Particles:FindFirstChild('PopStars').ChildRemoved:Connect(function(PopStar)
    if API:Magnitude(PopStar.Position, Root.Position) < 20 then
        Temptable.FoundPopStar = false
    end
end)

-- game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(function(Sprout)
--     if Sprout.Name == "Sprout" then
--         Temptable.Sprouts.Detected = true
--         table.insert(Temptable.Sprouts.Instances, {
--             Field = FindFieldWithRay(Sprout.Position + Vector3.new(0, 5, 0), Vector3.new(0, -200, 0)),
--             Coords = Sprout.CFrame,
--             Sprout = Sprout
--         })
--         if Kometa.Toggles.FarmSprouts then
--             LogsModify({Action = 'Add', Callback = 'Found a Sprout!'})
--         end
--     end
-- end)

-- game:GetService("Workspace").Particles.Folder2.ChildRemoved:Connect(function(Sprout)
--     if Sprout.Name == "Sprout" then
--         if Kometa.Toggles.Autofarm and Kometa.Toggles.FarmSprouts then 
--             Temptable.Stats.FarmedSprouts += 1
--             local OsTime = os.time()
--             repeat
--                 task.wait()
--                 CollectTokens(70)
--             until os.time() - OsTime >= 30 or not (Kometa.Toggles.Autofarm and Kometa.Toggles.FarmSprouts)
--         end
--         for Index, Value in next, Temptable.Sprouts.Instances do
--             if Value.Sprout == Sprout then
--                 table.remove(Temptable.Sprouts.Instances, Index)
--             end
--         end
--         Temptable.Sprouts.Detected = #Temptable.Sprouts.Instances > 0
--     end
-- end)

game:GetService("Workspace").Particles.ChildAdded:Connect(function(Vicious)
    if string.find(Vicious.Name, "Vicious") and not Temptable.Detected.Vicious then
        Temptable.Vicious = Vicious
        Temptable.Detected.Vicious = true
        if Kometa.Webhooking.Vicious then 
            API:ImageHook(KometaWebhook.Webhook, "Vicious Bee detected!", "kometa v2 ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/1/1f/Vicious_Bee.png/revision/latest/scale-to-width-down/350?cb=20181130115012&path-prefix=ru") 
        end
    end
end)

game:GetService("Workspace").Particles.ChildRemoved:Connect(function(Vicious)
    if string.find(Vicious.Name, "Vicious") then
        Temptable.Vicious = nil
        Temptable.Detected.Vicious = false
        if Kometa.Toggles.KillVicious then
            Temptable.Stats.KilledVicious += 1
        end
    end
end)

game:GetService("Workspace").NPCBees.ChildAdded:Connect(function(Windy)
    if string.find(Windy.Name, "Windy") and not Temptable.Detected.Windy then
        Temptable.Windy = Windy 
        Temptable.Detected.Windy = true
        if Kometa.Webhooking.Windy then 
            API:ImageHook(KometaWebhook.Webhook, "Windy Bee detected!", "kometa v2 ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/8/85/Windy_Bee.png/revision/latest?cb=20200404000105") 
        end
    end
end)

game:GetService("Workspace").NPCBees.ChildRemoved:Connect(function(Windy)
    if string.find(Windy.Name, "Windy") then
        task.wait(3) 
        Temptable.Windy = nil 
        Temptable.Detected.Windy = false
        if Kometa.Toggles.KillWindy then
            Temptable.Stats.KilledWindy += 1
        end
    end
end)

game.Players.PlayerAdded:Connect(function(Player)
    if Kometa.Webhooking.PlayerAdded then 
        API:ImageHook(KometaWebhook.Webhook, Player.Name.." joined your server", "kometa v2 ☄️", "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=420&height=420&format=png") 
    end
end)

game.Players.PlayerRemoving:Connect(function(Player)
    if Player.Name ~= game.Players.LocalPlayer.Name then return end 
    if Kometa.Webhooking.ConnectionLost then API:ImageHook(KometaWebhook.Webhook, "You've been disconnected!\n"..GenerateWebhookText(), "kometa v2 ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/7/7f/Eviction.png/revision/latest?cb=20200403235248") end
end)

local function RespawnFunction()
    Temptable.Float = false
    if Kometa.Toggles.Autofarm then
        Temptable.Dead = true
        Kometa.Toggles.Autofarm = false
        Temptable.Converting = false
    end
    if Temptable.Dead then
        task.wait(25)
        Temptable.Dead = false
        Kometa.Toggles.Autofarm = true
        Temptable.Converting = false
    end
end

Humanoid.Died:Connect(RespawnFunction)

Player.CharacterAdded:Connect(function(Char)
    Character = API:Character()
    Root = API:Root()
    Humanoid = API:Humanoid()
    Player.DevComputerMovementMode = Enum.DevComputerMovementMode.UserChoice
    Humanoid.Died:Connect(RespawnFunction)
    PollenBar = Player.PlayerGui.ScreenGui.MeterHUD.PollenMeter.Bar.FillBar
end)

Player.PlayerGui.ScreenGui.Alerts.ChildAdded:Connect(function(Object)
    task.wait(0.03)
    if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
        if string.find(Object.Text, "Defeated") then
            Temptable.Stats.KilledMobs += 1
        elseif string.find(Object.Text, "Ticket") then
            local Amount = tonumber(string.sub(Object.Text, 2, 2)) or 1
            Temptable.Stats.CollectedTickets += Amount
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Temptable.Collecting.Tickets or Temptable.Collecting.Rares then continue end
        if Kometa.Toggles.Autofarm and not Temptable.DontFarm then
            if Kometa.Toggles.KillMondo then
                KillMondo()
            end
            CollectPlanters()
            PlantPlanters()
            if (Kometa.Toggles.AutoKillMobs or (#QuestsList['Defeat Monsters'] > 0 and Kometa.Toggles.KillMobsQuest)) and not Temptable.Started.KillMobs and not CheckCombatSettings() then 
                if (os.time() - Temptable.CurrentTime >= Kometa.Vars.MonsterTimer and #Kometa.Vars.MobsWhitelist > 0) or (#QuestsList['Defeat Monsters'] > 0 and Kometa.Toggles.KillMobsQuest) then
                    Temptable.Started.KillMobs = true
                    KillMobs()
                    Temptable.CurrentTime = os.time()
                    Temptable.Started.KillMobs = false
                end
            end
            if (Kometa.Toggles.AutoAnt or (Kometa.Toggles.AutoDoQuests and Kometa.Toggles.DoAntQuests and #QuestsList['Defeat Monsters'] > 0 and #TableFilter(QuestsList['Defeat Monsters'], function(Value) return string.find(Value[1], 'Ant') end) > 0)) and not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and (GetPlayerData().Eggs.AntPass or 0) > 0 then 
                KillAnts() 
            end
            if not CheckCombatSettings() then
                FieldSelected = game:GetService("Workspace").FlowerZones[Kometa.Vars.Field]
                local FieldPosition = FieldSelected.Position
                local FieldPos = FieldSelected.CFrame * CFrame.new(0, 3, 0)
                if Kometa.Toggles.AutoQuest then ClaimQuests() end
                if Kometa.Toggles.AutoDoQuests then  
                    if PollenTask then
                        FieldSelected = game:GetService("Workspace").FlowerZones[PollenTask[1]]
                        FieldPosition = FieldSelected.Position
                        FieldPos = FieldSelected.CFrame * CFrame.new(0, 3, 0)
                    elseif #QuestsList['Collect Pollen'] > 0 or #QuestsList['Collect Goo'] > 0 then
                        PollenTask = QuestsList['Collect Goo'][1] or QuestsList['Collect Pollen'][1]
                        FieldSelected = game:GetService("Workspace").FlowerZones[PollenTask[1]]
                        FieldPosition = FieldSelected.Position
                        FieldPos = FieldSelected.CFrame * CFrame.new(0, 3, 0)
                        if PollenTask then
                            LogsModify({Action = 'Add', Callback = 'Set Auto Do Quest - Pollen Task to '..PollenTask[1]})
                        end
                    end
                    -- if PollenTask then
                    --     FieldSelected = game:GetService("Workspace").FlowerZones[PollenTask[1]]
                    --     FieldPosition = FieldSelected.Position
                    --     FieldPos = FieldSelected.CFrame * CFrame.new(0, 3, 0)
                    -- else
                    --     table.sort(QuestsList)
                    --     for _, Quest in next, QuestsList do
                    --         for _, QuestTask in next, Quest do
                    --             if QuestTask and (QuestTask[2] == 'Collect Pollen' or QuestTask[2] == 'Collect Goo') and not table.find(Kometa.BlacklistedFields, QuestTask[1]) then
                    --                 PollenTask = QuestTask
                    --                 FieldSelected = game:GetService("Workspace").FlowerZones[PollenTask[1]]
                    --                 FieldPosition = FieldSelected.Position
                    --                 FieldPos = FieldSelected.CFrame * CFrame.new(0, 3, 0)
                    --                 continue
                    --             end
                    --         end
                    --     end
                    --     if PollenTask then
                    --         LogsModify({Action = 'Add', Callback = 'Set Auto Do Quest - Pollen Task to '..PollenTask[1]})
                    --     end
                    -- end
                end
                if CheckForSprout() then
                    local Sprout = Temptable.Sprouts.Instances[1]
                    FieldSelected = FindFieldWithRay(Sprout.Coords.Position + Vector3.new(0, 5, 0), Vector3.new(0, -200, 0))
                    FieldPosition = Sprout.Coords.Position
                    FieldPos = Sprout.Coords
                end
                --if --(Kometa.Toggles.ConvertPollen and (PollenBar.Size.X.Scale * 100 >= Kometa.Vars.ConvertAt or (Temptable.ConvetingTime + Kometa.Vars.ConvertAfter <= os.time() and Kometa.Toggles.ToggleConvertAfter))) and not (CheckForSprout() and Kometa.Toggles.FarmSprouts) then
                if ((Kometa.Toggles.ConvertPollen and PollenBar.Size.X.Scale * 100 >= Kometa.Vars.ConvertAt) or (Temptable.ConvetingTime + Kometa.Vars.ConvertAfter <= os.time() and Kometa.Toggles.ToggleConvertAfter)) and not (CheckForSprout() and Kometa.Toggles.FarmSprouts) then
                    ConvertPollen()
                    if Temptable.ConvetingTime + Kometa.Vars.ConvertAfter <= os.time() and Kometa.Toggles.ToggleConvertAfter then Temptable.ConvetingTime = os.time() end
                    if Kometa.Toggles.RotateFields then
                        Kometa.Vars.Field = FieldsTable[table.find(FieldsTable, Kometa.Vars.Field) + 1] or FieldsTable[1]
                    end
                else--if PollenBar.Size.X.Scale * 100 < Kometa.Vars.ConvertAt or (not Kometa.Toggles.ConvertPollen and not CheckForSprout()) then
                    Humanoid.AutoRotate = not (Kometa.Toggles.FaceBalloons or Kometa.Toggles.FaceFlames or Kometa.Toggles.FaceCenter)
                    if CheckForPuffshrooms() and not CheckCombatSettings() then
                        pcall(function()
                            CollectPuffshrooms()
                        end)
                        continue
                    end
                    if Kometa.Toggles.FarmFireflies and workspace.NPCBees:FindFirstChild("Firefly") and not CheckCombatSettings() then
                        CollectFireflies()
                        continue
                    end
                    if Kometa.Toggles.FarmSparkles and Flowers:FindFirstChild("Sparkles", true) and not CheckCombatSettings() then
                        CollectSparkles()
                        continue
                    end
                    if Kometa.Toggles.AvoidMobs and CheckMobsNearby() then 
                        AvoidMobs() 
                        continue
                    end
                    if API:Magnitude(FieldPosition, Root.Position) >= 100 then
                        Tween(FieldPos)
                        if Kometa.Toggles.AutoSprinkler then
                            MakeSprinklers(FieldSelected)
                        end
                    end
                    if Kometa.Toggles.FarmDuped and not (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) then 
                        CollectDuped()
                    end
                    if Kometa.Toggles.FarmBubbles then 
                        CollectBubbles() 
                    end
                    if Kometa.Toggles.FarmFuzzy and not (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) then
                        CollectFuzzyBombs()
                    end
                    if Kometa.Toggles.FarmFlame and not (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) then 
                        CollectFlames() 
                    end
                    if Kometa.Toggles.FarmBalloons then 
                        CollectUnderBalloons() 
                    end
                    if Kometa.Toggles.FarmClouds and not (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar) then 
                        CollectClouds() 
                    end
                    if not (Kometa.Toggles.BloatFarm and Temptable.FoundPopStar and not CheckForSprout()) then
                        WalkOnField(FieldPosition, 30)
                        CollectTokens(60)
                    end
                end
            end
        end
    end
end)


task.spawn(function()
    while task.wait(15) do
        RefreshQuests()
        UseDispensers()
        UseItems()
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Kometa.Toggles.AutoDoQuests and Kometa.Toggles.DoFoodQuests then
            if #QuestsList['Feed Bees'] > 0 then
                local FeedTask = QuestsList['Feed Bees'][1]
                Temptable.Feed(1, 1, FeedTask[1], FeedTask[2])
                table.remove(QuestsList['Feed Bees'], 1)
            end
        end
        if CheckPriority() and Kometa.Toggles.KillVicious and not Temptable.Collecting.Planter and not Temptable.DontFarm and not Temptable.Converting then
            KillVicious()
        elseif not Temptable.Collecting.Planter and not Temptable.DontFarm and not Temptable.Converting then
            if Kometa.Toggles.KillVicious and Temptable.Detected.Vicious and not Temptable.Started.Vicious then
                KillVicious()
            end
            if Kometa.Toggles.KillWindy and Temptable.Detected.Windy and not Temptable.Started.Windy then
                KillWindy()
            end
            if Kometa.Toggles.KillCommando and not MonsterSpawners['Commando Chick'].Attachment.TimerGui.TimerLabel.Visible then
                KillCommando()
            end
        end
        if Kometa.Toggles.TrainCrab and not Kometa.Toggles.TrainSnail and Temptable.ReadyForCrab then 
            FetchTokens(CFrame.new(-256, 110, 475).Position, 50)
            API:WalkTo(CFrame.new(-256, 110, 475).Position)
            Temptable.Float = true
            if API:Magnitude(CFrame.new(-256, 110, 475).Position, Root.Position) > 30 and Kometa.Toggles.TrainCrab then -- math.abs(Root.Position.Y - 110) >= 5
                TweenStart(CFrame.new(-256, 110, 475), false)
            end
        end
        if Kometa.Toggles.TrainSnail and not Kometa.Toggles.TrainCrab then 
            FetchTokens(game.Workspace.FlowerZones['Stump Field'].Position, 25)
            API:WalkTo(game.Workspace.FlowerZones['Stump Field'].Position + Vector3.new(0, 3, 0), 0)
            if API:Magnitude(Root.Position, game.Workspace.FlowerZones['Stump Field'].Position + Vector3.new(0, 3, 0)) > 30 then
                TweenStart(CFrame.new(game.Workspace.FlowerZones['Stump Field'].Position + Vector3.new(0, 3, 0)))
            end
        end
        if Kometa.Toggles.AutoMask and Root then
            if FindFieldWithRay(Root.Position, Vector3.new(0, -90, 0)) then
                local MaskField = FindFieldWithRay(Root.Position, Vector3.new(0, -90, 0))
                local FieldColor
                if MaskField:FindFirstChild("ColorGroup") then FieldColor = MaskField:FindFirstChild("ColorGroup").Value else FieldColor = 'White' end
                if Temptable.LastFieldColor == FieldColor then continue end
                Temptable.LastFieldColor = FieldColor
                if FieldColor == 'Blue' then
                    MaskEquip('Bubble Mask')
                    MaskEquip('Diamond Mask')
                elseif FieldColor == 'Red' then
                    MaskEquip('Fire Mask')
                    MaskEquip('Demon Mask')
                else
                    MaskEquip('Honey Mask')
                    MaskEquip('Gummy Mask')
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        repeat task.wait() until Kometa.Toggles.Autokick
        task.delay(Kometa.Vars.AutokickDelay * 60, function()
            if Kometa.Vars.AutokickMode == 'Kick' then
                Player:Kick("kometa v2 - Auto-kicked after "..Kometa.Vars.AutokickDelay.." minutes")
            else
                game:Shutdown()
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        Temptable.Stats.ElapsedTime += 1
        Temptable.Stats.HoneyCurrent = GetPlayerData().Totals.Honey

        --local SusActions = GetPlayerData()
        local Categories = game:GetService("CoreGui").FinityUI.Container.Categories
        local Statistics = Categories.Statistics:FindFirstChild("Player Statistics", true).Container
        local Luarmor_Info = nil
        -- local QuestStatistics = game:GetService("CoreGui").FinityUI.Container.Categories.Statistics:FindFirstChild("Statistics", true).Container
        local MobTimers = Categories.Statistics:FindFirstChild("Mob Timers", true).Container

        Statistics["⏳ Elapsed Time: "].Title.Text = "⏳ Elapsed Time: "..API:ToHMS(Temptable.Stats.ElapsedTime)
        Statistics["🍯 Honey: "].Title.Text = "🍯 Honey: "..API:SuffixString(Temptable.Stats.HoneyCurrent - Temptable.Stats.HoneyStart)
        Statistics["⏳ Honey Per Hour: "].Title.Text = "⏳ Honey Per Hour: "..API:SuffixString(math.floor((Temptable.Stats.HoneyCurrent - Temptable.Stats.HoneyStart) / Temptable.Stats.ElapsedTime * 3600))
        Statistics["⏳ Honey Per Day: "].Title.Text = "⏳ Honey Per Day: "..API:SuffixString(math.floor((Temptable.Stats.HoneyCurrent - Temptable.Stats.HoneyStart) / Temptable.Stats.ElapsedTime * 86400))
        Statistics["🎫 Collected Tickets: "].Title.Text = "🎫 Collected Tickets: "..Temptable.Stats.CollectedTickets
        Statistics["🕷️ Killed Mobs: "].Title.Text = "🕷️ Killed Mobs: "..Temptable.Stats.KilledMobs
        Statistics["🌱 Sprouts Collected: "].Title.Text = "🌱 Sprouts Collected: "..Temptable.Stats.FarmedSprouts
        Statistics["⚠️ Killed Vicious: "].Title.Text = "⚠️ Killed Vicious: "..Temptable.Stats.KilledVicious
        Statistics["🌪️ Killed Windy: "].Title.Text = "🌪️ Killed Windy: "..Temptable.Stats.KilledWindy
        Statistics["🐥 Killed Mondo: "].Title.Text = "🐥 Killed Mondo: "..Temptable.Stats.KilledMondo

        -- QuestStatistics["📃 Quest Name: "].Title.Text = "📃 Quest Name: "
        -- QuestStatistics[" ∟ Quest NPC: "].Title.Text = " ∟ Quest NPC: "
        -- QuestStatistics[" ∟ Task Description: "].Title.Text = " ∟ Task Description: "
        -- QuestStatistics[" ∟ Task Needed: "].Title.Text = " ∟ Task Needed: "

        UpdateTimer(MobTimers["Clover Beetle: Alive! ✅"].Title, MonsterSpawners["Rhino Bush"])
        UpdateTimer(MobTimers["Clover Ladybug: Alive! ✅"].Title, MonsterSpawners["Ladybug Bush"])
        UpdateTimer(MobTimers["Blue Flower Beetle: Alive! ✅"].Title, MonsterSpawners["Rhino Cave 1"])
        UpdateTimer(MobTimers["Bamboo Beetle: Alive! ✅"].Title, MonsterSpawners["Rhino Cave 2"])
        UpdateTimer(MobTimers["Bamboo Beetle 2: Alive! ✅"].Title, MonsterSpawners["Rhino Cave 3"])
        UpdateTimer(MobTimers["Pineapple Beetle: Alive! ✅"].Title, MonsterSpawners["PineappleBeetle"])
        UpdateTimer(MobTimers["Pineapple Mantis: Alive! ✅"].Title, MonsterSpawners["PineappleMantis1"])
        UpdateTimer(MobTimers["Spider: Alive! ✅"].Title, MonsterSpawners["Spider Cave"])
        UpdateTimer(MobTimers["Mushroom Ladybug: Alive! ✅"].Title, MonsterSpawners["MushroomBush"])
        UpdateTimer(MobTimers["Strawberry Ladybug: Alive! ✅"].Title, MonsterSpawners["Ladybug Bush 2"])
        UpdateTimer(MobTimers["Strawberry Ladybug 2: Alive! ✅"].Title, MonsterSpawners["Ladybug Bush 3"])
        UpdateTimer(MobTimers["Rose Scorpion: Alive! ✅"].Title, MonsterSpawners["ScorpionBush"])
        UpdateTimer(MobTimers["Rose Scorpion 2: Alive! ✅"].Title, MonsterSpawners["ScorpionBush2"])
        UpdateTimer(MobTimers["Werewolf: Alive! ✅"].Title, MonsterSpawners["WerewolfCave"])
        UpdateTimer(MobTimers["Pine Tree Mantis: Alive! ✅"].Title, MonsterSpawners["ForestMantis1"])
        UpdateTimer(MobTimers["Pine Tree Mantis 2: Alive! ✅"].Title, MonsterSpawners["ForestMantis2"])

        UpdateTimer(MobTimers["King Beetle: Alive! ✅"].Title, MonsterSpawners["King Beetle Cave"])
        UpdateTimer(MobTimers["Tunnel Bear: Alive! ✅"].Title, MonsterSpawners["TunnelBear"])
        UpdateTimer(MobTimers["Snail: Alive! ✅"].Title, MonsterSpawners["StumpSnail"])
        UpdateTimer(MobTimers["Coconut Crab: Alive! ✅"].Title, MonsterSpawners["CoconutCrab"])

        if Categories:FindFirstChild("Debug") then
            Luarmor_Info = Categories.Debug:FindFirstChild("Luarmor Stats", true).Container

            Luarmor_Info["Linked Discord ID:"].Title.Text = "Linked Discord ID: "..(LRM_LinkedDiscordID or 'Unknown')
            Luarmor_Info["Your Total Exectutions:"].Title.Text = "Your Total Exectutions: "..(LRM_TotalExecutions or 'Unknown')
            Luarmor_Info["Time Left:"].Title.Text = "Time Left: "..(API:ToHMS(LRM_SecondsLeft or 0) or 'Unknown')
            Luarmor_Info["User Note:"].Title.Text = "User Note: "..(LRM_UserNote or 'Unknown')
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Kometa.BeesSettings.UsbToggle then
            HatchUntilSelected(Kometa.BeesSettings.General.X, Kometa.BeesSettings.General.Y, Kometa.BeesSettings.UntilSelectedBee)
        end
        if Kometa.BeesSettings.FoodUntilGifted then
            UntilGifted(Kometa.BeesSettings.General.X, Kometa.BeesSettings.General.Y, Kometa.BeesSettings.FoodType, Kometa.BeesSettings.General.Amount)
        end
        if Kometa.BeesSettings.AutoFeed then
            Temptable.Feed(Kometa.BeesSettings.General.X, Kometa.BeesSettings.General.Y, Kometa.BeesSettings.FoodType, Kometa.BeesSettings.General.Amount)
        end
        if Kometa.BeesSettings.UntilMutation then
            MutationFeed(Kometa.BeesSettings.General.X, Kometa.BeesSettings.General.Y, Kometa.BeesSettings.Mutation, Kometa.BeesSettings.General.Amount)
        end
        if Kometa.Toggles.AutoDonate then
            game.ReplicatedStorage.Events.WindShrineDonation:InvokeServer(Kometa.Vars.DonatIt[1], Kometa.Vars.DonatIt[2])
            if not Kometa.Toggles.DontSpawnDrop then
                game.ReplicatedStorage.Events.WindShrineTrigger:FireServer() 
                Temptable.Collecting.Rares = true
                TweenStart(CFrame.new(Vector3.new(-484, 146, 413)))
                task.wait(5)
                FetchTokens(Vector3.new(-484, 146, 413), 35)
                task.wait(1)
                Temptable.Collecting.Rares = false
            end
        end
        if Kometa.Toggles.AutoDig then 
            if Player and Character and Character:FindFirstChildOfClass("Tool") then  
                pcall(function()
                    getsenv(Character:FindFirstChildOfClass('Tool').ClientScriptMouse).collectStart()
                end)
            end
        end
        if Kometa.Toggles.VisualNight then
            game:GetService("Lighting").TimeOfDay = '00:00:00'
            game:GetService("Lighting").Brightness = 0.03
            game:GetService("Lighting").ClockTime = 0
        end
    end
end)

task.spawn(function()
    while task.wait() do
        local Position = Root.Position
        task.wait(0.00001)
        local currentSpeed = API:Magnitude(Position, Root.Position)
        if currentSpeed > 0 then
            Temptable.Running = true
        else
            Temptable.Running = false
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Temptable.Running then
            PlayerRotate()
        end
        if Kometa.Toggles.AutoQuest then
            firesignal(Player.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click)
        end
    end
end)

game:GetService('RunService').Heartbeat:Connect(function()
    pcall(function()
        if Kometa.Toggles.LoopSpeed and not (CheckCombatSettings() and not Kometa.Toggles.AutoKillMobs and not Temptable.Started.Windy ) then 
            Humanoid.WalkSpeed = Kometa.Vars.WalkSpeed
        end
        if Kometa.Toggles.LoopJump and not (CheckCombatSettings() and not Kometa.Toggles.AutoKillMobs and not Temptable.Started.Windy) then 
            Humanoid.JumpPower = Kometa.Vars.JumpPower
        end
        for _, MinigameLayer in next, game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do 
            for _, Object in next, MinigameLayer:WaitForChild("GuiGrid"):GetDescendants() do 
                if Object.Name == "ObjContent" or Object.Name == "ObjImage" then 
                    Object.Visible = true 
                end 
            end 
        end
        if Temptable.Float then
            Humanoid:ChangeState(11)
        end
    end)
end)

task.spawn(function() 
    while task.wait(1) do
        if LRM_SecondsLeft then
            local LRM_SecondsLeft = LRM_SecondsLeft - 1;
            if LRM_SecondsLeft > 0 and LRM_SecondsLeft < 5 then
                Kometa = DefaultKometa
                game.CoreGui.FinityUI:Destroy()
            end
        end
    end 
end)

-- // UI \\
local UI = LibraryUI.new(true, "kometa ☄️ | " .. Temptable.Version)
UI.ChangeToggleKey(Enum.KeyCode.Semicolon)

function DebugMode()
    game:GetService("CoreGui").FinityUI.Container.Categories.Home:FindFirstChild("Main", true).Container['Enable Debug Mode']:Destroy()
    local Debug_Category = UI:Category('Debug')

    local Logs = Debug_Category:Sector('Logs')
    Logs:Cheat('Toggle', 'Disable Actions Logs', function(State) Kometa.Toggles.DisableActionLogs = State end)
    Logs:Cheat("Button", "Save Logs", function() SaveLogs() end, { text = "Save Logs" })

    local Luarmor_Stats = Debug_Category:Sector('Luarmor Stats')
    Luarmor_Stats:Cheat('Label', 'Linked Discord ID:')
    Luarmor_Stats:Cheat('Label', 'Your Total Exectutions:')
    Luarmor_Stats:Cheat('Label', 'Time Left:')
    Luarmor_Stats:Cheat('Label', 'User Note:')

    local Websocket_Debug = Debug_Category:Sector('Websocket')
    Websocket_Debug:Cheat('Button', 'Reconnect To Websocket', function() Temptable.WebSocket:Close() WebsocketConnect() end, { text = "Reconnect" })
end

local Home_Category = UI:Category("Home")
local Farming_Category = UI:Category("Farming")
local AutoQuests_Category = UI:Category("Quests")
local Planters_Category = UI:Category("Planters")
local Combat_Category = UI:Category("Combat")
local Statistics_Category = UI:Category("Statistics")
local Hive_Category = UI:Category("Hive")
local Misc_Category = UI:Category("Misc")
local Extra_Category = UI:Category("Extra")
--local Visual_Category = UI:Category("Visual")
local Configs_Category = UI:Category("Configs")
local Settings_Category = UI:Category("Settings")

local Main = Home_Category:Sector("Main")
Main:Cheat("Label", "Thanks you for using our script!")
Main:Cheat("Label", "Script version: "..Temptable.Version)
Main:Cheat("Button", "Enable Debug Mode", function() DebugMode() end, { text = "Enable" })

local Signs = Home_Category:Sector("Signs")
Signs:Cheat("Label", "⚠️ - High Chance Of Getting Flag")
Signs:Cheat("Label", "⚙ - Configurable Function")
Signs:Cheat("Label", "🛠️ - Beta Function")

local Credits = Home_Category:Sector("Credits")
Credits:Cheat("Label", "Scripters: notweuz#0001 & cryptozen")
Credits:Cheat("Label", "OG UI Library: detourious @ v3rmillion.net")
Credits:Cheat("Label", "Modified UI Library: cryptozen")
Credits:Cheat("Label", "Websocket Functions: Феня♡#2033")
Credits:Cheat("Label", "Pathfinding Helping & Force Walk: xZyn#7946")

local Links = Home_Category:Sector("Links")
Links:Cheat("Button", "Discord Server", function() setclipboard("https://discord.gg/2a5gVpcpzv") end, { text = "" })
Links:Cheat("Button", "Token IDs", function() setclipboard("https://kometa.pw/token-ids") end, { text = "" })

local Farm = Farming_Category:Sector("Farming")
Farm:Cheat("Dropdown", "Field", function(Option) Kometa.Vars.Field = Option end, { options = FieldsTable })
Farm:Cheat("Checkbox", " ∟ Rotate Fields", function(State) Kometa.Toggles.RotateFields = State end)
Farm:Cheat("Checkbox", "Autofarm", function(State) Humanoid.AutoRotate = not State Kometa.Toggles.Autofarm = State if Temptable.Path == nil then Player.DevComputerMovementMode = Enum.DevComputerMovementMode.UserChoice end end)
Farm:Cheat("Checkbox", " ∟ Ignore Honey Token", function(State) 
    if State then
        table.insert(Kometa.BlacklistTokens, '1472135114')
    else
        table.remove(Kometa.BlacklistTokens, API:TableFind(Kometa.BlacklistTokens, '1472135114'))
    end
end)
Farm:Cheat("Checkbox", "Convert Pollen", function(State) Kometa.Toggles.ConvertPollen = State end)
Farm:Cheat("Checkbox", " ∟ Auto Equip Honey Mask", function(State) Kometa.Toggles.AutoEquipHoneyMask = State end)
Farm:Cheat("Slider", " ∟ Convert at:", function(Value) Kometa.Vars.ConvertAt = Value end, { min = 0, max = 100, suffix = "%", default = 100 })
Farm:Cheat("Checkbox", " ∟ Convert Hive Balloon", function(State) Kometa.Toggles.ConvertBalloons = State end)
Farm:Cheat("Textbox", " ∟ Convert After", function(Value) Kometa.Vars.ConvertAfter = tonumber(Value or 0)*60 end, { placeholder = "Minutes" })
Farm:Cheat("Checkbox", "    ∟ Enable", function(State) Kometa.Toggles.ToggleConvertAfter = State end)
Farm:Cheat("Checkbox", "Catch Duped Tokens", function(State) Kometa.Toggles.FarmDuped = State end)
Farm:Cheat("Checkbox", " ∟ Only Faces", function(State) Kometa.Toggles.CollectOnlyFaces = State end)
Farm:Cheat("Checkbox", "Catch Coconuts & Shower", function(State) Kometa.Toggles.FarmDisks = State end)
Farm:Cheat("Checkbox", "Catch Precise Crosshairs", function(State) Kometa.Toggles.CollectCrossHairs = State end)
Farm:Cheat("Checkbox", " ∟ Smart Mode", function(State) Kometa.Toggles.SmartCrosshairs = State end)
Farm:Cheat("Slider", " ∟ Stand In Crosshair at % Backpack ", function(Value) Kometa.Vars.StandCrosshairAt = Value end, { min = 0, max = 100, suffix = "%", default = 100, text_scale = 12 })
Farm:Cheat("Checkbox", "Catch Fuzzy Bombs", function(State) Kometa.Toggles.FarmFuzzy = State end)

local Farm_Second = Farming_Category:Sector("Farm Features")
Farm_Second:Cheat("Checkbox", "Auto Dig", function(State) Kometa.Toggles.AutoDig = State end)
Farm_Second:Cheat("Checkbox", "Auto Sprinkler", function(State) Kometa.Toggles.AutoSprinkler = State end)
Farm_Second:Cheat("Checkbox", "Auto Mask", function(State) Kometa.Toggles.AutoMask = State end)
Farm_Second:Cheat("Checkbox", "Auto Micro-Converter", function(State) Kometa.Toggles.AutoMicroConverter = State end)
Farm_Second:Cheat("Checkbox", "Auto Ticket Conversion", function(State) Kometa.Toggles.AutoTicketConverter = State end)
Farm_Second:Cheat("Checkbox", "Auto Dispenser ⚙", function(State) Kometa.Toggles.AutoDispenser = State end)
Farm_Second:Cheat("Checkbox", " ∟ Auto Field Boosters ⚙", function(State) Kometa.Toggles.AutoBoosters = State end)
Farm_Second:Cheat("Checkbox", "Farm Sprouts", function(State) Kometa.Toggles.FarmSprouts = State end)
Farm_Second:Cheat("Checkbox", "Farm Puffshrooms", function(State) Kometa.Toggles.FarmPuffshrooms = State end)

local Farm_Third = Farming_Category:Sector("Farm Settings")
Farm_Third:Cheat("Checkbox", "Farm Bubbles", function(State) Kometa.Toggles.FarmBubbles = State end)
Farm_Third:Cheat("Checkbox", " ∟ Bubble Bloat Helper", function(State) Kometa.Toggles.BloatFarm = State end)
-- Farm_Third:Cheat("Checkbox", "Farm Snowflakes ⚠️", function(State) Kometa.Toggles.FarmSnowflakes = State end)
Farm_Third:Cheat("Checkbox", "Farm Sparkles", function(State) Kometa.Toggles.FarmSparkles = State end)
Farm_Third:Cheat("Checkbox", "Farm Fireflies", function(State) Kometa.Toggles.FarmFireflies = State end)
Farm_Third:Cheat("Checkbox", "Farm Under Clouds", function(State) Kometa.Toggles.FarmClouds = State end)
Farm_Third:Cheat("Checkbox", "Farm Under Balloons", function(State) Kometa.Toggles.FarmBalloons = State end)
Farm_Third:Cheat("Checkbox", "Face Balloons", function(State) Kometa.Toggles.FaceBalloons = State end)
Farm_Third:Cheat("Checkbox", "Farm Flames", function(State) Kometa.Toggles.FarmFlame = State end)
Farm_Third:Cheat("Checkbox", "Face Flames", function(State) Kometa.Toggles.FaceFlames = State end)
--Farm_Third:Cheat("Checkbox", "Face Center Field", function(State) Kometa.Toggles.FaceCenter = State end)

local Farm_Fourth = Farming_Category:Sector("Beesmas Features")
Farm_Fourth:Cheat("Checkbox", 'Auto Samovar', function(State) Kometa.BeesmasDispenserSettings['Samovar'] = State end)
Farm_Fourth:Cheat("Checkbox", 'Auto Stockings', function(State) Kometa.BeesmasDispenserSettings['Stockings'] = State end)
Farm_Fourth:Cheat("Checkbox", 'Auto Onett`s Lid Art', function(State) Kometa.BeesmasDispenserSettings["Onett's Lid Art"] = State end)
Farm_Fourth:Cheat("Checkbox", 'Auto Honeyday Candles', function(State) Kometa.BeesmasDispenserSettings['Honeyday Candles'] = State end)
Farm_Fourth:Cheat("Checkbox", 'Auto Beesmas Feast', function(State) Kometa.BeesmasDispenserSettings['Beesmas Feast'] = State end)
Farm_Fourth:Cheat("Checkbox", 'Auto Snow Machine', function(State) Kometa.BeesmasDispenserSettings['Snow Machine'] = State end)

local Farm_Fifth = Farming_Category:Sector("Toys Features")
Farm_Fifth:Cheat("Checkbox", 'Auto Honeystorm', function(State) Kometa.ToysSettings['Honeystorm'] = State end)
Farm_Fifth:Cheat("Checkbox", 'Auto Sprout Summoner', function(State) Kometa.ToysSettings['Sprout Summoner'] = State end)
Farm_Fifth:Cheat("Checkbox", 'Auto Wealth Clock', function(State) Kometa.ToysSettings['Wealth Clock'] = State end)
Farm_Fifth:Cheat("Checkbox", 'Auto Free Ant Pass', function(State) Kometa.ToysSettings['Free Ant Pass Dispenser'] = State end)
Farm_Fifth:Cheat("Checkbox", 'Auto Free Robo Pass', function(State) Kometa.ToysSettings['Free Robo Pass Dispenser'] = State end)

local Quests_Settings = AutoQuests_Category:Sector("Auto Quest Settings")
Quests_Settings:Cheat("Checkbox", "Auto Accept/Confirm Quests 🛠️", function(State) Kometa.Toggles.AutoQuest = State end)
Quests_Settings:Cheat("Checkbox", "Auto Do Quests 🛠️", function(State) Kometa.Toggles.AutoDoQuests = State end)
Quests_Settings:Cheat("Checkbox", " ∟ Do Defeat Ants Quests", function(State) Kometa.Toggles.DoAntQuests = State end)
Quests_Settings:Cheat("Checkbox", " ∟ Do Food Quests", function(State) Kometa.Toggles.DoFoodQuests = State end)
Quests_Settings:Cheat("Checkbox", " ∟ Do Monster Quests", function(State) Kometa.Toggles.KillMobsQuest = State end)
Quests_Settings:Cheat("MultiDropdown", "Do NPC Quests", function(Option) Kometa.Vars.NpcPrefer = Option end, {options = {'Black Bear', 'Mother Bear', 'Brown Bear', 'Panda Bear', 'Science Bear', 'Polar Bear', 'Spirit Bear', 'Bucko Bee', 'Riley Bee', 'Onett'}})

local Field_Settings = AutoQuests_Category:Sector("Fields Settings")
Field_Settings:Cheat("Dropdown", "Best White Field", function(Option) Kometa.BestFields.White = Option end, {options = Temptable.WhiteFields})
Field_Settings:Cheat("Dropdown", "Best Red Field", function(Option) Kometa.BestFields.Red = Option end, {options = Temptable.RedFields})
Field_Settings:Cheat("Dropdown", "Best Blue Field", function(Option) Kometa.BestFields.Blue = Option end, {options = Temptable.BlueFields})
-- Field_Settings:Cheat("Button", "Add Field To Blacklist", function() table.insert(Kometa.BlacklistedFields, Temptable.BlackField) game:GetService("CoreGui").FinityUI.Container.Categories.Quests:FindFirstChild("Fields Settings", true).Container["Blacklisted Fields"]:Destroy() Field_Settings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, {options = Kometa.BlacklistedFields}) end, {text = ' '})
-- Field_Settings:Cheat("Button", "Remove Field From Blacklist", function() table.remove(Kometa.BlacklistedFields, API:TableFind(Kometa.BlacklistedFields, Temptable.BlackField)) game:GetService("CoreGui").FinityUI.Container.Categories.Quests:FindFirstChild("Fields Settings", true).Container["Blacklisted Fields"]:Destroy() Field_Settings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, {options = Kometa.BlacklistedFields}) end, {text = ' '})
Field_Settings:Cheat("MultiDropdown", "Blacklisted Fields", function(Option) Kometa.BlacklistedFields = Option end, {options = FieldsTable})

local Planter_First = Planters_Category:Sector("First Planter")
Planter_First:Cheat("Dropdown", "Planter", function(Option) Kometa.PlanterSettings[1].Type = Option end, {options = require(game:GetService("ReplicatedStorage").PlanterTypes).INVENTORY_ORDER})
Planter_First:Cheat("Dropdown", "Field", function(Option) Kometa.PlanterSettings[1].Field = Option end, {options = FieldsTable})
Planter_First:Cheat("Dropdown", "Nectar", function(Option) Kometa.PlanterSettings[1].Nectar = Option end, {options = NectarsList})
Planter_First:Cheat("Dropdown", "Plant Planter Mode", function(Option) Kometa.PlanterSettings[1].PlantMode = Option end, {options = { 'Field', 'Nectar' }})
Planter_First:Cheat("Slider", "Growth Percent", function(Value) Kometa.PlanterSettings[1].Growth = tonumber(Value) / 100 or 1 end, {min = 0, max = 100, suffix = "%", default = 100})
Planter_First:Cheat("Checkbox", "Auto Plant", function(State) Kometa.PlanterSettings[1].Enabled = State end)

local Planter_Second = Planters_Category:Sector("Second Planter")
Planter_Second:Cheat("Dropdown", "Planter", function(Option) Kometa.PlanterSettings[2].Type = Option end, {options = require(game:GetService("ReplicatedStorage").PlanterTypes).INVENTORY_ORDER})
Planter_Second:Cheat("Dropdown", "Field", function(Option) Kometa.PlanterSettings[2].Field = Option end, {options = FieldsTable})
Planter_Second:Cheat("Dropdown", "Nectar", function(Option) Kometa.PlanterSettings[2].Nectar = Option end, {options = NectarsList})
Planter_Second:Cheat("Dropdown", "Plant Planter Mode", function(Option) Kometa.PlanterSettings[2].PlantMode = Option end, {options = { 'Field', 'Nectar' }})
Planter_Second:Cheat("Slider", "Growth Percent", function(Value) Kometa.PlanterSettings[2].Growth = tonumber(Value) / 100 or 1 end, {min = 0, max = 100, suffix = "%", default = 100})
Planter_Second:Cheat("Checkbox", "Auto Plant", function(State) Kometa.PlanterSettings[2].Enabled = State end)

local Planter_Third = Planters_Category:Sector("Third Planter")
Planter_Third:Cheat("Dropdown", "Planter", function(Option) Kometa.PlanterSettings[3].Type = Option end, {options = require(game:GetService("ReplicatedStorage").PlanterTypes).INVENTORY_ORDER})
Planter_Third:Cheat("Dropdown", "Field", function(Option) Kometa.PlanterSettings[3].Field = Option end, {options = FieldsTable})
Planter_Third:Cheat("Dropdown", "Nectar", function(Option) Kometa.PlanterSettings[3].Nectar = Option end, {options = NectarsList})
Planter_Third:Cheat("Dropdown", "Plant Planter Mode", function(Option) Kometa.PlanterSettings[3].PlantMode = Option end, {options = { 'Field', 'Nectar' }})
Planter_Third:Cheat("Slider", "Growth Percent", function(Value) Kometa.PlanterSettings[3].Growth = tonumber(Value) / 100 or 1 end, {min = 0, max = 100, suffix = "%", default = 100})
Planter_Third:Cheat("Checkbox", "Auto Plant", function(State) Kometa.PlanterSettings[3].Enabled = State end)

local Planter_Notes = Planters_Category:Sector("Notes")
Planter_Notes:Cheat("Label", "Please choose planters that you've planted already")
Planter_Notes:Cheat("Label", "If you don't have any planters planted, ")
Planter_Notes:Cheat("Label", "choose planters how you want to plant them")
Planter_Notes:Cheat("Label", "Or it will break the script")

local Combat_First = Combat_Category:Sector("Combat")
Combat_First:Cheat("Checkbox", "Train Crab", function(State) 
    Kometa.Toggles.TrainCrab = State
    local OldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 40
    if State then 
        TweenStart(CFrame.new(-375, 110, 535)) 
        task.wait(5) 
        Temptable.ReadyForCrab = true
        TweenStart(CFrame.new(-256, 110, 475), false)
    else 
        Temptable.ReadyForCrab = false
        Humanoid.WalkSpeed = OldSpeed
    end 
    Temptable.Float = State
end)
Combat_First:Cheat("Checkbox", "Train Snail", function(State) 
    local OldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 40
    Kometa.Toggles.TrainSnail = State 
    local Field = game.Workspace.FlowerZones['Stump Field'] 
    if State then 
        TweenStart(CFrame.new(Field.Position.X, Field.Position.Y + 3, Field.Position.Z)) 
        Humanoid.WalkSpeed = OldSpeed
    end 
end)
Combat_First:Cheat("Checkbox", "Kill Mondo", function(State) Kometa.Toggles.KillMondo = State end)
Combat_First:Cheat("Checkbox", "Kill Commando", function(State) Kometa.Toggles.KillCommando = State end)
Combat_First:Cheat("Checkbox", "Kill Vicious", function(State) Kometa.Toggles.KillVicious = State end)
Combat_First:Cheat("Checkbox", "Kill Windy", function(State) Kometa.Toggles.KillWindy = State end)
--Combat_First:Cheat("Checkbox", "Kill Stick Bug", function(State) Kometa.Toggles.KillStickBug = State end)
Combat_First:Cheat("Checkbox", "Auto Kill Mobs", function(State) Kometa.Toggles.AutoKillMobs = State end)
Combat_First:Cheat("Checkbox", "Avoid Mobs", function(State) Kometa.Toggles.AvoidMobs = State end)
Combat_First:Cheat("Checkbox", "Anti Mobs", function(State)
    ToggleAntiMobs(State)
    if State then
        API:Notify('kometa', 'Kill your player now to enable Anti Mobs', 1)
    end
end)
Combat_First:Cheat("Checkbox", "Auto Ant", function(State) Kometa.Toggles.AutoAnt = State end)

local Combat_Second = Combat_Category:Sector("Auto Kill Mobs Settings")
Combat_Second:Cheat("Textbox", 'Kill Mobs After x Seconds', function(Value) Kometa.Vars.MonsterTimer = tonumber(Value) or 300 end, { placeholder = 'default = 300'})
Combat_Second:Cheat("MultiDropdown", "Mobs To Kill", function(Option) Kometa.Vars.MobsWhitelist = Option end, { options = { 'Rhino Beetle', 'Ladybug', 'Spider', 'Werewolf', 'Scorpion', 'Mantis' }})

local Statistic_First = Statistics_Category:Sector("Mob Timers")
Statistic_First:Cheat("Label", "Clover Beetle: Alive! ✅")
Statistic_First:Cheat("Label", "Clover Ladybug: Alive! ✅")
Statistic_First:Cheat("Label", "Blue Flower Beetle: Alive! ✅")
Statistic_First:Cheat("Label", "Bamboo Beetle: Alive! ✅")
Statistic_First:Cheat("Label", "Bamboo Beetle 2: Alive! ✅")
Statistic_First:Cheat("Label", "Pineapple Beetle: Alive! ✅")
Statistic_First:Cheat("Label", "Pineapple Mantis: Alive! ✅")
Statistic_First:Cheat("Label", "Spider: Alive! ✅")
Statistic_First:Cheat("Label", "Mushroom Ladybug: Alive! ✅")
Statistic_First:Cheat("Label", "Strawberry Ladybug: Alive! ✅")
Statistic_First:Cheat("Label", "Strawberry Ladybug 2: Alive! ✅")
Statistic_First:Cheat("Label", "Rose Scorpion: Alive! ✅")
Statistic_First:Cheat("Label", "Rose Scorpion 2: Alive! ✅")
Statistic_First:Cheat("Label", "Werewolf: Alive! ✅")
Statistic_First:Cheat("Label", "Pine Tree Mantis: Alive! ✅")
Statistic_First:Cheat("Label", "Pine Tree Mantis 2: Alive! ✅")
Statistic_First:Cheat("Label", "King Beetle: Alive! ✅")
Statistic_First:Cheat("Label", "Tunnel Bear: Alive! ✅")
Statistic_First:Cheat("Label", "Snail: Alive! ✅")
Statistic_First:Cheat("Label", "Coconut Crab: Alive! ✅")

local Statistic_Second = Statistics_Category:Sector("Player Statistics")
Statistic_Second:Cheat("Label", "⏳ Elapsed Time: ")
Statistic_Second:Cheat("Label", "🍯 Honey: ")
Statistic_Second:Cheat("Label", "⏳ Honey Per Hour: ")
Statistic_Second:Cheat("Label", "⏳ Honey Per Day: ")
Statistic_Second:Cheat("Label", "🎫 Collected Tickets: ")
Statistic_Second:Cheat("Label", "🕷️ Killed Mobs: ")
Statistic_Second:Cheat("Label", "🌱 Sprouts Collected: ")
Statistic_Second:Cheat("Label", "⚠️ Killed Vicious: ")
Statistic_Second:Cheat("Label", "🌪️ Killed Windy: ")
Statistic_Second:Cheat("Label", "🐥 Killed Mondo: ")

-- local Statistic_Third = Statistics_Category:Sector("Quest Statistics")
-- Statistic_Third:Cheat("Label", "📃 Quest Name: ")
-- Statistic_Third:Cheat("Label", " ∟ Quest NPC: ")
-- Statistic_Third:Cheat("Label", " ∟ Task Description: ")
-- Statistic_Third:Cheat("Label", " ∟ Task Needed: ")

local Hive_First = Hive_Category:Sector("Hive")
Hive_First:Cheat("Textbox", "X", function(Value) Kometa.BeesSettings.General.X = tonumber(Value) or 1 Player.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = '' end, {placeholder = ' '})
Hive_First:Cheat("Textbox", "Y", function(Value) Kometa.BeesSettings.General.Y = tonumber(Value) or 1  Player.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = '' end, {placeholder = ' '})
Hive_First:Cheat("Textbox", "Amount", function(Value) Kometa.BeesSettings.General.Amount = tonumber(Value) or 1 end, {placeholder = ' '})
Hive_First:Cheat("Dropdown", "Food Type", function(Option) Kometa.BeesSettings.FoodType = Option end, { options = { "Treat", "SunflowerSeed", "Blueberry", "Strawberry", "Bitterberry", "Pineapple", "Neonberry" }})

local Hive_Second = Hive_Category:Sector("Auto Royal Jelly")
Hive_Second:Cheat("MultiDropdown", "Bee", function(Value) Kometa.BeesSettings.UntilSelectedBee = Value Player.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = '' end, {options = BeesTable})
Hive_Second:Cheat("Checkbox", "Until Selected Bee", function(State) Kometa.BeesSettings.UsbToggle = State Player.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = '' end)

local Hive_Third = Hive_Category:Sector("Autofeed")
Hive_Third:Cheat("Checkbox", "Food Until Gifted", function(State) Kometa.BeesSettings.FoodUntilGifted = State end)
Hive_Third:Cheat("Checkbox", "Auto Feed", function(State) Kometa.BeesSettings.AutoFeed = State end)

local Hive_Fourth = Hive_Category:Sector("Manual Feeding")
Hive_Fourth:Cheat("Button", "Feed Selected Bee", function() Temptable.Feed(Kometa.BeesSettings.General.X, Kometa.BeesSettings.General.Y, Kometa.BeesSettings.FoodType, Kometa.BeesSettings.General.Amount) end, {text = 'Feed'})
Hive_Fourth:Cheat("Button", "Feed All Bees", function()
    for X = 1, 5, 1 do
        for Y = 1, 10, 1 do
            Temptable.Feed(X, Y, Kometa.BeesSettings.FoodType, Kometa.BeesSettings.General.Amount)
        end
    end
end, {text = 'Feed'})

local Hive_Fifth = Hive_Category:Sector("Mutation Rolling")
Hive_Fifth:Cheat("Dropdown", "Mutation", function(Option) Kometa.BeesSettings.Mutation = Option end, {options = {"Attack %", "Convert Amount %", "Gather Amount %", "Attack", "Convert Amount", "Gather Amount", "Ability Rate", "Energy"}})
Hive_Fifth:Cheat("Checkbox", "Roll Until Mutation", function(State) Kometa.BeesSettings.UntilMutation = State end)

local Misc_AutoItems = Misc_Category:Sector("Auto Use Items")
for Item, Toggle in next, Kometa.ItemUsingSettings do
    Misc_AutoItems:Cheat("Checkbox", Item, function(State) Kometa.ItemUsingSettings[Item] = State end)
end

local Misc_First = Misc_Category:Sector("Misc")
Misc_First:Cheat("Textbox", "Glider Speed", function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Speed = Value setupvalue(st, st[1]'Glider', glidersTable) end)
Misc_First:Cheat("Textbox", "Glider Float", function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Float = Value setupvalue(st, st[1]'Glider', glidersTable) end)

local Misc_Second = Misc_Category:Sector("Wind Shrine ⚠️")
Misc_Second:Cheat("Dropdown", "Item", function(Option) Kometa.Vars.DonatIt[1] = Option end, {options = Temptable.Item_Names}) 
Misc_Second:Cheat("Textbox", "Count", function(Value) Kometa.Vars.DonatIt[2] = tonumber(Value) end)
Misc_Second:Cheat("Checkbox", "Auto Donate", function(State) Kometa.Toggles.AutoDonate = State end)
Misc_Second:Cheat("Checkbox", "Don't Spawn Drop On Donate", function(State) Kometa.Toggles.DontSpawnDrop = State end)
Misc_Second:Cheat("Button", "Donate", function()
    game.ReplicatedStorage.Events.WindShrineDonation:InvokeServer(Kometa.Vars.DonatIt[1], Kometa.Vars.DonatIt[2])
    if not Kometa.Toggles.DontSpawnDrop then game.ReplicatedStorage.Events.WindShrineTrigger:FireServer() end
end, {text = 'Once'})
Misc_Second:Cheat("Button", "Spawn Drop", function()
    game.ReplicatedStorage.Events.WindShrineTrigger:FireServer()
end, {text = 'Spawn'})

local Misc_Third = Misc_Category:Sector("Other")
Misc_Third:Cheat("Dropdown", "Equip Accesories", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, {options = AccesoriesTable})
Misc_Third:Cheat("Dropdown", "Equip Masks", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, {options = MaskTable})
Misc_Third:Cheat("Dropdown", "Equip Collectors", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Collector" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, {options = CollectorsTable})
Misc_Third:Cheat("Dropdown", "Generate Amulet", function(Option) local A_1 = Option.." Generator" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end, {options = {"Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet","Silver Star Amulet","Bronze Star Amulet","Moon Amulet"}})
Misc_Third:Cheat("Button", "Export Stats Table", function() local StatCache = require(game.ReplicatedStorage.ClientStatCache)writefile("Stats_"..Player.Name..".json", StatCache:Encode()) end, {text = ''})
Misc_Third:Cheat("Button", "Collect Treasures", function()
    for _, Token in next, TreasuresTable do
        if Token.Parent and Token.Transparency == 0 then
            repeat
                task.wait()
                TweenStart(CFrame.new(Token.Position))
            until Token.Transparency ~= 0
        end
    end
end, {text = 'Click Me'})
Misc_Third:Cheat("Checkbox", "Always Visual Night", function(State) Kometa.Toggles.VisualNight = State end)
Misc_Third:Cheat("Checkbox", "Hide Decorations", function(State) 
    if State then
        for _, Object in next, game:GetService("Workspace").FieldDecos:GetDescendants() do
            if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                Object.CanCollide = false
                Object.Transparency = 0.5
                DeletedObjects[#DeletedObjects + 1] = { Type = "CanCollide", Object = Object }
            end
        end 
        for _, Object in next, game:GetService("Workspace").Decorations.Misc:GetChildren() do
            if string.find(Object.Name, 'Blue Flower') then
                DeletedObjects[#DeletedObjects + 1] = { Type = "Delete", Object = Object, Parent = Object.Parent }
                Object.Parent = game.ReplicatedStorage
            end
        end     
        for _, Model in next, game:GetService("Workspace").Decorations.Misc:GetChildren() do
            if Model.Name == "Mushroom" and Model:IsA("Model") then
                for _, Object in pairs(Model:GetChildren()) do
                    if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                        Object.CanCollide = false
                        Object.Transparency = 0.5
                        DeletedObjects[#DeletedObjects + 1] = { Type = "CanCollide", Object = Object }
                    end
                end
            end
        end    
        for _, Object in next, game:GetService("Workspace").Decorations.JumpGames.Mushroom:GetChildren() do
            DeletedObjects[#DeletedObjects + 1] = { Type = "Delete", Object = Object, Parent = Object.Parent }
            Object.Parent = game.ReplicatedStorage
        end
        for _, Object in next, game:GetService("Workspace").Map.Fences:GetChildren() do
            DeletedObjects[#DeletedObjects + 1] = { Type = "Delete", Object = Object, Parent = Object.Parent }
            Object.Parent = game.ReplicatedStorage
        end
    else
        for _, Data in next, DeletedObjects do
            if Data.Type == "Delete" then
                Data.Object.Parent = Data.Parent
            elseif Data.Type == "CanCollide" then
                Data.Object.CanCollide = true
                Data.Object.Transparency = 0
            end
        end
    end
end)
Misc_Third:Cheat("Button", "Make Anything 🤓", function()
    for _, Value in next, game.Workspace:GetDescendants() do
        if Value:IsA("TextLabel") then
            Value.Text = '🤓️'
        end
        if Value:IsA("Decal") or Value:IsA("Texture") then
           Value.Texture = 'rbxassetid://12149476526' 
        end
        if Value:IsA("ImageLabel") then 
            Value.Image = 'rbxassetid://12149476526'
        end
    end
    for _, Value in next, Player.PlayerGui:GetDescendants() do
        if Value:IsA("TextLabel") then
            Value.Text = '🤓️'
        end
        if Value:IsA("Decal") or Value:IsA("Texture") then
           Value.Texture = 'rbxassetid://12149476526' 
        end
        if Value:IsA("ImageLabel") then 
            Value.Image = 'rbxassetid://12149476526'
        end
    end
end, {text = '🤓'})
Misc_Third:Cheat("Checkbox", "Hide Item Notifications", function(State)
    Player.PlayerGui.ScreenGui.Alerts.Visible = not State
end)

local Misc_Fourth = Misc_Category:Sector("Waypoints")
Misc_Fourth:Cheat("Dropdown", "Field Teleports", function(Option) Root.CFrame = game:GetService("Workspace").FlowerZones:FindFirstChild(Option).CFrame end, {options = FieldsTable})
Misc_Fourth:Cheat("Dropdown", "Monster Teleports", function(Option) local MonsterTeleport = MonsterSpawners:FindFirstChild(Option) Root.CFrame = CFrame.new(MonsterTeleport.Position.X, MonsterTeleport.Position.Y + 3, MonsterTeleport.Position.Z) end, {options = SpawnersTable})
Misc_Fourth:Cheat("Dropdown", "Toys Teleports", function(Option) local ToyTeleport = game:GetService("Workspace").Toys:FindFirstChild(Option).Platform Root.CFrame = CFrame.new(ToyTeleport.Position.X, ToyTeleport.Position.Y + 3, ToyTeleport.Position.Z) end, {options = ToysTable})
Misc_Fourth:Cheat("Button", "Teleport to Hive", function() Root.CFrame = Player.SpawnPos.Value end, {placeholder = ' '})

local Extra_First = Extra_Category:Sector("Extras")
Extra_First:Cheat("Checkbox", "Float", function(State) Temptable.Float = State end)
Extra_First:Cheat("Checkbox", "Walk Speed", function(State) Kometa.Toggles.LoopSpeed = State end)
Extra_First:Cheat("Checkbox", "Jump Power", function(State) Kometa.Toggles.LoopJump = State end)
Extra_First:Cheat("Slider", "Walk Speed Value", function(Value) Kometa.Vars.WalkSpeed = Value end, {min = 0, max = 80, suffix = " studs", default = 70})
Extra_First:Cheat("Slider", "Jump Power Value", function(Value) Kometa.Vars.JumpPower = Value end, {min = 0, max = 90, suffix = " studs", default = 70})
Extra_First:Cheat("Button", "Fix Movement", function() Player.DevComputerMovementMode = Enum.DevComputerMovementMode.UserChoice end, {placeholder = ' '})
Extra_First:Cheat("Button", "Replace Nickname With 🤓", function()
    for Index, Value in next, game.Workspace:GetDescendants() do
        if Value:IsA("TextLabel") and string.find(Value.Text, game.Players.LocalPlayer.Name) then
            Value.Text = '🤓️'
        end
    end
end, { text = 'Make Yourself 🤓'})

local Extra_Second = Extra_Category:Sector("Optimization")
-- Extra_Second:Cheat("Button", "Hide nickname", function() loadstring(game:HttpGet("https://s.kometa.pw/other/nicknamespoofer.lua"))() end, {text = ''})\
Extra_Second:Cheat("Button", "Boost FPS", function()loadstring(game:HttpGet("https://s.kometa.pw/other/fpsboost.lua"))() end, {text = ''})
Extra_Second:Cheat("Button", "Destroy Decals", function()loadstring(game:HttpGet("https://s.kometa.pw/other/destroydecals.lua"))() end, {text = ''})
Extra_Second:Cheat("Checkbox", "Disable 3D Render On Unfocus", function(State) Kometa.Toggles.DisableRender = State end)
Extra_Second:Cheat("Checkbox", "Set 30 FPS On Unfocus", function(State) Kometa.Toggles.FPS30Unfocus = State end)
Extra_Second:Cheat("Checkbox", "Disable 3D Render", function(State) game:GetService("RunService"):Set3dRenderingEnabled(not State) end)

local Extra_Third = Extra_Category:Sector("Discord Webhooking")
Extra_Third:Cheat("Textbox", "Webhook", function(Value) KometaWebhook.Webhook = Value end, {placeholder = ' '})
Extra_Third:Cheat("Button", "Remind Webhook", function() API:Notify('kometa', 'Your webhook is '..KometaWebhook.Webhook) end, {text = ''})
Extra_Third:Cheat("Checkbox", "Send After Converting", function(State) Kometa.Webhooking.Convert = State end)
Extra_Third:Cheat("Checkbox", " ∟ Send Balloon Stats", function(State) Kometa.Webhooking.BalloonStats = State end)
Extra_Third:Cheat("Checkbox", "Send On Vicious", function(State) Kometa.Webhooking.Vicious = State end)
Extra_Third:Cheat("Checkbox", "Send On Windy", function(State) Kometa.Webhooking.Windy = State end)
Extra_Third:Cheat("Checkbox", "Send When Player Joins Server", function(State) Kometa.Webhooking.PlayerAdded = State end)
Extra_Third:Cheat("Checkbox", "Send On Connection Lost", function(State) Kometa.Webhooking.ConnectionLost = State end)

local Autokick_Sector = Extra_Category:Sector("Autokick")
Autokick_Sector:Cheat("Checkbox", "Autokick", function(State) Kometa.Toggles.Autokick = State end)
Autokick_Sector:Cheat("Slider", " ∟ Delay Before Kick", function(Value) Kometa.Vars.AutokickDelay = Value end, {min = 1, max = 720, suffix = " minutes", default = 60})
Autokick_Sector:Cheat("Dropdown", " ∟ Kick Mode", function(Value) Kometa.Vars.AutokickMode = Value end, {options = {"Kick", "Kill Roblox"}})

local Local_Configs = Configs_Category:Sector("Local Configs")
Local_Configs:Cheat("Textbox", "Config Name", function(Value) Temptable.ConfigName = Value end, {placeholder = 'ex: stumpconfig'})
Local_Configs:Cheat("Button", "Load Config", function() Kometa = game:GetService('HttpService'):JSONDecode(readfile("kometa/BSS_"..Temptable.ConfigName..".json")) KometaWebhook = game:GetService('HttpService'):JSONDecode(readfile("kometa/BSS_webhook_"..Temptable.ConfigName..".json")) end, {text = ' '})
Local_Configs:Cheat("Button", "Save Config", function() writefile("kometa/BSS_"..Temptable.ConfigName..".json",game:GetService('HttpService'):JSONEncode(Kometa)) writefile("kometa/BSS_webhook_"..Temptable.ConfigName..".json", game:GetService('HttpService'):JSONEncode(KometaWebhook)) end, {text = ' '})
Local_Configs:Cheat("Button", "Reset Config", function() Kometa = DefaultKometa KometaWebhook = DefaultKometaWebhook end, {text = ' '})

if (syn or Krnl or (identifyexecutor() and identifyexecutor() == 'ScriptWare')) and Temptable.WebSocket then
    local Global_Configs = Configs_Category:Sector("Global Configs")
    Global_Configs:Cheat("Textbox", "Config ID", function(Value) Temptable.GlobalConfigId = Value end, {placeholder = 'ex: OdACVVunos'})
    Global_Configs:Cheat("Textbox", "Name", function(Value) Temptable.GlobalConfigName = Value end, {placeholder = 'ex: pine tree autofarm'})
    Global_Configs:Cheat("Textbox", "Description", function(Value) Temptable.GlobalConfigDescription = Value end, {placeholder = 'ex: this is a pine tree autofarm'})
    Global_Configs:Cheat("Button", "Load Config", function() Temptable.WebSocket:Send(game:GetService('HttpService'):JSONEncode({ action = 'ConfigLoad', hwid = game:GetService("RbxAnalyticsService"):GetClientId(), id = Temptable.GlobalConfigId })) end, {text = ' '})
    Global_Configs:Cheat("Button", "Save Config", function() Temptable.WebSocket:Send(game:GetService('HttpService'):JSONEncode({ hwid = game:GetService("RbxAnalyticsService"):GetClientId(), action = 'ConfigSave', nickname = Player.Name, name = Temptable.GlobalConfigName, config = game:GetService('HttpService'):JSONEncode(Kometa), version = Temptable.Version, description = Temptable.GlobalConfigDescription })) end, {text = ' '})
end

local Autofarm_Settings = Settings_Category:Sector("Autofarm Settings")
Autofarm_Settings:Cheat("Dropdown", "Mobility Method", function(Option) Kometa.Vars.Mobility = Option end, { options = { "Prefer Pathfind", "Tween" } })
Autofarm_Settings:Cheat("Dropdown", "Autofarming Engine", function(Option) Kometa.Vars.AutofarmingEngine = Option end, {options = {'Classic', 'k-01', 'k-02'}, default = 'k-02'})

local Rare_Settings = Settings_Category:Sector("Tokens Settings")
Rare_Settings:Cheat("Textbox", "Asset ID", function(Value) RareName = Value end, {placeholder = 'rbxassetid'})
Rare_Settings:Cheat("Button", "Add To Blacklist", function()
    table.insert(Kometa.BlacklistTokens, RareName)
    game.CoreGui.FinityUI.Container.Categories.Settings:FindFirstChild("Tokens Settings", true).Container["Tokens Blacklist"]:Destroy()
    Rare_Settings:Cheat("Dropdown", "Tokens Blacklist", function(Option)
    end, {
        options = Kometa.BlacklistTokens
    })
end, {text = 'Add'})
Rare_Settings:Cheat("Button", "Remove From Blacklist", function()
    table.remove(Kometa.BlacklistTokens, API:TableFind(Kometa.BlacklistTokens, RareName))
    game.CoreGui.FinityUI.Container.Categories.Settings:FindFirstChild("Tokens Settings", true).Container["Tokens Blacklist"]:Destroy()
    Rare_Settings:Cheat("Dropdown", "Tokens Blacklist", function(Option)
    end, {
        options = Kometa.BlacklistTokens
    })
end, {text = 'Remove'})
Rare_Settings:Cheat("Dropdown", "Tokens Blacklist", function(Option) end, {options = Kometa.BlacklistTokens})

local Dispenser_Settings = Settings_Category:Sector("Auto Dispensers & Auto Boosters Settings")
Dispenser_Settings:Cheat("Checkbox", 'Royal Jelly Dispenser', function(State) Kometa.NormalDispenserSettings['Free Royal Jelly Dispenser'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Blueberry Dispenser', function(State) Kometa.NormalDispenserSettings['Blueberry Dispenser'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Strawberry Dispenser', function(State) Kometa.NormalDispenserSettings['Strawberry Dispenser'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Treat Dispenser', function(State) Kometa.NormalDispenserSettings['Treat Dispenser'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Coconut Dispenser', function(State) Kometa.NormalDispenserSettings['Coconut Dispenser'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Glue Dispenser', function(State) Kometa.NormalDispenserSettings['Glue Dispenser'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Field Booster', function(State) Kometa.NormalDispenserSettings['Field Booster'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Red Field Booster', function(State) Kometa.NormalDispenserSettings['Red Field Booster'] = State end)
Dispenser_Settings:Cheat("Checkbox", 'Blue Field Booster', function(State) Kometa.NormalDispenserSettings['Blue Field Booster'] = State end) 

local Gui_Settings = Settings_Category:Sector("GUI Settings")
Gui_Settings:Cheat("Keybind", "Set toggle button", function(Value) UI.ChangeToggleKey(Value) end, {text = 'Set New'})
Gui_Settings:Cheat("Dropdown", "GUI Options (Dropdown)", function(Option) game.CoreGui.FinityUI:Destroy() end, { options = { "Destroy GUI" } })

local Priority_Settings = Settings_Category:Sector("Autofarm Priority Tokens")
Priority_Settings:Cheat("Textbox", "Asset ID", function(Value) RareName = Value end, {placeholder = 'rbxassetid'})
Priority_Settings:Cheat("Button", "Add Token To Priority List", function() table.insert(Kometa.Priority, RareName) game:GetService("CoreGui").FinityUI.Container.Categories.Settings:FindFirstChild("Autofarm Priority Tokens", true).Container["Priority List"]:Destroy() Priority_Settings:Cheat("Dropdown", "Priority List", function(Option) end, {options = Kometa.Priority}) end, {text = ''})
Priority_Settings:Cheat("Button", "Remove Token From Priority List", function() table.remove(Kometa.Priority, API:TableFind(Kometa.Priority, RareName)) game:GetService("CoreGui").FinityUI.Container.Categories.Settings:FindFirstChild("Autofarm Priority Tokens", true).Container["Priority List"]:Destroy() Priority_Settings:Cheat("Dropdown", "Priority List", function(Option) end, {options = Kometa.Priority}) end, {text = ''})
Priority_Settings:Cheat("Dropdown", "Priority List", function(Option) end, {options = Kometa.Priority})

-- // Script Object \\
if not getgenv().DontClaimHive then
    for ClaimID = 6, 1, -1 do
        if game.Workspace.Honeycombs:GetChildren()[ClaimID].Owner.Value == nil and game.Workspace.Honeycombs:GetChildren()[ClaimID].Owner.Value ~= Player.Name then
            Tween(game.Workspace.Honeycombs:GetChildren()[ClaimID]:FindFirstChild("SpawnPos").Value)
            VirtualPressButton('E')
            break
        end
    end
end

task.wait(2)

for _, Object in next, workspace.Gates:GetDescendants() do 
    if Object:IsA("BasePart") and string.find(Object.parent.Name, "Bee Gate") then 
        Object.CanCollide = false
        Object.Transparency = 0.5
    end 
end

for _, Token in next, Temptable.TokenPath:GetChildren() do
    Token:Destroy()
end 

game:GetService("UserInputService").WindowFocused:Connect(function()
	if Kometa.Toggles.DisableRender then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
    if Kometa.Toggles.FPS30Unfocus then
        setfpscap(999)
    end
end)

game:GetService("UserInputService").WindowFocusReleased:Connect(function()
	if Kometa.Toggles.DisableRender then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
    if Kometa.Toggles.FPS30Unfocus then
        setfpscap(30)
    end
end)

setfflag("HumanoidParallelRemoveNoPhysics", "False")
setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")

-- roblox gay
setfflag("AbuseReportScreenshot", "False") 
setfflag("AbuseReportScreenshotPercentage", "0")

if getgenv().AutoLoad then 
    if isfile("kometa/BSS_"..getgenv().AutoLoad..".json") then 
        Kometa = game:service'HttpService':JSONDecode(readfile("kometa/BSS_"..getgenv().AutoLoad..".json")) 
    end 
end
