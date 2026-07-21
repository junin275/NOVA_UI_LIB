local Tab = {}
Tab.__index = Tab

local TweenService = game:GetService("TweenService")
local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

function Tab:New(window, options)
	options = options or {}

	local self = setmetatable({}, Tab)

	self.Window = window
	self.Name = options.Name or "Tab"
	self.Icon = options.Icon or nil
	self.Sections = {}
	self._visible = false

	local tabButton = Instance.new("TextButton")
	tabButton.Name = "Tab_" .. self.Name
	tabButton.Size = UDim2.new(0, 0, 1, 0)
	tabButton.Position = UDim2.new(0, 0, 0, 0)
	tabButton.BackgroundColor3 = ThemeManager:GetColor("Background")
	tabButton.BackgroundTransparency = 1
	tabButton.BorderSizePixel = 0
	tabButton.Text = ""
	tabButton.Parent = window.TabContainer

	self.TabButton = tabButton

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 6)
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = tabButton

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingLeft = UDim.new(0, 14)
	tabPadding.PaddingRight = UDim.new(0, 14)
	tabPadding.Parent = tabButton

	local iconLabel = nil
	if self.Icon then
		iconLabel = IconManager:CreateIconLabel(tabButton, self.Icon, UDim2.new(0, 16, 0, 16), ThemeManager:GetColor("TextMuted"))
		if iconLabel then
			iconLabel.LayoutOrder = 1
		end
	end

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0, 0, 0, 16)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 13
	nameLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
	nameLabel.TextTransparency = 0
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.LayoutOrder = 2
	nameLabel.Parent = tabButton

	self.NameLabel = nameLabel
	self.IconLabel = iconLabel

	local buttonWidth = Utility:GetTextBounds(self.Name, Enum.Font.Gotham, 13).X + (self.Icon and 32 or 24)

	tabButton.Size = UDim2.new(0, buttonWidth, 1, 0)

	tabButton.MouseEnter:Connect(function()
		if not self._active then
			AnimationManager:CreateTween(nameLabel, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.2)
			if iconLabel then
				AnimationManager:CreateTween(iconLabel, {
					ImageColor3 = ThemeManager:GetColor("TextSecondary")
				}, "Smooth", "Out", 0.2)
			end
			AnimationManager:CreateTween(tabButton, {
				BackgroundTransparency = 0.92
			}, "Smooth", "Out", 0.2)
			SoundManager:PlayHover()
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if not self._active then
			AnimationManager:CreateTween(nameLabel, {
				TextColor3 = ThemeManager:GetColor("TextMuted")
			}, "Smooth", "Out", 0.3)
			if iconLabel then
				AnimationManager:CreateTween(iconLabel, {
					ImageColor3 = ThemeManager:GetColor("TextMuted")
				}, "Smooth", "Out", 0.3)
			end
			AnimationManager:CreateTween(tabButton, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.3)
		end
	end)

	tabButton.MouseButton1Click:Connect(function()
		window:SelectTab(self)
		AnimationManager:RippleEffect(tabButton, ThemeManager:GetColor("Accent"), 0.3)
	end)

	local container = Instance.new("ScrollingFrame")
	container.Name = "TabContent_" .. self.Name
	container.Size = UDim2.new(1, 0, 1, 0)
	container.Position = UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 2
	container.ScrollBarImageColor3 = ThemeManager:GetColor("Accent")
	container.ScrollBarImageTransparency = 0.6
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.ScrollingDirection = Enum.ScrollingDirection.Y
	container.ElasticBehavior = Enum.ElasticBehavior.Never
	container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	container.Visible = false
	container.Parent = window.ContentArea

	self.Container = container

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 14)
	padding.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = container

	self._listLayout = listLayout

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self:UpdateContentSize()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Tab:CreateSection(options)
	options = options or {}
	local Section = require(script.Parent.Section)
	local section = Section:New(self, options)
	table.insert(self.Sections, section)
	section.Container.Parent = self.Container
	section.Container.LayoutOrder = #self.Sections
	return section
end

function Tab:Show()
	self._visible = true
	self.Container.Visible = true
	self._active = true

	AnimationManager:CreateTween(self.NameLabel, {
		TextColor3 = ThemeManager:GetColor("Accent")
	}, "Smooth", "Out", 0.3)

	AnimationManager:CreateTween(self.TabButton, {
		BackgroundTransparency = 0.9
	}, "Smooth", "Out", 0.3)

	if self.IconLabel then
		AnimationManager:CreateTween(self.IconLabel, {
			ImageColor3 = ThemeManager:GetColor("Accent")
		}, "Smooth", "Out", 0.3)
	end

	self.Container.CanvasPosition = Vector2.new(0, 0)
	self:UpdateContentSize()
end

function Tab:Hide()
	self._visible = false
	self.Container.Visible = false
	self._active = false

	AnimationManager:CreateTween(self.NameLabel, {
		TextColor3 = ThemeManager:GetColor("TextMuted")
	}, "Smooth", "Out", 0.2)

	AnimationManager:CreateTween(self.TabButton, {
		BackgroundTransparency = 1
	}, "Smooth", "Out", 0.2)

	if self.IconLabel then
		AnimationManager:CreateTween(self.IconLabel, {
			ImageColor3 = ThemeManager:GetColor("TextMuted")
		}, "Smooth", "Out", 0.2)
	end
end

function Tab:UpdateContentSize()
	task.wait()
	local contentSize = self._listLayout.AbsoluteContentSize
	self.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 24)
end

function Tab:UpdateTheme(palette, animate)
	animate = animate and true

	if self._active then
		if animate then
			AnimationManager:CreateTween(self.NameLabel, {
				TextColor3 = palette.Accent
			}, "Smooth", "Out", 0.3)
			if self.IconLabel then
				AnimationManager:CreateTween(self.IconLabel, {
					ImageColor3 = palette.Accent
				}, "Smooth", "Out", 0.3)
			end
		else
			self.NameLabel.TextColor3 = palette.Accent
			if self.IconLabel then
				self.IconLabel.ImageColor3 = palette.Accent
			end
		end
	else
		if animate then
			AnimationManager:CreateTween(self.NameLabel, {
				TextColor3 = palette.TextMuted
			}, "Smooth", "Out", 0.3)
			if self.IconLabel then
				AnimationManager:CreateTween(self.IconLabel, {
					ImageColor3 = palette.TextMuted
				}, "Smooth", "Out", 0.3)
			end
		end
	end
end

function Tab:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end

	for _, section in ipairs(self.Sections) do
		section:Destroy()
	end

	self.TabButton:Destroy()
	self.Container:Destroy()
end

return Tab
