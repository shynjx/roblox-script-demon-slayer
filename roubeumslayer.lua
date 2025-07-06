local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local speed = 30
local minSpeed = 30
local maxSpeed = 100
local dragging = false
local noclipEnabled = false

local gui
local fill, knob, label, noclipBtn

local function updateSlider()
	local pct = (speed - minSpeed) / (maxSpeed - minSpeed)
	if fill then fill.Size = UDim2.new(pct, 0, 1, 0) end
	if knob then knob.Position = UDim2.new(pct, 0, 0.5, 0) end
	if label then label.Text = "Velocidade: "..speed end
end

local function applyEffects(character)
	local hum = character:WaitForChild("Humanoid")
	if hum then
		hum.WalkSpeed = speed
	end
end

local function createGui()
	if player.PlayerGui:FindFirstChild("ShynjxGUI") then
		player.PlayerGui.ShinjxGUI:Destroy()
	end

	local guiLocal = Instance.new("ScreenGui", player.PlayerGui)
	guiLocal.Name = "ShynjxGUI"

	local frame = Instance.new("Frame", guiLocal)
	frame.Size = UDim2.new(0, 300, 0, 200)
	frame.Position = UDim2.new(0.5, -150, 0.5, -100)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Position = UDim2.new(0, 0, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = "Speed Hack GUI"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(0, 170, 255)

	label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 0, 24)
	label.Position = UDim2.new(0, 0, 0, 40)
	label.BackgroundTransparency = 1
	label.Text = "Velocidade: "..speed
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 18
	label.TextColor3 = Color3.new(1,1,1)

	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(0, 240, 0, 12)
	bar.Position = UDim2.new(0.5, -120, 0, 70)
	bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	bar.BorderSizePixel = 0

	fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((speed - minSpeed) / (maxSpeed - minSpeed), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	fill.BorderSizePixel = 0

	knob = Instance.new("ImageButton", bar)
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new((speed - minSpeed) / (maxSpeed - minSpeed), -9, 0.5, -9)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundTransparency = 1
	knob.Image = "rbxassetid://3570695787"
	knob.ImageColor3 = Color3.fromRGB(0, 170, 255)

	noclipBtn = Instance.new("TextButton", frame)
	noclipBtn.Size = UDim2.new(0, 120, 0, 36)
	noclipBtn.Position = UDim2.new(0.1, 0, 0, 110)
	noclipBtn.Font = Enum.Font.GothamBold
	noclipBtn.TextSize = 16
	noclipBtn.TextColor3 = Color3.new(1, 1, 1)
	noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

	local steelBtn = Instance.new("TextButton", frame)
	steelBtn.Size = UDim2.new(0, 120, 0, 36)
	steelBtn.Position = UDim2.new(0.55, 0, 0, 110)
	steelBtn.Text = "Steel"
	steelBtn.Font = Enum.Font.GothamBold
	steelBtn.TextSize = 16
	steelBtn.TextColor3 = Color3.new(1, 1, 1)
	steelBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)

	local credit = Instance.new("TextLabel", frame)
	credit.Size = UDim2.new(1, 0, 0, 20)
	credit.Position = UDim2.new(0, 0, 1, -22)
	credit.BackgroundTransparency = 1
	credit.Text = "Criado por Shynjx"
	credit.Font = Enum.Font.Gotham
	credit.TextSize = 14
	credit.TextColor3 = Color3.fromRGB(150, 150, 150)

	noclipBtn.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"

	knob.MouseButton1Down:Connect(function()
		dragging = true
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	RunService.RenderStepped:Connect(function()
		if dragging then
			local mx = UIS:GetMouseLocation().X
			local x0 = bar.AbsolutePosition.X
			local w = bar.AbsoluteSize.X
			local rx = math.clamp(mx - x0, 0, w)
			local pct = rx / w
			speed = math.floor(minSpeed + pct * (maxSpeed - minSpeed))
			updateSlider()
		end
	end)

	noclipBtn.MouseButton1Click:Connect(function()
		noclipEnabled = not noclipEnabled
		noclipBtn.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
	end)

	steelBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = CFrame.new(54.3979, 16.2781, -30.125)
		end
	end)

	updateSlider()

	return guiLocal
end

player.CharacterAdded:Connect(function(char)
	applyEffects(char)
	gui = createGui()
end)

if player.Character then
	applyEffects(player.Character)
	gui = createGui()
end

RunService.RenderStepped:Connect(function()
	local char = player.Character
	if char then
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		if hum then
			hum.WalkSpeed = speed
		end
		if noclipEnabled then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then
					p.CanCollide = false
				end
			end
		end
	end
end)
