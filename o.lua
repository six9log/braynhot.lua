-- [[ GGPVP HUB - VERSÃO NATIVA PARA DELTA ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.Aimbot = false
_G.WallCheck = true
_G.ESP = false
_G.Speed = 16
_G.FOV = 150

-- [[ INTERFACE NATIVA ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GGPVP_UI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") -- Delta prefere PlayerGui
ScreenGui.ResetOnSpawn = false

-- Botão de Abrir/Fechar
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.Text = "GGPVP"
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Parent = ScreenGui
OpenBtn.Draggable = true

-- Painel Principal
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 260)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = Main
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Função para criar botões da lista
local function NewButton(txt, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = Main
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- Função para criar inputs (Speed/FOV)
local function NewInput(placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 35)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Parent = Main
    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

-- Botões do Script
NewButton("Aimbot: OFF", function(b)
    _G.Aimbot = not _G.Aimbot
    b.Text = _G.Aimbot and "Aimbot: ON" or "Aimbot: OFF"
    b.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

NewButton("WallCheck: ON", function(b)
    _G.WallCheck = not _G.WallCheck
    b.Text = _G.WallCheck and "WallCheck: ON" or "WallCheck: OFF"
end)

NewButton("ESP: OFF", function(b)
    _G.ESP = not _G.ESP
    b.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
    b.BackgroundColor3 = _G.ESP and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

NewInput("Velocidade (Ex: 50)", function(t)
    _G.Speed = tonumber(t) or 16
end)

NewInput("Tamanho FOV (Ex: 200)", function(t)
    _G.FOV = tonumber(t) or 150
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- [[ LÓGICA DO AIMBOT ]]
local function IsVisible(part)
    if not _G.WallCheck then return true end
    local cast = Camera:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    return cast == nil or cast.Instance:IsDescendantOf(part.Parent)
end

local function GetTarget()
    local target = nil
    local dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist and IsVisible(head) then
                    dist = mag
                    target = head
                end
            end
        end
    end
    return target
end

-- [[ LOOP DE FUNCIONAMENTO ]]
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local t = GetTarget()
        if t then
            local look = CFrame.new(Camera.CFrame.Position, t.Position + (t.Velocity * 0.12))
            Camera.CFrame = Camera.CFrame:Lerp(look, 0.15)
        end
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed
    end

    -- ESP Simples (Highlight)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local highlight = v.Character:FindFirstChild("GGPVP_ESP")
            if _G.ESP and v.Team ~= LocalPlayer.Team then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GGPVP_ESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = v.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)
