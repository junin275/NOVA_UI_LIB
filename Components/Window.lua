local Window = {}
Window.__index = Window

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)
local DragService = require(script.Parent.Parent.Services.DragService)

local Windows = {}

function Window:New(options)
	options = options or {}

	local self = setmetatable({}, Window)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_UI"
	screenGui.DisplayOrder = 10
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local parentGui = (type(gethui) == "function" and pcall(gethui) or nil)
	if type(parentGui) == "table" and typeof(parentGui) == "Instance" then
		screenGui.Parent = parentGui
	else
		local success, err = pcall(function()
			screenGui.Parent = CoreGui
		end)
		if not success then
			local plrGui = Player:FindFirstChild("PlayerGui")
			if plrGui then
				screenGui.Parent = plrGui
			else
				plrGui = Player:WaitForChild("PlayerGui", 5)
				if plrGui then
					screenGui.Parent = plrGui
				end
			end
		end
	end

	self.ScreenGui = screenGui
	self.Options = options
	self.Title = options.Title or "Nova UI"
	self.Size = options.Size or UDim2.new(0, 640, 0, 440)
	self.Position = options.Position or UDim2.new(0.5, -320, 0.5, -220)
	self.MinSize = options.MinSize or Vector2.new(360, 280)
	self.Theme = options.Theme or "Default"
	self.Icon = options.Icon or nil
	self.Resizable = options.Resizable or false
	self.ShowFPS = options.ShowFPS or false
	self._minimized = false
	self._maximized = false
	self._previousSize = nil
	self._previousPosition = nil
	self.Tabs = {}
	self._currentTab = nil

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainWindow"
	mainFrame.Size = self.Size
	mainFrame.Position = self.Position
	mainFrame.BackgroundColor3 = ThemeManager:GetColor("Surface")
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 10)

	local outerGlow = Instance.new("ImageLabel")
	outerGlow.Name = "OuterGlow"
	outerGlow.BackgroundTransparency = 1
	outerGlow.BorderSizePixel = 0
	outerGlow.Size = UDim2.new(1, 40, 1, 40)
	outerGlow.Position = UDim2.new(-0.5, -20, -0.5, -20)
	outerGlow.ZIndex = mainFrame.ZIndex - 1
	outerGlow.Image = "rbxassetid://1316045217"
	outerGlow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	outerGlow.ImageTransparency = 0.85
	outerGlow.ScaleType = Enum.ScaleType.Slice
	outerGlow.SliceCenter = Rect.new(10, 10, 118, 118)
	outerGlow.Parent = mainFrame

	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.4, 1)

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 42)
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame

	Utility:CreateCorner(titleBar, 10)
	Utility:CreateStroke(titleBar, ThemeManager:GetColor("Border"), 0.3, 1)

	local titleBarBottom = Instance.new("Frame")
	titleBarBottom.Name = "TitleBarBottom"
	titleBarBottom.Size = UDim2.new(1, 0, 0, 0)
	titleBarBottom.Position = UDim2.new(0, 0, 1, 0)
	titleBarBottom.BackgroundColor3 = ThemeManager:GetColor("Border")
	titleBarBottom.BorderSizePixel = 0
	titleBarBottom.Parent = titleBar

	self.TitleBar = titleBar
	self._titleBarBottom = titleBarBottom

	local accentLine = Instance.new("Frame")
	accentLine.Name = "AccentLine"
	accentLine.Size = UDim2.new(0, 0, 0, 2)
	accentLine.Position = UDim2.new(0, 0, 1, -2)
	accentLine.BackgroundColor3 = ThemeManager:GetColor("Accent")
	accentLine.BorderSizePixel = 0
	accentLine.Parent = titleBar

	AnimationManager:CreateTween(accentLine, {Size = UDim2.new(1, 0, 0, 2)}, "Soft", "Out", 0.6)

	local iconLabel = nil
	if self.Icon then
		iconLabel = IconManager:CreateIconLabel(titleBar, self.Icon, UDim2.new(0, 18, 0, 18), ThemeManager:GetColor("TextPrimary"))
		if iconLabel then
			iconLabel.Position = UDim2.new(0, 14, 0.5, -9)
			iconLabel.ZIndex = titleBar.ZIndex + 1
		end
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.new(0, iconLabel and 40 or 16, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextTransparency = 0.1
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = titleBar

	self.TitleLabel = titleLabel

	local windowButtons = Instance.new("Frame")
	windowButtons.Name = "WindowButtons"
	windowButtons.Size = UDim2.new(0, 90, 0, 24)
	windowButtons.Position = UDim2.new(1, -100, 0.5, -12)
	windowButtons.BackgroundTransparency = 1
	windowButtons.BorderSizePixel = 0
	windowButtons.Parent = titleBar

	local function createWindowButton(iconName, order)
		local btn = Instance.new("TextButton")
		btn.Name = iconName .. "Button"
		btn.Size = UDim2.new(0, 24, 0, 24)
		btn.Position = UDim2.new(0, (order - 1) * 28, 0, 0)
		btn.BackgroundColor3 = ThemeManager:GetColor("Surface")
		btn.BackgroundTransparency = 1
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.ZIndex = titleBar.ZIndex + 2
		btn.Parent = windowButtons

		local icon = IconManager:CreateIconLabel(btn, iconName, UDim2.new(0, 14, 0, 14), ThemeManager:GetColor("TextSecondary"))
		if icon then
			icon.Position = UDim2.new(0.5, -7, 0.5, -7)
			icon.ZIndex = btn.ZIndex + 1
		end

		btn.MouseEnter:Connect(function()
			AnimationManager:CreateTween(btn, {BackgroundTransparency = 0.7}, "Smooth", "Out", 0.15)
			if icon then
				AnimationManager:CreateTween(icon, {ImageColor3 = ThemeManager:GetColor("TextPrimary")}, "Smooth", "Out", 0.15)
			end
		end)

		btn.MouseLeave:Connect(function()
			AnimationManager:CreateTween(btn, {BackgroundTransparency = 1}, "Smooth", "Out", 0.2)
			if icon then
				AnimationManager:CreateTween(icon, {ImageColor3 = ThemeManager:GetColor("TextSecondary")}, "Smooth", "Out", 0.2)
			end
		end)

		btn.MouseButton1Click:Connect(function()
			SoundManager:PlayClick()
			AnimationManager:RippleEffect(btn, ThemeManager:GetColor("Accent"), 0.3)
		end)

		return btn, icon
	end

	local minimizeBtn, minimizeIcon = createWindowButton("Minus", 1)
	local maximizeBtn, maximizeIcon = createWindowButton("Square", 2)
	local closeBtn, closeIcon = createWindowButton("Close", 3)

	minimizeBtn.MouseButton1Click:Connect(function()
		self:Minimize()
	end)

	maximizeBtn.MouseButton1Click:Connect(function()
		self:ToggleMaximize()
	end)

	closeBtn.MouseButton1Click:Connect(function()
		self:Close()
	end)

	local tabContainer = Instance.new("Frame")
	tabContainer.Name = "TabContainer"
	tabContainer.Size = UDim2.new(1, 0, 0, 38)
	tabContainer.Position = UDim2.new(0, 0, 0, 42)
	tabContainer.BackgroundColor3 = ThemeManager:GetColor("Background")
	tabContainer.BorderSizePixel = 0
	tabContainer.Parent = mainFrame

	self.TabContainer = tabContainer

	Utility:CreateStroke(tabContainer, ThemeManager:GetColor("Border"), 0.5, 1)

	local tabIndicator = Instance.new("Frame")
	tabIndicator.Name = "TabIndicator"
	tabIndicator.Size = UDim2.new(0, 0, 0, 2)
	tabIndicator.Position = UDim2.new(0, 0, 1, -2)
	tabIndicator.BackgroundColor3 = ThemeManager:GetColor("Accent")
	tabIndicator.BorderSizePixel = 0
	tabIndicator.Parent = tabContainer

	self.TabIndicator = tabIndicator

	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, 0, 1, -(42 + 38))
	contentArea.Position = UDim2.new(0, 0, 0, 42 + 38)
	contentArea.BackgroundColor3 = ThemeManager:GetColor("Background")
	contentArea.BorderSizePixel = 0
	contentArea.Parent = mainFrame

	self.ContentArea = contentArea

	DragService:MakeDraggable(mainFrame, titleBar, {
		ConstrainToScreen = true,
		SmoothDrag = true,
		OnDragStart = function()
			AnimationManager:CreateTween(mainFrame, {
				BackgroundTransparency = 0.05
			}, "Smooth", "Out", 0.1)
		end,
		OnDragEnd = function()
			AnimationManager:CreateTween(mainFrame, {
				BackgroundTransparency = 0
			}, "Smooth", "Out", 0.2)
		end,
	})

	if self.Resizable then
		DragService:MakeResizable(mainFrame, {MinSize = self.MinSize})
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	table.insert(Windows, self)

	AnimationManager:CreateTween(mainFrame, {
		BackgroundTransparency = 0,
	}, "Smooth", "Out", 0.4)

	return self
