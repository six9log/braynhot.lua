-- ORION LIBRARY (A melhor para Delta Mobile)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "GGPVP HUB - DELTA SUPREME", HidePremium = false, SaveConfig = true, ConfigFolder = "GGPVPHub", IntroText = "GGPVP HUB"})

-- [[ SERVIÇOS ]]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ VARIÁVEIS ]]
_G.Aimbot = false
_G.Smoothness = 0.1
_G.WallCheck = true
_G.AimDistance = 1000
_G.NoRecoil = false
_G.WalkSpeed = 16
_G.Fly = false
_G.FlySpeed = 50
_G.GodMode = false
_G.Noclip = false

_G.ESP_Box = false
_G.ESP_Skeleton = false
_G.ESP_Distance = false

-- [[ LÓGICA AIMBOT ]]
local function IsVisible(part)
    local character = LocalPlayer.Character
    if not character then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {character, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000, params)
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function GetTarget()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local head = v.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local worldDist = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                if worldDist <= _G.AimDistance then
                    if not _G.WallCheck or IsVisible(head) then
                        local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if mag < dist then
                            dist = mag
                            target = head
                        end
                    end
                end
            end
        end
    end
    return target
end

-- [[ LOOP PRINCIPAL ]]
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local t = GetTarget()
        if t then
            local look = CFrame.new(Camera.CFrame.Position, t.Position + (t.Velocity * 0.12))
            Camera.CFrame = Camera.CFrame:Lerp(look, _G.Smoothness)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        if _G.GodMode then LocalPlayer.Character.Humanoid.Health = 100 end
    end
end)

-- [[ FLY & NOCLIP ]]
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector * _G.FlySpeed
    end
end)

-- [[ ABAS ]]
local Tab1 = Window:MakeTab({Name = "Combate", Icon = "rbxassetid://4483345998", PremiumOnly = false})
Tab1:AddToggle({Name = "Ativar Aimbot", Default = false, Callback = function(v) _G.Aimbot = v end})
Tab1:AddToggle({Name = "Wall Check", Default = true, Callback = function(v) _G.WallCheck = v end})
Tab1:AddSlider({Name = "Suavidade (Smooth)", Min = 0.01, Max = 1, Default = 0.1, Color = Color3.fromRGB(255,255,255), Increment = 0.01, ValueName = "S", Callback = function(v) _G.Smoothness = v end})
Tab1:AddSlider({Name = "Distância do Aim", Min = 100, Max = 5000, Default = 1000, Color = Color3.fromRGB(255,255,255), Increment = 100, ValueName = "m", Callback = function(v) _G.AimDistance = v end})

local Tab2 = Window:MakeTab({Name = "Troll/Mov", Icon = "rbxassetid://4483345998", PremiumOnly = false})
Tab2:AddToggle({Name = "Fly (Vôo)", Default = false, Callback = function(v) _G.Fly = v end})
Tab2:AddSlider({Name = "Velocidade Fly", Min = 10, Max = 500, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Spd", Callback = function(v) _G.FlySpeed = v end})
Tab2:AddSlider({Name = "Velocidade Andar", Min = 16, Max = 300, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Walk", Callback = function(v) _G.WalkSpeed = v end})
Tab2:AddToggle({Name = "Noclip", Default = false, Callback = function(v) _G.Noclip = v end})
Tab2:AddToggle({Name = "God Mode", Default = false, Callback = function(v) _G.GodMode = v end})

local Tab3 = Window:MakeTab({Name = "Visual", Icon = "rbxassetid://4483345998", PremiumOnly = false})
Tab3:AddLabel("Nota: ESP no Delta pode causar lag.")
Tab3:AddToggle({Name = "ESP Box (Vermelho)", Default = false, Callback = function(v) _G.ESP_Box = v end})
Tab3:AddToggle({Name = "ESP Skeleton (Linha)", Default = false, Callback = function(v) _G.ESP_Skeleton = v end})
Tab3:AddToggle({Name = "ESP Distância (Branco)", Default = false, Callback = function(v) _G.ESP_Distance = v end})

-- Botão de Minimizar para Mobile
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 50, 0, 50)
Button.Position = UDim2.new(0, 10, 0.5, 0)
Button.Text = "GGPVP"
Button.Parent = game:GetService("CoreGui"):FindFirstChild("Orion") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Orion")
Button.Draggable = true
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)

Button.MouseButton1Click:Connect(function()
    local gui = game:GetService("CoreGui"):FindFirstChild("Orion") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Orion")
    if gui then gui.Enabled = not gui.Enabled end
end)

OrionLib:Init()
