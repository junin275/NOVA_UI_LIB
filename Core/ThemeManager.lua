local ThemeManager = {}
ThemeManager.__index = ThemeManager

local DARK_BG = Color3.fromRGB(10, 10, 15)
local DARK_SURFACE = Color3.fromRGB(16, 16, 22)
local DARK_SURFACE_ALT = Color3.fromRGB(22, 22, 30)
local DARK_BORDER = Color3.fromRGB(30, 30, 42)
local DARK_BORDER_LIGHT = Color3.fromRGB(38, 38, 52)

local DEFAULT_PALETTE = {
	Background = DARK_BG,
	Surface = DARK_SURFACE,
	SurfaceAlt = DARK_SURFACE_ALT,
	Border = DARK_BORDER,
	BorderLight = DARK_BORDER_LIGHT,
	Accent = Color3.fromRGB(108, 92, 231),
	AccentSecondary = Color3.fromRGB(162, 108, 255),
	TextPrimary = Color3.fromRGB(230, 230, 245),
	TextSecondary = Color3.fromRGB(155, 155, 175),
	TextMuted = Color3.fromRGB(90, 90, 115),
	Success = Color3.fromRGB(0, 200, 117),
	Warning = Color3.fromRGB(255, 184, 76),
	Danger = Color3.fromRGB(255, 82, 82),
	Info = Color3.fromRGB(84, 160, 255),
	Overlay = Color3.fromRGB(0, 0, 0),
	Shadow = Color3.fromRGB(0, 0, 0),
	HeaderText = Color3.fromRGB(200, 200, 220),
	Divider = Color3.fromRGB(28, 28, 38),
	ToggleActive = Color3.fromRGB(108, 92, 231),
	ToggleInactive = Color3.fromRGB(38, 38, 50),
	InputBackground = Color3.fromRGB(18, 18, 26),
	ScrollBar = Color3.fromRGB(108, 92, 231),
}

local LIGHT_BG = Color3.fromRGB(245, 245, 250)
local LIGHT_SURFACE = Color3.fromRGB(255, 255, 255)
local LIGHT_SURFACE_ALT = Color3.fromRGB(238, 238, 245)
local LIGHT_BORDER = Color3.fromRGB(210, 210, 220)
local LIGHT_BORDER_LIGHT = Color3.fromRGB(220, 220, 230)

local LIGHT_PALETTE = {
	Background = LIGHT_BG,
	Surface = LIGHT_SURFACE,
	SurfaceAlt = LIGHT_SURFACE_ALT,
	Border = LIGHT_BORDER,
	BorderLight = LIGHT_BORDER_LIGHT,
	Accent = Color3.fromRGB(108, 92, 231),
	AccentSecondary = Color3.fromRGB(162, 108, 255),
	TextPrimary = Color3.fromRGB(20, 20, 35),
	TextSecondary = Color3.fromRGB(90, 90, 115),
	TextMuted = Color3.fromRGB(140, 140, 160),
	Success = Color3.fromRGB(0, 180, 100),
	Warning = Color3.fromRGB(230, 160, 50),
	Danger = Color3.fromRGB(230, 60, 60),
	Info = Color3.fromRGB(60, 140, 240),
	Overlay = Color3.fromRGB(0, 0, 0),
	Shadow = Color3.fromRGB(0, 0, 0),
	HeaderText = Color3.fromRGB(40, 40, 60),
	Divider = Color3.fromRGB(210, 210, 220),
	ToggleActive = Color3.fromRGB(108, 92, 231),
	ToggleInactive = Color3.fromRGB(180, 180, 195),
	InputBackground = Color3.fromRGB(232, 232, 240),
	ScrollBar = Color3.fromRGB(108, 92, 231),
}

