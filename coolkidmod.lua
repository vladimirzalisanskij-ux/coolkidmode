-- Coolkid Mode All-in-One Script
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local camera = Workspace.CurrentCamera

-- Настройки
local coolkidTexture = "rbxassetid://6688864505"
local coolkidMusic = "rbxassetid://1839241117"
local soundEffects = {
	"rbxassetid://1840453315",
	"rbxassetid://1840468435",
	"rbxassetid://1839241117"
}

local particleTexture = "rbxassetid://243098098"
local coolkidOn = false
local music

-- Создаём RemoteEvents если их нет
local function getOrCreateRemote(name)
	local obj = ReplicatedStorage:FindFirstChild(name)
	if not obj then
		obj = Instance.new("RemoteEvent")
		obj.Name = name
		obj.Parent = ReplicatedStorage
	end
	return obj
end

local shakeEvent = getOrCreateRemote("CoolkidShake")
local guiEvent = getOrCreateRemote("CoolkidShowMessage")
local nameTagEvent = getOrCreateRemote("CoolkidNameTag")
local playSoundEvent = getOrCreateRemote("CoolkidPlaySound")

-- Функции
local function setCoolkidTextures(enable)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj.Texture = enable and coolkidTexture or ""
		elseif obj:IsA("MeshPart") then
			obj.TextureID = enable and coolkidTexture or ""
		elseif obj:IsA("SpecialMesh") then
			obj.TextureId = enable and coolkidTexture or ""
		end
	end
end

local function flashingLighting()
	while coolkidOn do
		Lighting.Ambient = Color3.fromRGB(math.random(150,255), math.random(100,255), 0)
		Lighting.OutdoorAmbient = Color3.fromRGB(math.random(150,255), math.random(100,255), 0)
		task.wait(0.2)
	end
end

local function playMusic()
	if music then return end
	music = Instance.new("Sound")
	music.SoundId = coolkidMusic
	music.Looped = true
	music.Volume = 5
	music.Parent = Workspace
	music:Play()
end

local function stopMusic()
	if music then
		music:Stop()
		music:Destroy()
		music = nil
	end
end

local function createParticles()
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local emitter = Instance.new("ParticleEmitter")
			emitter.Texture = particleTexture
			emitter.Rate = 200
			emitter.Lifetime = NumberRange.new(0.5,1)
			emitter.Speed = NumberRange.new(5,10)
			emitter.Parent = p.Character.HumanoidRootPart
			task.delay(5, function()
				emitter.Enabled = false
				task.wait(1)
				if emitter then emitter:Destroy() end
			end)
		end
	end
end

local function showScreenMessage(text)
	for _, p in ipairs(Players:GetPlayers()) do
		guiEvent:FireClient(p, text)
	end
end

local function setNameTags(enable)
	for _, p in ipairs(Players:GetPlayers()) do
		nameTagEvent:FireClient(p, enable)
	end
end

local function playRandomSound()
	for _, p in ipairs(Players:GetPlayers()) do
		local sId = soundEffects[math.random(1,#soundEffects)]
		playSoundEvent:FireClient(p, sId)
	end
end

local function enableCoolkid()
	if coolkidOn then return end
	coolkidOn = true
	setCoolkidTextures(true)
	playMusic()
	showScreenMessage("COOLKID MODE ACTIVATED")
	setNameTags(true)
	createParticles()
	task.spawn(flashingLighting)
	for _, p in ipairs(Players:GetPlayers()) do
		shakeEvent:FireClient(p, true)
	end
end

local function disableCoolkid()
	if not coolkidOn then return end
	coolkidOn = false
	setCoolkidTextures(false)
	stopMusic()
	Lighting.Ambient = Color3.fromRGB(127,127,127)
	Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
	showScreenMessage("COOLKID MODE DEACTIVATED")
	setNameTags(false)
	for _, p in ipairs(Players:GetPlayers()) do
		shakeEvent:FireClient(p, false)
	end
end

-- Команды в чате
local function connectPlayer(plr)
	plr.Chatted:Connect(function(msg)
		msg = msg:lower()
		if msg == "/coolkid on" then
			enableCoolkid()
		elseif msg == "/coolkid off" then
			disableCoolkid()
		elseif msg == "/coolkid sound" then
			playRandomSound()
		end
	end)
end

Players.PlayerAdded:Connect(connectPlayer)
for _,p in ipairs(Players:GetPlayers()) do
	connectPlayer(p)
end
