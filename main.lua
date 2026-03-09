local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gameId = game.PlaceId
local successInfo, productInfo = pcall(function() return MarketplaceService:GetProductInfo(gameId) end)
local gameName = successInfo and productInfo.Name or "Unknown Game"

local repoOwner = "higuysdorobloxjoaopk-maker"
local repoName = "install-rbx.luay"
local scriptsPath = "data/scripts"

if makefolder and not isfolder("terminalLuay") then
makefolder("terminalLuay")
end

local function getFavs()
if isfile and isfile("terminalLuay/fav.json") then
local content = readfile("terminalLuay/fav.json")
local s,res = pcall(function() return HttpService:JSONDecode(content) end)
if s then return res end
end
return {}
end

local function saveFavs(tbl)
if writefile then
writefile("terminalLuay/fav.json",HttpService:JSONEncode(tbl))
end
end

local gui = Instance.new("ScreenGui")
gui.Name = "LuayTerminal"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 2147483647
gui.Parent = (game:GetService("CoreGui") or player.PlayerGui)

local spinIcon = Instance.new("ImageButton")
spinIcon.Size = UDim2.new(0,40,0,40)
spinIcon.Position = UDim2.new(0,10,0,50)
spinIcon.Image = "rbxassetid://139638431991473"
spinIcon.BackgroundTransparency = 1
spinIcon.Visible = false
spinIcon.Parent = gui

local terminalWindow = Instance.new("Frame")
terminalWindow.Size = UDim2.new(0,500,0,320)
terminalWindow.Position = UDim2.new(.5,-250,.5,-160)
terminalWindow.BackgroundColor3 = Color3.fromRGB(10,10,10)
terminalWindow.BorderSizePixel = 0
terminalWindow.ClipsDescendants = true
terminalWindow.Parent = gui

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,25)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)
top.BorderSizePixel = 0
top.Active = true
top.Parent = terminalWindow

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Terminal.luay"
title.Font = Enum.Font.Arcade
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0,255,120)
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = top

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-25,0,0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.Arcade
minimizeBtn.TextSize = 22
minimizeBtn.TextColor3 = Color3.fromRGB(0,255,120)
minimizeBtn.Parent = top

local dragging,dragInput,dragStart,startPos

local function updateDrag(input)
local delta = input.Position - dragStart
terminalWindow.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
end

top.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = terminalWindow.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)

top.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)

UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then updateDrag(input) end
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-10,1,-35)
scroll.Position = UDim2.new(0,5,0,30)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = terminalWindow

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,2)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local function addLog(text,color)
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,0,20)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Arcade
label.TextSize = 16
label.TextColor3 = color or Color3.fromRGB(0,255,120)
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextWrapped = true
label.Text = text
label.Parent = scroll
label.Size = UDim2.new(1,0,0,label.TextBounds.Y + 2)
scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 20)
scroll.CanvasPosition = Vector2.new(0,layout.AbsoluteContentSize.Y)
end

local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1,0,0,20)
inputContainer.BackgroundTransparency = 1
inputContainer.LayoutOrder = 999999
inputContainer.Parent = scroll

local prompt = Instance.new("TextLabel")
prompt.Size = UDim2.new(0,30,1,0)
prompt.BackgroundTransparency = 1
prompt.Font = Enum.Font.Arcade
prompt.TextSize = 16
prompt.TextColor3 = Color3.fromRGB(0,255,120)
prompt.TextXAlignment = Enum.TextXAlignment.Left
prompt.Text = "~$"
prompt.Parent = inputContainer

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1,-30,1,0)
inputBox.Position = UDim2.new(0,30,0,0)
inputBox.BackgroundTransparency = 1
inputBox.Font = Enum.Font.Arcade
inputBox.TextSize = 16
inputBox.TextColor3 = Color3.fromRGB(0,255,120)
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.Text = ""
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputContainer

local function runInstallAnim()
addLog("more about: https://luay.gt.tc/postScript",Color3.fromRGB(0,255,120))
task.wait(.2)
addLog("Use help(alias: ?) to view commands.",Color3.fromRGB(0,255,120))
end

local cachedScripts = {}

