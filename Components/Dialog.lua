local Dialog = {}
Dialog.__index = Dialog

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

function Dialog:New(options)
	options = options or {}

	local self = setmetatable({}, Dialog)

	self.Title = options.Title or "Dialog"
	self.Message = options.Message or ""
	self.Buttons = options.Buttons or {"OK", "Cancel"}
	self.DefaultButton = options.DefaultButton or 1
	self.Callback = options.Callback or function() end
	self.Type = options.Type or "Info"

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_Dialog"
	screenGui.DisplayOrder = 200
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent

	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	self.Overlay = overlay

	local container = Instance.new("Frame")
	container.Name = "Dialog"
	container.Size = UDim2.new(0, 360, 0, 0)
	container.Position = UDim2.new(0.5, -180, 0.5, 0)
	container.AnchorPoint = Vector2.new(0, 0.5)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Parent = screenGui
	self.Container = container
	Utility:CreateCorner(container, 10)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local typeIcons = {
		Info = "Info",
		Success = "Check",
		Warning = "Warning",
		Error = "Cross",
	}

	local typeColors = {
		Info = ThemeManager:GetColor("Info"),
		Success = ThemeManager:GetColor("Success"),
		Warning = ThemeManager:GetColor("Warning"),
		Error = ThemeManager:GetColor("Danger"),
	}

	local iconContainer = Instance.new("Frame")
	iconContainer.Name = "IconContainer"
	iconContainer.Size = UDim2.new(0, 40, 0, 40)
	iconContainer.Position = UDim2.new(0.5, -20, 0, 16)
	iconContainer.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	iconContainer.BorderSizePixel = 0
	iconContainer.Parent = container
	Utility:CreateCorner(iconContainer, 20)

	local dialogIcon = IconManager:CreateIconLabel(iconContainer, typeIcons[self.Type] or "Info", UDim2.new(0, 22, 0, 22), typeColors[self.Type] or typeColors.Info)
	if dialogIcon then
		dialogIcon.Position = UDim2.new(0.5, -11, 0.5, -11)
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -32, 0, 24)
	titleLabel.Position = UDim2.new(0, 16, 0, 64)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 18
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -32, 0, 20)
	messageLabel.Position = UDim2.new(0, 16, 0, 90)
	messageLabel.BackgroundTransparency = 1
	messageLabel.BorderSizePixel = 0
	messageLabel.Text = self.Message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 14
	messageLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	messageLabel.TextXAlignment = Enum.TextXAlignment.Center
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.TextWrapped = true
	messageLabel.AutomaticSize = Enum.AutomaticSize.Y
	messageLabel.Parent = container
	self.MessageLabel = messageLabel

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "Buttons"
	buttonFrame.Size = UDim2.new(1, -32, 0, 32)
	buttonFrame.Position = UDim2.new(0, 16, 1, -48)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Parent = container

	local buttonLayout = Instance.new("UIListLayout")
	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonLayout.Padding = UDim.new(0, 8)
	buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
	buttonLayout.Parent = buttonFrame

	self._buttons = {}

	for i, btnText in ipairs(self.Buttons) do
		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. btnText
		btn.Size = UDim2.new(0, math.max(80, #btnText * 10 + 20), 0, 32)
		btn.BackgroundColor3 = (i == self.DefaultButton) and ThemeManager:GetColor("Accent") or ThemeManager:GetColor("SurfaceAlt")
		btn.BackgroundTransparency = 0
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = buttonFrame
		Utility:CreateCorner(btn, 6)

		if i ~= self.DefaultButton then
			Utility:CreateStroke(btn, ThemeManager:GetColor("Border"), 0.6, 1)
		end

		local btnLabel = Instance.new("TextLabel")
		btnLabel.Name = "Label"
		btnLabel.Size = UDim2.new(1, 0, 1, 0)
		btnLabel.BackgroundTransparency = 1
		btnLabel.BorderSizePixel = 0
		btnLabel.Text = btnText
		btnLabel.Font = Enum.Font.GothamSemibold
		btnLabel.TextSize = 13
		btnLabel.TextColor3 = (i == self.DefaultButton) and Color3.fromRGB(255, 255, 255) or ThemeManager:GetColor("TextSecondary")
		btnLabel.TextXAlignment = Enum.TextXAlignment.Center
		btnLabel.TextYAlignment = Enum.TextYAlignment.Center
		btnLabel.Parent = btn

		btn.MouseEnter:Connect(function()
			AnimationManager:CreateTween(btn, {
				BackgroundTransparency = 0.15
			}, "Smooth", "Out", 0.15)
		end)

		btn.MouseLeave:Connect(function()
			AnimationManager:CreateTween(btn, {
				BackgroundTransparency = 0
			}, "Smooth", "Out", 0.2)
		end)

		btn.MouseButton1Click:Connect(function()
			SoundManager:PlayClick()
			AnimationManager:CreateTween(screenGui, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
			self:Close(function()
				pcall(self.Callback, btnText, i)
			end)
		end)

		self._buttons[btnText] = btn
	end

	container.Size = UDim2.new(0, 360, 0, container.AutomaticSize.Y)

	AnimationManager:CreateTween(overlay, {
		BackgroundTransparency = 0.4
	}, "Smooth", "Out", 0.3)

	container.Position = UDim2.new(0.5, -180, 0.5, 20)
	AnimationManager:CreateTween(container, {
		Position = UDim2.new(0.5, -180, 0.5, 0)
	}, "Smooth", "Out", 0.35)

	return self
end

function Dialog:Close(callback)
	AnimationManager:CreateTween(self.Overlay, {
		BackgroundTransparency = 1
	}, "Smooth", "Out", 0.2)

	AnimationManager:CreateTween(self.Container, {
		Position = UDim2.new(0.5, -180, 0.5, -50),
		BackgroundTransparency = 0.1
	}, "Smooth", "In", 0.25, function()
		self.Container.Parent:Destroy()
		if callback then
			callback()
		end
	end)
end

return Dialog