end

function Window:CreateTab(options)
	options = options or {}
	local Tab = require(script.Parent.Tab)
	local tab = Tab:New(self, options)
	table.insert(self.Tabs, tab)

	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end

	self:UpdateTabLayout()

	return tab
end

function Window:SelectTab(tab)
	if self._currentTab then
		self._currentTab:Hide()
	end

	self._currentTab = tab
	tab:Show()

	local tabIndex = 0
	for i, t in ipairs(self.Tabs) do
		if t == tab then
			tabIndex = i
			break
		end
	end

	local tabButton = tab.TabButton
	if tabButton then
		local targetX = tabButton.AbsolutePosition.X - self.TabContainer.AbsolutePosition.X
		local targetWidth = tabButton.AbsoluteSize.X
		AnimationManager:CreateTween(self.TabIndicator, {
			Position = UDim2.new(0, targetX, 1, -2),
			Size = UDim2.new(0, targetWidth, 0, 2)
		}, "Smooth", "Out", 0.35)
	end

	SoundManager:PlayTabSwitch()

	tab:UpdateContentSize()
end

function Window:UpdateTabLayout()
	local xOffset = 0
	for i, tab in ipairs(self.Tabs) do
		if tab.TabButton then
			tab.TabButton.Position = UDim2.new(0, xOffset, 0, 0)
			xOffset = xOffset + tab.TabButton.AbsoluteSize.X + 2
		end
	end
