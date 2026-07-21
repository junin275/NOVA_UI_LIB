local FPSCounter = {}
FPSCounter.__index = FPSCounter

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local ACTIVE_FPS = nil

function FPSCounter:New(options)
	options = options or {}

	if ACTIVE_FPS then
		ACTIVE_FPS:Destroy()
	end

	local self = setmetatable({}, FPSCounter)

	self.Position = options.Position or UDim2.new(1, -80, 0, 10)
	self.ShowGraph = options.ShowGraph or false
	self.UpdateInterval = options.UpdateInterval or 0.5

	local parent
	local success, err = pcall(function()
		parent = CoreGui
	end)
	if not success then
		parent = Player:WaitForChild("PlayerGui")
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_FPS"
	screenGui.DisplayOrder = 500
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = parent

	local container = Instance.new("Frame")
	container.Name = "FPSCounter"
	container.Size = UDim2.new(0, 70, 0, 24)
	container.Position = self.Position
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BackgroundTransparency = 0.2
	container.BorderSizePixel = 0
	container.Parent = screenGui
	self.Container = container
	Utility:CreateCorner(container, 6)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.4, 1)

	local fpsLabel = Instance.new("TextLabel")
	fpsLabel.Name = "FPS"
	fpsLabel.Size = UDim2.new(1, 0, 1, 0)
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.BorderSizePixel = 0
	fpsLabel.Text = "60 FPS"
	fpsLabel.Font = Enum.Font.Code
	fpsLabel.TextSize = 13
	fpsLabel.TextColor3 = ThemeManager:GetColor("Accent")
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
	fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
	fpsLabel.Parent = container
	self.FPSLabel = fpsLabel

	self._frameTimes = {}
	self._lastUpdate = tick()

	self._connection = RunService.RenderStepped:Connect(function(dt)
		self:_update(dt)
	end)

	ACTIVE_FPS = self

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function FPSCounter:_update(dt)
	table.insert(self._frameTimes, dt)
	if #self._frameTimes > 60 then
		table.remove(self._frameTimes, 1)
	end

	local now = tick()
	if now - self._lastUpdate >= self.UpdateInterval then
		self._lastUpdate = now

		local total = 0
		for _, t in ipairs(self._frameTimes) do
			total = total + t
		end
		local avgDt = total / #self._frameTimes
		local fps = math.floor(1 / avgDt)

		local color
		if fps >= 60 then
			color = ThemeManager:GetColor("Success")
		elseif fps >= 30 then
			color = ThemeManager:GetColor("Warning")
		else
			color = ThemeManager:GetColor("Danger")
		end

		self.FPSLabel.Text = fps .. " FPS"
		AnimationManager:CreateTween(self.FPSLabel, {
			TextColor3 = color
		}, "Smooth", "Out", 0.3)
	end
end

function FPSCounter:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
	else
		self.Container.BackgroundColor3 = palette.Surface
	end
end

function FPSCounter:Destroy()
	ACTIVE_FPS = nil
	if self._themeConnection then
		self._themeConnection()
	end
	if self._connection then
		self._connection:Disconnect()
	end
	if self.Container and self.Container.Parent then
		self.Container.Parent:Destroy()
	end
end

return FPSCounter
