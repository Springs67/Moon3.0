repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character


local MoonArray = Instance.new("ScreenGui")
local InvisFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
MoonArray.Name = "MoonArray"
MoonArray.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
MoonArray.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MoonArray.ResetOnSpawn = false
InvisFrame.Name = "InvisFrame"
InvisFrame.Parent = MoonArray
InvisFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InvisFrame.BackgroundTransparency = 1.000
InvisFrame.BorderSizePixel = 0
InvisFrame.Position = UDim2.new(0.84584707, 0, 0, 0)
InvisFrame.Size = UDim2.new(0, 232, 0, 379)
UIListLayout.Parent = InvisFrame
UIListLayout.SortOrder = Enum.SortOrder.Name

function MakeModule(name)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = InvisFrame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(0, 200, 0, 50)
	TextLabel.Font = Enum.Font.Merriweather
	TextLabel.Text = name 
	TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	TextLabel.TextSize = 25
	TextLabel.TextStrokeTransparency = 0
	TextLabel.Name = name
end
function RemoveModule(name)
	if InvisFrame:FindFirstChild(name) then
		InvisFrame:FindFirstChild(name):Remove()
	end
end

--Enabled

_G.LongjumpEnabled = false
_G.HighjumpEnabled = false
_G.FlightEnabled = false
_G.SlowFallEnabled = false

--functions and locals

local lplr = game.Players.LocalPlayer
local char = lplr.Character
local hum = char.Humanoid
local hrp = char.HumanoidRootPart
local prpart = char.PrimaryPart
local uis = game:GetService("UserInputService")
local lighting = game.Lighting

function runcode(func)
	pcall(function()
		func()
	end)
end
function Chat(msg)
	local args = { [1] = msg, [2] = "All" }
	game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
end

