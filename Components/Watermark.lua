local Watermark = {}
Watermark.__index = Watermark

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local ACTIVE_WATERMARK = nil

function Watermark:New(options)
	options = options or {}

	if ACTIVE_WATERMARK then
		ACTIVE_WATERMARK:Destroy()
	end

	local self = setmetatable({}, Watermark)

	self.Title = options.Title or "Nova UI"
	self.Version = options.Version or "1.0.0"
	self.SubText = options.SubText or ""
	self.ShowFPS = options.ShowFPS or false
	self.Position = options.Position or UDim2.new(0, 14, 0, 10)

	local parent
	local success, err = pcall(function()
		parent = CoreGui
	end)
	if not success then
		parent = Player:WaitForChild("PlayerGui")
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_Watermark"
	screenGui.DisplayOrder = 500
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = parent

	local container = Instance.new("Frame")
	container.Name = "Watermark"
	container.Size = UDim2.new(0, 0, 0, 28)
	container.Position = self.Position
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BackgroundTransparency = 0.15
	container.BorderSizePixel = 0
	container.Parent = screenGui
	self.Container = container
	Utility:CreateCorner(container, 6)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.4, 1)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = container

	local accentDot = Instance.new("Frame")
	accentDot.Name = "AccentDot"
	accentDot.Size = UDim2.new(0, 6, 0, 6)
	accentDot.Position = UDim2.new(0, 10, 0.5, -3)
	accentDot.BackgroundColor3 = ThemeManager:GetColor("Accent")
	accentDot.BorderSizePixel = 0
	accentDot.Parent = container
	Utility:CreateCorner(accentDot, 3)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(0, 0, 1, 0)
	titleLabel.Position = UDim2.new(0, 22, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.AutomaticSize = Enum.AutomaticSize.X
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local versionLabel = Instance.new("TextLabel")
	versionLabel.Name = "Version"
	versionLabel.Size = UDim2.new(0, 0, 1, 0)
	versionLabel.Position = UDim2.new(0, titleLabel.AutomaticSize.X + 26, 0, 0)
	versionLabel.BackgroundTransparency = 1
	versionLabel.BorderSizePixel = 0
	versionLabel.Text = "v" .. self.Version
	versionLabel.Font = Enum.Font.Gotham
	versionLabel.TextSize = 12
	versionLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
	versionLabel.TextXAlignment = Enum.TextXAlignment.Left
	versionLabel.TextYAlignment = Enum.TextYAlignment.Center
	versionLabel.AutomaticSize = Enum.AutomaticSize.X
	versionLabel.Parent = container
	self.VersionLabel = versionLabel

	if self.SubText and #self.SubText > 0 then
		local subLabel = Instance.new("TextLabel")
		subLabel.Name = "SubText"
		subLabel.Size = UDim2.new(0, 0, 1, 0)
		subLabel.Position = UDim2.new(0, titleLabel.AutomaticSize.X + versionLabel.AutomaticSize.X + 32, 0, 0)
		subLabel.BackgroundTransparency = 1
		subLabel.BorderSizePixel = 0
		subLabel.Text = self.SubText
		subLabel.Font = Enum.Font.Gotham
		subLabel.TextSize = 12
		subLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		subLabel.TextXAlignment = Enum.TextXAlignment.Left
		subLabel.TextYAlignment = Enum.TextYAlignment.Center
		subLabel.AutomaticSize = Enum.AutomaticSize.X
		subLabel.Parent = container
		self.SubLabel = subLabel
	end

	local fpsLabel = nil
	if self.ShowFPS then
		fpsLabel = Instance.new("TextLabel")
		fpsLabel.Name = "FPS"
		fpsLabel.Size = UDim2.new(0, 0, 1, 0)
		fpsLabel.BackgroundTransparency = 1
		fpsLabel.BorderSizePixel = 0
		fpsLabel.Text = "60 FPS"
		fpsLabel.Font = Enum.Font.Code
		fpsLabel.TextSize = 11
		fpsLabel.TextColor3 = ThemeManager:GetColor("Accent")
		fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
		fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
		fpsLabel.AutomaticSize = Enum.AutomaticSize.X
		fpsLabel.Parent = container
		self.FPSLabel = fpsLabel

		self._fpsConnection = RunService.RenderStepped:Connect(function()
			self:_updateFPS()
		end)
	end

	ACTIVE_WATERMARK = self

	container.Size = UDim2.new(0, container.AutomaticSize.X, 0, 28)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Watermark:_updateFPS()
	if not self.FPSLabel then
		return
	end
	local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
	self.FPSLabel.Text = fps .. " FPS"
end

function Watermark:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TitleLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.VersionLabel, {
			TextColor3 = palette.TextMuted,
		}, "Smooth", "Out", 0.3)
	else
		self.Container.BackgroundColor3 = palette.Surface
		self.TitleLabel.TextColor3 = palette.TextPrimary
		self.VersionLabel.TextColor3 = palette.TextMuted
	end
end

function Watermark:Destroy()
	ACTIVE_WATERMARK = nil
	if self._themeConnection then
		self._themeConnection()
	end
	if self._fpsConnection then
		self._fpsConnection:Disconnect()
	end
	if self.Container and self.Container.Parent then
		self.Container.Parent:Destroy()
	end
end

return Watermark
