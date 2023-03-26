local API = {} do

    function API:Load()
        API.Services = {}
        setmetatable(API.Services, {
            __index = function(_, Service_Name)
                return game:GetService(Service_Name)
            end
        })
    end

    function API:Properties(Table, Property)
        local PropertiesTable = {}
        for _, Instance in next, Table do
            if Instance and Instance[Property] then
                table.insert(PropertiesTable, Instance[Property])
            end
        end
        return PropertiesTable
    end

    function API:Create(Class, Properties, Parent)
        local Object = Instance.new(Class)

        for Property, Value in next, Properties do
            if Object[Property] then
                Object[Property] = Value
            end
        end

        Object.Parent = Parent or workspace

        return Object
    end

    function API:Sort(Table, Function, ...) 
        table.sort(Table, Function, ...)
        return Table or {}
    end

    function API:Indexes(Table)
        local Indexes = {}
        for Index, _ in next, Table do
            table.insert(Indexes, Index)
        end
        return Indexes
    end

    function API:Player()
        return game:GetService("Players").LocalPlayer
    end

    function API:Character()
        return self:Player().Character
    end

    function API:Root()
        return self:Character():WaitForChild("HumanoidRootPart")
    end

    function API:Humanoid()
        return self:Character():WaitForChild("Humanoid")
    end

    function API:Tween(Time, CF)
        pcall(function()
            game:GetService("TweenService"):Create(self:Root(), TweenInfo.new(Time, Enum.EasingStyle.Linear), { CFrame = CF }):Play() 
            task.wait(Time)
        end)
    end

    function API:TweenNoDelay(Time, CF)
        pcall(function()
            game:GetService("TweenService"):Create(self:Root(), TweenInfo.new(Time, Enum.EasingStyle.Linear), { CFrame = CF }):Play() 
        end)
    end

    function API:WalkTo(Position)
        self:Humanoid():MoveTo(Position)
    end

    function API:Teleport(CFrame)
        self:Root().CFrame = CFrame
    end

    function API:Magnitude(Pos1, Pos2)
        return (Pos1 - Pos2).Magnitude
    end

    function API:Notify(Title, Description, Duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = Title;
                Text = Description;
                Duration = Duration;
            })
        end)
    end

    function API:ToHMS(Time)
        local Minutes = (Time - Time % 60) / 60
        Time -= Minutes * 60
        local Hours = (Minutes - Minutes % 60) / 60
        Minutes -= Hours * 60
        return string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", Time)
    end

    function API:SuffixString(String)
        local Suffixes = {"k", "m", "b", "t", "q", "Q", "sx", "sp", "o", "n", "d"}
        for Index = #Suffixes, 1, -1 do
            local Pow = math.pow(10, Index * 3)
            if String >= Pow then
                return ("%.1f"):format(String / Pow) .. Suffixes[Index]
            end
        end
        return tostring(String)
    end

    function API:TableFind(Table, Value)
        for index, value in next, Table do
            if value == Value then
                return index
            end
        end
    end

    function API:FindValue(Table, Value)
        if type(Table) == "table" then
            for _, value in next, Table do
                if value == Value then
                    return true
                end
            end
        else
            return false
        end
        return false
    end

    function API:GetPartWithName(Name, Path)
        for _, Object in next, Path:GetChildren() do
            if (Object.Name:match(Name)) then
                return Object
            end
        end
    end

    function API:GetBiggestModel(Path)
        local Part
        for _, Object in next, Path:GetChildren() do
            if Object:IsA("Model") then
                if Part == nil then
                    Part = Object
                end
                if Object:GetExtentsSize().Y > Part:GetExtentsSize().Y then
                    Part = Object
                end
            end
        end
        return Part
    end

    function API:ImageHook(Hook, Description, Title, Image)
        pcall(function()
            local Embed = {
                color = "3454955",
                title =  Title,
                description = Description,
                thumbnail = {
                    url = Image
                },
            }

            (syn and syn.request or http_request) {
                Url = Hook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode( { content = Content; embeds = { Embed } } ),
            }
        end)
    end

end
------ 
return API