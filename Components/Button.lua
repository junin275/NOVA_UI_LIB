local Button = {}
Button.__index = Button

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

function Button:New(section, options)
	options = options or {}

	local self = setmetatable({}, Button)

	self.Section = section
	self.Name = options.Name or "Button"
	self.Description = options.Description or nil
	self.Icon = options.Icon or nil
	self.Callback = options.Callback or function() end
	self.Theme = options.Theme or "default"

	local container = Instance.new("Frame")
	container.Name = "Button_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local mainFrame = Instance.new("TextButton")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Text = ""
	mainFrame.AutoButtonColor = false
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, -20, 1, 0)
	contentFrame.Position = UDim2.new(0, 10, 0, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = mainFrame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 8)
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = contentFrame

	local iconLabel = nil
	if self.Icon then
		iconLabel = IconManager:CreateIconLabel(contentFrame, self.Icon, UDim2.new(0, 18, 0, 18), ThemeManager:GetColor("TextSecondary"))
		if iconLabel then
			iconLabel.LayoutOrder = 1
		end
	end

	local textFrame = Instance.new("Frame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.new(0, 0, 1, 0)
	textFrame.BackgroundTransparency = 1
	textFrame.BorderSizePixel = 0
	textFrame.AutomaticSize = Enum.AutomaticSize.X
	textFrame.LayoutOrder = 2
	textFrame.Parent = contentFrame

	self.TextFrame = textFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.AutomaticSize = Enum.AutomaticSize.X
	nameLabel.Parent = textFrame

	self.NameLabel = nameLabel

	if self.Description then
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(0, 0, 1, 0)
		descLabel.Position = UDim2.new(1, 6, 0, 0)
		descLabel.BackgroundTransparency = 1
		descLabel.BorderSizePixel = 0
		descLabel.Text = self.Description
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextSize = 12
		descLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextYAlignment = Enum.TextYAlignment.Center
		descLabel.AutomaticSize = Enum.AutomaticSize.X
		descLabel.Parent = textFrame
	end

	local hoverGlow = Instance.new("Frame")
	hoverGlow.Name = "HoverGlow"
	hoverGlow.Size = UDim2.new(1, 0, 1, 0)
	hoverGlow.BackgroundColor3 = ThemeManager:GetColor("Accent")
	hoverGlow.BackgroundTransparency = 1
	hoverGlow.BorderSizePixel = 0
	hoverGlow.ZIndex = mainFrame.ZIndex - 1
	hoverGlow.Parent = container

	Utility:CreateCorner(hoverGlow, 6)

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.15)
		AnimationManager:CreateTween(hoverGlow, {
			BackgroundTransparency = 0.92
		}, "Smooth", "Out", 0.2)
		SoundManager:PlayHover()
	end)

	mainFrame.MouseLeave:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.2)
		AnimationManager:CreateTween(hoverGlow, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.25)
	end)

	mainFrame.MouseButton1Down:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.2
		}, "Sharp", "In", 0.08)
		AnimationManager:CreateTween(container, {
			Size = UDim2.new(1, 0, 0, 34)
		}, "Sharp", "In", 0.08)
	end)

	mainFrame.MouseButton1Up:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.1
		}, "Elastic", "Out", 0.3)
		AnimationManager:CreateTween(container, {
			Size = UDim2.new(1, 0, 0, 36)
		}, "Elastic", "Out", 0.3)
	end)

	mainFrame.MouseButton1Click:Connect(function()
		SoundManager:PlayClick()
		AnimationManager:RippleEffect(mainFrame, ThemeManager:GetColor("Accent"), 0.4)
		local success, err = pcall(self.Callback)
		if not success then
			warn("Button callback error:", err)
		end
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Button:SetCallback(callback)
	self.Callback = callback
end

function Button:SetText(text)
	self.Name = text
	self.NameLabel.Text = text
end

function Button:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
	else
		self.NameLabel.TextColor3 = palette.TextPrimary
	end
end

function Button:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return Button
