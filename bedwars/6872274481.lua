--reorganizing of mooon

loadstring(game:HttpGet("https://pastebin.com/raw/PRvL4Fib"))()
wait()
local KnockbackTable = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Noboline B3.5", "GrapeTheme")
local lplr = game.Players.LocalPlayer
local Combat = Window:NewTab("Combat")
local Movement = Window:NewTab("Movement")
local Other = Window:NewTab("Other")
local Bypasses = Window:NewTab("Bypasses")

local CombatSection = Combat:NewSection("Combat")
local MovementSection = Movement:NewSection("Movement")
local OtherSection = Other:NewSection("Other")
local BypassesSection = Bypasses:NewSection("Bypasses")
local static1

function chat(message)
	local args = {
		[1] = message,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
end

CombatSection:NewButton("KillAura", "KillAura", function()
	local player = game:GetService("Players")
	local lplr = player.LocalPlayer
	local cam = workspace.CurrentCamera
	local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
	local SwordCont = KnitClient.Controllers.SwordController
	local aura = false
	local DistVal = {["Value"] = 14}
	function Aura()
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Character and v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("HumanoidRootPart") then
				local mag = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				if mag <= DistVal["Value"] and v.Team ~= game.Players.LocalPlayer.Team and v.Character:FindFirstChild("Humanoid") then
					if v.Character.Humanoid.Health > 0 then
						aura = true
						SwordCont:swingSwordAtMouse()
					end
				end
			end
		end
	end
	game:GetService("RunService").Stepped:connect(function()
		Aura()
	end)
end)

CombatSection:NewToggle("Velocity","Reduces knockback taken",function(state)
	if state then
		KnockbackTable["kbDirectionStrength"] = 0
		KnockbackTable["kbUpwardStrength"] = 0
	else
		KnockbackTable["kbDirectionStrength"] = 100
		KnockbackTable["kbUpwardStrength"] = 100
	end
end)

MovementSection:NewDropdown("Speed", "DropdownInf", {"HeatSeeker", "CFrame", "Disabled"}, function(currentOption)
    if currentOption == "HeatSeeker" then
        _G.SpeedHS = true
		while _G.SpeedHS do
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 57
			wait(0.08)
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
			wait(0.7)
		end
        elseif currentOption == "CFrame" then
            Speed = 0.2 
		_G.Speed = true

		You = game.Players.LocalPlayer.Name
		UIS = game:GetService("UserInputService")

		while _G.Speed do
			if UIS:IsKeyDown(Enum.KeyCode.W) then
				game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-Speed)
			end;
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-Speed,0,0)
			end;
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,Speed)
			end;
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(Speed,0,0)
			end;
			wait()
		end
    elseif currentOption == "Disabled" then
		_G.Speed = false
        _G.SpeedHS = false
    end
end)

MovementSection:NewButton("DamageFly | Damc", "FastFly", function()
	local player = game.Players.LocalPlayer
	local character = game.Players.LocalPlayer.Character
	local storedpos
	local mouse = player:GetMouse()
	bind = "x"
	mouse.KeyDown:connect(function(key)
		if key == bind then
			storedpos = player.Character.HumanoidRootPart.CFrame
			character.HumanoidRootPart.CFrame = CFrame.new(1043500,145000,10053450)
			wait(0.7)
			player.Character.HumanoidRootPart.CFrame = storedpos
			local chr = player.Character or player.CharacterAdded:Wait()
			local hrp = chr:WaitForChild("HumanoidRootPart")
			workspace.Gravity = 10
			for i = 1,30 do wait(0.000000002)
				hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5
			end
			workspace.Gravity = 196.2
		end
	end)
end)

MovementSection:NewKeybind("Fly1 | More Reliable", "2 seconds", Enum.KeyCode.R, function()
	local e = Instance.new("Part",workspace)
	e.Size = Vector3.new(99999999,2,999999999999)
	e.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	e.CFrame = e.CFrame - Vector3.new(0,5.2,0)
	e.Anchored = true
	e.Transparency = 1
	local function PlayerTouched(Part)
		local Parent = Part.Parent
		if game.Players:GetPlayerFromCharacter(Parent) then
			wait(2)
			e:Destroy()
			workspace.Gravity = 196.2
		end
	end
	e.Touched:connect(PlayerTouched)
end)