--vape stuff lol
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local getremote = function(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end
local repstorage = game:GetService("ReplicatedStorage")
local KnockbackTable = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local cstore = require(lplr.PlayerScripts.TS.ui.store).ClientStore
local bedwars = { -- vape
	["SprintController"] = KnitClient.Controllers.SprintController,
	["CombatConstant"] = require(repstorage.TS.combat["combat-constant"]).CombatConstant,
	["SwordController"] = KnitClient.Controllers.SwordController,
	["ClientHandler"] = Client,
	["AppController"] = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
	["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
}
function isalive(player)
	local character = player.Character
	if not character then
		-- the player does not have a character
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		-- the character does not have a humanoid object
		return false
	end
	return humanoid.Health > 0
end

local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsSwords
function hashFunc(instance) 
	return {value = instance}
end


local function GetInventory(plr)
	if not plr then
		return {inv = {}, armor = {}}
	end
	local success, result = pcall(function()
		return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(plr)
	end)
	if not success then
		return {items = {}, armor = {}}
	end
	if plr.Character and plr.Character:FindFirstChild("InventoryFolder") then
		local invFolder = plr.Character:FindFirstChild("InventoryFolder").Value
		if not invFolder then return result end

		for _, item in pairs(result) do
			for _, subItem in pairs(item) do
				if typeof(subItem) == "table" and subItem.itemType then
					subItem.instance = invFolder:FindFirstChild(subItem.itemType)
				end
			end

			if typeof(item) == "table" and item.itemType then
				item.instance = invFolder:FindFirstChild(item.itemType)
			end
		end
	end
	return result
end

-- omg 1 1 1 11!!
local function getSword()
	-- Initialize the highest power value and the returning item to nil.
	local highestPower = -9e9
	local returningItem = nil
	-- Get the inventory of the local player.
	local inventory = GetInventory(lplr)
	-- Loop through the items in the inventory.
	for _, item in pairs(inventory.items) do
		-- Check if the item is a sword.
		local power = table.find(BedwarsSwords, item.itemType)
		if not power then
			-- Skip the item if it is not a sword.
			continue
		end
		-- Check if the power of the current sword is higher than the current highest power.
		if power > highestPower then
			-- Set the returning item to the current sword and update the highest power value.
			returningItem = item
			highestPower = power
		end
	end
	-- Return the item with the highest power.
	return returningItem
end

local function getNearestPlayer(maxDist)
	-- define the position or object that you want to use as the reference point
	local referencePoint = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	-- get the list of players currently connected to the game
	local players = game:GetService("Players"):GetPlayers()
	-- initialize variables to store the nearest player and their distance
	local nearestPlayer = nil
	local nearestDistance = maxDist
	-- loop through all the players and find the nearest one
	for _, player in pairs(players) do
		if player ~= game.Players.LocalPlayer then
			-- calculate the distance between the reference point and the player
			local distance = (referencePoint - player.Character.PrimaryPart.Position).magnitude
			-- check if this player is closer than the current nearest player
			if distance < nearestDistance then
				-- update the nearest player and distance
				nearestPlayer = player
				nearestDistance = distance
			end
		end
	end
	if nearestPlayer then
		return nearestPlayer
	end
end


--rest of script ig

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Moon 3.0", "DarkTheme")

local Combat = Window:NewTab("Combat")
local Movement = Window:NewTab("Movement")
local Render = Window:NewTab("Render")
local Misc = Window:NewTab("Misc")
local Exploits = Window:NewTab("Exploits")

local CombatSection = Combat:NewSection("KillAura")
local MovementSection = Movement:NewSection("Movement")
local RenderSection = Render:NewSection("Render")
local MiscSection = Misc:NewSection("Misc")
local ExploitsSection = Exploits:NewSection("Exploits")

runcode(function()
	local Distance = {["Value"] = 18}
	local AuraEnabled = false
	CombatSection:NewToggle("KillAura", "attacks players around you.", function(enabled)
		if enabled then
			MakeModule("Aura")
			AuraEnabled = true
			local anims = {
				Normal = {
					{CFrame = CFrame.new(1, -1, 2) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.2},
					{CFrame = CFrame.new(-1, 1, -2.2) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.2}
				},
			}
			local origC0 = cam.Viewmodel.RightHand.RightWrist.C0
			local ui2 = Instance.new("ScreenGui")
			local nearestID = nil
			ui2.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			repeat
				if isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 then
					for _,v in pairs(game.Players:GetPlayers()) do
						if v ~= lplr then
							nearestID = v
							target = v.Name
							if v.Team ~= lplr.Team and v ~= lplr and isalive(v) and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude < 20 then
								local sword = getSword()
								if sword ~= nil then
									function swing()
										spawn(function()
											pcall(function()
												for i,v in pairs(anims.Normal) do 
													anim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(v.Time), {C0 = origC0 * v.CFrame})
													anim:Play()
													task.wait(v.Time)
												end
											end)
										end)
									end
									coroutine.wrap(swing)()

									Client:Get(bedwars["SwordRemote"]):SendToServer({
										["weapon"] = sword.tool,
										["entityInstance"] = v.Character,																																																																																							
										["validate"] = {
											["raycast"] = {
												["cameraPosition"] = hashFunc(cam.CFrame.Position),
												["cursorDirection"] = hashFunc(Ray.new(cam.CFrame.Position, v.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction)
											},
											["targetPosition"] = hashFunc(v.Character:FindFirstChild("HumanoidRootPart").Position),
											["selfPosition"] = hashFunc(lplr.Character:FindFirstChild("HumanoidRootPart").Position + ((lplr.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 14 and (CFrame.lookAt(lplr.Character:FindFirstChild("HumanoidRootPart").Position, v.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0)))
										},
										["chargedAttack"] = {["chargeRatio"] = 1}
									})
								end
							end
						end
					end
				end
				task.wait(0.22);	
				bedwars["SwordController"].lastAttack = game:GetService("Workspace"):GetServerTimeNow() - 0.11
				local function redo()
					if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
						pcall(function()
							anim:Cancel()
						end)
						anim2 = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.364), {C0 = origC0})
						anim2:Play()
					end
				end
				coroutine.wrap(redo)()
			until not AuraEnabled
		else
			AuraEnabled = false
			RemoveModule("Aura")
		end
	end)
end)

runcode(function()
	CombatSection:NewToggle("Velocity", "Allows you to not take knockback", function(enabled)
		if enabled then
			MakeModule("Velocity")
			KnockbackTable["kbDirectionStrength"] = 0
			KnockbackTable["kbUpwardStrength"] = 0
		else
			KnockbackTable["kbDirectionStrength"] = 100
			KnockbackTable["kbUpwardStrength"] = 100
			RemoveModule("Velocity")
		end
	end)
end)

runcode(function()
	local isSprinting = false
	CombatSection:NewToggle("AutoSprint", "auto sprints for u", function(enabled)
		if enabled then
			MakeModule("AutoSprint")
			isSprinting = true
			repeat wait()
				if (not bedwars["SprintController"].sprinting) then
					bedwars["SprintController"]:startSprinting()
				end
			until not isSprinting
		else
			isSprinting = false
			RemoveModule("AutoSprint")
		end
	end)
end)

runcode(function()
	local SpeedRepeat = false
	local You = lplr.Name
	local speed1 = 0.06
	MovementSection:NewToggle("Speed - Mode 1", "cframe mode 1!1!1", function(enabled)
		if enabled then
			MakeModule("Speed")
			SpeedRepeat = true
			repeat wait()
				if uis:IsKeyDown(Enum.KeyCode.W) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-speed1)
				end;
				if uis:IsKeyDown(Enum.KeyCode.A) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-speed1,0,0)
				end;
				if uis:IsKeyDown(Enum.KeyCode.S) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,speed1)
				end;
				if uis:IsKeyDown(Enum.KeyCode.D) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(speed1,0,0)
				end;
			until not SpeedRepeat
		else
			SpeedRepeat = false
			RemoveModule("Speed")
		end
	end)
	MovementSection:NewTextBox("SpeedAmount1", "recommended 0.06", function(speed2)
		speed1 = speed2
	end)
