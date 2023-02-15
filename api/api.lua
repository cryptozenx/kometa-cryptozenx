local API = {} do

    function API:Properties(Table, Property) 
        local PropertiesTable = {}
        for _, Instance in next, Table do
            if Instance and Instance[Property] then
                table.insert(PropertiesTable, Instance[Property])
            end
        end
        return PropertiesTable
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

    function API:Player() -- returns the player
        return game:GetService("Players").LocalPlayer
    end
    
    function API:Character() -- returns the player character
        return self:Player().Character
    end
    
    function API:Root() -- returns the player humanoid root
        return self:Character():WaitForChild("HumanoidRootPart")
    end
    
    function API:Humanoid() -- returns the humanoid
        return self:Character():WaitForChild("Humanoid")
    end
    
    function API:Tween(Time, CF) -- tween to position
        pcall(function()
            self:Humanoid():ChangeState(11)
            game:GetService("TweenService"):Create(self:Root(), TweenInfo.new(Time, Enum.EasingStyle.Linear), { CFrame = CF }):Play() 
            task.wait(Time)
        end)
    end

    function API:TweenNoDelay(Time, CF) -- tween to position without delay
        pcall(function()
            self:Humanoid():ChangeState(11)
            game:GetService("TweenService"):Create(self:Root(), TweenInfo.new(Time, Enum.EasingStyle.Linear), { CFrame = CF }):Play() 
        end)
    end
    
    function API:WalkTo(Position) -- walk to position
        self:Humanoid():MoveTo(Position)
    end
    
    function API:Teleport(CFrame) -- teleport to position
        self:Root().CFrame = CFrame
    end
    
    function API:Magnitude(Pos1, Pos2) -- return positions magnitude
        return (Pos1 - Pos2).Magnitude
    end
    
    function API:Notify(Title, Description, Duration) -- send notification
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = Title;
                Text = Description;
                Duration = Duration;
            })
        end)
    end
    
    function API:ToHMS(Time) -- return time string
        local Minutes = (Time - Time % 60) / 60
        Time -= Minutes * 60
        local Hours = (Minutes - Minutes % 60) / 60
        Minutes -= Hours * 60
        return string.format("%02i", Hours)..":"..string.format("%02i", Minutes)..":"..string.format("%02i", Time)
    end
    
    function API:SuffixString(String) -- return suffix string
        local Suffixes = {"k", "m", "b", "t", "q", "Q", "sx", "sp", "o", "n", "d"}
        for Index = #Suffixes, 1, -1 do
            local Pow = math.pow(10, Index * 3)
            if String >= Pow then
                return ("%.1f"):format(String / Pow) .. Suffixes[Index]
            end
        end
        return tostring(String)
    end
    
    function API:TableFind(Table, Value) -- return index
        for index, value in next, Table do
            if value == Value then
                return index
            end
        end
    end
    
    function API:FindValue(Table, Value) -- return boolean
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
    
    function API:GetPartWithName(Name, Path) -- return part
        for _, Object in next, Path:GetChildren() do
            if (Object.Name:match(Name)) then
                return Object
            end
        end
    end
    
    function API:GetBiggestModel(Path) -- return biggest part
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
    
    function API:ImageHook(Hook, Description, Title, Image) -- send webhook
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