MovementSection:NewKeybind("Fly2 | Less Reliable", "3 seconds", Enum.KeyCode.Z, function()
	local e = Instance.new("Part",workspace)
	e.Size = Vector3.new(99999999,2,999999999999)
	e.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	e.CFrame = e.CFrame - Vector3.new(0,4.6,0)
	e.Anchored = true
	e.Transparency = 1
	local function PlayerTouched(Part)
		local Parent = Part.Parent
		if game.Players:GetPlayerFromCharacter(Parent) then
			wait(2.8)
			e:Destroy()
			workspace.Gravity = 196.2
		end
	end
	local function PlayerTouched2(Part)
		local Parent = Part.Parent
		if game.Players:GetPlayerFromCharacter(Parent) then
			wait()
			e.CFrame = e.CFrame + Vector3.new(0,0.08,0)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+ Vector3.new(0,1,0)
		end
	end
	e.Touched:connect(PlayerTouched)
	e.Touched:connect(PlayerTouched2)
end)

MovementSection:NewKeybind("HighJump | Velocity", "Gravity", Enum.KeyCode.H, function()
	local Velocity = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
	Velocity.Name = "Velocity1"
	Velocity.Velocity = Vector3.new(0,500,0)
	game.Workspace.Gravity = 0
	wait(2)
	game.Workspace.Gravity = 192.6
	game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity1:Destroy()
end)

MovementSection:NewKeybind("DamageLessHighJump", "DamageHighJump", Enum.KeyCode.V, function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0)
end)

MovementSection:NewKeybind("LongJump | Gravity", "Gravity", Enum.KeyCode.J, function()
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	game.Workspace.Gravity = 10
	wait(2.2)
	game.Workspace.Gravity = 192.6
end)

MovementSection:NewToggle("AntiVoid | Velocity", "Velocity", function(state)
    if state then
        local e = Instance.new("Part",workspace)
        e.Size = Vector3.new(99999999,2,999999999999)
        e.Position = Vector3.new(0,27,0)
        e.Anchored = true
        e.BrickColor = BrickColor.new("Royal purple")
        e.Transparency = 0.5
        local function PlayerTouched(Part)
            local Parent = Part.Parent
            if game.Players:GetPlayerFromCharacter(Parent) then
                local bodyvelo = Instance.new("BodyVelocity",Parent.HumanoidRootPart)
                bodyvelo.Velocity = Vector3.new(0,500,0)
                task.wait(0.3)
                bodyvelo:Destroy()

            end
        end
        e.Touched:connect(PlayerTouched)
    else
        print("cringe")
    end
end)

MovementSection:NewToggle("AntiVoid | SmallTP", "SmallTP", function(state)
    if state then
        local e = Instance.new("Part",workspace)
        e.Size = Vector3.new(99999999,2,999999999999)
        e.Position = Vector3.new(0,27,0)
        e.Anchored = true
        e.BrickColor = BrickColor.new("Royal purple")
        e.Transparency = 0.5
        local function PlayerTouched(Part)
            local Parent = Part.Parent
            if game.Players:GetPlayerFromCharacter(Parent) then
                for i = 1,100 do wait()
                    Parent.HumanoidRootPart.CFrame = Parent.HumanoidRootPart.CFrame + Vector3.new(0,0.5,0)
                end

            end
        end
        e.Touched:connect(PlayerTouched)
    else
        print("cringe")
    end
end)

MovementSection:NewButton("NoFall", "NoFall", function()
	while true do
		wait(0.0001)
		game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
	end
end)

OtherSection:NewToggle("AutoToxic","MoonOnTop",function(state)
	if state then
		_G.AutoTalkEnabled = true
	else
		_G.AutoTalkEnabled = false
	end
	while _G.AutoTalkEnabled do
		wait(8)
		local pick = math.random(1,6)
		if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then
			chat("I was lagging! Moon On Top")
		end
		if pick == 1 then
			chat("Tired of dying? Get Moon")
		elseif pick == 2 then
			chat("Can't take a loss? get moon")
		elseif pick == 3 then
			chat("Moon on top")
		elseif pick == 4 then
			chat("Moon better then you")
		elseif pick == 5 then
			chat("ez moon on top")
		elseif pick == 6 then
			chat("Hate the game not the player :)")
		end
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Character.Humanoid.Health == 0 and v.Name ~= game.Players.LocalPlayer.Name and v.Team ~= game.Players.LocalPlayer.Team then
				chat("how do you even die in a block game "..v.Name)
			end
		end
	end
end)

