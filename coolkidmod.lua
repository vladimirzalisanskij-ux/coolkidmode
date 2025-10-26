-- Bootstrap: САМ СОЗДАЁТ основной скрипт в ServerScriptService + тряска
-- Помести ВРУЧНУЮ в Workspace или ReplicatedStorage

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- === ОСНОВНОЙ СКРИПТ (будет создан в SSS) ===
local mainScriptSource = [[
-- CoolkidMain: Автоматически создан в ServerScriptService
-- Текстуры, звук, ТРЯСКА КАМЕРЫ — ВСЕМ игрокам

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- ID
local COOLKID_IMAGE_ID = "rbxassetid://118652198574158"
local COOLKID_SOUND_ID = "rbxassetid://119729923584444"

-- RemoteEvents
local textureEvent = ReplicatedStorage:FindFirstChild("CoolkidTextureEvent") or Instance.new("RemoteEvent")
textureEvent_TLS = textureEvent
textureEvent.Name = "CoolkidTextureEvent"
textureEvent.Parent = ReplicatedStorage

local soundEvent = ReplicatedStorage:FindFirstChild("CoolkidSoundEvent") or Instance.new("RemoteEvent")
soundEvent.Name = "CoolkidSoundEvent"
soundEvent.Parent = ReplicatedStorage

local shakeEvent = ReplicatedStorage:FindFirstChild("CoolkidShakeEvent") or Instance.new("RemoteEvent")
shakeEvent.Name = "CoolkidShakeEvent"
shakeEvent.Parent = ReplicatedStorage

-- === ТЕКСТУРЫ ===
textureEvent.OnServerEvent:Connect(function(player, enable)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("MeshPart") then
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Decal") and child.Texture == COOLKID_IMAGE_ID then
					child:Destroy()
				end
			end
		end
	end

	if enable then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") or obj:IsA("MeshPart") then
				for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
					local decal = Instance.new("Decal")
					decal.Name = "CoolkidDecal"
					decal.Texture = COOLKID_IMAGE_ID
					decal.Face = face
					decal.Transparency = 0
					decal.Parent = obj
				end
			end
		end
	end
end)

-- === ЗВУК ===
soundEvent.OnServerEvent:Connect(function(player, enable)
	for _, s in ipairs(workspace:GetChildren()) do
		if s:IsA("Sound") and s.SoundId == COOLKID_SOUND_ID then
			s:Stop()
			s:Destroy()
		end
	end

	if enable then
		local sound = Instance.new("Sound")
		sound.Name = "CoolkidSound"
		sound.SoundId = COOLKID_SOUND_ID
		sound.Volume = 8
		sound.Looped = false
		sound.Parent = workspace
		sound:Play()
		Debris:AddItem(sound, 15)
	end
end)

-- === ТРЯСКА КАМЕРЫ (для всех) ===
local shaking = false
local shakeIntensity = 0

shakeEvent.OnServerEvent:Connect(function(player, enable, intensity)
	shaking = enable
	shakeIntensity = intensity or 0.7
	shakeEvent:FireAllClients(enable, shakeIntensity)
end)

-- Клиентская тряска (встроена в GUI)
]]

