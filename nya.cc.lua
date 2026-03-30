local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "nya.cc <3",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "nya.cc",
   LoadingSubtitle = "by eouya <3",
   ShowText = "nya.cc <3", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Green", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "nya.cc",
      Subtitle = "Get key .gg/bEW7phdvs",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"nya"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

Rayfield:Notify({
   Title = "nya.cc <3",
   Content = "Thanks for support my project :D",
   Duration = 6.5,
   Image = 4483362458,
})

Rayfield:Notify({
   Title = "nya.cc <3",
   Content = "Join for discord! : .gg/bEW7phdvs",
   Duration = 6.5,
   Image = 4483362458,
})

local Tab = Window:CreateTab("Aim", 4483362458) -- Title, Image
local Tab2 = Window:CreateTab("Visual", 4483362458)
---aim
local Button = Tab:CreateButton({
   Name = "AimBot",
   Callback = function()
   local Players = game:GetService("Players")
     local LocalPlayer = Players.LocalPlayer
     local Camera = workspace.CurrentCamera
     local RunService = game:GetService("RunService")
     local MAX_DIST = 70 -- Максимальная дистанция (поменяй число, если нужно ближе/дальше)
     
     RunService.RenderStepped:Connect(function()
       local closest, shortestDist = nil, MAX_DIST
       for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            
            -- Считаем расстояние до игрока
            local distance = (head.Position - Camera.CFrame.Position).Magnitude
            
            -- Проверяем: 1. Близко ли он? 2. Виден ли на экране?
            local _, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if distance < shortestDist and onScreen then
                -- 3. Проверяем стены (Raycast)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local ray = workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rayParams)
                
                -- Если луч попал прямо в персонажа (стены нет)
                if ray and ray.Instance:IsDescendantOf(p.Character) then
                    closest = head
                    shortestDist = distance
                end
            end
        end
    end
    -- Наводка (если цель найдена)
    if closest then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Position)
    end
end)

   end,
})

--------VISUAL
local Button = Tab2:CreateButton({
   Name = "Esp",
   Callback = function()
   local Players = game:GetService("Players")
     local LocalPlayer = Players.LocalPlayer

-- Функция для создания подсветки
     local function addHighlight(character)
       if not character then return end
    
    -- Проверяем, нет ли уже подсветки, чтобы не плодить их
       if character:FindFirstChild("PlayerHighlight") then return end
       
       local highlight = Instance.new("Highlight")
       highlight.Name = "PlayerHighlight"
       highlight.FillColor = Color3.fromRGB(255, 255, 255) 
       highlight.OutlineColor = Color3.fromRGB(0, 255, 0) 
       highlight.FillTransparency = 0.5 -- Прозрачность заливки (0 - плотный, 1 - невидимый)
       highlight.OutlineTransparency = 0 -- Обводка полностью видна
    
    -- ГЛАВНАЯ НАСТРОЙКА: AlwaysOnTop позволяет видеть сквозь стены
       highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
       highlight.Parent = character
     end

-- Применяем ко всем текущим игрокам
     for _, player in pairs(Players:GetPlayers()) do
       if player ~= LocalPlayer then
         if player.Character then
           addHighlight(player.Character)
         end
        -- Следим за возрождением игрока
         player.CharacterAdded:Connect(addHighlight)
       end
     end

-- Следим за новыми игроками, которые зашли на сервер
     Players.PlayerAdded:Connect(function(player)
       player.CharacterAdded:Connect(addHighlight)
     end)

   end,
})

local Button = Tab2:CreateButton({
   Name = "3-rd face",
   Callback = function()
   local p = game.Players.LocalPlayer
     local Camera = workspace.CurrentCamera

-- 1. Снимаем все ограничения зума
     p.CameraMaxZoomDistance = 20 -- Установи комфортную дистанцию (например 20)
     p.CameraMinZoomDistance = 10 -- Не дает войти в 1-е лицо
     p.CameraMode = Enum.CameraMode.Classic -- Отключает принудительное 1-е лицо от разработчика

-- 2. Сброс настроек камеры (на случай, если скрипт игры их заблокировал)
     Camera.CameraType = Enum.CameraType.Custom
     Camera.FieldOfView = 70

-- 3. Цикл для принудительного удержания (если игра пытается вернуть 1-е лицо)
     game:GetService("RunService").RenderStepped:Connect(function()
    -- Проверка на существование персонажа
       if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
         local root = p.Character.HumanoidRootPart
        
        -- Поворот лицом к камере
         local camPos = Camera.CFrame.Position
         local targetLook = Vector3.new(camPos.X, root.Position.Y, camPos.Z)
         root.CFrame = CFrame.lookAt(root.Position, targetLook)
       end
    
    -- Постоянно проверяем, чтобы зум не сбросился
       if p.CameraMinZoomDistance < 10 then
         p.CameraMinZoomDistance = 10
       end
     end)

   end,
})