local DARK_THEMES = {
	Default = DEFAULT_PALETTE,
	Amethyst = {
		Background = Color3.fromRGB(10, 10, 18),
		Surface = Color3.fromRGB(16, 16, 26),
		SurfaceAlt = Color3.fromRGB(22, 22, 34),
		Border = Color3.fromRGB(35, 30, 45),
		BorderLight = Color3.fromRGB(42, 38, 55),
		Accent = Color3.fromRGB(156, 101, 217),
		AccentSecondary = Color3.fromRGB(217, 101, 189),
		TextPrimary = Color3.fromRGB(230, 230, 245),
		TextSecondary = Color3.fromRGB(155, 155, 176),
		TextMuted = Color3.fromRGB(95, 90, 115),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(156, 101, 217),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(200, 200, 220),
		Divider = Color3.fromRGB(28, 28, 42),
		ToggleActive = Color3.fromRGB(156, 101, 217),
		ToggleInactive = Color3.fromRGB(38, 38, 52),
		InputBackground = Color3.fromRGB(18, 18, 28),
		ScrollBar = Color3.fromRGB(156, 101, 217),
	},
	Emerald = {
		Background = Color3.fromRGB(10, 14, 10),
		Surface = Color3.fromRGB(16, 22, 16),
		SurfaceAlt = Color3.fromRGB(22, 30, 22),
		Border = Color3.fromRGB(30, 42, 30),
		BorderLight = Color3.fromRGB(38, 52, 38),
		Accent = Color3.fromRGB(38, 185, 128),
		AccentSecondary = Color3.fromRGB(38, 128, 185),
		TextPrimary = Color3.fromRGB(230, 245, 230),
		TextSecondary = Color3.fromRGB(155, 176, 155),
		TextMuted = Color3.fromRGB(90, 115, 90),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(38, 185, 128),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(200, 220, 200),
		Divider = Color3.fromRGB(28, 42, 28),
		ToggleActive = Color3.fromRGB(38, 185, 128),
		ToggleInactive = Color3.fromRGB(38, 52, 38),
		InputBackground = Color3.fromRGB(18, 26, 18),
		ScrollBar = Color3.fromRGB(38, 185, 128),
	},
	Ruby = {
		Background = Color3.fromRGB(18, 10, 10),
		Surface = Color3.fromRGB(26, 16, 16),
		SurfaceAlt = Color3.fromRGB(34, 22, 22),
		Border = Color3.fromRGB(45, 30, 30),
		BorderLight = Color3.fromRGB(55, 38, 38),
		Accent = Color3.fromRGB(217, 65, 65),
		AccentSecondary = Color3.fromRGB(185, 65, 101),
		TextPrimary = Color3.fromRGB(245, 230, 230),
		TextSecondary = Color3.fromRGB(176, 155, 155),
		TextMuted = Color3.fromRGB(115, 90, 90),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(217, 65, 65),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(220, 200, 200),
		Divider = Color3.fromRGB(42, 28, 28),
		ToggleActive = Color3.fromRGB(217, 65, 65),
		ToggleInactive = Color3.fromRGB(52, 38, 38),
		InputBackground = Color3.fromRGB(26, 18, 18),
		ScrollBar = Color3.fromRGB(217, 65, 65),
	},
	Sapphire = {
		Background = Color3.fromRGB(10, 10, 18),
		Surface = Color3.fromRGB(16, 16, 26),
		SurfaceAlt = Color3.fromRGB(22, 22, 34),
		Border = Color3.fromRGB(30, 30, 45),
		BorderLight = Color3.fromRGB(38, 38, 55),
		Accent = Color3.fromRGB(45, 156, 219),
		AccentSecondary = Color3.fromRGB(45, 101, 219),
		TextPrimary = Color3.fromRGB(230, 230, 245),
		TextSecondary = Color3.fromRGB(155, 155, 176),
		TextMuted = Color3.fromRGB(90, 95, 115),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(45, 156, 219),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(200, 200, 220),
		Divider = Color3.fromRGB(28, 28, 42),
		ToggleActive = Color3.fromRGB(45, 156, 219),
		ToggleInactive = Color3.fromRGB(38, 38, 52),
		InputBackground = Color3.fromRGB(18, 18, 28),
		ScrollBar = Color3.fromRGB(45, 156, 219),
	},
}

local LIGHT_THEMES = {
	Default = LIGHT_PALETTE,
}

ThemeManager.CurrentTheme = "Default"
ThemeManager.CurrentPalette = {}
ThemeManager.CustomPalettes = {}
ThemeManager.Listeners = {}
ThemeManager.AnimateOnChange = true
ThemeManager.IsDark = true

function ThemeManager:GetColor(key)
	local palette = self.CurrentPalette
	if palette and palette[key] then
		return palette[key]
	end
	return DEFAULT_PALETTE[key] or Color3.fromRGB(255, 255, 255)
end

function ThemeManager:GetThemeList()
	local list = {}
	for name in DARK_THEMES do
		table.insert(list, name)
	end
	for name in LIGHT_THEMES do
		table.insert(list, name)
	end
	for name in self.CustomPalettes do
		table.insert(list, name)
	end
	return list
end

function ThemeManager:AddTheme(name, palette)
	palette = palette or {}
	for k, v in DEFAULT_PALETTE do
		if palette[k] == nil then
			palette[k] = v
		end
	end
	self.CustomPalettes[name] = palette
	if self.CurrentTheme == name then
		self:ApplyTheme(name)
	end
end

function ThemeManager:ApplyTheme(name)
	local palette = DARK_THEMES[name] or LIGHT_THEMES[name] or self.CustomPalettes[name]
	if not palette then
		return
	end
	self.CurrentTheme = name
	self.CurrentPalette = palette
	self.IsDark = (DARK_THEMES[name] ~= nil)
	self:NotifyListeners()
end

function ThemeManager:SetAccent(color)
	self.CurrentPalette.Accent = color
	self:NotifyListeners()
end

function ThemeManager:SetAnimateOnChange(state)
	self.AnimateOnChange = state
end

function ThemeManager:OnChange(callback)
	table.insert(self.Listeners, callback)
	return function()
		for i, cb in ipairs(self.Listeners) do
			if cb == callback then
				table.remove(self.Listeners, i)
				break
			end
		end
	end
end

function ThemeManager:NotifyListeners()
	for _, callback in self.Listeners do
		pcall(callback, self.CurrentPalette, self.AnimateOnChange)
	end
end

return ThemeManager
