local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- === Admin Check ===
local function isAdmin()
	return player.Name == "thefakeparkourmaster" or player.UserId == 123456789
end

if not isAdmin() then return end

-- === UI Setup ===
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PanelOfPower"
screenGui.ResetOnSpawn = false

-- Draggable Panel
local panelFrame = Instance.new("Frame")
panelFrame.Size = UDim2.new(0, 200, 0, 220)
panelFrame.Position = UDim2.new(0, 20, 0, 100)
panelFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panelFrame.Active = true
panelFrame.Draggable = true
panelFrame.BorderSizePixel = 0
panelFrame.Parent = screenGui

local uiListLayout = Instance.new("UIListLayout", panelFrame)
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(name, text)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	button.Size = UDim2.new(1, -10, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.BorderSizePixel = 0
	button.Parent = panelFrame
	return button
end

local speedButton = createButton("SpeedButton", "Speed Power")
local teleportButton = createButton("TeleportButton", "Teleport Tool")
local locateButton = createButton("LocateButton", "Locate Players")
local notepadButton = createButton("NotepadButton", "Notepad")

-- === Speed Power ===
local speedStates = {16, 32, 64, 80}
local currentSpeedIndex = 1
local speedCooldown = false

speedButton.MouseButton1Click:Connect(function()
	if speedCooldown then return end
	speedCooldown = true
	currentSpeedIndex += 1
	if currentSpeedIndex > #speedStates then currentSpeedIndex = 2 end -- skip 16
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = speedStates[currentSpeedIndex]
	end
	task.delay(0.5, function() speedCooldown = false end)
end)

-- === Teleport Tool ===
local teleportCooldown = false
local teleportTool = nil

teleportButton.MouseButton1Click:Connect(function()
	if teleportCooldown then return end
	teleportCooldown = true

	if teleportTool and teleportTool.Parent then
		teleportTool:Destroy()
	end

	teleportTool = Instance.new("Tool")
	teleportTool.RequiresHandle = false
	teleportTool.Name = "Teleport Tool"

	teleportTool.Activated:Connect(function()
		if not mouse then return end
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local pos = mouse.Hit.Position
			char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		end
	end)

	teleportTool.Parent = player.Backpack

	task.delay(15, function()
		teleportCooldown = false
	end)
end)

-- === Locate Players ===
local locateCooldown = false

locateButton.MouseButton1Click:Connect(function()
	if locateCooldown then return end
	locateCooldown = true

	for _, target in pairs(Players:GetPlayers()) do
		if target ~= player and target.Character then
			local char = target.Character
			local highlight = Instance.new("Highlight")
			highlight.Name = "LocateHighlight"
			highlight.Adornee = char
			highlight.FillColor = Color3.fromRGB(255, 255, 0)
			highlight.FillTransparency = 0.2
			highlight.OutlineTransparency = 1
			highlight.Parent = char

			task.delay(4, function()
				if highlight and highlight.Parent then
					highlight:Destroy()
				end
			end)
		end
	end

	task.delay(20, function()
		locateCooldown = false
	end)
end)

-- === Notepad GUI ===
local notepadGui = Instance.new("Frame")
notepadGui.Size = UDim2.new(0, 400, 0, 300)
notepadGui.Position = UDim2.new(0.5, -200, 0.5, -150)
notepadGui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
notepadGui.Visible = false
notepadGui.BorderSizePixel = 0
notepadGui.Active = true
notepadGui.Draggable = true
notepadGui.Parent = screenGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -60)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.MultiLine = true
textBox.ClearTextOnFocus = false
textBox.Text = "-- Type local script here\n"
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.Font = Enum.Font.Code
textBox.TextSize = 16
textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
textBox.BorderSizePixel = 0
textBox.Parent = notepadGui

local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0, 120, 0, 30)
runButton.Position = UDim2.new(1, -130, 1, -40)
runButton.Text = "Run Script"
runButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
runButton.TextColor3 = Color3.new(1, 1, 1)
runButton.Font = Enum.Font.GothamBold
runButton.TextSize = 14
runButton.BorderSizePixel = 0
runButton.Parent = notepadGui

notepadButton.MouseButton1Click:Connect(function()
	notepadGui.Visible = notepadGui.Visible == false
end)

runButton.MouseButton1Click:Connect(function()
	local code = textBox.Text
	local func, err = loadstring(code)
	if func then
		pcall(func)
	else
		warn("Script error:", err)
	end
end)
