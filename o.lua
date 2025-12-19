--========================================
-- FORCE NOCLIP + SPEED SELECT (STUDIO)
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

------------------------------------------------
-- STATE
------------------------------------------------
local noclip = false
local speed = 50 -- velocidade inicial
local moveConn
local dir = Vector3.zero

------------------------------------------------
-- UI
------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ForceNoclipUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,260)
frame.Position = UDim2.new(0,20,0.55,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Active = true
frame.Draggable = true

local function makeBtn(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,32)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,80)
    return b
end

local toggle = makeBtn("NOCLIP : OFF", 10)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1,-20,0,30)
speedLabel.Position = UDim2.new(0,10,0,50)
speedLabel.Text = "Velocidade: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1

local s10  = makeBtn("Velocidade 10", 85)
local s50  = makeBtn("Velocidade 50", 120)
local s100 = makeBtn("Velocidade 100",155)
local s200 = makeBtn("Velocidade 200",190)

local close = makeBtn("FECHAR MENU", 225)
close.BackgroundColor3 = Color3.fromRGB(120,30,30)

------------------------------------------------
-- INPUT
------------------------------------------------
UserInputService.InputBegan:Connect(function(i,gp
