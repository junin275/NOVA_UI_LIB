local LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local ACTIVE_LOADING = nil

function LoadingScreen:New(options)
	options = options or {}

	local self = setmetatable({}, LoadingScreen)

	self.Title = options.Title or "Loading"
	self.Message = options.Message or "Please wait..."
	self.Icon = options.Icon or "Circle"
	self.AutoDestroy = options.AutoDestroy or false
	self.Duration = options.Duration or 0

	local parent
	local success, err = pcall(function()
		parent = CoreGui
	end)
	if not success then
		parent = Player:WaitForChild("PlayerGui")
	end

	if ACTIVE_LOADING then
		ACTIVE_LOADING:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_LoadingScreen"
	screenGui.DisplayOrder = 999
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent

	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.6
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	self.Overlay = overlay

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 200, 0, 120)
	container.Position = UDim2.new(0.5, -100, 0.5, -60)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.Parent = screenGui
	Utility:CreateCorner(container, 10)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local spinnerContainer = Instance.new("Frame")
	spinnerContainer.Name = "Spinner"
	spinnerContainer.Size = UDim2.new(0, 32, 0, 32)
	spinnerContainer.Position = UDim2.new(0.5, -16, 0, 16)
	spinnerContainer.BackgroundTransparency = 1
	spinnerContainer.BorderSizePixel = 0
	spinnerContainer.Parent = container

	local spinner = Instance.new("Frame")
	spinner.Name = "SpinnerInner"
	spinner.Size = UDim2.new(1, 0, 1, 0)
	spinner.BackgroundTransparency = 1
	spinner.BorderSizePixel = 0
	spinner.Parent = spinnerContainer
	self.Spinner = spinner

	local spinnerArc = Instance.new("UICorner")
	spinnerArc.CornerRadius = UDim.new(1, 0)
	spinnerArc.Parent = spinner

	local spinnerStroke = Instance.new("UIStroke")
	spinnerStroke.Color = ThemeManager:GetColor("Accent")
	spinnerStroke.Thickness = 3
	spinnerStroke.Transparency = 0
	spinnerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	spinnerStroke.Parent = spinner

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 54)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -20, 0, 16)
	messageLabel.Position = UDim2.new(0, 10, 0, 76)
	messageLabel.BackgroundTransparency = 1
	messageLabel.BorderSizePixel = 0
	messageLabel.Text = self.Message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 12
	messageLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
	messageLabel.TextXAlignment = Enum.TextXAlignment.Center
	messageLabel.TextYAlignment = Enum.TextYAlignment.Center
	messageLabel.Parent = container
	self.MessageLabel = messageLabel

	ACTIVE_LOADING = self

	task.spawn(function()
		while spinner and spinner.Parent do
			AnimationManager:CreateTween(spinner, {
				Rotation = spinner.Rotation + 360
			}, "Linear", "In", 1)
			task.wait(1)
		end
	end)

	if self.AutoDestroy and self.Duration > 0 then
		task.delay(self.Duration, function()
			self:Destroy()
		end)
	end

	if self.AutoDestroy and self.Duration == 0 then
		task.delay(3, function()
			self:Destroy()
		end)
	end

	return self
end

function LoadingScreen:SetTitle(title)
	self.Title = title
	if self.TitleLabel then
		self.TitleLabel.Text = title
	end
end

function LoadingScreen:SetMessage(message)
	self.Message = message
	if self.MessageLabel then
		self.MessageLabel.Text = message
	end
end

function LoadingScreen:Destroy()
	ACTIVE_LOADING = nil
	if self.Overlay and self.Overlay.Parent then
		AnimationManager:CreateTween(self.Overlay, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.3, function()
			if self.Overlay and self.Overlay.Parent then
				self.Overlay.Parent:Destroy()
			end
		end)
	end
end

return LoadingScreen
