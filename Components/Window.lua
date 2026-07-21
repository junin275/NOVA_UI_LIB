local Window = {}
Window.__index = Window

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player and Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

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
	screenGui.Parent = findParent()

	self.ScreenGui = screenGui
	self.Options = options
	self.Title = options.Title or "Nova UI"
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
	local defaultW = math.min(680, viewport.X - 40)
	local defaultH = math.min(480, viewport.Y - 60)
	self.Size = options.Size or UDim2.new(0, defaultW, 0, defaultH)
	self.Position = options.Position or UDim2.new(0.5, -defaultW / 2, 0.5, -defaultH / 2)
	self.MinSize = options.MinSize or Vector2.new(400, 320)
	self.Theme = options.Theme or "Default"
	self.Icon = options.Icon or nil
	self.Resizable = options.Resizable or false
	self.ShowFPS = options.ShowFPS or false
	self.SidebarWidth = options.SidebarWidth or 50
	self._minimized = false
	self._maximized = false
	self._previousSize = nil
	self._previousPosition = nil
	self.Tabs = {}
	self._currentTab = nil

	local modalBackdrop = Instance.new("Frame")
	modalBackdrop.Name = "ModalBackdrop"
	modalBackdrop.Size = UDim2.new(1, 0, 1, 0)
	modalBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	modalBackdrop.BackgroundTransparency = 1
	modalBackdrop.BorderSizePixel = 0
	modalBackdrop.ZIndex = 0
	modalBackdrop.Parent = screenGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainWindow"
	mainFrame.Size = self.Size
	mainFrame.Position = self.Position
	mainFrame.BackgroundColor3 = ThemeManager:GetColor("Surface")
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 0}, "Smooth", "Out", 0.4)

	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 12)

	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local shadowFrame = Instance.new("ImageLabel")
	shadowFrame.Name = "Shadow"
	shadowFrame.BackgroundTransparency = 1
	shadowFrame.BorderSizePixel = 0
	shadowFrame.Size = UDim2.new(1, 60, 1, 60)
	shadowFrame.Position = UDim2.new(-0.5, -30, -0.5, -30)
	shadowFrame.ZIndex = mainFrame.ZIndex - 2
	shadowFrame.Image = "rbxassetid://1316045217"
	shadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadowFrame.ImageTransparency = 0.78
	shadowFrame.ScaleType = Enum.ScaleType.Slice
	shadowFrame.SliceCenter = Rect.new(10, 10, 118, 118)
	shadowFrame.Parent = mainFrame

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 44)
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame

	Utility:CreateCorner(titleBar, 12)
	Utility:CreateStroke(titleBar, ThemeManager:GetColor("Border"), 0.3, 1)

	local titleBarFill = Instance.new("Frame")
	titleBarFill.Name = "TitleBarFill"
	titleBarFill.Size = UDim2.new(0, 0, 0, 1)
	titleBarFill.Position = UDim2.new(0, 0, 1, 0)
	titleBarFill.BackgroundColor3 = ThemeManager:GetColor("Divider")
	titleBarFill.BorderSizePixel = 0
	titleBarFill.Parent = titleBar

	self.TitleBar = titleBar

	local iconLabel
	if self.Icon then
		iconLabel = IconManager:CreateIconLabel(titleBar, self.Icon, UDim2.new(0, 20, 0, 20), ThemeManager:GetColor("Accent"))
		if iconLabel then
			iconLabel.Position = UDim2.new(0, 14, 0.5, -10)
			iconLabel.ZIndex = titleBar.ZIndex + 1
		end
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, iconLabel and 44 or 16, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = titleBar

	self.TitleLabel = titleLabel

	local windowButtons = Instance.new("Frame")
	windowButtons.Name = "WindowButtons"
	windowButtons.Size = UDim2.new(0, 90, 0, 26)
	windowButtons.Position = UDim2.new(1, -104, 0.5, -13)
	windowButtons.BackgroundTransparency = 1
	windowButtons.BorderSizePixel = 0
	windowButtons.Parent = titleBar

	local buttonColors = {
		{idle = Color3.fromRGB(255, 100, 89), hover = Color3.fromRGB(255, 80, 70)},
		{idle = Color3.fromRGB(255, 190, 50), hover = Color3.fromRGB(240, 170, 40)},
		{idle = Color3.fromRGB(60, 200, 80), hover = Color3.fromRGB(50, 180, 70)},
	}

	local function createMacButton(colorSet, order)
		local btn = Instance.new("TextButton")
		btn.Name = "MacButton" .. order
		btn.Size = UDim2.new(0, 14, 0, 14)
		btn.Position = UDim2.new(0, (order - 1) * 22, 0.5, -7)
		btn.BackgroundColor3 = colorSet.idle
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.ZIndex = titleBar.ZIndex + 2
		btn.Parent = windowButtons

		Utility:CreateCorner(btn, 7)

		btn.MouseEnter:Connect(function()
			AnimationManager:CreateTween(btn, {BackgroundColor3 = colorSet.hover}, "Smooth", "Out", 0.1)
		end)

		btn.MouseLeave:Connect(function()
			AnimationManager:CreateTween(btn, {BackgroundColor3 = colorSet.idle}, "Smooth", "Out", 0.2)
		end)

		return btn
	end

	local closeBtn = createMacButton(buttonColors[1], 1)
	closeBtn.MouseButton1Click:Connect(function() self:Close() end)

	local minimizeBtn = createMacButton(buttonColors[2], 2)
	minimizeBtn.MouseButton1Click:Connect(function() self:Minimize() end)

	local maximizeBtn = createMacButton(buttonColors[3], 3)
	maximizeBtn.MouseButton1Click:Connect(function() self:ToggleMaximize() end)

	local bodyFrame = Instance.new("Frame")
	bodyFrame.Name = "Body"
	bodyFrame.Size = UDim2.new(1, 0, 1, -44)
	bodyFrame.Position = UDim2.new(0, 0, 0, 44)
	bodyFrame.BackgroundTransparency = 1
	bodyFrame.BorderSizePixel = 0
	bodyFrame.Parent = mainFrame

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, self.SidebarWidth, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	sidebar.BorderSizePixel = 0
	sidebar.Parent = bodyFrame

	self.Sidebar = sidebar

	local sidebarDivider = Instance.new("Frame")
	sidebarDivider.Name = "SidebarDivider"
	sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
	sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
	sidebarDivider.BackgroundColor3 = ThemeManager:GetColor("Divider")
	sidebarDivider.BorderSizePixel = 0
	sidebarDivider.Parent = sidebar

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.FillDirection = Enum.FillDirection.Vertical
	sidebarLayout.Padding = UDim.new(0, 2)
	sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Parent = sidebar

	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 8)
	sidebarPadding.PaddingBottom = UDim.new(0, 8)
	sidebarPadding.Parent = sidebar

	local tabIndicator = Instance.new("Frame")
	tabIndicator.Name = "TabIndicator"
	tabIndicator.Size = UDim2.new(0, 3, 0, 0)
	tabIndicator.Position = UDim2.new(0, 0, 0, 0)
	tabIndicator.BackgroundColor3 = ThemeManager:GetColor("Accent")
	tabIndicator.BorderSizePixel = 0
	tabIndicator.Parent = sidebar

	self.TabIndicator = tabIndicator

	local contentArea = Instance.new("ScrollingFrame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -(self.SidebarWidth + 1), 1, 0)
	contentArea.Position = UDim2.new(0, self.SidebarWidth + 1, 0, 0)
	contentArea.BackgroundColor3 = ThemeManager:GetColor("Background")
	contentArea.BorderSizePixel = 0
	contentArea.ScrollBarThickness = 3
	contentArea.ScrollBarImageColor3 = ThemeManager:GetColor("ScrollBar")
	contentArea.ScrollBarImageTransparency = 0.6
	contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
	contentArea.ElasticBehavior = Enum.ElasticBehavior.Never
	contentArea.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	contentArea.Parent = bodyFrame

	self.ContentArea = contentArea

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 16)
	contentPadding.PaddingBottom = UDim.new(0, 16)
	contentPadding.PaddingLeft = UDim.new(0, 18)
	contentPadding.PaddingRight = UDim.new(0, 18)
	contentPadding.Parent = contentArea

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.FillDirection = Enum.FillDirection.Vertical
	contentLayout.Padding = UDim.new(0, 10)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Parent = contentArea

	self._contentLayout = contentLayout

	local function updateCanvas()
		local size = contentLayout.AbsoluteContentSize
		contentArea.CanvasSize = UDim2.new(0, 0, 0, size.Y + 32)
	end

	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
	task.spawn(updateCanvas)

	DragService:MakeDraggable(mainFrame, titleBar, {
		ConstrainToScreen = true,
		SmoothDrag = true,
	})

	DragService:MakeResizable(mainFrame, {
		MinSize = self.MinSize,
		Enabled = self.Resizable,
	})

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	table.insert(Windows, self)

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
		local targetY = tabButton.AbsolutePosition.Y - self.Sidebar.AbsolutePosition.Y
		local targetHeight = tabButton.AbsoluteSize.Y

		AnimationManager:CreateTween(self.TabIndicator, {
			Position = UDim2.new(0, 0, 0, targetY),
			Size = UDim2.new(0, 3, 0, targetHeight)
		}, "Smooth", "Out", 0.35)
	end

	SoundManager:PlayTabSwitch()

	local size = self._contentLayout.AbsoluteContentSize
	self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, size.Y + 32)