local function mobileOptimize()
if not UserInputService.TouchEnabled then return end
TweenService:Create(
terminalWindow,
TweenInfo.new(.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
{Size = UDim2.new(0,340,0,220)}
):Play()
end

local function fetchScripts()
local apiUrl = string.format("https://api.github.com/repos/%s/%s/contents/%s",repoOwner,repoName,scriptsPath)
local success,response = pcall(function() return game:HttpGet(apiUrl) end)

if success then  
    local data = HttpService:JSONDecode(response)  
    for _,item in ipairs(data) do  
        if item.type == "dir" then  
            local folderName = item.name  
            local jsonUrl = string.format("https://raw.githubusercontent.com/%s/%s/main/%s/%s/data.json",repoOwner,repoName,scriptsPath,folderName)  
            local scriptUrl = string.format("https://raw.githubusercontent.com/%s/%s/main/%s/%s/script.lua",repoOwner,repoName,scriptsPath,folderName)  

            local jSuccess,jResponse = pcall(function() return game:HttpGet(jsonUrl) end)  

            if jSuccess then  
                local scriptInfo = HttpService:JSONDecode(jResponse)  
                scriptInfo.folderName = folderName  
                scriptInfo.executeUrl = scriptUrl  
                table.insert(cachedScripts,scriptInfo)  
            end  
        end  
    end  
end  

mobileOptimize()

end

local function processCommand(cmd)
local raw = cmd:gsub("^~%$ ","")
local args = string.split(raw," ")
local main = string.lower(args[1] or "")
local id = args[2]

if main == "game" or main == "g" then  
    addLog("Game: "..gameId.." | "..gameName,Color3.fromRGB(0,255,255))  

elseif main == "load" or string.sub(main,1,1) == "$" then  
    local target = id  
    if string.sub(main,1,1) == "[" then  
        target = string.gsub(main,"%[","")  
        target = string.gsub(target,"%]","")  
    end  

    local scriptToLoad  
    for _,s in ipairs(cachedScripts) do  
        if string.lower(s.folderName) == string.lower(target or "") then  
            scriptToLoad = s  
            break  
        end  
    end  

    if scriptToLoad then  
        addLog("Executing "..scriptToLoad.name.."...",Color3.fromRGB(180,0,255))  
        pcall(function()  
            loadstring(game:HttpGet(scriptToLoad.executeUrl))()  
        end)  
    else  
        addLog("ID not found.",Color3.fromRGB(255,50,50))  
    end  

elseif main == "fav.add" or main == "add" then  
    if id then  
        local favs = getFavs()  
        table.insert(favs,{Id=id})  
        saveFavs(favs)  
        addLog("Saved "..id.." to favorites.",Color3.fromRGB(0,255,120))  
    end  

elseif main == "fav.remove" or main == "remove" then  
    if id then  
        local favs = getFavs()  
        for i,v in ipairs(favs) do  
            if tostring(v.Id) == tostring(id) then  
                table.remove(favs,i)  
                saveFavs(favs)  
                addLog("Removed "..id..".",Color3.fromRGB(255,50,50))  
                break  
            end  
        end  
    end  

elseif main == "fav.list" or main == "fl" then  
    local favs = getFavs()  
    addLog("Favorites:",Color3.fromRGB(255,255,0))  
    for _,v in ipairs(favs) do  
        addLog(" - "..tostring(v.Id),Color3.fromRGB(255,255,255))  
    end  

elseif main == "clear" or main == "c" then  
    for _,child in ipairs(scroll:GetChildren()) do  
        if child:IsA("TextLabel") then  
            child:Destroy()  
        end  
    end  

elseif main == "close" or main == "x" or main == "exit" then  
    terminalWindow.Visible = false
    spinIcon.Visible = false

elseif main == "help" or main == "?" then  
    addLog("Commands:",Color3.fromRGB(255,255,255))  
    addLog("game | g",Color3.fromRGB(255,255,255))  
    addLog("load [id] | $[id]",Color3.fromRGB(255,255,255))  
    addLog("fav.add [id] | add [id]",Color3.fromRGB(255,255,255))  
    addLog("fav.remove [id] | remove [id]",Color3.fromRGB(255,255,255))  
    addLog("fav.list | fl",Color3.fromRGB(255,255,255))  
    addLog("clear | c",Color3.fromRGB(255,255,255))  
    addLog("close | x | exit",Color3.fromRGB(255,255,255))  
    addLog("help | ?",Color3.fromRGB(255,255,255))  

else  
    addLog("Unknown command.",Color3.fromRGB(255,50,50))  
end

end

inputBox.FocusLost:Connect(function(enterPressed)
if enterPressed then
local command = inputBox.Text
if command ~= "" then
addLog("~$ "..command,Color3.fromRGB(0,255,120))
processCommand("~$ "..command)
end
inputBox.Text = ""
task.wait()
inputBox:CaptureFocus()
end
end)

minimizeBtn.MouseButton1Click:Connect(function()
terminalWindow.Visible=false
spinIcon.Visible=true
end)

spinIcon.MouseButton1Click:Connect(function()
spinIcon.Visible=false
terminalWindow.Visible=true
end)

RunService.RenderStepped:Connect(function()
if spinIcon.Visible then
spinIcon.Rotation=spinIcon.Rotation+2
end
end)

player.Chatted:Connect(function(msg)
    if msg == "$open" or msg == "$_" then
        if not terminalWindow.Visible and not spinIcon.Visible then
            local animText = Instance.new("TextLabel")
            animText.Text = ">_ luay.terminal"
            animText.Font = Enum.Font.Arcade
            animText.TextColor3 = Color3.fromRGB(0, 255, 120)
            animText.BackgroundTransparency = 1
            animText.TextSize = 10
            animText.Size = UDim2.new(1, 0, 1, 0)
            animText.Position = UDim2.new(0, 0, 0, 0)
            animText.Parent = gui

            local tweenText = TweenService:Create(animText, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextSize = 150})
            tweenText:Play()
            tweenText.Completed:Wait()

            local fadeText = TweenService:Create(animText, TweenInfo.new(0.2), {TextTransparency = 1})
            fadeText:Play()
            fadeText.Completed:Wait()
            animText:Destroy()

            local targetSize = UDim2.new(0, 500, 0, 320)
            local targetPos = UDim2.new(0.5, -250, 0.5, -160)
            
            if UserInputService.TouchEnabled then
                targetSize = UDim2.new(0, 340, 0, 220)
            end

            terminalWindow.Size = UDim2.new(0, 0, 0, 0)
            terminalWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
            terminalWindow.Visible = true

            local tweenWin = TweenService:Create(terminalWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = targetSize,
                Position = targetPos
            })
            tweenWin:Play()
        end
    end
end)

task.spawn(runInstallAnim)
task.spawn(fetchScripts)
