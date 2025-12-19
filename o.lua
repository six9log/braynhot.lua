--====================================================
-- RED TEAM AUDIT V6 (NOCLIP & TELEPORT)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local STATE = {
    Running = true,
    Noclip = false,
    TargetPlayer = ""
}

-- FUNÇÃO PARA OBTER O HUMANÓIDE DE FORMA SEGURA
local function getHumanoid()
    local char = LocalPlayer.Character
    if not char or not char.Parent then return end
    return char:FindFirstChildOfClass("Humanoid")
end

-- 1. LOOP PRINCIPAL DE FÍSICA (NOCLIP PERSISTENTE)
local physicsConnection = RunService.Heartbeat:Connect(function()
    if not STATE.Running then return end
    
    local char = LocalPlayer.Character
    if char and STATE.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
            end
        end
    end
end)

-- 2. INTERFACE ROBUSTA
local sg = Instance.new("ScreenGui")
sg.Name = "AuditV6_Interface"
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

local Frame = Instance.new("Frame", sg)
Frame.Size = UDim2.new(0, 220, 0, 260)
Frame.Position = UDim2.new(0.5, -110, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame.Active = true
Frame.Draggable = true

-- TÍTULO
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "NOCLIP & TP AUDIT"
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
Title.TextColor3 = Color3.new(1, 1, 1)

-- BOTÃO NOCLIP
local NocBtn = Instance.new("TextButton", Frame)
NocBtn.Size = UDim2.new(0.9, 0, 0, 45)
NocBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
NocBtn.Text = "NOCLIP: OFF"
NocBtn.MouseButton1Click:Connect(function()
    STATE.Noclip = not STATE.Noclip
end)

-- INPUT: NOME DO JOGADOR PARA TP
local TpInput = Instance.new("TextBox", Frame)
TpInput.Size = UDim2.new(0.9, 0, 0, 40)
TpInput.Position = UDim2.new(0.05, 0, 0.45, 0)
TpInput.PlaceholderText = "Nome do Jogador..."
TpInput.Text = ""

-- BOTÃO TELEPORTE
local TpBtn = Instance.new("TextButton", Frame)
TpBtn.Size = UDim2.new(0.9, 0, 0, 45)
TpBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
TpBtn.Text = "TELEPORTAR"
TpBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(TpInput.Text)
    local char = LocalPlayer.Character
    if target and target.Character and char then
        -- Teleporta o jogador para a CFrame do alvo
        char:SetPrimaryPartCFrame(target.Character:GetPrimaryPartCFrame() * CFrame.new(0, 5, 0))
    end
end)

-- FEEDBACK VISUAL EM TEMPO REAL
RunService.RenderStepped:Connect(function()
    if not STATE.Running then return end
    NocBtn.Text = STATE.Noclip and "NOCLIP: ATIVO" or "NOCLIP: INATIVO"
    NocBtn.BackgroundColor3 = STATE.Noclip and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
end)

-- BOTÃO FECHAR
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(1, 0, 0, 40)
CloseBtn.Position = UDim2.new(0, 0, 1, -40)
CloseBtn.Text = "FECHAR E LIMPAR AUDIT"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

CloseBtn.MouseButton1Click:Connect(function()
    STATE.Running = false
    STATE.Noclip = false
    if physicsConnection then physicsConnection:Disconnect() end
    sg:Destroy() 
end)