end)

runcode(function()
	local function LongjumpToggleKey()
		pcall(function()
			repeat task.wait(0.49)
				if _G.LongjumpEnabled == true then
					hum:ChangeState(3)
				end
			until false
		end)
	end
	coroutine.wrap(LongjumpToggleKey)()
	MovementSection:NewKeybind("Longjump - Bind", "very long jump fr", Enum.KeyCode.J, function()
		_G.LongjumpEnabled = not _G.LongjumpEnabled
		if _G.LongjumpEnabled == true then
			MakeModule("Longjump")
		else
			RemoveModule("Longjump")
		end
	end)	
end)

runcode(function()
	local function HighjumpToggleKey()
		repeat task.wait()
			pcall(function()
				if _G.HighjumpEnabled == true then
					hrp.CFrame = hrp.CFrame * CFrame.new(0, 30, 0)
				end
			end)
		until false
	end
	coroutine.wrap(HighjumpToggleKey)()
	MovementSection:NewKeybind("Highjump - Bind", "very high jump fr", Enum.KeyCode.H, function()
		_G.HighjumpEnabled = not _G.HighjumpEnabled
		if _G.HighjumpEnabled == true then
			MakeModule("Highjump")
		else
			RemoveModule("Highjump")
		end
	end)	
end)

runcode(function()
	local function FlightToggleKey()
		repeat task.wait()
			pcall(function()
				if _G.FlightEnabled == true then
					game.Workspace.Gravity = 0
					if uis:IsKeyDown(Enum.KeyCode.Space) then
						prpart.CFrame += Vector3.new(0, 0.7, 0)
					end
					if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
						prpart.CFrame += Vector3.new(0, -0.7, 0)
					end
				else
					game.Workspace.Gravity = 196.2
				end
			end)
		until false
	end
	coroutine.wrap(FlightToggleKey)()
	MovementSection:NewKeybind("Flight - Bind", "coolio", Enum.KeyCode.R, function()
		_G.FlightEnabled = not _G.FlightEnabled
		if _G.FlightEnabled == true then
			prpart.Velocity = Vector3.new(0,0,0)
		end
		if _G.FlightEnabled == true then
			MakeModule("Flight")
		else
			RemoveModule("Flight")
		end
	end)	
end)

runcode(function()
	local nofallenabled = false
	MovementSection:NewToggle("NoFall", "allows for no fall damage", function(enabled)
		if enabled then
			MakeModule("NoFall")
			nofallenabled = true
			repeat
				game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
				task.wait(0.25)
			until not nofallenabled
		else
			nofallenabled = false
			RemoveModule("NoFall")
		end
	end)	
end)

runcode(function()
	MovementSection:NewToggle("SlowFall", "makes u slow faller lol", function(state)
		if state then
			MakeModule("SlowFall")
			_G.SlowFallEnabled = true
			repeat
				if _G.SlowFallEnabled == true then
					if hum.FloorMaterial == Enum.Material.Air then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,2,lplr.Character.PrimaryPart.Velocity.Z)
					end
				end
				task.wait(0.4)
			until false
		else
			_G.SlowFallEnabled = false
			RemoveModule("SlowFall")
		end
	end)
end)

--[[
runcode(function()
    local FunnyFlyTog = false
    MovementSection:NewToggle("FunnyFly", "not longer fly, made 4 fun xD. Also if u wanna use this, get rid of the code that hides this XD", function(state)
        if state then
            FunnyFlyTog = true
            game.Workspace.Gravity = 4
            repeat
                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                task.wait()
                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
                task.wait()
            until not FunnyFlyTog
        else
            game.Workspace.Gravity = 196.2
            FunnyFlyTog = false
        end
    end)
end)
--]]

runcode(function()
	local MoonLogo
	RenderSection:NewToggle("Logo", "", function(state)
		if state then
			MakeModule("Logo")
			MoonLogo = Instance.new("ScreenGui")
			local Frame = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			MoonLogo.Name = "MoonLogo"
			MoonLogo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			MoonLogo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			MoonLogo.ResetOnSpawn = false
			Frame.Parent = MoonLogo
			Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BackgroundTransparency = 0.500
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.007, 0, 0.012, 0)
			Frame.Size = UDim2.new(0, 261, 0, 44)
			TextLabel.Parent = Frame
			TextLabel.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.11, 0, 0.1, 0)
			TextLabel.Size = UDim2.new(0, 200, 0, 33)
			TextLabel.Font = Enum.Font.SourceSans
			TextLabel.Text = "Moon - 3.0 - Public Beta"
			TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextSize = 30.000
			TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextStrokeTransparency = 0.200
		else
			MoonLogo:Remove()
			RemoveModule("Logo")
		end
	end)