local Slider = Tab2:CreateSlider({
   Name = "Universal Body Lean",
   Range = {-90, 90}, 
   Increment = 1,
   Suffix = "°",
   CurrentValue = 0,
   Flag = "UniversalLean", 
   Callback = function(Value)
      local Character = game.Players.LocalPlayer.Character
      if not Character then return end
      
      local Humanoid = Character:FindFirstChildOfClass("Humanoid")
      if not Humanoid then return end

      local rad = math.rad(Value)

      if Humanoid.RigType == Enum.HumanoidRigType.R15 then
         -- Логика для R15: двигаем Waist в UpperTorso
         local UpperTorso = Character:FindFirstChild("UpperTorso")
         local Waist = UpperTorso and UpperTorso:FindFirstChild("Waist")
         if Waist then
            Waist.C0 = CFrame.new(0, Waist.C0.Y, 0) * CFrame.Angles(rad, 0, 0)
         end
      elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
         -- Логика для R6: двигаем RootJoint в HumanoidRootPart
         local RootPart = Character:FindFirstChild("HumanoidRootPart")
         local RootJoint = RootPart and RootPart:FindFirstChild("RootJoint")
         if RootJoint then
            -- В R6 RootJoint повернут иначе, поэтому используем оси (rad, 0, 0) или (0, 0, rad) 
            -- в зависимости от нужной стороны наклона
            RootJoint.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90) + rad, math.rad(180), 0)
         end
      end
   end,
})

local Button = Tab2:CreateButton({
   Name = "Fake Lag",
   Callback = function()
      local LagAmount = 0.5 -- How many seconds to "store" the lag
      local FakeLagEnabled = true
      
      local RunService = game:GetService("RunService")
      local Player = game.Players.LocalPlayer

-- Ghost Setup (Your visual indicator)
      local ghost = Instance.new("Part")
      ghost.Name = "FakeLag_Visual"
      ghost.CanCollide = false
      ghost.Anchored = true
      ghost.Transparency = 0.6
      ghost.Color = Color3.fromRGB(255, 255, 255)
      ghost.Material = Enum.Material.ForceField
      ghost.Parent = workspace
      
      local highlight = Instance.new("Highlight")
      highlight.FillColor = Color3.fromRGB(255, 255, 255)
      highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
      highlight.Parent = ghost

-- Main Loop
      RunService.Heartbeat:Connect(function()
         local char = Player.Character
         local root = char and char:FindFirstChild("HumanoidRootPart")
         
         if root and FakeLagEnabled then
        -- 1. Visual Ghost (Stays where others see you)
        -- It updates only every X seconds
            if tick() % LagAmount < 0.05 then 
            ghost.CFrame = root.CFrame
            ghost.Size = char:GetExtentsSize()
        end

        -- 2. Network Lag (The "Magic" part)
        -- We tell the engine to delay sending our position to the server
        settings().Network.IncomingReplicationLag = LagAmount
        
        -- Alternative: Some executors use 'setsimulationradius' to mess with physics ownership
        if sethiddenproperty then
            sethiddenproperty(Player, "SimulationRadius", 0)
            sethiddenproperty(Player, "MaxSimulationRadius", 0)
        end
    else
        settings().Network.IncomingReplicationLag = 0
        ghost.Transparency = 1
        highlight.Enabled = false
    end
end)

   end,
})

local Button = Tab:CreateButton({
   Name = "Fog green",
   Callback = function()
      -- Settings for Stronger Soft Gree
      local StrongGreen = Color3.fromRGB(160, 220, 160) -- More saturated soft green
      local Visibility = 450 -- Closer visibility to make the fog "thick"
      local FogStart = 20 -- Fog starts almost immediately
      
      local Lighting = game:GetService("Lighting")

-- 1. Setup Thicker Atmosphere
      local function applyStrongAtmosphere()
         local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
         
         atmo.Density = 0.55 -- Increased density for a "thicker" feel
         atmo.Offset = 0 -- Makes the fog cover everything from the ground up
         atmo.Color = StrongGreen
         atmo.Decay = Color3.fromRGB(130, 180, 130) -- Darker green for the distance
         atmo.Glare = 0.5 -- Adds a nice "glow" effect to the green
         atmo.Haze = 4 -- Makes the horizon very blurry and solid
      end

-- 2. Setup Heavy Fog
      local function applyHeavyFog()
         Lighting.FogColor = StrongGreen
         Lighting.FogStart = FogStart
         Lighting.FogEnd = Visibility
    
    -- Make the world colors match the fog
         Lighting.OutdoorAmbient = StrongGreen
         Lighting.Brightness = 2.5 -- Boosts the "glow"
         Lighting.ClockTime = 14
      end

-- 3. Solid Sky (Covers the Skybox)
      local function setupSolidSky()
         local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    
    -- Clear all skybox textures to make it a solid green void/atmosphere
         sky.SkyboxBk = ""
         sky.SkyboxDn = ""
         sky.SkyboxFt = ""
         sky.SkyboxLf = ""
         sky.SkyboxRt = ""
         sky.SkyboxUp = ""
         sky.SunAngularSize = 0 -- Completely hide the sun
      end

-- Execute
      applyStrongAtmosphere()
      applyHeavyFog()
      setupSolidSky()

-- Loop to force settings
      task.spawn(function()
         while task.wait(1) do
            Lighting.FogColor = StrongGreen
            Lighting.FogEnd = Visibility
            Lighting.OutdoorAmbient = StrongGreen
         end
      end)
   end,
})

Rayfield:LoadConfiguration()