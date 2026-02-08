local API = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local PathfindingService = game:GetService("PathfindingService")

local SYMBOLS = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"):split("")
local SUFFIXES = { "k", "m", "b", "t", "q", "Q", "sx", "sp", "o", "n", "d" }

-- Server methods
function API:getServerUptime()
	return workspace.DistributedGameTime
end

-- Player methods
function API:getPlayer()
	return Players.LocalPlayer
end

function API:getCharacter()
	local player = self:getPlayer()
	return player and player.Character
end

function API:getRootPart()
	local character = self:getCharacter()
	return character and character:FindFirstChild("HumanoidRootPart")
end

function API:getHumanoid()
	local character = self:getCharacter()
	return character and character:FindFirstChildOfClass("Humanoid")
end

-- Movement
function API:walkTo(position)
	local humanoid = self:getHumanoid()
	if humanoid then
		humanoid:MoveTo(position)
	end
end

function API:teleport(cframe)
	local root = self:getRootPart()
	if root then
		root.CFrame = cframe
	end
end

function API:pathfindTo(position)
	local humanoid = self:getHumanoid()
	local root = self:getRootPart()

	if not (humanoid and root) then
		return false
	end

	local path = PathfindingService:CreatePath({
		AgentCanJump = true,
		WaypointSpacing = 2,
		AgentHeight = 5,
		AgentRadius = 2,
	})

	local success = pcall(function()
		path:ComputeAsync(root.Position, position)
	end)

	if not success then
		return false
	end

	if path.Status == Enum.PathStatus.Success then
		local waypoints = path:GetWaypoints()
		for _, waypoint in ipairs(waypoints) do
			humanoid:MoveTo(waypoint.Position)
			humanoid.MoveToFinished:Wait()
			if waypoint.Action == Enum.PathWaypointAction.Jump then
				humanoid.Jump = true
			end
		end
		return true
	end

	return false
end

-- Table utilities
function API.filterTable(tbl, predicate, keepKeys)
	local result = {}
	for key, value in pairs(tbl) do
		if predicate(value, key) then
			if keepKeys then
				result[key] = value
			else
				table.insert(result, value)
			end
		end
	end
	return result
end

API.mapTable = function(tbl, mapper)
	local result = {}
	for key, value in pairs(tbl) do
		result[key] = mapper(value, key)
	end
	return result
end

API.forEachTable = function(tbl, action)
	for key, value in pairs(tbl) do
		action(value, key)
	end
end

function API.findInTable(tbl, target)
	for key, value in pairs(tbl) do
		if value == target then
			return key
		end
	end
	return nil
end

function API.extractProperty(tbl, propertyName)
	local result = {}
	for _, object in ipairs(tbl) do
		if object and object[propertyName] then
			table.insert(result, object[propertyName])
		end
	end
	return result
end

-- Formatting utilities
function API.formatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local seconds = math.floor(seconds % 60)
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function API.formatNumber(number)
	for i = #SUFFIXES, 1, -1 do
		local power = 10 ^ (i * 3)
		if number >= power then
			return string.format("%.1f%s", number / power, SUFFIXES[i])
		end
	end
	return tostring(number)
end

function API.calculateDistance(position1, position2)
	return (position1 - position2).Magnitude
end

-- Instance utilities
function API.createInstance(parent, className, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	instance.Parent = parent
	return instance
end

function API.findInstanceByName(parent, namePattern)
	for _, child in ipairs(parent:GetChildren()) do
		if child.Name:match(namePattern) then
			return child
		end
	end
	return nil
end

-- UI
function API:showNotification(title, text, duration)
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = duration or 5,
		Icon = "rbxassetid://0",
	})
end

-- Utility functions
function API.generateRandomId(length)
	local result = {}
	for i = 1, length do
		result[i] = SYMBOLS[math.random(1, #SYMBOLS)]
	end
	return table.concat(result)
end

function API.waitForCondition(condition, timeout)
	local startTime = os.clock()
	while not condition() do
		if timeout and os.clock() - startTime > timeout then
			return false
		end
		task.wait()
	end
	return true
end

-- Safe execution
function API.tryExecute(func, ...)
	local success, result = pcall(func, ...)
	if not success then
		warn("Execution failed:", result)
	end
	return success, result
end

return API
