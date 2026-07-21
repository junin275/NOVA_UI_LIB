local Tooltip = {}
Tooltip.__index = Tooltip

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player and Player:GetMouse()

local ACTIVE_TOOLTIP = nil

function Tooltip:New(target, text, options)
	options = options or {}

	local self = setmetatable({}, Tooltip)

	self.Target = target
	self.Text = text or ""
	self.Position = options.Position or "Top"
	self.Offset = options.Offset or Vector2.new(0, 8)
	self.MaxWidth = options.MaxWidth or 200
	self.Delay = options.Delay or 0.5

	local parent = target.Parent
	while parent and not parent:IsA("ScreenGui") do
		parent = parent.Parent
	end

	local tooltip = Instance.new("Frame")
	tooltip.Name = "Tooltip"
	tooltip.Size = UDim2.new(0, 0, 0, 0)
	tooltip.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	tooltip.BorderSizePixel = 0
	tooltip.Visible = false
	tooltip.ZIndex = 1000
	tooltip.Parent = target
	self.Tooltip = tooltip
	Utility:CreateCorner(tooltip, 5)
	Utility:CreateStroke(tooltip, ThemeManager:GetColor("Border"), 0.5, 1)

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Text = self.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextColor3 = ThemeManager:GetColor("TextPrimary")
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = tooltip
	self.Label = label

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = tooltip

	local hoverConnection
	local leaveConnection

	hoverConnection = target.MouseEnter:Connect(function()
		if ACTIVE_TOOLTIP and ACTIVE_TOOLTIP ~= self then
			ACTIVE_TOOLTIP:Hide()
		end
		ACTIVE_TOOLTIP = self
		task.delay(self.Delay, function()
			if ACTIVE_TOOLTIP == self then
				self:Show()
			end
		end)
	end)

	leaveConnection = target.MouseLeave:Connect(function()
		if ACTIVE_TOOLTIP == self then
			ACTIVE_TOOLTIP = nil
		end
		self:Hide()
	end)

	self._hoverConnection = hoverConnection
	self._leaveConnection = leaveConnection

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Tooltip:Show()
	local textSize = self.Label.TextBounds
	local width = math.min(textSize.X + 20, self.MaxWidth)
	local height = textSize.Y + 12

	self.Tooltip.Size = UDim2.new(0, width, 0, 0)
	self.Tooltip.Visible = true
	self.Label.Size = UDim2.new(1, -20, 0, height - 12)

	local targetPos = self.Target.AbsolutePosition
	local targetSize = self.Target.AbsoluteSize
	local tipPosition

	if self.Position == "Top" then
		tipPosition = UDim2.new(0.5, -width / 2, 0, -(height + self.Offset.Y))
	elseif self.Position == "Bottom" then
		tipPosition = UDim2.new(0.5, -width / 2, 1, self.Offset.Y)
	elseif self.Position == "Left" then
		tipPosition = UDim2.new(0, -(width + self.Offset.X), 0.5, -height / 2)
	elseif self.Position == "Right" then
		tipPosition = UDim2.new(1, self.Offset.X, 0.5, -height / 2)
	end

	self.Tooltip.Position = tipPosition

	AnimationManager:CreateTween(self.Tooltip, {
		Size = UDim2.new(0, width, 0, height)
	}, "Smooth", "Out", 0.2)
end

function Tooltip:Hide()
	if not self.Tooltip.Visible then
		return
	end
	AnimationManager:CreateTween(self.Tooltip, {
		Size = UDim2.new(0, 0, 0, 0)
	}, "Smooth", "Out", 0.15, function()
		self.Tooltip.Visible = false
	end)
end

function Tooltip:SetText(text)
	self.Text = text
	self.Label.Text = text
end

function Tooltip:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Tooltip, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.Tooltip.BackgroundColor3 = palette.SurfaceAlt
	end
end

function Tooltip:Destroy()
	if ACTIVE_TOOLTIP == self then
		ACTIVE_TOOLTIP = nil
	end
	if self._hoverConnection then
		self._hoverConnection:Disconnect()
	end
	if self._leaveConnection then
		self._leaveConnection:Disconnect()
	end
	if self._themeConnection then
		self._themeConnection()
	end
	self.Tooltip:Destroy()
end

return Tooltip
