local ThemeManager = {}
ThemeManager.__index = ThemeManager

local DEFAULT_PALETTE = {
	Background = Color3.fromRGB(13, 13, 15),
	Surface = Color3.fromRGB(20, 20, 24),
	SurfaceAlt = Color3.fromRGB(26, 26, 32),
	Border = Color3.fromRGB(35, 35, 42),
	BorderLight = Color3.fromRGB(42, 42, 53),
	Accent = Color3.fromRGB(79, 124, 255),
	AccentSecondary = Color3.fromRGB(118, 89, 255),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(154, 154, 176),
	TextMuted = Color3.fromRGB(90, 90, 112),
	Success = Color3.fromRGB(76, 175, 132),
	Warning = Color3.fromRGB(255, 184, 76),
	Danger = Color3.fromRGB(255, 107, 107),
	Info = Color3.fromRGB(79, 124, 255),
	Overlay = Color3.fromRGB(0, 0, 0),
	Shadow = Color3.fromRGB(0, 0, 0),
}

local DARK_THEMES = {
	Default = DEFAULT_PALETTE,
	Amethyst = {
		Background = Color3.fromRGB(13, 13, 15),
		Surface = Color3.fromRGB(20, 20, 24),
		SurfaceAlt = Color3.fromRGB(26, 26, 32),
		Border = Color3.fromRGB(35, 35, 42),
		BorderLight = Color3.fromRGB(42, 42, 53),
		Accent = Color3.fromRGB(156, 101, 217),
		AccentSecondary = Color3.fromRGB(217, 101, 189),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(154, 154, 176),
		TextMuted = Color3.fromRGB(90, 90, 112),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(156, 101, 217),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Emerald = {
		Background = Color3.fromRGB(13, 15, 13),
		Surface = Color3.fromRGB(20, 24, 20),
		SurfaceAlt = Color3.fromRGB(26, 32, 26),
		Border = Color3.fromRGB(35, 42, 35),
		BorderLight = Color3.fromRGB(42, 53, 42),
		Accent = Color3.fromRGB(38, 185, 128),
		AccentSecondary = Color3.fromRGB(38, 128, 185),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(154, 176, 154),
		TextMuted = Color3.fromRGB(90, 112, 90),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(38, 185, 128),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Ruby = {
		Background = Color3.fromRGB(15, 13, 13),
		Surface = Color3.fromRGB(24, 20, 20),
		SurfaceAlt = Color3.fromRGB(32, 26, 26),
		Border = Color3.fromRGB(42, 35, 35),
		BorderLight = Color3.fromRGB(53, 42, 42),
		Accent = Color3.fromRGB(217, 65, 65),
		AccentSecondary = Color3.fromRGB(185, 65, 101),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(176, 154, 154),
		TextMuted = Color3.fromRGB(112, 90, 90),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(217, 65, 65),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
	Sapphire = {
		Background = Color3.fromRGB(13, 13, 15),
		Surface = Color3.fromRGB(20, 20, 24),
		SurfaceAlt = Color3.fromRGB(26, 26, 32),
		Border = Color3.fromRGB(35, 35, 42),
		BorderLight = Color3.fromRGB(42, 42, 53),
		Accent = Color3.fromRGB(45, 156, 219),
		AccentSecondary = Color3.fromRGB(45, 101, 219),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(154, 154, 176),
		TextMuted = Color3.fromRGB(90, 90, 112),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(45, 156, 219),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
	},
}

ThemeManager.CurrentTheme = "Default"
ThemeManager.CurrentPalette = {}
ThemeManager.CustomPalettes = {}
ThemeManager.Listeners = {}
ThemeManager.AnimateOnChange = true

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
	local palette = DARK_THEMES[name] or self.CustomPalettes[name]
	if not palette then
		return
	end
	self.CurrentTheme = name
	self.CurrentPalette = palette
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
	for _, callback in ipairs(self.Listeners) do
		pcall(callback, self.CurrentPalette, self.AnimateOnChange)
	end
end

function ThemeManager:GetCSSColor(key)
	local color = self:GetColor(key)
	return Color3.new(color.R, color.G, color.B)
end

function ThemeManager:ApplyToInstance(instance, properties)
	for propName, colorKey in properties do
		local color = self:GetColor(colorKey)
		if color then
			if propName == "BackgroundColor3" or propName == "BorderColor3" or propName == "TextColor3" then
				instance[propName] = color
			elseif propName == "BackgroundTransparency" then
				instance.BackgroundTransparency = color
			end
		end
	end
end

return ThemeManager
