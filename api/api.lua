local API = {} do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local StarterGui = game:GetService("StarterGui")
    local PathfindingService = game:GetService("PathfindingService")
    local HttpService = game:GetService("HttpService")

    local symbols = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"):split("")
    local suffixes = {"k", "m", "b", "t", "q", "Q", "sx", "sp", "o", "n", "d"}

    API.Services = setmetatable({}, {
        __index = function(self, name)
            local success, service = pcall(game.GetService, game, name)
            if success then
                rawset(self, name, service)
                return service
            end
            warn("[API] Service not found:", name)
            return nil
        end,
        __newindex = function()
            error("[API] Services table is read-only", 2)
        end
    })

    API.S = API.Services

    function API:getService(name)
        return self.S[name]
    end

    function API:player()
        return Players.LocalPlayer
    end

    function API:character()
        return self:player().Character
    end

    function API:root()
        local char = self:character()
        return char and char:WaitForChild("HumanoidRootPart")
    end

    function API:humanoid()
        local char = self:character()
        return char and char:WaitForChild("Humanoid")
    end

    function API:properties(tbl, prop)
        local result = {}
        for _, obj in next, tbl do
            if obj and obj[prop] then
                table.insert(result, obj[prop])
            end
        end
        return result
    end

    function API:sort(tbl, func, ...)
        table.sort(tbl, func, ...)
        return tbl
    end

    function API:indexes(tbl)
        local result = {}
        for idx in next, tbl do
            table.insert(result, idx)
        end
        return result
    end

    function API:tween(time, cf)
        local char = self:character()
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local tween = TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf})
        tween:Play()
        task.wait(time)
    end

    function API:tweenNoDelay(time, cf)
        local char = self:character()
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        TweenService:Create(root, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf}):Play()
    end

    function API:walkTo(pos)
        local humanoid = self:humanoid()
        if humanoid then
            humanoid:MoveTo(pos)
        end
    end

    function API:teleport(cf)
        local root = self:root()
        if root then
            root.CFrame = cf
        end
    end

    function API:pathfind(pos)
        local humanoid = self:humanoid()
        local root = self:root()
        if not (humanoid and root) then return end

        local path = PathfindingService:CreatePath({AgentCanJump = true, WaypointSpacing = 1})
        path:ComputeAsync(root.Position, pos)

        for _, wp in ipairs(path:GetWaypoints()) do
            humanoid:MoveTo(wp.Position)
            humanoid.MoveToFinished:Wait()
            if wp.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
        end
    end

    function API:magnitude(p1, p2)
        return (p1 - p2).Magnitude
    end

    function API:toHms(seconds)
        local mins = math.floor(seconds / 60)
        seconds = seconds % 60
        local hours = math.floor(mins / 60)
        mins = mins % 60
        return string.format("%02i:%02i:%02i", hours, mins, seconds)
    end

    function API:suffixString(num)
        for i = #suffixes, 1, -1 do
            local pow = 10 ^ (i * 3)
            if num >= pow then
                return string.format("%.1f%s", num / pow, suffixes[i])
            end
        end
        return tostring(num)
    end

    function API:notify(title, text, duration)
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end

    function API:tableFind(tbl, val)
        for idx, v in next, tbl do
            if v == val then
                return idx
            end
        end
    end

    function API:findValue(tbl, val)
        if type(tbl) ~= "table" then return false end
        for _, v in next, tbl do
            if v == val then
                return true
            end
        end
        return false
    end

    function API:getPartWithName(name, path)
        for _, obj in next, path:GetChildren() do
            if obj.Name:match(name) then
                return obj
            end
        end
    end

    function API:getBiggestModel(path)
        local biggest
        for _, obj in next, path:GetChildren() do
            if obj:IsA("Model") then
                if not biggest or obj:GetExtentsSize().Y > biggest:GetExtentsSize().Y then
                    biggest = obj
                end
            end
        end
        return biggest
    end

    function API:imageHook(url, desc, title, image)
        local embed = {
            color = 3454955,
            title = title,
            description = desc,
            thumbnail = {url = image}
        }

        local request = syn and syn.request or http_request
        if request then
            request({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({embeds = {embed}})
            })
        end
    end

    function API:generateRandomString(len)
        local result = ""
        for _ = 1, len do
            result = result .. symbols[math.random(1, #symbols)]
        end
        return result
    end

    function API:tableFilter(tbl, predicate, keepKeys)
        local result = {}
        for k, v in next, tbl do
            if predicate(v, k) then
                if keepKeys then
                    result[k] = v
                else
                    table.insert(result, v)
                end
            end
        end
        return result
    end

    function API:tableMap(tbl, mapper)
        local result = {}
        for k, v in next, tbl do
            result[k] = mapper(v, k)
        end
        return result
    end

    function API:tableForEach(tbl, action)
        for k, v in next, tbl do
            action(v, k)
        end
    end

    function API:setupInstance(parent, className, name, props)
        local existing = parent:FindFirstChild(name)
        if existing then return existing end

        local obj = Instance.new(className)
        obj.Name = name
        for prop, val in pairs(props) do
            obj[prop] = val
        end
        obj.Parent = parent
        return obj
    end
end

return API
