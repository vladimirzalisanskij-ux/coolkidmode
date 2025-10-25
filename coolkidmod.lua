-- CoolkidGUI: ТОЛЬКО У ТЕБЯ (тестовая панель)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- RemoteEvents
local textureEvent = ReplicatedStorage:WaitForChild("CoolkidTextureEvent")
local soundEvent = ReplicatedStorage:WaitForChild("CoolkidSoundEvent")

-- СОСТОЯНИЯ
local textureOn = false
local soundOn = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolkidTestGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 10, 0.5, -90)
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

-- КНОПКА: ТЕКСТУРЫ
local textureBtn = Instance.new("TextButton")
textureBtn.Size = UDim2.new(0.9, 0, 0, 40)
textureBtn.Position = UDim2.new(0.05, 0, 0, 50)
textureBtn.Text = "TEXTURES: OFF"
textureBtn.TextColor3 = Color3.new(0, 0, 0)
textureBtn.BackgroundColor3 = Color3.new(1, 0, 0)
textureBtn.Font = Enum.Font.GothamBold
textureBtn.TextScaled = true
textureBtn.Parent = frame

-- КНОПКА: ЗВУК
local soundBtn = Instance.new("TextButton")
soundBtn.Size = UDim2.new(0.9, 0, 0, 40)
soundBtn.Position = UDim2.new(0.05, 0, 0, 100)
soundBtn.Text = "SOUND: OFF"
soundBtn.TextColor3 = Color3.new(0, 0, 0)
soundBtn.BackgroundColor3 = Color3.new(1, 0, 0)
soundBtn.Font = Enum.Font.GothamBold
soundBtn.TextScaled = true
soundBtn.Parent = frame

-- КНОПКА: ОЧИСТКА
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.9, 0, 0, 35)
clearBtn.Position = UDim2.new(0.05, 0, 0, 145)
clearBtn.Text = "CLEAR ALL"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.BackgroundColor3 = Color3.new(0.7, 0, 0)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextScaled = true
clearBtn.Parent = frame

-- === ТЕКСТУРЫ ===
textureBtn.MouseButton1Click:Connect(function()
	textureOn = not textureOn
	textureBtn.Text = "TEXTURES: " .. (textureOn and "ON" or "OFF")
	textureBtn.BackgroundColor3 = textureOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	
	-- Отправляем на сервер → все видят
	textureEvent:FireServer(textureOn)
end)

-- === ЗВУК ===
soundBtn.MouseButton1Click:Connect(function()
	soundOn = not soundOn
	soundBtn.Text = "SOUND: " .. (soundOn and "ON" or "OFF")
	soundBtn.BackgroundColor3 = soundOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	
	-- Отправляем на сервер → все слышат
	soundEvent:FireServer(soundOn)
end)

-- === ОЧИСТКА ===
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
end)
