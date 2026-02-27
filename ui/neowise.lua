local neowise = {}

neowise.gs = {}

neowise.theme = {
	background = Color3.fromRGB(21, 21, 21),
	button_background = Color3.fromRGB(36, 36, 36),
	accent = Color3.fromRGB(28, 26, 31),
	text = Color3.fromRGB(211, 211, 211),
	text_hover = Color3.fromRGB(255, 255, 255),
	text_title = Color3.fromRGB(182, 182, 182),
	text_dim = Color3.fromRGB(164, 126, 255),
	separator = Color3.fromRGB(72, 72, 72),
}

neowise.fonts = {
	Inter_Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	Inter_Medium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
	Inter_SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
	Inter_Bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
}

neowise.icons = {
	arrow = "rbxassetid://87945610246816",
	arrow_white = "rbxassetid://114982778065358",
	home = "rbxassetid://101200119141684",
	farm = "rbxassetid://98468883920281",
	tokens = "rbxassetid://120161860287483",
	convert = "rbxassetid://128818707335394",
	sprouts = "rbxassetid://106276112840593",
	puffshrooms = "rbxassetid://103951583199082",
	planters = "rbxassetid://75635149228058",
	monsters = "rbxassetid://129640727843651",
	monsters_timers = "rbxassetid://76238972196430",
	challenges = "rbxassetid://87465123962474",
	quests = "rbxassetid://100982721820924",
	badges = "rbxassetid://125183607086156",
	hive_editor = "rbxassetid://108614571815180",
	toys = "rbxassetid://128739091501140",
	boosters = "rbxassetid://127555674548811",
	dispensers = "rbxassetid://134609220029065",
	memory_match = "rbxassetid://89838213736875",
	wind_shrine = "rbxassetid://76358308622004",
	stickers = "rbxassetid://90178883010761",
	config = "rbxassetid://109512863736133",
	debug = "rbxassetid://127122659606543",
}

setmetatable(neowise.gs, {
	__index = function(_, service)
		return game:GetService(service)
	end,
	__newindex = function(t, i)
		t[i] = nil
		return
	end,
})

local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = UserInputService.TouchEnabled and UserInputService.MouseEnabled

local fieldsIcons = game:GetService("ReplicatedStorage"):WaitForChild("SmallFieldIcons")
local mouse = neowise.gs["Players"].LocalPlayer:GetMouse()

function neowise:Create(class, properties)
	local object = Instance.new(class)

	for prop, val in next, properties do
		object[prop] = val
	end

	return object
end

