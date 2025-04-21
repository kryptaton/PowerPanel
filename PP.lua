local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- === Admin Check ===
local function isAdmin()
    -- Edit this check to match your admin system
    return player.Name == "thefakeparkourmaster" or player.UserId == 123456789
end

if not isAdmin() then return end

-- === UI Setup ===
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PanelOfPower"

local function createButton(name, text, position)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	button.Size = UDim2.new(0, 160, 0, 40)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.Parent = screenGui
	return button
end

local speedButton = createButton("SpeedButton", "Speed Power", UDim2.new(0, 20, 0, 100))
local teleportButton = createButton("TeleportButton", "Teleport Tool", UDim2.new(0, 20, 0, 150))
local locateButton = createButton("LocateButton", "Locate Players", UDim2.new(0, 20, 0, 200))

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

	-- Create Teleport Tool
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