-- === GUI + ТРЯСКА (LocalScript как строка) ===
local guiScriptSource = [[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- RemoteEvents
local textureEvent = ReplicatedStorage:WaitForChild("CoolkidTextureEvent")
local soundEvent = ReplicatedStorage:WaitForChild("CoolkidSoundEvent")
local shakeEvent = ReplicatedStorage:WaitForChild("CoolkidShakeEvent")

-- Состояния
local textureOn = false
local soundOn = false
local shakeOn = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolkidTestGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 230)
frame.Position = UDim2.new(0, 10, 0.5, -115)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(1, 1, 0)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "COOLKID CONTROL"
title.TextColor3 = Color3.new(1, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = frame

-- Кнопка: Текстуры
local textureBtn = Instance.new("TextButton")
textureBtn.Size = UDim2.new(0.9, 0, 0, 40)
textureBtn.Position = UDim2.new(0.05, 0, 0, 50)
textureBtn.Text = "TEXTURES: OFF"
textureBtn.TextColor3 = Color3.new(0, 0, 0)
textureBtn.BackgroundColor3 = Color3.new(1, 0, 0)
textureBtn.Font = Enum.Font.GothamBold
textureBtn.TextScaled = true
textureBtn.Parent = frame

-- Кнопка: Звук
local soundBtn = Instance.new("TextButton")
soundBtn.Size = UDim2.new(0.9, 0, 0, 40)
soundBtn.Position = UDim2.new(0.05, 0, 0, 100)
soundBtn.Text = "SOUND: OFF"
soundBtn.TextColor3 = Color3.new(0, 0, 0)
soundBtn.BackgroundColor3 = Color3.new(1, 0, 0)
soundBtn.Font = Enum.Font.GothamBold
soundBtn.TextScaled = true
soundBtn.Parent = frame

-- Кнопка: Тряска
local shakeBtn = Instance.new("TextButton")
shakeBtn.Size = UDim2.new(0.9, 0, 0, 40)
shakeBtn.Position = UDim2.new(0.05, 0, 0, 150)
shakeBtn.Text = "SHAKE: OFF"
shakeBtn.TextColor3 = Color3.new(0, 0, 0)
shakeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
shakeBtn.Font = Enum.Font.GothamBold
shakeBtn.TextScaled = true
shakeBtn.Parent = frame

-- Кнопка: Очистка
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.9, 0, 0, 35)
clearBtn.Position = UDim2.new(0.05, 0, 0, 195)
clearBtn.Text = "CLEAR ALL"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.BackgroundColor3 = Color3.new(0.7, 0, 0)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextScaled = true
clearBtn.Parent = frame

-- === ТРЯСКА КАМЕРЫ (клиентская) ===
local shaking = false
local shakeIntensity = 0
local originalCFrame = camera.CFrame

shakeEvent.OnClientEvent:Connect(function(enable, intensity)
	shaking = enable
	shakeIntensity = intensity or 0.7
end)

RunService.RenderStepped:Connect(function(dt)
	if shaking and shakeIntensity > 0 then
		local offset = Vector3.new(
			(math.random() - 0.5) * shakeIntensity,
			(math.random() - 0.5) * shakeIntensity,
			0
		)
		camera.CFrame = originalCFrame * CFrame.new(offset)
		shakeIntensity = math.max(shakeIntensity - 8 * dt, 0)
	else
		originalCFrame = camera.CFrame
	end
end)

-- === КНОПКИ ===
textureBtn.MouseButton1Click:Connect(function()
	textureOn = not textureOn
	textureBtn.Text = "TEXTURES: " .. (textureOn and "ON" or "OFF")
	textureBtn.BackgroundColor3 = textureOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	textureEvent:FireServer(textureOn)
end)

soundBtn.MouseButton1Click:Connect(function()
	soundOn = not soundOn
	soundBtn.Text = "SOUND: " .. (soundOn and "ON" or "OFF")
	soundBtn.BackgroundColor3 = soundOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	soundEvent:FireServer(soundOn)
end)

shakeBtn.MouseButton1Click:Connect(function()
	shakeOn = not shakeOn
	shakeBtn.Text = "SHAKE: " .. (shakeOn and "ON" or "OFF")
	shakeBtn.BackgroundColor3 = shakeOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	shakeEvent:FireServer(shakeOn)
end)

clearBtn.MouseButton1Click:Connect(function()
	if textureOn then
		textureOn = false
		textureBtn.Text = "TEXTURES: OFF"
		textureBtn.BackgroundColor3 = Color3.new(1, 0, 0)
		textureEvent:FireServer(false)
	end
	if soundOn then
		soundOn = false
		soundBtn.Text = "SOUND: OFF"
		soundBtn.BackgroundColor3 = Color3.new(1, 0, 0)
		soundEvent:FireServer(false)
	end
	if shakeOn then
		shakeOn = false
		shakeBtn.Text = "SHAKE: OFF"
		shakeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
		shakeEvent:FireServer(false)
	end
end)
]]

-- === РАЗВОРАЧИВАЕМ GUI ДЛЯ ВСЕХ ===
local function deployGUI(player)
	local guiScript = Instance.new("LocalScript")
	guiScript.Name = "CoolkidGUI"
	guiScript.Source = guiScriptSource
	guiScript.Parent = player:WaitForChild("PlayerGui")
end

for _, player in ipairs(Players:GetPlayers()) do
	deployGUI(player)
end

Players.PlayerAdded:Connect(deployGUI)
]]

-- === СОЗДАЁМ ОСНОВНОЙ СКРИПТ ===
local mainScript = Instance.new("Script")
mainScript.Name = "CoolkidMain"
mainScript.Source = mainScriptSource
mainScript.Parent = ServerScriptService

-- Удаляем bootstrap после создания
script:Destroy()
