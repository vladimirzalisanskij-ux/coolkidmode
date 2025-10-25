-- Coolkid Test GUI: ТВОЯ КАРТИНКА + ТВОЙ ЗВУК
-- ID картинки: 118652198574158
-- ID звука: 119729923584444

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ТВОЯ КАРТИНКА COOLKID
local COOLKID_IMAGE_ID = "rbxassetid://118652198574158"

-- ТВОЙ ЗВУК COOLKID
local COOLKID_SOUND_ID = "rbxassetid://119729923584444"

-- СОСТОЯНИЯ
local textureEnabled = false
local soundEnabled = false
local currentSound = nil

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
title.Text = "COOLKID TEST"
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

-- ПРИМЕНИТЬ ТЕКСТУРЫ
local function applyTextures(enable)
	textureEnabled = enable
	textureBtn.Text = "TEXTURES: " .. (enable and "ON" or "OFF")
	textureBtn.BackgroundColor3 = enable and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("MeshPart") then
			-- Удаляем старые декали
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Decal") then
					child:Destroy()
				end
			end

			if enable then
				-- Добавляем твою картинку на все грани
				for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
					local decal = Instance.new("Decal")
					decal.Texture = COOLKID_IMAGE_ID
					decal.Face = face
					decal.Transparency = 0
					decal.Parent = obj
				end
			end
		end
	end
end

-- ЗВУК (твой ID)
local function toggleSound()
	soundEnabled = not soundEnabled
	soundBtn.Text = "SOUND: " .. (soundEnabled and "ON" or "OFF")
	soundBtn.BackgroundColor3 = soundEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)

	if soundEnabled then
		spawn(function()
			while soundEnabled do
				-- Останавливаем старый
				if currentSound and currentSound.Parent then
					currentSound:Stop()
					currentSound:Destroy()
				end

				-- Новый звук
				currentSound = Instance.new("Sound")
				currentSound.SoundId = COOLKID_SOUND_ID
				currentSound.Volume = 8
				currentSound.Looped = false
				currentSound.Parent = workspace
				currentSound:Play()

				-- Ждём окончания
				currentSound.Ended:Wait()
			end
		end)
	else
		if currentSound then
			currentSound:Stop()
			currentSound:Destroy()
			currentSound = nil
		end
	end
end

-- ОЧИСТКА
local function clearAll()
	applyTextures(false)
	if soundEnabled then toggleSound() end
end

-- ПОДКЛЮЧЕНИЕ КНОПОК
textureBtn.MouseButton1Click:Connect(function()
	applyTextures(not textureEnabled)
end)

soundBtn.MouseButton1Click:Connect(toggleSound)

clearBtn.MouseButton1Click:Connect(clearAll)
