local SoundManager = {}
SoundManager.__index = SoundManager

local SOUNDS = {
	Hover = "rbxassetid://9120385726",
	Click = "rbxassetid://9120386667",
	Success = "rbxassetid://9120389271",
	Error = "rbxassetid://9120388158",
	Notification = "rbxassetid://9120387472",
	ToggleOn = "rbxassetid://9120388878",
	ToggleOff = "rbxassetid://9120389634",
	TabSwitch = "rbxassetid://9120386710",
	Open = "rbxassetid://9120388320",
	Close = "rbxassetid://9120388271",
	Slider = "rbxassetid://9120388934",
	Dropdown = "rbxassetid://9120388320",
}

local SoundService = game:GetService("SoundService")

SoundManager.Enabled = true
SoundManager.Volume = 0.5
SoundManager.SoundGroup = nil

function SoundManager:Init()
	if not self.SoundGroup then
		self.SoundGroup = Instance.new("SoundGroup")
		self.SoundGroup.Name = "UILibrarySounds"
		self.SoundGroup.Volume = self.Volume
		self.SoundGroup.Parent = SoundService
	end
end

function SoundManager:Play(soundName)
	if not self.Enabled then
		return nil
	end

	local assetId = SOUNDS[soundName]
	if not assetId then
		return nil
	end

	self:Init()

	local sound = Instance.new("Sound")
	sound.SoundId = assetId
	sound.Volume = self.Volume
	sound.SoundGroup = self.SoundGroup
	sound.Parent = SoundService

	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	return sound
end

function SoundManager:SetVolume(volume)
	self.Volume = math.clamp(volume, 0, 1)
	if self.SoundGroup then
		self.SoundGroup.Volume = self.Volume
	end
end

function SoundManager:SetEnabled(enabled)
	self.Enabled = enabled
	if not enabled and self.SoundGroup then
		self.SoundGroup.Volume = 0
	elseif enabled and self.SoundGroup then
		self.SoundGroup.Volume = self.Volume
	end
end

function SoundManager:Toggle()
	self:SetEnabled(not self.Enabled)
end

function SoundManager:RegisterSound(name, assetId)
	SOUNDS[name] = assetId
end

function SoundManager:GetSoundNames()
	local names = {}
	for name in SOUNDS do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function SoundManager:PlayHover()
	return self:Play("Hover")
end

function SoundManager:PlayClick()
	return self:Play("Click")
end

function SoundManager:PlaySuccess()
	return self:Play("Success")
end

function SoundManager:PlayError()
	return self:Play("Error")
end

function SoundManager:PlayNotification()
	return self:Play("Notification")
end

function SoundManager:PlayToggle()
	return self:Play("ToggleOn")
end

function SoundManager:Cleanup()
	if self.SoundGroup then
		self.SoundGroup:Destroy()
		self.SoundGroup = nil
	end
end

return SoundManager