end

function Window:Minimize()
	self._minimized = not self._minimized
	if self._minimized then
		self._previousSize = self.MainFrame.Size
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, self.MainFrame.AbsoluteSize.X, 0, 42)
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ContentArea, {
			Size = UDim2.new(1, 0, 0, 0)
		}, "Smooth", "Out", 0.25)
		AnimationManager:CreateTween(self.TabContainer, {
			Size = UDim2.new(1, 0, 0, 0)
		}, "Smooth", "Out", 0.25)
	else
		AnimationManager:CreateTween(self.MainFrame, {
			Size = self._previousSize or self.Size
		}, "Smooth", "Out", 0.35)
		AnimationManager:CreateTween(self.ContentArea, {
			Size = UDim2.new(1, 0, 1, -(42 + 38))
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TabContainer, {
			Size = UDim2.new(1, 0, 0, 38)
		}, "Smooth", "Out", 0.3)
	end
end

function Window:ToggleMaximize()
	if self._maximized then
		self._maximized = false
		AnimationManager:CreateTween(self.MainFrame, {
			Size = self._previousSize or self.Size,
			Position = self._previousPosition or self.Position
		}, "Smooth", "Out", 0.35)
	else
		self._maximized = true
		self._previousSize = self.MainFrame.Size
		self._previousPosition = self.MainFrame.Position
		local screenSize = workspace.CurrentCamera.ViewportSize
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, screenSize.X, 0, screenSize.Y),
			Position = UDim2.new(0, 0, 0, 0)
		}, "Smooth", "Out", 0.35)
	end
end

function Window:Close(animate)
	animate = animate ~= false
	if animate then
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.3, function()
			self:Destroy()
		end)
	else
		self:Destroy()
	end
end

function Window:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end

	for _, tab in ipairs(self.Tabs) do
		tab:Destroy()
	end

	self.ScreenGui:Destroy()

	for i, w in ipairs(Windows) do
		if w == self then
			table.remove(Windows, i)
			break
		end
	end
end

function Window:UpdateTheme(palette, animate)
	animate = animate and true

	if animate then
		AnimationManager:CreateTween(self.MainFrame, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)

		AnimationManager:CreateTween(self.TitleBar, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)

		AnimationManager:CreateTween(self.TabContainer, {
			BackgroundColor3 = palette.Background,
		}, "Smooth", "Out", 0.3)

		AnimationManager:CreateTween(self.ContentArea, {
			BackgroundColor3 = palette.Background,
		}, "Smooth", "Out", 0.3)

		AnimationManager:CreateTween(self._titleBarBottom, {
			BackgroundColor3 = palette.Border,
		}, "Smooth", "Out", 0.3)

		AnimationManager:CreateTween(self.TabIndicator, {
			BackgroundColor3 = palette.Accent,
		}, "Smooth", "Out", 0.3)
	else
		self.MainFrame.BackgroundColor3 = palette.Surface
		self.TitleBar.BackgroundColor3 = palette.SurfaceAlt
		self.TabContainer.BackgroundColor3 = palette.Background
		self.ContentArea.BackgroundColor3 = palette.Background
		self._titleBarBottom.BackgroundColor3 = palette.Border
		self.TabIndicator.BackgroundColor3 = palette.Accent
	end
end

function Window:UpdateContentSize()
	if self._currentTab then
		self._currentTab:UpdateContentSize()
	end
end

function Window:GetWindows()
	return Windows
end

return Window
