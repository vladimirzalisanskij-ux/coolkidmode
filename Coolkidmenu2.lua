-- CoolkidServer: Синхронизация для всех игроков
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаём RemoteEvent
local textureEvent = Instance.new("RemoteEvent")
textureEvent.Name = "CoolkidTextureEvent"
textureEvent.Parent = ReplicatedStorage

local soundEvent = Instance.new("RemoteEvent")
soundEvent.Name = "CoolkidSoundEvent"
soundEvent.Parent = ReplicatedStorage

-- ТВОЯ КАРТИНКА
local COOLKID_IMAGE_ID = "rbxassetid://118652198574158"

-- ТВОЙ ЗВУК
local COOLKID_SOUND_ID = "rbxassetid://119729923584444"

-- === ТЕКСТУРЫ ===
textureEvent.OnServerEvent:Connect(function(player, enable)
	-- Применяем на сервере → все видят
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("MeshPart") then
			-- Удаляем старые
			for _, child in ipairs(obj:GetChildren()) do
				if child:IsA("Decal") then
					child:Destroy()
				end
			end

			if enable then
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
end)

-- === ЗВУК ===
soundEvent.OnServerEvent:Connect(function(player, enable)
	if enable then
		local sound = Instance.new("Sound")
		sound.SoundId = COOLKID_SOUND_ID
		sound.Volume = 8
		sound.Parent = workspace
		sound:Play()
		-- Автоудаление
		game.Debris:AddItem(sound, 10)
	else
		-- Остановка (если нужно)
		for _, s in ipairs(workspace:GetChildren()) do
			if s:IsA("Sound") and s.SoundId == COOLKID_SOUND_ID then
				s:Stop()
				s:Destroy()
			end
		end
	end
end)