end

function Window:Minimize()
	self._minimized = not self._minimized
	if self._minimized then
		self._previousSize = self.MainFrame.Size
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, self.MainFrame.AbsoluteSize.X, 0, 44)
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ContentArea, {
			Size = UDim2.new(1, -(self.SidebarWidth + 1), 0, 0)
		}, "Smooth", "Out", 0.25)
		local tabArea = self.MainFrame:FindFirstChild("Body")
		if tabArea then
			tabArea.Size = UDim2.new(1, 0, 0, 0)
		end
	else
		AnimationManager:CreateTween(self.MainFrame, {
			Size = self._previousSize or self.Size
		}, "Smooth", "Out", 0.4)
		AnimationManager:CreateTween(self.MainFrame:FindFirstChild("Body"), {
			Size = UDim2.new(1, 0, 1, -44)
		}, "Smooth", "Out", 0.3)
	end
end

function Window:ToggleMaximize()
	if self._maximized then
		self._maximized = false
		AnimationManager:CreateTween(self.MainFrame, {
			Size = self._previousSize or self.Size,
			Position = self._previousPosition or self.Position
		}, "Smooth", "Out", 0.4)
	else
		self._maximized = true
		self._previousSize = self.MainFrame.Size
		self._previousPosition = self.MainFrame.Position
		local screenSize = workspace.CurrentCamera.ViewportSize
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, screenSize.X, 0, screenSize.Y),
			Position = UDim2.new(0, 0, 0, 0)
		}, "Smooth", "Out", 0.4)
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
	if animate then
		AnimationManager:CreateTween(self.MainFrame, {BackgroundColor3 = palette.Surface}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TitleBar, {BackgroundColor3 = palette.SurfaceAlt}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.Sidebar, {BackgroundColor3 = palette.SurfaceAlt}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ContentArea, {BackgroundColor3 = palette.Background}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TabIndicator, {BackgroundColor3 = palette.Accent}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TitleLabel, {TextColor3 = palette.TextPrimary}, "Smooth", "Out", 0.3)
	else
		self.MainFrame.BackgroundColor3 = palette.Surface
		self.TitleBar.BackgroundColor3 = palette.SurfaceAlt
		self.Sidebar.BackgroundColor3 = palette.SurfaceAlt
		self.ContentArea.BackgroundColor3 = palette.Background
		self.TabIndicator.BackgroundColor3 = palette.Accent
		self.TitleLabel.TextColor3 = palette.TextPrimary
	end
end

function Window:UpdateContentSize()
	local size = self._contentLayout.AbsoluteContentSize
	self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, size.Y + 32)
end

function Window:GetWindows()
	return Windows
end

return Window
