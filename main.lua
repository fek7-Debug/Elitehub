--[[
    MIT LICENSE
    Copyright (c) 2026 Elite Hub Developer
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
--]]

-- ELITE HUB V1 | FINAL EDITION
local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Stats = game:GetService("Stats")

-- Limpieza de GUI previa
if CoreGui:FindFirstChild("EliteV30") then CoreGui.EliteV30:Destroy() end

local UI = Instance.new("ScreenGui", CoreGui)
UI.Name = "EliteV30"
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- VARIABLES GLOBALES
_G.FullESP = false
_G.ItemESP = false
_G.SpeedValue = 16
_G.Aimbot = true
_G.Lang = "ES"

-- --- PANEL DE CONFIG / AYUDA ---
local ConfigFrame = Instance.new("Frame", UI)
ConfigFrame.Size = UDim2.new(0, 250, 0, 300); ConfigFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
ConfigFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); ConfigFrame.Visible = false; Instance.new("UICorner", ConfigFrame)
Instance.new("UIStroke", ConfigFrame).Color = Color3.fromRGB(0, 150, 255)

local Title = Instance.new("TextLabel", ConfigFrame)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "ELITE CONFIG"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold

local LangBtn = Instance.new("TextButton", ConfigFrame)
LangBtn.Size = UDim2.new(0.8, 0, 0, 35); LangBtn.Position = UDim2.new(0.1, 0, 0.15, 0); LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); LangBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", LangBtn)

local HelpText = Instance.new("TextLabel", ConfigFrame)
HelpText.Size = UDim2.new(0.9, 0, 0, 200); HelpText.Position = UDim2.new(0.05, 0, 0.3, 0); HelpText.BackgroundTransparency = 1; HelpText.TextColor3 = Color3.new(0.8, 0.8, 0.8); HelpText.TextWrapped = true; HelpText.Font = Enum.Font.Gotham; HelpText.TextSize = 13; HelpText.TextYAlignment = Enum.TextYAlignment.Top

local function UpdateLang()
    if _G.Lang == "ES" then
        LangBtn.Text = "IDIOMA: ESPAÑOL"
        HelpText.Text = "• AIMBOT: Apunta al pecho (Auto).\n• AUTO-SLASH: Activo por defecto ✅\n• 👁️: ESP de Roles (Rojo/Azul).\n• 📦: ESP de arma en el suelo.\n• ⚡: Velocidad x3.\n• 🧤: TP Flash al arma."
    else
        LangBtn.Text = "LANGUAGE: ENGLISH"
        HelpText.Text = "• AIMBOT: Target Chest (Auto).\n• AUTO-SLASH: Enabled by default ✅\n• 👁️: Role ESP (Red/Blue).\n• 📦: Item ESP (Dropped Gun).\n• ⚡: Speed x3.\n• 🧤: TP Flash to Gun."
    end
end
UpdateLang()
LangBtn.MouseButton1Click:Connect(function() _G.Lang = (_G.Lang == "ES") and "EN" or "ES" UpdateLang() end)

-- --- PANEL DE STATS ARRASTRABLE ---
local StatsFrame = Instance.new("Frame", UI)
StatsFrame.Size = UDim2.new(0, 160, 0, 35); StatsFrame.Position = UDim2.new(0.5, -80, 0, 10); StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); StatsFrame.Active = true; StatsFrame.Draggable = true; Instance.new("UICorner", StatsFrame)
local StatsLabel = Instance.new("TextLabel", StatsFrame)
StatsLabel.Size = UDim2.new(1, 0, 1, 0); StatsLabel.BackgroundTransparency = 1; StatsLabel.TextColor3 = Color3.new(1, 1, 1); StatsLabel.Font = Enum.Font.Code; StatsLabel.TextSize = 13

-- --- FUNCIÓN BOTONES ---
local function CreateBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", UI)
    b.Size = UDim2.new(0, 50, 0, 50); b.Position = pos; b.BackgroundColor3 = Color3.fromRGB(15, 15, 15); b.TextColor3 = color; b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 18; b.Active = true; b.Draggable = true; Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = color
    b.MouseButton1Click:Connect(callback)
    return b
end

-- BOTONES
CreateBtn("CONF", UDim2.new(0, 15, 0.3, 0), Color3.fromRGB(0, 150, 255), function() ConfigFrame.Visible = not ConfigFrame.Visible end)
CreateBtn("👁️", UDim2.new(0, 15, 0.4, 0), Color3.fromRGB(255, 255, 255), function() _G.FullESP = not _G.FullESP end)
CreateBtn("📦", UDim2.new(0, 15, 0.5, 0), Color3.fromRGB(255, 150, 0), function() _G.ItemESP = not _G.ItemESP end)
CreateBtn("⚡", UDim2.new(0, 15, 0.6, 0), Color3.fromRGB(255, 255, 0), function() _G.SpeedValue = (_G.SpeedValue == 16) and 60 or 16 end)
CreateBtn("🧤", UDim2.new(0.85, 0, 0.4, 0), Color3.fromRGB(0, 255, 150), function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun") then
            local hrp = lp.Character.HumanoidRootPart
            local old = hrp.CFrame
            hrp.CFrame = (obj:IsA("BasePart") and obj.CFrame or obj.Parent:GetModelCFrame())
            task.wait(0.3)
            hrp.CFrame = old
            break
        end
    end
end)
CreateBtn("🎯", UDim2.new(0.85, 0, 0.5, 0), Color3.fromRGB(255, 0, 0), function() _G.Aimbot = not _G.Aimbot end)

-- --- LOOP MAESTRO ---
local lastT = tick(); local fCount = 0; local fps = 0
RS.RenderStepped:Connect(function()
    -- Stats
    fCount = fCount + 1
    if tick() - lastT >= 1 then fps = fCount; fCount = 0; lastT = tick() end
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    StatsLabel.Text = string.format("FPS: %d | PING: %d ms", fps, ping)

    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = _G.SpeedValue
    end

    local myGun = lp.Character:FindFirstChild("Gun")
    local myKnife = lp.Character:FindFirstChild("Knife")

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart

            -- Aimbot al pecho (Solo vs Asesino)
            if myGun and _G.Aimbot and (char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
                myGun:Activate()
            end

            -- Auto-Slash
            if myKnife and (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 15 then
                myKnife:Activate()
            end

            -- ESP Dinámico
            local h = char:FindFirstChild("EliteHigh") or Instance.new("Highlight", char)
            h.Name = "EliteHigh"; h.Enabled = _G.FullESP
            if _G.FullESP then
                if char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then h.FillColor = Color3.new(1,0,0)
                elseif char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then h.FillColor = Color3.new(0,0,1)
                else h.FillColor = Color3.new(0,1,0) end
            end
        end
    end

    -- Item ESP
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" then
            local b = obj:FindFirstChild("B") or Instance.new("SelectionBox", obj)
            b.Name = "B"; b.Adornee = obj; b.Visible = _G.ItemESP; b.Color3 = Color3.new(1,0.5,0)
        end
    end
end)

