local Separator = {}
Separator.__index = Separator

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)

function Separator:New(section, options)
	options = options or {}

	local self = setmetatable({}, Separator)

	self.Section = section
	self.Text = options.Text or nil
	self.Padding = options.Padding or 8

	local container = Instance.new("Frame")
	container.Name = "Separator"
	container.Size = UDim2.new(1, 0, 0, self.Text and 28 or 12)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	if self.Text then
		local label = Instance.new("TextLabel")
		label.Name = "Text"
		label.Size = UDim2.new(0, 0, 0, 16)
		label.Position = UDim2.new(0, 10, 0.5, -8)
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Text = self.Text
		label.Font = Enum.Font.GothamSemibold
		label.TextSize = 12
		label.TextColor3 = ThemeManager:GetColor("TextMuted")
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.AutomaticSize = Enum.AutomaticSize.X
		label.Parent = container
		self.Label = label

		local line1 = Instance.new("Frame")
		line1.Name = "Line1"
		line1.Size = UDim2.new(0, 6, 0, 1)
		line1.Position = UDim2.new(0, 0, 0.5, -0.5)
		line1.BackgroundColor3 = ThemeManager:GetColor("Border")
		line1.BorderSizePixel = 0
		line1.Parent = container

		local line2 = Instance.new("Frame")
		line2.Name = "Line2"
		line2.Size = UDim2.new(1, -(label.AutomaticSize.X + 26), 0, 1)
		line2.Position = UDim2.new(0, label.AutomaticSize.X + 16, 0.5, -0.5)
		line2.BackgroundColor3 = ThemeManager:GetColor("Border")
		line2.BorderSizePixel = 0
		line2.Parent = container
		self.Line2 = line2
	else
		local line = Instance.new("Frame")
		line.Name = "Line"
		line.Size = UDim2.new(1, -20, 0, 1)
		line.Position = UDim2.new(0, 10, 0.5, -0.5)
		line.BackgroundColor3 = ThemeManager:GetColor("Border")
		line.BorderSizePixel = 0
		line.Parent = container
		self.Line = line
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Separator:UpdateTheme(palette, animate)
	local lineColor = palette.Border
	if animate then
		if self.Line then
			AnimationManager:CreateTween(self.Line, {
				BackgroundColor3 = lineColor,
			}, "Smooth", "Out", 0.3)
		end
		if self.Line2 then
			AnimationManager:CreateTween(self.Line2, {
				BackgroundColor3 = lineColor,
			}, "Smooth", "Out", 0.3)
		end
	else
		if self.Line then self.Line.BackgroundColor3 = lineColor end
		if self.Line2 then self.Line2.BackgroundColor3 = lineColor end
	end
end

function Separator:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return Separator
