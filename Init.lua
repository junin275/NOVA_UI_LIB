local NovaUI = {}

-- Core Modules
NovaUI.ThemeManager = require(script.Core.ThemeManager)
NovaUI.AnimationManager = require(script.Core.AnimationManager)
NovaUI.Utility = require(script.Core.Utility)
NovaUI.IconManager = require(script.Core.IconManager)
NovaUI.SoundManager = require(script.Core.SoundManager)

-- Services
NovaUI.ConfigService = require(script.Services.ConfigService)
NovaUI.DragService = require(script.Services.DragService)

-- Component Constructors
local Window = require(script.Components.Window)
local Notification = require(script.Components.Notification)
local Dialog = require(script.Components.Dialog)
local Tooltip = require(script.Components.Tooltip)
local LoadingScreen = require(script.Components.LoadingScreen)
local FloatingButton = require(script.Components.FloatingButton)
local Watermark = require(script.Components.Watermark)
local FPSCounter = require(script.Components.FPSCounter)

-- Library Version
NovaUI.Version = "1.0.0"
NovaUI.Build = "Nova UI - Modern Roblox UI Library"

function NovaUI:CreateWindow(options)
	options = options or {}

	local window = Window:New(options)

	self:ApplyTheme(NovaUI.ThemeManager.CurrentTheme)

	return window
end

function NovaUI:CreateNotification(options)
	options = options or {}
	return Notification:New(options)
end

function NovaUI:CreateDialog(options)
	options = options or {}
	return Dialog:New(options)
end

function NovaUI:CreateTooltip(target, text, options)
	return Tooltip:New(target, text, options)
end

function NovaUI:CreateLoadingScreen(options)
	options = options or {}
	return LoadingScreen:New(options)
end

function NovaUI:CreateFloatingButton(options)
	options = options or {}
	return FloatingButton:New(options)
end

function NovaUI:CreateWatermark(options)
	options = options or {}
	return Watermark:New(options)
end

function NovaUI:CreateFPSCounter(options)
	options = options or {}
	return FPSCounter:New(options)
end

function NovaUI:SetTheme(themeName)
	NovaUI.ThemeManager:ApplyTheme(themeName)
	self:ApplyTheme(themeName)
end

function NovaUI:ApplyTheme(themeName)
	NovaUI.ThemeManager:ApplyTheme(themeName)
end

function NovaUI:SetAccentColor(color)
	NovaUI.ThemeManager:SetAccent(color)
end

function NovaUI:GetAccentColor()
	return NovaUI.ThemeManager:GetColor("Accent")
end

function NovaUI:GetColor(colorKey)
	return NovaUI.ThemeManager:GetColor(colorKey)
end

function NovaUI:GetThemes()
	return NovaUI.ThemeManager:GetThemeList()
end

function NovaUI:AddTheme(name, palette)
	NovaUI.ThemeManager:AddTheme(name, palette)
end

function NovaUI:SetSoundsEnabled(enabled)
	NovaUI.SoundManager:SetEnabled(enabled)
end

function NovaUI:SetSoundVolume(volume)
	NovaUI.SoundManager:SetVolume(volume)
end

function NovaUI:RegisterIcon(name, assetId)
	NovaUI.IconManager:RegisterIcon(name, assetId)
end

function NovaUI:RegisterIcons(iconTable)
	NovaUI.IconManager:RegisterIcons(iconTable)
end

function NovaUI:OnThemeChange(callback)
	return NovaUI.ThemeManager:OnChange(callback)
end

function NovaUI:CreateConfig(options)
	options = options or {}
	return NovaUI.ConfigService:Init(options)
end

function NovaUI:Unload()
	NovaUI.AnimationManager:CancelAll()
	NovaUI.SoundManager:Cleanup()
	NovaUI.DragService:Cleanup()

	for _, window in ipairs(Window.GetWindows()) do
		window:Destroy()
	end
end

return NovaUI
