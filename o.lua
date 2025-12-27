-- [[ GGPVP HUB - AIMBOT PROXIMIDADE & WALLCHECK ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.Aimbot = false
_G.WallCheck = true
_G.ESP = false
_G.Speed = 16
_G.AimDistance = 2000 -- Distância máxima para o aimbot focar

-- [[ INTERFACE NATIVA (DELTA FRIENDLY) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGPVP_UI_V2"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.Text = "GGPVP"
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Parent = ScreenGui
OpenBtn.Draggable = true

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 220)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = Main
UIList.Padding = UDim.new(0, 7)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function NewButton(txt, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Main
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

local function NewInput(placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 40)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Parent = Main
    box.FocusLost:Connect(function() callback(box.Text) end)
end

-- Configuração dos botões
NewButton("Aimbot: OFF", function(b)
    _G.Aimbot = not _G.Aimbot
    b.Text = _G.Aimbot and "Aimbot: ON" or "Aimbot: OFF"
    b.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 45)
end)

NewButton("WallCheck: ON", function(b)
    _G.WallCheck = not _G.WallCheck
    b.Text = _G.WallCheck and "WallCheck: ON" or "WallCheck: OFF"
    b.BackgroundColor3 = _G.WallCheck and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(45, 45, 45)
end)

NewButton("ESP (Chams): OFF", function(b)
    _G.ESP = not _G.ESP
    b.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
    b.BackgroundColor3 = _G.ESP and Color3.fromRGB(150, 0, 150) or Color3.fromRGB(45, 45, 45)
end)

NewInput("Velocidade", function(t) _G.Speed = tonumber(t) or 16 end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [[ LÓGICA DE VISIBILIDADE ]]
local function IsVisible(part)
    if not _G.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {char, Camera}
    
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000, rayParams)
    
    -- Se o raycast não atingir nada antes do inimigo, ele está visível
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

-- [[ BUSCA PELO MAIS PRÓXIMO ]]
local function GetClosestToCharacter()
    local target = nil
    local shortestDistance = _G.AimDistance
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            
            local enemyHead = v.Character.Head
            local distance = (myRoot.Position - enemyHead.Position).Magnitude
            
            if distance < shortestDistance then
                if IsVisible(enemyHead) then
                    shortestDistance = distance
                    target = enemyHead
                end
            end
        end
    end
    return target
end

-- [[ LOOP SUPREMO ]]
RunService.RenderStepped:Connect(function()
    -- Aimbot na Cabeça
    if _G.Aimbot then
        local target = GetClosestToCharacter()
        if target then
            -- Suavidade de 0.2 para ser preciso mas não dar "kick"
            local goal = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, 0.2)
        end
    end
    
    -- Velocidade
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed
    end

    -- ESP (Highlight)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local highlight = v.Character:FindFirstChild("GGPVP_CHAMS")
            if _G.ESP and v.Team ~= LocalPlayer.Team and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GGPVP_CHAMS"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = v.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)
