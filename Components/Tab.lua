local Tab = {}
Tab.__index = Tab

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

	local sidebar = window.Sidebar

	local tabButton = Instance.new("TextButton")
	tabButton.Name = "Tab_" .. self.Name
	tabButton.Size = UDim2.new(1, -12, 0, 44)
	tabButton.Position = UDim2.new(0, 6, 0, 0)
	tabButton.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	tabButton.BackgroundTransparency = 1
	tabButton.BorderSizePixel = 0
	tabButton.Text = ""
	tabButton.Parent = sidebar

	Utility:CreateCorner(tabButton, 8)

	self.TabButton = tabButton

	if self.Icon then
		local icon = IconManager:CreateIconLabel(tabButton, self.Icon, UDim2.new(0, 22, 0, 22), ThemeManager:GetColor("TextMuted"))
		if icon then
			icon.Position = UDim2.new(0.5, -11, 0.5, -11)
			icon.ZIndex = tabButton.ZIndex + 1
			self._icon = icon
		end
	end

	tabButton.MouseEnter:Connect(function()
		if not self._active then
			AnimationManager:CreateTween(tabButton, {BackgroundTransparency = 0.85}, "Smooth", "Out", 0.2)
			if self._icon then
				AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("TextSecondary")}, "Smooth", "Out", 0.2)
			end
			SoundManager:PlayHover()
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if not self._active then
			AnimationManager:CreateTween(tabButton, {BackgroundTransparency = 1}, "Smooth", "Out", 0.3)
			if self._icon then
				AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("TextMuted")}, "Smooth", "Out", 0.3)
			end
		end
	end)

	tabButton.MouseButton1Click:Connect(function()
		window:SelectTab(self)
	end)

	local container = Instance.new("ScrollingFrame")
	container.Name = "TabContent_" .. self.Name
	container.Size = UDim2.new(1, 0, 1, 0)
	container.Position = UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 0
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	container.ScrollingDirection = Enum.ScrollingDirection.Y
	container.ElasticBehavior = Enum.ElasticBehavior.Never
	container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	container.Visible = false
	container.Parent = window.ContentArea

	self.Container = container

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 0)
	padding.PaddingRight = UDim.new(0, 0)
	padding.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 10)
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

	AnimationManager:CreateTween(self.TabButton, {BackgroundTransparency = 0.8}, "Smooth", "Out", 0.3)

	if self._icon then
		AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("Accent")}, "Smooth", "Out", 0.3)
	end

	self.Container.CanvasPosition = Vector2.new(0, 0)
	self:UpdateContentSize()
end

function Tab:Hide()
	self._visible = false
	self.Container.Visible = false
	self._active = false

	AnimationManager:CreateTween(self.TabButton, {BackgroundTransparency = 1}, "Smooth", "Out", 0.2)

	if self._icon then
		AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("TextMuted")}, "Smooth", "Out", 0.2)
	end
end

function Tab:UpdateContentSize()
	task.wait()
	local contentSize = self._listLayout.AbsoluteContentSize
	self.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 32)
end

function Tab:UpdateTheme(palette, animate)
	if self._active then
		if animate then
			if self._icon then
				AnimationManager:CreateTween(self._icon, {ImageColor3 = palette.Accent}, "Smooth", "Out", 0.3)
			end
		elseif self._icon then
			self._icon.ImageColor3 = palette.Accent
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