function neowise.new(gprojectName, gprojectVersion, scale)
	local neowiseObject = {}
	local self2 = neowiseObject
	local self = neowise

	repeat
		task.wait()
	until neowise.gs["CoreGui"]

	local guiPath = neowise.gs["CoreGui"]
	local SCALE = scale or 2.0

	if not neowise.gs["RunService"]:IsStudio() and guiPath:FindFirstChild("neowiseUI") then
		guiPath:FindFirstChild("neowiseUI"):Destroy()
	end

	local projectName, projectVersion
	if gprojectName then
		projectName = gprojectName
	end
	if gprojectVersion then
		projectVersion = gprojectVersion
	end

	local tweenCooldown = false
	local toggled = true
	local typing = false
	local firstCategory = true

	local neowiseData
	neowiseData = {
		UpConnection = nil,
		ToggleKey = Enum.KeyCode.Home,
	}

	local function setUpDragging(dragHandle, targetFrame, callback)
		local dragging = false
		local dragStartInputPos
		local frameStartPos
		local touchConnection = nil

		local function updatePosition(newPos)
			if not dragging then
				return
			end
			local delta = newPos - dragStartInputPos
			targetFrame.Position = UDim2.new(
				frameStartPos.X.Scale,
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale,
				frameStartPos.Y.Offset + delta.Y
			)
		end

		dragHandle.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = true
				dragStartInputPos = input.Position
				frameStartPos = targetFrame.Position

				if input.UserInputType == Enum.UserInputType.Touch then
					if touchConnection then
						touchConnection:Disconnect()
					end
					touchConnection = input.Changed:Connect(function()
						if not dragging then
							return
						end

						if input.UserInputState == Enum.UserInputState.Change then
							updatePosition(input.Position)
						elseif input.UserInputState == Enum.UserInputState.End then
							dragging = false
							if touchConnection then
								touchConnection:Disconnect()
								touchConnection = nil
							end
							if callback then
								callback()
							end
						end
					end)
				end
			end
		end)

		dragHandle.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
				if callback then
					callback()
				end
			end
		end)

		neowise.gs["UserInputService"].InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				updatePosition(input.Position)
			end
		end)

		dragHandle.Active = true
		dragHandle.Selectable = true
	end

	function self2.ChangeToggleKey(key)
		neowiseData.ToggleKey = key

		if neowiseData.UpConnection then
			neowiseData.UpConnection:Disconnect()
		end

		neowiseData.UpConnection = neowise.gs["UserInputService"].InputEnded:Connect(function(input)
			if input.KeyCode == neowiseData.ToggleKey and not typing and not tweenCooldown then
				toggled = not toggled

				tweenCooldown = true

				pcall(function()
					self2.modal.Modal = toggled
				end)

				if toggled then
					self2.container.Visible = true
				else
					self2.container.Visible = false
				end

				tweenCooldown = false
			end
		end)
	end

	function self2.DestroyUI()
		if self2.userinterface then
			self2.userinterface:Destroy()
			self2 = nil

			if neowiseData.UpConnection then
				neowiseData.UpConnection:Disconnect()
			end
		end
	end

	neowiseData.UpConnection = neowise.gs["UserInputService"].InputEnded:Connect(function(input)
		if input.KeyCode == neowiseData.ToggleKey and not typing then
			toggled = not toggled

			if toggled then
				self2.container.Visible = true
			else
				self2.container.Visible = false
			end
		end
	end)

	self2.userinterface = neowise:Create("ScreenGui", {
		Name = "neowiseUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
	})

	self2.container = neowise:Create("ImageLabel", {
		Name = "Container",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0,
		BackgroundColor3 = neowise.theme.background,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 800 * SCALE, 0, 350 * SCALE),
		Visible = false,
		ZIndex = 2,
		ImageTransparency = 1,
	})

	-- self2.dragHandle = neowise:Create("Frame", {
	-- 	Name = "DragHandle",
	-- 	BackgroundTransparency = 1,
	-- 	Size = UDim2.new(0, 168 * SCALE, 0, 42 * SCALE),
	-- 	Position = UDim2.new(0, 16 * SCALE, 0, 16 * SCALE),
	-- 	ZIndex = 100,
	-- 	Active = true,
	-- 	Selectable = true,
	-- 	Parent = self2.container,
	-- })

	neowise:Create("UICorner", {
		CornerRadius = UDim.new(0, 16 * SCALE),
		Parent = self2.container,
	})

	self2.container.Active = true
	setUpDragging(self2.container, self2.container)

	self2.mobileToggle = coroutine.wrap(function()
		local button = neowise:Create("TextButton", {
			Name = "Toggle",
			AutoButtonColor = false,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 0.5,
			BackgroundColor3 = neowise.theme.background,
			Size = UDim2.new(0, 35 * SCALE, 0, 35 * SCALE),
			Position = UDim2.new(1, -128, 0, 128),
			Text = "",
			ZIndex = 2,
		})

		neowise:Create("UICorner", {
			CornerRadius = UDim.new(0, 10 * SCALE),
			Parent = button,
		})

		neowise:Create("ImageLabel", {
			Name = "Icon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.7, 0.7),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = "rbxassetid://86177069340691",
			ZIndex = 2,
			Parent = button,
		})

		return button
	end)()

	setUpDragging(self2.mobileToggle, self2.mobileToggle, function()
		toggled = not toggled

		pcall(function()
			self2.modal.Modal = toggled
		end)

		self2.container.Visible = toggled
	end)

	self2.modal = neowise:Create("TextButton", {
		Text = "",
		Transparency = 1,
		Modal = true,
	})
	self2.modal.Parent = self2.userinterface

	self2.tip = coroutine.wrap(function()
		local tip = neowise:Create("Frame", {
			Name = "Tip",
			BackgroundColor3 = neowise.theme.accent,
			Size = UDim2.new(0, 168 * SCALE, 0, 42 * SCALE),
			Position = UDim2.new(0, 16 * SCALE, 0, 16 * SCALE),
			ZIndex = 2,
		})

		neowise:Create("UICorner", {
			CornerRadius = UDim.new(0, 10 * SCALE),
			Parent = tip,
		})

		neowise:Create("UIPadding", {
			PaddingLeft = UDim.new(0, 8 * SCALE),
			PaddingRight = UDim.new(0, 8 * SCALE),
			Parent = tip,
		})

		local iconLabel = neowise:Create("ImageLabel", {
			Name = "Icon",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(25 * SCALE, 25 * SCALE),
			Position = UDim2.fromScale(0, 0.5),
			Image = "rbxassetid://86177069340691",
			ZIndex = 2,
		})

		local titleLabel = neowise:Create("TextLabel", {
			Name = "Title",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(72 * SCALE, 15 * SCALE),
			Position = UDim2.new(0, 35 * SCALE, 0.5, -5 * SCALE),
			Text = projectName,
			FontFace = neowise.fonts.Inter_SemiBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 20 * SCALE,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
		})

		local versionLabel = neowise:Create("TextLabel", {
			Name = "Version",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(72 * SCALE, 15 * SCALE),
			Position = UDim2.new(0, 35 * SCALE, 0.5, 8 * SCALE),
			Text = "ver. " .. projectVersion,
			FontFace = neowise.fonts.Inter_Regular,
			TextColor3 = neowise.theme.text_title,
			TextSize = 12 * SCALE,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
		})

		iconLabel.Parent = tip
		titleLabel.Parent = tip
		versionLabel.Parent = tip

		return tip
	end)()

	self2.sidebar = neowise:Create("ScrollingFrame", {
		Name = "Sidebar",
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200 * SCALE, 1, -58 * SCALE),
		Position = UDim2.new(0, 0, 1, 0),
		ZIndex = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarImageTransparency = isMobile and 0 or 1,
		ScrollBarThickness = isMobile and 6 * SCALE or 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	})

	neowise:Create("UIPadding", {
		PaddingBottom = UDim.new(0, 16 * SCALE),
		PaddingLeft = UDim.new(0, 16 * SCALE),
		PaddingRight = UDim.new(0, 16 * SCALE),
		PaddingTop = UDim.new(0, 12 * SCALE),
		Parent = self2.sidebar,
	})

	neowise:Create("UIListLayout", {
		Padding = UDim.new(0, 12 * SCALE),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self2.sidebar,
	})

	self2.categories = neowise:Create("Frame", {
		Name = "Categories",
		AnchorPoint = Vector2.new(1, 0),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -200 * SCALE, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		ZIndex = 2,
	})
	self2.categories.ClipsDescendants = true

	neowise:Create("UIPageLayout", {
		Padding = UDim.new(0, 10 * SCALE),
		FillDirection = Enum.FillDirection.Vertical,
		TweenTime = 0.4,
		EasingStyle = Enum.EasingStyle.Quad,
		EasingDirection = Enum.EasingDirection.InOut,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self2.categories,
	})

	self2.separator = neowise:Create("Frame", {
		Name = "Separator",
		BackgroundColor3 = neowise.theme.separator,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 1 * SCALE, 1, 0),
		Position = UDim2.fromOffset(200 * SCALE, 0),
		ZIndex = 6,
	})
	self2.separator.Parent = self2.container

	function self2:Category(name)
		local category = {
			closed = false,
		}

		category.button = neowise:Create("Frame", {
			Name = name,
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(168 * SCALE, 25 * SCALE),
			ZIndex = 2,
			Parent = self2.sidebar,
		})
		category.button.ClipsDescendants = true

		category.container = neowise:Create("Frame", {
			Name = "Container",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 25 * SCALE),
			Size = UDim2.new(1, 0, 0, 0),
			ZIndex = 2,
			Parent = category.button,
		})

		local containerLayout = neowise:Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = category.container,
		})

		neowise:Create("UIPadding", {
			PaddingTop = UDim.new(0, 2 * SCALE),
			Parent = category.container,
		})

		local buttonTitle = neowise:Create("TextButton", {
			Name = "Title",
			BackgroundColor3 = neowise.theme.accent,
			Size = UDim2.fromOffset(168 * SCALE, 25 * SCALE),
			Text = "",
			ZIndex = 2,
			Parent = category.button,
		})

		neowise:Create("UICorner", {
			CornerRadius = UDim.new(0, 10 * SCALE),
			Parent = buttonTitle,
		})

		neowise:Create("UIPadding", {
			PaddingLeft = UDim.new(0, 8 * SCALE),
			PaddingRight = UDim.new(0, 8 * SCALE),
			Parent = buttonTitle,
		})

		neowise:Create("ImageLabel", {
			Name = "Arrow",
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(10 * SCALE, 5 * SCALE),
			Image = neowise.icons.arrow,
			ZIndex = 2,
			Parent = buttonTitle,
		})

		neowise:Create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			FontFace = neowise.fonts.Inter_SemiBold,
			Text = name,
			TextColor3 = neowise.theme.text_dim,
			TextSize = 13 * SCALE,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			Parent = buttonTitle,
		})

		containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if not category.closed then
				local newSize = containerLayout.AbsoluteContentSize.Y + 25 * SCALE
				neowise.gs["TweenService"]
					:Create(category.button, TweenInfo.new(0.25), { Size = UDim2.fromOffset(168 * SCALE, newSize) })
					:Play()
			end
		end)

		local function handleButtonPress()
			category.closed = not category.closed

			if category.closed then
				neowise.gs["TweenService"]
					:Create(buttonTitle.Arrow, TweenInfo.new(0.25), {
						Rotation = 90,
					})
					:Play()
				neowise.gs["TweenService"]
					:Create(category.button, TweenInfo.new(0.25), { Size = UDim2.fromOffset(168 * SCALE, 25 * SCALE) })
					:Play()
			else
				neowise.gs["TweenService"]
					:Create(buttonTitle.Arrow, TweenInfo.new(0.25), {
						Rotation = 0,
					})
					:Play()
				local newSize = containerLayout.AbsoluteContentSize.Y + 25 * SCALE
				neowise.gs["TweenService"]
					:Create(category.button, TweenInfo.new(0.25), { Size = UDim2.fromOffset(168 * SCALE, newSize) })
					:Play()
			end
		end

		buttonTitle.MouseButton1Click:Connect(handleButtonPress)

		function category:Tab(name, texture)
			local tab = {}

			tab.button = neowise:Create("TextButton", {
				Name = name,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 25 * SCALE),
				Text = "",
				ZIndex = 2,
				Parent = category.container,
			})

			neowise:Create("ImageLabel", {
				Name = "Icon",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 8 * SCALE, 0.5, 0),
				Size = UDim2.fromOffset(14 * SCALE, 14 * SCALE),
				Image = texture or neowise.icons.home,
				ZIndex = 2,
				Parent = tab.button,
			})

			neowise:Create("TextLabel", {
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.new(1, -28 * SCALE, 0, 14 * SCALE),
				FontFace = neowise.fonts.Inter_Medium,
				Text = name,
				TextColor3 = neowise.theme.text,
				TextSize = 12 * SCALE,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				Parent = tab.button,
			})

			tab.container = neowise:Create("ScrollingFrame", {
				Name = name,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollBarImageTransparency = isMobile and 0 or 1,
				ScrollBarThickness = isMobile and 6 * SCALE or 0,
				BottomImage = "rbxassetid://967852042",
				MidImage = "rbxassetid://967852042",
				TopImage = "rbxassetid://967852042",
				ZIndex = 2,
				Parent = self2.categories,
			})

			tab.hider = neowise:Create("Frame", {
				Name = "Hider",
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				BackgroundColor3 = neowise.theme.background,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 5,
				Parent = tab.container,
			})

			if name == "Console" or name == "Debug Console" then
				tab.consoleFrame = neowise:Create("Frame", {
					Name = "ConsoleFrame",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 2,
					Parent = tab.container,
				})

				neowise:Create("UIPadding", {
					PaddingBottom = UDim.new(0, 16 * SCALE),
					PaddingLeft = UDim.new(0, 16 * SCALE),
					PaddingRight = UDim.new(0, 16 * SCALE),
					PaddingTop = UDim.new(0, 16 * SCALE),
					Parent = tab.consoleFrame,
				})

				tab.consoleLog = neowise:Create("ScrollingFrame", {
					Name = "ConsoleLog",
					BackgroundColor3 = neowise.theme.accent,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 0),
					ScrollBarImageColor3 = neowise.theme.text_dim,
					ScrollBarThickness = 4 * SCALE,
					BottomImage = "rbxassetid://967852042",
					MidImage = "rbxassetid://967852042",
					TopImage = "rbxassetid://967852042",
					ZIndex = 2,
					Parent = tab.consoleFrame,
				})

				neowise:Create("UICorner", {
					CornerRadius = UDim.new(0, 10 * SCALE),
					Parent = tab.consoleLog,
				})

				neowise:Create("UIPadding", {
					PaddingBottom = UDim.new(0, 8 * SCALE),
					PaddingLeft = UDim.new(0, 8 * SCALE),
					PaddingRight = UDim.new(0, 8 * SCALE),
					PaddingTop = UDim.new(0, 8 * SCALE),
					Parent = tab.consoleLog,
				})

				neowise:Create("UIListLayout", {
					Padding = UDim.new(0, 2 * SCALE),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = tab.consoleLog,
				})

				function tab:AddLog(message, color, timestamp)
					local logEntry = neowise:Create("TextLabel", {
						Name = "LogEntry",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 16 * SCALE),
						AutomaticSize = Enum.AutomaticSize.Y,
						FontFace = neowise.fonts.Inter_Regular,
						Text = (timestamp or os.date("[%H:%M:%S]")) .. " " .. message,
						TextColor3 = color or neowise.theme.text,
						TextSize = 11 * SCALE,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextWrapped = true,
						RichText = true,
						ZIndex = 2,
						Parent = tab.consoleLog,
					})

					tab.consoleLog.CanvasPosition = Vector2.new(0, tab.consoleLog.AbsoluteCanvasSize.Y)

					return logEntry
				end

				function tab:ClearConsole()
					for _, child in ipairs(tab.consoleLog:GetChildren()) do
						if child:IsA("TextLabel") then
							child:Destroy()
						end
					end
				end
			else
				tab.L = neowise:Create("Frame", {
					Name = "L",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.5, 1),
					ZIndex = 2,
					Parent = tab.container,
				})

				neowise:Create("UIListLayout", {
					Padding = UDim.new(0, 16 * SCALE),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = tab.L,
				})

				neowise:Create("UIPadding", {
					PaddingBottom = UDim.new(0, 16 * SCALE),
					PaddingLeft = UDim.new(0, 16 * SCALE),
					PaddingRight = UDim.new(0, 8 * SCALE),
					PaddingTop = UDim.new(0, 16 * SCALE),
					Parent = tab.L,
				})

				tab.R = neowise:Create("Frame", {
					Name = "R",
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromScale(0.5, 1),
					ZIndex = 2,
					Parent = tab.container,
				})

				neowise:Create("UIListLayout", {
					Padding = UDim.new(0, 16 * SCALE),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = tab.R,
				})

				neowise:Create("UIPadding", {
					PaddingBottom = UDim.new(0, 16 * SCALE),
					PaddingLeft = UDim.new(0, 8 * SCALE),
					PaddingRight = UDim.new(0, 16 * SCALE),
					PaddingTop = UDim.new(0, 16 * SCALE),
					Parent = tab.R,
				})
			end

			if firstCategory then
				neowise.gs["TweenService"]:Create(tab.hider, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
				firstCategory = false
			end

			if not isMobile then
				tab.button.MouseEnter:Connect(function()
					neowise.gs["TweenService"]
						:Create(
							tab.button.TextLabel,
							TweenInfo.new(0.2),
							{ TextColor3 = neowise.theme.text:Lerp(neowise.theme.text_hover, 0.5) }
						)
						:Play()
				end)
				tab.button.MouseLeave:Connect(function()
					neowise.gs["TweenService"]
						:Create(tab.button.TextLabel, TweenInfo.new(0.2), { TextColor3 = neowise.theme.text })
						:Play()
				end)
			end

			local function switchTab()
				for _, categoryf in next, self2.userinterface["Container"]["Categories"]:GetChildren() do
					if categoryf:IsA("ScrollingFrame") then
						if categoryf ~= tab.container then
							neowise.gs["TweenService"]
								:Create(categoryf.Hider, TweenInfo.new(0.3), { BackgroundTransparency = 0 })
								:Play()
						end
					end
				end

				neowise.gs["TweenService"]
					:Create(tab.button.TextLabel, TweenInfo.new(0.2), { TextColor3 = neowise.theme.text_hover })
					:Play()
				neowise.gs["TweenService"]:Create(tab.hider, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()

				self2.categories["UIPageLayout"]:JumpTo(tab.container)
			end

			tab.button.MouseButton1Click:Connect(switchTab)

			local function calculateSector()
				local R = #tab.R:GetChildren() - 1
				local L = #tab.L:GetChildren() - 1

				if L > R then
					return "R"
				else
					return "L"
				end
			end

			function tab:Sector(name, collapse)
				if collapse == nil then
					collapse = true
				end

				local sector = {
					closed = false,
					cooldown = false,
					collapse = collapse,
					dropdowns = {},
				}

				sector.frame = neowise:Create("Frame", {
					Name = name,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 25 * SCALE),
					ZIndex = 2,
					Parent = tab[calculateSector()],
				})

				sector.container = neowise:Create("Frame", {
					Name = "Container",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 30 * SCALE),
					Size = UDim2.new(1, 0, 0, 0),
					ZIndex = 2,
					Parent = sector.frame,
				})

				neowise:Create("UIPadding", {
					PaddingLeft = UDim.new(0, 8 * SCALE),
					PaddingRight = UDim.new(0, 8 * SCALE),
					Parent = sector.container,
				})

				local containerLayout = neowise:Create("UIListLayout", {
					Padding = UDim.new(0, 4 * SCALE),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = sector.container,
				})

				sector.title = neowise:Create("TextButton", {
					Name = "Title",
					AnchorPoint = Vector2.new(0.5, 0),
					Text = "",
					AutoButtonColor = sector.collapse,
					BackgroundColor3 = neowise.theme.accent,
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.new(1, 0, 0, 25 * SCALE),
					ZIndex = 2,
					Parent = sector.frame,
				})

				containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					if not sector.closed then
						local newSize = 25 * SCALE + containerLayout.AbsoluteContentSize.Y + 12.5
						neowise.gs["TweenService"]
							:Create(sector.frame, TweenInfo.new(0.35), { Size = UDim2.new(1, 0, 0, newSize) })
							:Play()
					end
				end)

				local function toggleSector()
					if not sector.collapse or sector.cooldown then
						return
					end

					sector.cooldown = true
					sector.closed = not sector.closed

					if sector.closed then
						sector.frame.ClipsDescendants = true

						for _, cheat in next, sector.dropdowns do
							if cheat.dropped then
								cheat.fadelist()
							end
						end

						neowise.gs["TweenService"]
							:Create(sector.title.Arrow, TweenInfo.new(0.35), {
								Rotation = 90,
							})
							:Play()

						neowise.gs["TweenService"]
							:Create(sector.frame, TweenInfo.new(0.35), { Size = UDim2.new(1, 0, 0, 25 * SCALE) })
							:Play()
					else
						neowise.gs["TweenService"]
							:Create(sector.title.Arrow, TweenInfo.new(0.35), {
								Rotation = 0,
							})
							:Play()

						local newSize = 25 * SCALE + containerLayout.AbsoluteContentSize.Y + 12.5
						neowise.gs["TweenService"]
							:Create(sector.frame, TweenInfo.new(0.35), { Size = UDim2.new(1, 0, 0, newSize) })
							:Play()

						task.delay(0.35, function()
							sector.frame.ClipsDescendants = false
						end)
					end

					task.delay(0.35, function()
						sector.cooldown = false
					end)
				end

				sector.title.MouseButton1Click:Connect(toggleSector)

				neowise:Create("UICorner", {
					CornerRadius = UDim.new(0, 10 * SCALE),
					Parent = sector.title,
				})

				neowise:Create("UIPadding", {
					PaddingLeft = UDim.new(0, 8 * SCALE),
					PaddingRight = UDim.new(0, 8 * SCALE),
					Parent = sector.title,
				})

				if sector.collapse then
					neowise:Create("ImageLabel", {
						Name = "Arrow",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(1, 0.5),
						Size = UDim2.fromOffset(10 * SCALE, 5 * SCALE),
						Image = neowise.icons.arrow,
						ZIndex = 2,
						Parent = sector.title,
					})
				end

				neowise:Create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					FontFace = neowise.fonts.Inter_SemiBold,
					Text = name,
					TextColor3 = neowise.theme.text_dim,
					TextSize = 14 * SCALE,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 2,
					Parent = sector.title,
				})

				function sector:Cheat(kind, name, callback, data)
					if not data then
						data = {}
					end

					local cheat = {}
					cheat.value = nil
					cheat.kind = kind

					cheat.frame = neowise:Create("Frame", {
						Name = name,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 25 * SCALE),
						ZIndex = 2,
						Parent = sector.container,
					})

					cheat.title = neowise:Create("TextLabel", {
						Name = "Title",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(0.5, 1),
						FontFace = neowise.fonts.Inter_Medium,
						Text = name,
						TextColor3 = neowise.theme.text_title,
						TextSize = 12 * SCALE,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 2,
						Parent = cheat.frame,
					})

					if kind then
						if string.lower(kind) == "textbox" then
							local placeholdertext = data and data.placeholder

							cheat.frame.Size = UDim2.new(1, 0, 0, 20 * SCALE)

							function cheat:SetValue(value)
								cheat.value = tostring(value)
								cheat.title.Text = tostring(value)
							end
						elseif string.lower(kind) == "toggle" then
							if data then
								if data.enabled then
									cheat.value = true
								end
							end

							cheat.toggle = neowise:Create("TextButton", {
								Name = "Toggle",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundColor3 = neowise.theme.button_background,
								Position = UDim2.fromScale(1, 0.5),
								Size = UDim2.fromOffset(40 * SCALE, 20 * SCALE),
								Text = "",
								ZIndex = 2,
								Parent = cheat.frame,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(1, 0),
								Parent = cheat.toggle,
							})

							neowise:Create("UIPadding", {
								PaddingBottom = UDim.new(0, 2 * SCALE),
								PaddingLeft = UDim.new(0, 2 * SCALE),
								PaddingRight = UDim.new(0, 2 * SCALE),
								PaddingTop = UDim.new(0, 2 * SCALE),
								Parent = cheat.toggle,
							})

							local circle = neowise:Create("Frame", {
								Name = "Circle",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundColor3 = Color3.fromRGB(217, 217, 217),
								Position = UDim2.fromScale(0, 0.5),
								Size = UDim2.fromOffset(18 * SCALE, 18 * SCALE),
								ZIndex = 2,
								Parent = cheat.toggle,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(1, 0),
								Parent = circle,
							})

							if data then
								if data.enabled then
									neowise.gs["TweenService"]
										:Create(
											cheat.toggle,
											TweenInfo.new(0.2),
											{ BackgroundColor3 = neowise.theme.text_dim }
										)
										:Play()
									neowise.gs["TweenService"]
										:Create(circle, TweenInfo.new(0.2), { Position = UDim2.fromScale(0.5, 0.5) })
										:Play()
								end
							end

							local function handleToggle()
								cheat.value = not cheat.value

								if callback then
									local s, e = pcall(function()
										callback(cheat.value)
									end)

									if not s then
										warn("error: " .. e)
									end
								end

								if cheat.value then
									neowise.gs["TweenService"]
										:Create(
											cheat.toggle,
											TweenInfo.new(0.2),
											{ BackgroundColor3 = neowise.theme.text_dim }
										)
										:Play()
									neowise.gs["TweenService"]
										:Create(circle, TweenInfo.new(0.2), { Position = UDim2.fromScale(0.5, 0.5) })
										:Play()
								else
									neowise.gs["TweenService"]
										:Create(
											cheat.toggle,
											TweenInfo.new(0.2),
											{ BackgroundColor3 = neowise.theme.button_background }
										)
										:Play()
									neowise.gs["TweenService"]
										:Create(circle, TweenInfo.new(0.2), { Position = UDim2.fromScale(0, 0.5) })
										:Play()
								end
							end

							cheat.toggle.MouseButton1Click:Connect(handleToggle)

							function cheat:SetValue(value)
								cheat.value = value

								if callback then
									local s, e = pcall(function()
										callback(cheat.value)
									end)

									if not s then
										warn("error: " .. e)
									end
								end

								if cheat.value then
									neowise.gs["TweenService"]
										:Create(
											cheat.toggle,
											TweenInfo.new(0.2),
											{ BackgroundColor3 = neowise.theme.text_dim }
										)
										:Play()
									neowise.gs["TweenService"]
										:Create(circle, TweenInfo.new(0.2), { Position = UDim2.fromScale(0.5, 0.5) })
										:Play()
								else
									neowise.gs["TweenService"]
										:Create(
											cheat.toggle,
											TweenInfo.new(0.2),
											{ BackgroundColor3 = neowise.theme.button_background }
										)
										:Play()
									neowise.gs["TweenService"]
										:Create(circle, TweenInfo.new(0.2), { Position = UDim2.fromScale(0, 0.5) })
										:Play()
								end
							end
						elseif string.lower(kind) == "dropdown" then
							if data then
								if data.default then
									cheat.value = data.default
								elseif data.options then
									cheat.value = data.options[1]
								else
									cheat.value = "None"
								end
							end

							local options
							if data and data.options then
								options = data.options
							end

							local dropdownXSize = 150 * SCALE
							cheat.dropped = false

							cheat.frame.Size = UDim2.new(1, 0, 0, 25 * SCALE)

							local dropdownLayout = neowise:Create("UIListLayout", {
								Padding = UDim.new(0, 2 * SCALE),
								SortOrder = Enum.SortOrder.LayoutOrder,
								Parent = cheat.frame,
							})

							local dropdownButtonContainer = neowise:Create("Frame", {
								Name = "DropdownButtonContainer",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 25 * SCALE),
								ZIndex = 2,
								LayoutOrder = 1,
								Parent = cheat.frame,
							})

							cheat.title.Parent = dropdownButtonContainer

							cheat.dropdown = neowise:Create("TextButton", {
								Name = "Dropdown",
								AnchorPoint = Vector2.new(1, 0.5),
								AutoButtonColor = false,
								BackgroundColor3 = neowise.theme.button_background,
								Position = UDim2.fromScale(1, 0.5),
								Size = UDim2.new(0, dropdownXSize, 0, 25 * SCALE),
								Text = "",
								ZIndex = 2,
								Parent = dropdownButtonContainer,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.dropdown,
							})

							neowise:Create("UIPadding", {
								PaddingRight = UDim.new(0, 8 * SCALE),
								Parent = cheat.dropdown,
							})

							cheat.arrow = neowise:Create("ImageLabel", {
								Name = "Arrow",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundTransparency = 1,
								Rotation = 90,
								Position = UDim2.fromScale(1, 0.5),
								Size = UDim2.fromOffset(10 * SCALE, 5 * SCALE),
								Image = neowise.icons.arrow_white,
								ZIndex = 2,
								Parent = cheat.dropdown,
							})

							cheat.selected = neowise:Create("TextLabel", {
								Name = "Selected",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 8 * SCALE, 0.5, 0),
								Size = UDim2.new(1, -10 * SCALE, 1, 0),
								FontFace = neowise.fonts.Inter_Regular,
								Text = tostring(cheat.value),
								TextColor3 = neowise.theme.text_title,
								TextSize = 12 * SCALE,
								TextXAlignment = Enum.TextXAlignment.Left,
								ZIndex = 2,
								Parent = cheat.dropdown,
							})

							cheat.listContainer = neowise:Create("Frame", {
								Name = "ListContainer",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 0),
								ZIndex = 2,
								LayoutOrder = 2,
								Parent = cheat.frame,
							})

							cheat.list = neowise:Create("ScrollingFrame", {
								Name = "List",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = neowise.theme.button_background,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.fromScale(1, 0),
								Size = UDim2.new(0, dropdownXSize, 0, 0),
								CanvasSize = UDim2.fromScale(0, 0),
								ZIndex = 3,
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								BottomImage = "rbxassetid://967852042",
								MidImage = "rbxassetid://967852042",
								TopImage = "rbxassetid://967852042",
								VerticalScrollBarInset = Enum.ScrollBarInset.None,
								ScrollBarImageTransparency = isMobile and 0 or 1,
								ScrollBarThickness = isMobile and 4 * SCALE or 0,
								Parent = cheat.listContainer,
							})

							neowise:Create("UIPadding", {
								PaddingLeft = UDim.new(0, 8 * SCALE),
								PaddingRight = UDim.new(0, 8 * SCALE),
								Parent = cheat.list,
							})

							local listLayout = neowise:Create("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Parent = cheat.list,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.list,
							})

							local function refreshOptions()
								if cheat.dropped then
									cheat.fadelist()
								end

								for _, child in next, cheat.list:GetChildren() do
									if child:IsA("TextButton") then
										child:Destroy()
									end
								end

								for _, value in next, options do
									local button

									local fieldIcon

									for _, decal in next, fieldsIcons:GetChildren() do
										if decal.Name == value then
											fieldIcon = decal.Texture
										end
									end

									if fieldIcon then
										button = neowise:Create("TextButton", {
											BackgroundColor3 = Color3.new(1, 1, 1),
											BackgroundTransparency = 1,
											Size = UDim2.new(1, 0, 0, 20 * SCALE),
											Text = "",
											ZIndex = 3,
										})

										neowise:Create("TextLabel", {
											BackgroundTransparency = 1,
											AnchorPoint = Vector2.new(1, 0.5),
											Position = UDim2.fromScale(1, 0.5),
											Size = UDim2.fromScale(0.85, 1),
											FontFace = neowise.fonts.Inter_Regular,
											Text = value,
											TextColor3 = neowise.theme.text_title,
											TextXAlignment = Enum.TextXAlignment.Left,
											TextSize = 12 * SCALE,
											ZIndex = 3,
											Parent = button,
										})

										neowise:Create("ImageLabel", {
											Name = "FieldIcon",
											AnchorPoint = Vector2.new(0, 0.5),
											BackgroundTransparency = 1,
											Rotation = 0,
											Position = UDim2.fromScale(0, 0.5),
											Size = UDim2.fromOffset(15 * SCALE, 15 * SCALE),
											Image = fieldIcon,
											ZIndex = 3,
											Parent = button,
										})

										if not isMobile then
											button.MouseEnter:Connect(function()
												neowise.gs["TweenService"]
													:Create(
														button.TextLabel,
														TweenInfo.new(0.1),
														{ TextColor3 = Color3.fromRGB(255, 255, 255) }
													)
													:Play()
											end)
											button.MouseLeave:Connect(function()
												neowise.gs["TweenService"]
													:Create(
														button.TextLabel,
														TweenInfo.new(0.1),
														{ TextColor3 = neowise.theme.text_title }
													)
													:Play()
											end)
										end
									else
										button = neowise:Create("TextButton", {
											BackgroundColor3 = Color3.new(1, 1, 1),
											BackgroundTransparency = 1,
											Size = UDim2.new(1, 0, 0, 20 * SCALE),
											ZIndex = 3,
											FontFace = neowise.fonts.Inter_Regular,
											Text = value,
											TextColor3 = neowise.theme.text_title,
											TextXAlignment = Enum.TextXAlignment.Left,
											TextSize = 12 * SCALE,
										})

										if not isMobile then
											button.MouseEnter:Connect(function()
												neowise.gs["TweenService"]
													:Create(
														button,
														TweenInfo.new(0.1),
														{ TextColor3 = Color3.fromRGB(255, 255, 255) }
													)
													:Play()
											end)
											button.MouseLeave:Connect(function()
												neowise.gs["TweenService"]
													:Create(
														button,
														TweenInfo.new(0.1),
														{ TextColor3 = neowise.theme.text_title }
													)
													:Play()
											end)
										end
									end

									button.Parent = cheat.list

									local function selectOption()
										if cheat.dropped then
											cheat.value = value
											cheat.selected.Text = value

											cheat.fadelist()

											if callback then
												local s, e = pcall(function()
													callback(cheat.value)
												end)

												if not s then
													warn("error: " .. e)
												end
											end
										end
									end

									button.MouseButton1Click:Connect(selectOption)

									neowise.gs["TweenService"]
										:Create(button, TweenInfo.new(0), { TextTransparency = 1 })
										:Play()
								end

								neowise.gs["TweenService"]
									:Create(
										cheat.list,
										TweenInfo.new(0),
										{ Size = UDim2.new(0, dropdownXSize, 0, 0), BackgroundTransparency = 1 }
									)
									:Play()
								neowise.gs["TweenService"]
									:Create(cheat.listContainer, TweenInfo.new(0), { Size = UDim2.new(1, 0, 0, 0) })
									:Play()
							end

							listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
								if cheat.dropped then
									local maxHeight = 100 * SCALE
									local contentHeight = listLayout.AbsoluteContentSize.Y
									local finalHeight = math.min(contentHeight, maxHeight)

									neowise.gs["TweenService"]
										:Create(cheat.listContainer, TweenInfo.new(0.35), {
											Size = UDim2.new(1, 0, 0, finalHeight),
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.list, TweenInfo.new(0.35), {
											Size = UDim2.new(0, dropdownXSize, 0, finalHeight),
										})
										:Play()
								end
							end)

							dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
								cheat.frame.Size = UDim2.new(1, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
							end)

							function cheat.fadelist()
								cheat.dropped = not cheat.dropped

								if cheat.dropped then
									for _, otherCheat in next, sector.dropdowns do
										if otherCheat ~= cheat and otherCheat.dropped then
											otherCheat.fadelist()
										end
									end

									local maxHeight = 100 * SCALE
									local contentHeight = listLayout.AbsoluteContentSize.Y
									local finalHeight = math.min(contentHeight, maxHeight)

									for _, button in next, cheat.list:GetChildren() do
										if button:IsA("TextButton") then
											neowise.gs["TweenService"]
												:Create(button, TweenInfo.new(0.2), { TextTransparency = 0 })
												:Play()
										end
									end

									neowise.gs["TweenService"]
										:Create(cheat.arrow, TweenInfo.new(0.35), {
											Rotation = 0,
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.listContainer, TweenInfo.new(0.35), {
											Size = UDim2.new(1, 0, 0, finalHeight),
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.list, TweenInfo.new(0.35), {
											Size = UDim2.new(0, dropdownXSize, 0, finalHeight),
											BackgroundTransparency = 0,
										})
										:Play()
								else
									for _, button in next, cheat.list:GetChildren() do
										if button:IsA("TextButton") then
											neowise.gs["TweenService"]
												:Create(button, TweenInfo.new(0.2), { TextTransparency = 1 })
												:Play()
										end
									end

									neowise.gs["TweenService"]
										:Create(cheat.arrow, TweenInfo.new(0.35), {
											Rotation = 90,
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.listContainer, TweenInfo.new(0.35), {
											Size = UDim2.new(1, 0, 0, 0),
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.list, TweenInfo.new(0.35), {
											Size = UDim2.new(0, dropdownXSize, 0, 0),
											BackgroundTransparency = 1,
										})
										:Play()
								end
							end

							if not isMobile then
								cheat.dropdown.MouseEnter:Connect(function()
									neowise.gs["TweenService"]
										:Create(
											cheat.selected,
											TweenInfo.new(0.1),
											{ TextColor3 = Color3.fromRGB(255, 255, 255) }
										)
										:Play()
								end)
								cheat.dropdown.MouseLeave:Connect(function()
									neowise.gs["TweenService"]
										:Create(
											cheat.selected,
											TweenInfo.new(0.1),
											{ TextColor3 = neowise.theme.text_title }
										)
										:Play()
								end)
							end

							local function toggleDropdown()
								cheat.fadelist()
							end

							cheat.dropdown.MouseButton1Click:Connect(toggleDropdown)
							cheat.dropdown.TouchTap:Connect(toggleDropdown)

							refreshOptions()

							function cheat:Clear()
								refreshOptions()
							end

							function cheat:RemoveOption(value)
								local removed = false
								for index, option in next, options do
									if option == value then
										table.remove(options, index)
										removed = true
										break
									end
								end

								if removed then
									refreshOptions()
								end

								return removed
							end

							function cheat:AddOption(value)
								table.insert(options, value)
								refreshOptions()
							end

							function cheat:SetValue(value)
								cheat.selected.Text = value
								cheat.value = value

								if cheat.dropped then
									cheat.fadelist()
								end

								if callback then
									local s, e = pcall(function()
										callback(cheat.value)
									end)

									if not s then
										warn("error: " .. e)
									end
								end
							end

							table.insert(sector.dropdowns, cheat)
						elseif string.lower(kind) == "multidropdown" then
							cheat.value = {}
							cheat.buttons = {}

							local options
							if data and data.options then
								options = data.options
							end

							local dropdownXSize = 150 * SCALE
							cheat.dropped = false

							cheat.frame.Size = UDim2.new(1, 0, 0, 25 * SCALE)

							local dropdownLayout = neowise:Create("UIListLayout", {
								Padding = UDim.new(0, 2 * SCALE),
								SortOrder = Enum.SortOrder.LayoutOrder,
								Parent = cheat.frame,
							})

							local dropdownButtonContainer = neowise:Create("Frame", {
								Name = "DropdownButtonContainer",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 25 * SCALE),
								ZIndex = 2,
								LayoutOrder = 1,
								Parent = cheat.frame,
							})

							cheat.title.Parent = dropdownButtonContainer

							cheat.dropdown = neowise:Create("TextButton", {
								Name = "MultiDropdown",
								AnchorPoint = Vector2.new(1, 0.5),
								AutoButtonColor = false,
								BackgroundColor3 = neowise.theme.button_background,
								Position = UDim2.fromScale(1, 0.5),
								Size = UDim2.new(0, dropdownXSize, 0, 25 * SCALE),
								Text = "",
								ZIndex = 2,
								Parent = dropdownButtonContainer,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.dropdown,
							})

							neowise:Create("UIPadding", {
								PaddingRight = UDim.new(0, 8 * SCALE),
								Parent = cheat.dropdown,
							})

							cheat.arrow = neowise:Create("ImageLabel", {
								Name = "Arrow",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundTransparency = 1,
								Rotation = 90,
								Position = UDim2.fromScale(1, 0.5),
								Size = UDim2.fromOffset(10 * SCALE, 5 * SCALE),
								Image = neowise.icons.arrow_white,
								ZIndex = 2,
								Parent = cheat.dropdown,
							})

							cheat.selected = neowise:Create("TextLabel", {
								Name = "Selected",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 8 * SCALE, 0.5, 0),
								Size = UDim2.new(1, -10 * SCALE, 1, 0),
								FontFace = neowise.fonts.Inter_Regular,
								Text = "None",
								TextColor3 = neowise.theme.text_title,
								TextSize = 12 * SCALE,
								TextXAlignment = Enum.TextXAlignment.Left,
								ZIndex = 2,
								Parent = cheat.dropdown,
							})

							cheat.listContainer = neowise:Create("Frame", {
								Name = "ListContainer",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 0),
								ZIndex = 2,
								LayoutOrder = 2,
								Parent = cheat.frame,
							})

							cheat.list = neowise:Create("ScrollingFrame", {
								Name = "List",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = neowise.theme.button_background,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.fromScale(1, 0),
								Size = UDim2.new(0, dropdownXSize, 0, 0),
								CanvasSize = UDim2.fromScale(0, 0),
								ZIndex = 3,
								AutomaticCanvasSize = Enum.AutomaticSize.Y,
								BottomImage = "rbxassetid://967852042",
								MidImage = "rbxassetid://967852042",
								TopImage = "rbxassetid://967852042",
								VerticalScrollBarInset = Enum.ScrollBarInset.None,
								ScrollBarImageTransparency = isMobile and 0 or 1,
								ScrollBarThickness = isMobile and 4 * SCALE or 0,
								Parent = cheat.listContainer,
							})

							neowise:Create("UIPadding", {
								PaddingLeft = UDim.new(0, 8 * SCALE),
								PaddingRight = UDim.new(0, 8 * SCALE),
								Parent = cheat.list,
							})

							local listLayout = neowise:Create("UIListLayout", {
								Padding = UDim.new(0, 2 * SCALE),
								SortOrder = Enum.SortOrder.LayoutOrder,
								Parent = cheat.list,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.list,
							})

							local function updateSelectedText()
								if #cheat.value > 0 then
									cheat.selected.Text = #cheat.value .. " Enabled"
								else
									cheat.selected.Text = "None"
								end
							end

							local function refreshOptions()
								if cheat.dropped then
									cheat.fadelist()
								end

								for _, child in next, cheat.list:GetChildren() do
									if child:IsA("TextButton") then
										child:Destroy()
									end
								end

								cheat.buttons = {}

								for _, value in next, options do
									local button = neowise:Create("TextButton", {
										BackgroundColor3 = Color3.new(1, 1, 1),
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 20 * SCALE),
										ZIndex = 3,
										FontFace = neowise.fonts.Inter_Regular,
										Text = value,
										TextColor3 = neowise.theme.text_title,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextSize = 12 * SCALE,
									})

									table.insert(cheat.buttons, button)
									button.Parent = cheat.list

									if not isMobile then
										button.MouseEnter:Connect(function()
											if not table.find(cheat.value, value) then
												neowise.gs["TweenService"]
													:Create(
														button,
														TweenInfo.new(0.1),
														{ TextColor3 = Color3.fromRGB(255, 255, 255) }
													)
													:Play()
											end
										end)
										button.MouseLeave:Connect(function()
											if not table.find(cheat.value, value) then
												neowise.gs["TweenService"]
													:Create(
														button,
														TweenInfo.new(0.1),
														{ TextColor3 = neowise.theme.text_title }
													)
													:Play()
											end
										end)
									end

									local function toggleMultiValue()
										if cheat.dropped then
											if table.find(cheat.value, value) then
												table.remove(cheat.value, table.find(cheat.value, value))
												neowise.gs["TweenService"]
													:Create(
														button,
														TweenInfo.new(0.2),
														{ TextColor3 = neowise.theme.text_title }
													)
													:Play()
											else
												table.insert(cheat.value, value)
												neowise.gs["TweenService"]
													:Create(
														button,
														TweenInfo.new(0.2),
														{ TextColor3 = neowise.theme.text_dim }
													)
													:Play()
											end

											updateSelectedText()

											if callback then
												local s, e = pcall(function()
													callback(cheat.value)
												end)

												if not s then
													warn("error: " .. e)
												end
											end
										end
									end

									button.MouseButton1Click:Connect(toggleMultiValue)

									neowise.gs["TweenService"]
										:Create(button, TweenInfo.new(0), { TextTransparency = 1 })
										:Play()
								end

								neowise.gs["TweenService"]
									:Create(
										cheat.list,
										TweenInfo.new(0),
										{ Size = UDim2.new(0, dropdownXSize, 0, 0), BackgroundTransparency = 1 }
									)
									:Play()
								neowise.gs["TweenService"]
									:Create(cheat.listContainer, TweenInfo.new(0), { Size = UDim2.new(1, 0, 0, 0) })
									:Play()
							end

							listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
								if cheat.dropped then
									local maxHeight = 100 * SCALE
									local contentHeight = listLayout.AbsoluteContentSize.Y
									local finalHeight = math.min(contentHeight, maxHeight)

									neowise.gs["TweenService"]
										:Create(cheat.listContainer, TweenInfo.new(0.35), {
											Size = UDim2.new(1, 0, 0, finalHeight),
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.list, TweenInfo.new(0.35), {
											Size = UDim2.new(0, dropdownXSize, 0, finalHeight),
										})
										:Play()
								end
							end)

							dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
								cheat.frame.Size = UDim2.new(1, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
							end)

							function cheat.fadelist()
								cheat.dropped = not cheat.dropped

								if cheat.dropped then
									for _, otherCheat in next, sector.dropdowns do
										if otherCheat ~= cheat and otherCheat.dropped then
											otherCheat.fadelist()
										end
									end

									local maxHeight = 100 * SCALE
									local contentHeight = listLayout.AbsoluteContentSize.Y
									local finalHeight = math.min(contentHeight, maxHeight)

									for _, button in next, cheat.list:GetChildren() do
										if button:IsA("TextButton") then
											neowise.gs["TweenService"]
												:Create(button, TweenInfo.new(0.2), { TextTransparency = 0 })
												:Play()
										end
									end

									neowise.gs["TweenService"]
										:Create(cheat.arrow, TweenInfo.new(0.35), {
											Rotation = 0,
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.listContainer, TweenInfo.new(0.35), {
											Size = UDim2.new(1, 0, 0, finalHeight),
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.list, TweenInfo.new(0.35), {
											Size = UDim2.new(0, dropdownXSize, 0, finalHeight),
											BackgroundTransparency = 0,
										})
										:Play()
								else
									for _, button in next, cheat.list:GetChildren() do
										if button:IsA("TextButton") then
											neowise.gs["TweenService"]
												:Create(button, TweenInfo.new(0.2), { TextTransparency = 1 })
												:Play()
										end
									end

									neowise.gs["TweenService"]
										:Create(cheat.arrow, TweenInfo.new(0.35), {
											Rotation = 90,
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.listContainer, TweenInfo.new(0.35), {
											Size = UDim2.new(1, 0, 0, 0),
										})
										:Play()

									neowise.gs["TweenService"]
										:Create(cheat.list, TweenInfo.new(0.35), {
											Size = UDim2.new(0, dropdownXSize, 0, 0),
											BackgroundTransparency = 1,
										})
										:Play()
								end
							end

							if not isMobile then
								cheat.dropdown.MouseEnter:Connect(function()
									neowise.gs["TweenService"]
										:Create(
											cheat.selected,
											TweenInfo.new(0.1),
											{ TextColor3 = Color3.fromRGB(255, 255, 255) }
										)
										:Play()
								end)
								cheat.dropdown.MouseLeave:Connect(function()
									neowise.gs["TweenService"]
										:Create(
											cheat.selected,
											TweenInfo.new(0.1),
											{ TextColor3 = neowise.theme.text_title }
										)
										:Play()
								end)
							end

							local function toggleMultiDropdown()
								cheat.fadelist()
							end

							cheat.dropdown.MouseButton1Click:Connect(toggleMultiDropdown)
							cheat.dropdown.TouchTap:Connect(toggleMultiDropdown)

							refreshOptions()

							function cheat:Clear()
								cheat.value = {}
								updateSelectedText()
								refreshOptions()
							end

							function cheat:RemoveOption(value)
								local removed = false
								for index, option in next, options do
									if option == value then
										table.remove(options, index)
										removed = true
										break
									end
								end

								if table.find(cheat.value, value) then
									table.remove(cheat.value, table.find(cheat.value, value))
									updateSelectedText()
								end

								if removed then
									refreshOptions()
								end

								return removed
							end

							function cheat:AddOption(value)
								table.insert(options, value)
								refreshOptions()
							end

							function cheat:SetValue(value)
								cheat.value = value
								updateSelectedText()

								for i, v in ipairs(cheat.buttons) do
									if table.find(cheat.value, v.Text) then
										neowise.gs["TweenService"]
											:Create(v, TweenInfo.new(0.2), { TextColor3 = neowise.theme.text_dim })
											:Play()
									else
										neowise.gs["TweenService"]
											:Create(v, TweenInfo.new(0.2), { TextColor3 = neowise.theme.text_title })
											:Play()
									end
								end

								if callback then
									local s, e = pcall(function()
										callback(cheat.value)
									end)

									if not s then
										warn("error: " .. e)
									end
								end
							end

							table.insert(sector.dropdowns, cheat)
						elseif string.lower(kind) == "slider" then
							cheat.value = 0

							local suffix = data.suffix or "%"
							local minimum = data.min or 0
							local maximum = data.max or 1
							local default = data.default or minimum
							local precise = data.precise

							local moveconnection
							local releaseconnection
							local touchconnection

							cheat.frame.Size = UDim2.new(1, 0, 0, 30 * SCALE)
							cheat.title:Destroy()

							cheat.slider = neowise:Create("Frame", {
								Name = "Slider",
								BackgroundColor3 = neowise.theme.button_background,
								Size = UDim2.new(1, 0, 0, 22 * SCALE),
								Position = UDim2.fromScale(0, 0.5),
								AnchorPoint = Vector2.new(0, 0.5),
								ZIndex = 2,
								Parent = cheat.frame,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.slider,
							})

							cheat.sliderbar = neowise:Create("Frame", {
								Name = "Sliderbar",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundColor3 = Color3.new(1, 1, 1),
								Position = UDim2.fromScale(0, 0.5),
								Size = UDim2.fromScale(0, 1),
								ZIndex = 2,
								Parent = cheat.slider,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.sliderbar,
							})

							neowise:Create("UIGradient", {
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(
										0,
										neowise.theme.text_dim:Lerp(neowise.theme.accent, 0.25)
									),
									ColorSequenceKeypoint.new(1, neowise.theme.text_dim),
								}),
								Parent = cheat.sliderbar,
							})

							cheat.nameLabel = neowise:Create("TextLabel", {
								Name = "NameLabel",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 8 * SCALE, 0.5, 0),
								Size = UDim2.new(0.5, -8 * SCALE, 1, 0),
								ZIndex = 3,
								FontFace = neowise.fonts.Inter_SemiBold,
								Text = name,
								TextColor3 = Color3.new(1, 1, 1),
								TextSize = 12 * SCALE,
								TextXAlignment = Enum.TextXAlignment.Left,
								Parent = cheat.slider,
							})

							cheat.numbervalue = neowise:Create("TextLabel", {
								Name = "Value",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -8 * SCALE, 0.5, 0),
								Size = UDim2.new(0.5, -8 * SCALE, 1, 0),
								ZIndex = 3,
								FontFace = neowise.fonts.Inter_SemiBold,
								Text = tostring(cheat.value) .. suffix,
								TextColor3 = Color3.new(1, 1, 1),
								TextSize = 12 * SCALE,
								TextXAlignment = Enum.TextXAlignment.Right,
								Parent = cheat.slider,
							})

							local clickArea = neowise:Create("TextButton", {
								Name = "ClickArea",
								BackgroundTransparency = 1,
								Size = UDim2.fromScale(1, 1),
								Text = "",
								ZIndex = 4,
								Parent = cheat.slider,
							})

							local function setSliderValue(value)
								value = math.clamp(value, minimum, maximum)

								local percent = (value - minimum) / (maximum - minimum)
								cheat.value = value

								if precise then
									cheat.numbervalue.Text = tostring(math.floor(value)) .. suffix
								else
									cheat.numbervalue.Text = string.format("%.2f", value) .. suffix
								end

								neowise.gs["TweenService"]
									:Create(cheat.sliderbar, TweenInfo.new(0.1), {
										Size = UDim2.new(percent, 0, 1, 0),
									})
									:Play()
							end

							local function getValueFromPosition(posX)
								local sliderWidth = cheat.slider.AbsoluteSize.X
								local sliderStart = cheat.slider.AbsolutePosition.X

								local percent = math.clamp((posX - sliderStart) / sliderWidth, 0, 1)
								return minimum + (maximum - minimum) * percent
							end

							local function updateSliderFromMouse()
								local newValue = getValueFromPosition(mouse.X)
								setSliderValue(newValue)

								if callback then
									local s, e = pcall(function()
										if precise then
											callback(math.floor(newValue))
										else
											callback(newValue)
										end
									end)

									if not s then
										warn("error: " .. e)
									end
								end
							end

							if default then
								setSliderValue(default)

								if callback then
									local s, e = pcall(function()
										if precise then
											callback(math.floor(default))
										else
											callback(default)
										end
									end)

									if not s then
										warn("error: " .. e)
									end
								end
							end

							clickArea.InputBegan:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 then
									updateSliderFromMouse()

									moveconnection = mouse.Move:Connect(updateSliderFromMouse)

									releaseconnection = neowise.gs["UserInputService"].InputEnded:Connect(
										function(endInput)
											if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
												if moveconnection then
													moveconnection:Disconnect()
													moveconnection = nil
												end

												if releaseconnection then
													releaseconnection:Disconnect()
													releaseconnection = nil
												end
											end
										end
									)
								elseif input.UserInputType == Enum.UserInputType.Touch then
									local newValue = getValueFromPosition(input.Position.X)
									setSliderValue(newValue)

									if callback then
										local s, e = pcall(function()
											if precise then
												callback(math.floor(newValue))
											else
												callback(newValue)
											end
										end)

										if not s then
											warn("error: " .. e)
										end
									end

									touchconnection = input.Changed:Connect(function()
										if input.UserInputState == Enum.UserInputState.End then
											if touchconnection then
												touchconnection:Disconnect()
												touchconnection = nil
											end
										end
									end)
								end
							end)

							clickArea.InputChanged:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.Touch then
									local newValue = getValueFromPosition(input.Position.X)
									setSliderValue(newValue)

									if callback then
										local s, e = pcall(function()
											if precise then
												callback(math.floor(newValue))
											else
												callback(newValue)
											end
										end)

										if not s then
											warn("error: " .. e)
										end
									end
								end
							end)

							function cheat:SetValue(value)
								setSliderValue(value)

								if callback then
									local s, e = pcall(function()
										if precise then
											callback(math.floor(value))
										else
											callback(value)
										end
									end)

									if not s then
										warn("error: " .. e)
									end
								end
							end
						elseif string.lower(kind) == "button" then
							local button_text = data and data.text

							cheat.button = neowise:Create("TextButton", {
								Name = "Button",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundColor3 = neowise.theme.button_background,
								Position = UDim2.fromScale(1, 0.5),
								Size = UDim2.new(0, 100 * SCALE, 0, 25 * SCALE),
								FontFace = neowise.fonts.Inter_Regular,
								Text = button_text or "Button",
								TextColor3 = neowise.theme.text_title,
								TextSize = 12 * SCALE,
								ZIndex = 2,
								Parent = cheat.frame,
							})

							neowise:Create("UICorner", {
								CornerRadius = UDim.new(0, 10 * SCALE),
								Parent = cheat.button,
							})

							local function handleButtonClick()
								if callback then
									local s, e = pcall(function()
										callback()
									end)

									if not s then
										warn("error: " .. e)
									end
								end
							end

							cheat.button.MouseButton1Click:Connect(handleButtonClick)

							function cheat:Fire()
								handleButtonClick()
							end
						end
					end

					return cheat
				end

				return sector
			end

			return tab
		end

		return category
	end

	if not neowise.gs["RunService"]:IsStudio() then
		self2.userinterface.Parent = neowise.gs["CoreGui"]
	else
		self2.userinterface.Parent = neowise.gs["Players"].LocalPlayer:WaitForChild("PlayerGui")
	end

	self2.container.Parent = self2.userinterface
	self2.categories.Parent = self2.container
	self2.sidebar.Parent = self2.container
	self2.tip.Parent = self2.container
	self2.mobileToggle.Parent = self2.userinterface

	return self2, neowiseData
end

return neowise
