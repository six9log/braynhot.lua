--====================================================
-- RED TEAM AUDIT V4 (FORCE LOOP + UI REFORÇADA)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local STATE = {
    Running = true,
    SpeedEnabled = false,
    SpeedValue = 100
}

-- 1. LOOP PRINCIPAL AGRESSIVO (FORÇA VALORES CONSTANTEMENTE)
local loopConnection = RunService.Heartbeat:Connect(function()
    if not STATE.Running then return end
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hum and STATE.SpeedEnabled then
        -- Isso força a velocidade a cada frame, impedindo o servidor de sobrescrever
        hum.WalkSpeed = STATE.SpeedValue
    end
end)

-- 2. INTERFACE ROBUSTA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AuditV4_Interface"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Essencial para a GUI não sumir quando você morre

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame.Active = true
Frame.Draggable = true -- Permite arrastar no mobile

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

-- BOTÃO FECHAR (POSIÇÃO ABSOLUTA E GARANTIDA)
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(1, 0, 0, 40)
CloseBtn.Position = UDim2.new(0, 0, 1, -40)
CloseBtn.Text = "FECHAR E LIMPAR AUDIT"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

CloseBtn.MouseButton1Click:Connect(function()
    STATE.Running = false
    STATE.SpeedEnabled = false
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 16 end -- Reseta para a velocidade padrão
    loopConnection:Disconnect() -- Desconecta o loop principal
    ScreenGui:Destroy() -- Destrói a interface
end)
