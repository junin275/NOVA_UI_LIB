local ConfigService = {}
ConfigService.__index = ConfigService

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DEFAULT_CONFIG = {
	Theme = "Default",
	Accent = nil,
	Sounds = true,
	Volume = 0.5,
	Scale = 1,
	Minimized = false,
	Position = nil,
	Size = nil,
	CustomData = {},
}

function ConfigService:Init(options)
	options = options or {}
	self.ConfigName = options.ConfigName or "UI_Library_Config"
	self.AutoSaveInterval = options.AutoSaveInterval or 60
	self.AutoSaveEnabled = options.AutoSaveEnabled or false
	self.CurrentConfig = self:Load() or self:DeepCopy(DEFAULT_CONFIG)

	if self.AutoSaveEnabled then
		self:StartAutoSave()
	end

	return self
end

function ConfigService:GetConfigPath()
	return string.format("%s/%s.json", Player.UserId, self.ConfigName)
end

function ConfigService:Save()
	local success, err = pcall(function()
		local data = HttpService:JSONEncode(self.CurrentConfig)
		writefile(self:GetConfigPath(), data)
	end)
	return success
end

function ConfigService:Load()
	local success, data = pcall(function()
		return readfile(self:GetConfigPath())
	end)
	if success and data then
		local decoded = HttpService:JSONDecode(data)
		self.CurrentConfig = self:MergeConfigs(DEFAULT_CONFIG, decoded)
		return self.CurrentConfig
	end
	return nil
end

function ConfigService:Get(key, defaultValue)
	if self.CurrentConfig[key] ~= nil then
		return self.CurrentConfig[key]
	end
	return defaultValue
end

function ConfigService:Set(key, value)
	self.CurrentConfig[key] = value
	self:Save()
end

function ConfigService:GetCustom(key, defaultValue)
	local custom = self.CurrentConfig.CustomData or {}
	if custom[key] ~= nil then
		return custom[key]
	end
	return defaultValue
end

function ConfigService:SetCustom(key, value)
	if not self.CurrentConfig.CustomData then
		self.CurrentConfig.CustomData = {}
	end
	self.CurrentConfig.CustomData[key] = value
	self:Save()
end

function ConfigService:Reset()
	self.CurrentConfig = self:DeepCopy(DEFAULT_CONFIG)
	self:Save()
end

function ConfigService:ResetSection(section)
	if section == "CustomData" then
		self.CurrentConfig.CustomData = {}
	else
		self.CurrentConfig[section] = DEFAULT_CONFIG[section]
	end
	self:Save()
end

function ConfigService:Export()
	return HttpService:JSONEncode(self.CurrentConfig)
end

function ConfigService:Import(jsonString)
	local success, data = pcall(function()
		return HttpService:JSONDecode(jsonString)
	end)
	if success then
		self.CurrentConfig = self:MergeConfigs(DEFAULT_CONFIG, data)
		self:Save()
		return true
	end
	return false
end

function ConfigService:StartAutoSave()
	if self._autoSaveThread then
		self._autoSaveThread:Disconnect()
	end

	while self.AutoSaveEnabled do
		task.wait(self.AutoSaveInterval)
		self:Save()
	end
end

function ConfigService:SetAutoSaveInterval(seconds)
	self.AutoSaveInterval = seconds
end

function ConfigService:DeepCopy(tbl)
	local copy = {}
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			copy[k] = self:DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function ConfigService:MergeConfigs(defaults, overrides)
	local result = self:DeepCopy(defaults)
	for k, v in pairs(overrides) do
		if type(v) == "table" and type(result[k]) == "table" then
			result[k] = self:MergeConfigs(result[k], v)
		else
			result[k] = v
		end
	end
	return result
end

function ConfigService:OnConfigChanged(callback)
	self._onChanged = callback
end

function ConfigService:Destroy()
	if self._autoSaveThread then
		self._autoSaveThread:Disconnect()
		self._autoSaveThread = nil
	end
	self.CurrentConfig = nil
end

return ConfigService