end)

runcode(function()
	RenderSection:NewToggle("FemboyAmbient", "'My favorite module', -Spring67#2760", function(state)
		if state then
			MakeModule("FemboyAmbient")
			lighting.Ambient = Color3.fromRGB(255, 85, 255)
			lighting.OutdoorAmbient = Color3.fromRGB(255, 85, 255)
			lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
			lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
			lighting.EnvironmentDiffuseScale = 0
		else
			lighting.Ambient = Color3.fromRGB(91, 91, 91)
			lighting.OutdoorAmbient = Color3.fromRGB(201, 201, 201)
			lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
			lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
			lighting.EnvironmentDiffuseScale = 1
			RemoveModule("FemboyAmbient")
		end
	end)
end)

runcode(function()
	RenderSection:NewButton("Chams", "lets u see plrs through walls", function()
		MakeModule("Chams")
		local players = game.Players:GetPlayers()
		for i,v in pairs(players) do
			local esp = Instance.new("Highlight")
			esp.Name = v.Name
			esp.FillTransparency = 0.5
			esp.FillColor = Color3.new(0.462745, 0, 0.462745)
			esp.OutlineColor = Color3.new(0.462745, 0, 0.462745)
			esp.OutlineTransparency = 0
			esp.Parent = v.Character
		end
		game.Players.PlayerAdded:Connect(function(plr)
			plr.CharacterAdded:Connect(function(chr)
				local esp = Instance.new("Highlight")
				esp.Name = plr.Name
				esp.FillTransparency = 0.5
				esp.FillColor = Color3.new(0.462745, 0, 0.462745)
				esp.OutlineColor = Color3.new(0.462745, 0, 0.462745)
				esp.OutlineTransparency = 0
				esp.Parent = chr
			end)
		end)
	end)
end)

runcode(function()
	RenderSection:NewButton("ESP", "dead", function()
		MakeModule("ESP")
		local body
		local gui = Instance.new("BillboardGui");
		gui.Name = "names";
		gui.AlwaysOnTop = true;
		gui.LightInfluence = 0;
		gui.Size = UDim2.new(1.75, 0, 1.75, 0);
		local frame = Instance.new("Frame", gui);
		frame.BackgroundColor3 = Color3.fromRGB(170, 0, 0);
		frame.Size = UDim2.new(1.7, 0, 3.89, 0);
		frame.BorderSizePixel = 4;
		frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
		local gi = gui:Clone();
		body = frame:Clone();
		body.Parent = gi;
		body.BackgroundColor3 = Color3.fromRGB(0, 170, 170);
		for _, v in pairs(game:GetService("Players"):GetPlayers()) do
			if v.Name ~= lplr.Name and v.Character and v.Character:FindFirstChild("Head") then
				gui:Clone().Parent = v.Character.Head;
			end
		end
	end)
end)

runcode(function()
	RenderSection:NewKeybind("ToggleUi", "toggles ui lol", Enum.KeyCode.RightShift, function()
		Library:ToggleUI()
	end)
end)

--[[
runcode(function()
	local TeleportAmount1 = 15
	local AcBypassEnabled = false
	local AnticheatBypassSection = Player:NewSection("AnticheatBypass")
	AnticheatBypassSection:NewToggle("AnticheatBypass", "allows you to bypass the anticheat speed check", function(enabled)
		if enabled then
			local oldchar
			local clone
			oldchar = lplr.Character
			oldchar.Archivable = true
			clone = oldchar:Clone()
			oldchar.PrimaryPart.Anchored = false
			local humc = oldchar.Humanoid:Clone()
			humc.Parent = lplr.Character
			game:GetService("RunService").Stepped:connect(function()
				local mag = (clone.PrimaryPart.Position - oldchar.PrimaryPart.Position).Magnitude
				if mag >= 18 then
					oldchar:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame)
				end
			end)
			cam.CameraSubject = clone.Humanoid 
			clone.Parent = workspace
			lplr.Character = clone
			for _,v in pairs(lplr.Character:GetChildren()) do
				v.Transparency = 0.5
			end
		else
			lplr.Character.Humanoid.Health = 0
		end
	end)
	AnticheatBypass:NewTextBox("TeleportAmount", "recommended 14", function(TeleportAmount2)
		TeleportAmount1 = TeleportAmount2
	end)
end)
--]]
