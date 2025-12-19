--====================================================
-- RED TEAM AUDIT V5 (ULTIMATE FORCE-LOOP)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local STATE = {
    Running = true,
    SpeedEnabled = false,
    SpeedValue = 100
}

-- FUNÇÃO PARA OBTER O HUMANÓIDE DE FORMA SEGURA
local function getHumanoid()
    local char = LocalPlayer.Character
    if not char or not char.Parent then return end -- Garante que o char existe no workspace
    return char:FindFirstChildOfClass("Humanoid")
end

-- 1. LOOP PRINCIPAL AGRESSIVO (FORÇA VALORES CONSTANTEMENTE)
local loopConnection = RunService.Heartbeat:Connect(function()
    if not STATE.Running then return end
    
    local hum = getHumanoid()
    
    if hum and STATE.SpeedEnabled then
        -- Força a velocidade a CADA FRAME. Isso deve vencer o anti-cheat de reset.
        hum.WalkSpeed = STATE.SpeedValue
    end
end)

-- 2. INTERFACE ROBUSTA
local sg = Instance.new("ScreenGui")
sg.Name = "AuditV5_Interface"
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false -- Essencial para não sumir ao morrer

local Frame = Instance.new("Frame", sg)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame.Active = true
Frame.Draggable = true

-- BOTÃO SPEED
local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
SpeedBtn.Text = "SPEED: OFF (100)"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SpeedBtn.MouseButton1Click:Connect(function()
    STATE.SpeedEnabled = not STATE.SpeedEnabled
end)

-- FEEDBACK VISUAL EM TEMPO REAL
RunService.RenderStepped:Connect(function()
    if STATE.SpeedEnabled then
        SpeedBtn.Text = "SPEED: ON (100)"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        SpeedBtn.Text = "SPEED: OFF (100)"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

-- BOTÃO FECHAR
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(1, 0, 0, 40)
CloseBtn.Position = UDim2.new(0, 0, 1, -40)
CloseBtn.Text = "FECHAR E LIMPAR AUDIT"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

CloseBtn.MouseButton1Click:Connect(function()
    STATE.Running = false
    STATE.SpeedEnabled = false
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = 16 end -- Reseta para o padrão
    if loopConnection then loopConnection:Disconnect() end
    sg:Destroy() 
end)

-- Conecta a atualização do personagem para garantir que sempre peguemos o Humanoid certo
LocalPlayer.CharacterAdded:Connect(function()
    -- Quando o char é adicionado, a função getHumanoid() automaticamente pega o novo
end)