OtherSection:NewKeybind("Open/Close GUI", "Open/Close GUI", Enum.KeyCode.End, function()
	Library:ToggleUI()
end)

BypassesSection:NewButton("TPAura | TEAM", "TPAura", function()
	lplr = game.Players.LocalPlayer
	local cam = workspace.CurrentCamera
	local oldchar
	local clone
	oldchar = lplr.Character
	oldchar.Archivable = true
	clone = oldchar:Clone()
	oldchar.PrimaryPart.Anchored = false
	local humc = oldchar.Humanoid:Clone()
	humc.Parent = lplr.Character
	cam.CameraSubject = clone.Humanoid 
	clone.Parent = workspace
	while true do wait(1)
		local Players = game.Players:GetPlayers() -- Gets a list of players in the server
		cam.CameraSubject = clone.Humanoid
		local nplrs = #Players -- Prepares variables for next line
		Randomplayer = Players[math.random(1, nplrs)] -- pick random player to teleport to
		if Randomplayer.Team == game.Players.LocalPlayer.Team then -- line 5 to 7 prevent it from picking you
			Randomplayer = Players[math.random(1, nplrs)]
		end
		local TargetCF = Randomplayer.Character.HumanoidRootPart.Position -- gets the random players position
		local part = Instance.new("Part",workspace) -- creates a storage to store the randomplayers postion
		part.Position = TargetCF -- sets the position
		part.Transparency = 1 -- makes the location invisible
		local character = game.Players.LocalPlayer.Character -- tells the game what the player is
		character.HumanoidRootPart.CFrame = CFrame.new(133230000,10332323000,1003232200) -- disables the anticheat for 2 seconds
		task.wait(1) -- part of disabler
		character.PrimaryPart = part -- teleport
		part.Position = TargetCF -- teleport
		character.HumanoidRootPart.CFrame = part.CFrame
		character.HumanoidRootPart.CFrame = part.CFrame
		character.PrimaryPart = character.HumanoidRootPart
		part:Destroy()
		wait(7)
	end
end)

BypassesSection:NewButton("TP Player | Damc", "TP Player", function()
	local Players = game.Players:GetPlayers() -- Gets a list of players in the server
	cam.CameraSubject = clone.Humanoid
	local nplrs = #Players -- Prepares variables for next line
	Randomplayer = Players[math.random(1, nplrs)] -- pick random player to teleport to
	if Randomplayer.Team == game.Players.LocalPlayer.Team then -- line 5 to 7 prevent it from picking you
		Randomplayer = Players[math.random(1, nplrs)]
	end
	local TargetCF = Randomplayer.Character.HumanoidRootPart.Position -- gets the random players position
	local part = Instance.new("Part",workspace) -- creates a storage to store the randomplayers postion
	part.Position = TargetCF -- sets the position
	part.Transparency = 1 -- makes the location invisible
	local character = game.Players.LocalPlayer.Character -- tells the game what the player is
	character.HumanoidRootPart.CFrame = CFrame.new(133230000,10332323000,1003232200) -- disables the anticheat for 2 seconds
	task.wait(1) -- part of disabler
	character.PrimaryPart = part -- teleport
	part.Position = TargetCF -- teleport
	character.HumanoidRootPart.CFrame = part.CFrame
	character.HumanoidRootPart.CFrame = part.CFrame
	character.PrimaryPart = character.HumanoidRootPart
	part:Destroy()
end)

BypassesSection:NewButton("ACBypasser", "ACBypasser", function()
	local lplr = game.Players.LocalPlayer
    local cam = workspace.CurrentCamera
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
            if mag >= 16 then
                oldchar:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame)
            end
        end)
    pcall(function()
        oldchar.PrimaryPart:GetPropertyChangedSignal("CFrame"):connect(function()
            clone:SetPrimaryPartCFrame(oldchar.PrimaryPart.CFrame)
        end)
    end)
    cam.CameraSubject = clone.Humanoid 
    clone.Parent = workspace
    lplr.Character = clone
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 25
    game.Workspace.Gravity = 10
end)
