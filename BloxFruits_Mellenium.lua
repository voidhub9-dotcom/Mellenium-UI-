task.spawn(function()
	pcall(function()
		local source = game:HttpGet("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/attack-module.lua")
		local loader = loadstring(source)
		if loader then loader() end
	end)
end)
if not game:IsLoaded() then pcall(function() game.Loaded:Wait() end) end
local Y = game.Players;
local d = Y.LocalPlayer;
local initialCharacter = d.Character or d.CharacterAdded:Wait();
local R = initialCharacter:WaitForChild("HumanoidRootPart", 15);
local Q = game:GetService("ReplicatedStorage");
local PlayerData = d:WaitForChild("Data", 20);
local LevelValue = PlayerData and PlayerData:FindFirstChild("Level");
local r = LevelValue and LevelValue.Value or 0;
local a = game:GetService("TeleportService");
local w = game:GetService("TweenService");
local F = game:GetService("Lighting");
local M = workspace:FindFirstChild("Enemies") or workspace:WaitForChild("Enemies", 20);
local K = game:GetService("VirtualInputManager");
local n = game:GetService("VirtualUser");
local I = d.Team;
local W = game:GetService("RunService");
local N = game:GetService("Stats");
local EnergyValue = initialCharacter:FindFirstChild("Energy") or initialCharacter:WaitForChild("Energy", 10);
local D = EnergyValue and EnergyValue.Value or 0;
local A = game:GetService("Players");
local u = A.LocalPlayer:WaitForChild("PlayerGui");
local g = A.LocalPlayer;
local z = g:WaitForChild("Backpack");
local i = g.Character or g.CharacterAdded:Wait();
local U = {};
local C = {};
local v = {};
local m = {};
local y = false;
local b = false;
local c = true;
local H = false;
local S = false;
local o = false;
local Z = false;
-- Keep legacy feature pollers responsive without waking hundreds of
-- coroutines every frame on mobile clients.
local T = .2;
local L = 0;
local P = 25;
-- Compatibility aliases for new system
plr = d
replicated = Q
Root = R
C = R
Lv = r
TeleportService = a
TW = w
Lighting = F
Enemies = M
vim1 = K
vim2 = n
TeamSelf = I
RunSer = W
Stats = N
Energy = D
shouldTween = false
d.CharacterAdded:Connect(function(character)
    local root = character:WaitForChild("HumanoidRootPart", 10)
    if root and d.Character == character then
        i, R, Root, C, HRP = character, root, root, root, root
    end
end)
if LevelValue then
	LevelValue:GetPropertyChangedSignal("Value"):Connect(function()
		r, Lv = LevelValue.Value, LevelValue.Value
	end)
end


if not game:IsLoaded() then
	pcall(function() game.Loaded:Wait() end);
end;
World1, World2, World3 = false, false, false;
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
	World1 = true;
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
	World2 = true;
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
	World3 = true;
end;
Marines = function()
		Q.Remotes.CommF_:InvokeServer("SetTeam", "Marines");
	end;

-- SUBMERGED ISLAND AUTO-TELEPORT (3rd Sea)

function HandleSubmergedIslandTeleport(playerLevel, questPos, hrp)
	if not hrp then return false end
	
	-- Check if player is at Submerged Island level range
	if playerLevel >= 2600 then
		local distance = (questPos.Position - hrp.Position).Magnitude
		
		if distance > 10000 then
			local tikiNPC = CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.99739098, 1.47309942e-09, -0.07218909, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.07218908, 5.75363091e-10, 0.99739092)
			_tp(tikiNPC)
			task.wait(2)
			
			-- Trigger submarine worker to travel to Submerged Island
			local args = {"TravelToSubmergedIsland"}
			pcall(function()
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
			end)
			
			print("[OK] Traveling to Submerged Island...")
			return true
		end
	end
	
	return false
end

function VoidEnterSubmergedIsland()
	local player = game.Players.LocalPlayer
	local character = player and player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return false, "waiting for character" end
	local tiki = CFrame.new(-16269.7041, 25.2288494, 1373.65955)
	local submerged = Vector3.new(10533, -2030, 9940)
	if (root.Position - submerged).Magnitude <= 2500 then
		return true, "At Submerged Island"
	end
	if _G.VoidSubmergedEntryRequested and os.clock() - _G.VoidSubmergedEntryRequested < 5 then
		return false, "Waiting for Submerged Island entry"
	end
	local distance = (root.Position - tiki.Position).Magnitude
	if distance > 120 then
		_tp(tiki, 100)
		return false, "Tweening to Tiki Outpost"
	end
	local net = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
	local remotes = net and net:FindFirstChild("Net")
	local worker = remotes and remotes:FindFirstChild("RF/SubmarineWorkerSpeak")
	if not worker then return false, "Submarine Worker unavailable" end
	local ok, result = pcall(function() return worker:InvokeServer("TravelToSubmergedIsland") end)
	if not ok then return false, "Submerged Island request failed" end
	_G.VoidSubmergedEntryRequested = os.clock()
	return false, "Requesting entry to Submerged Island"
end


Pirates = function()
		Q.Remotes.CommF_:InvokeServer("SetTeam", "Pirates");
	end;
-- BACKGROUND VIDEO (VonLib API)
-- Video decoding is expensive on touch/mobile clients, so keep it for
-- desktop sessions and leave the farm/UI responsive on phones and tablets.
local UserInputService = game:GetService("UserInputService")
local mobileClient = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if _Window and not mobileClient then
	task.spawn(function()
		task.wait(1)
		_Window:SetBackgroundVideo("https://files.catbox.moe/5f9loy.webm", 0.5)
		print("[OK] Background video loaded on UI")
	end)
end

-- TEXT GRADIENT SUPPORT
function CreateGradientLabel(parent, text, colors, rotation)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 30)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextSize = 13
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Parent = parent
	
	local gradient = Instance.new("UIGradient")
	gradient.Parent = label
	
	if colors and #colors >= 2 then
		local colorSequence = {}
		for i, color in ipairs(colors) do
			table.insert(colorSequence, ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color))
		end
		gradient.Color = ColorSequence.new(colorSequence)
	else
		gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
		}
	end
	
	gradient.Rotation = rotation or 0
	return label
end

function UpdateGradientLabel(label, newText, newColors, newRotation)
	if label and label:IsA("TextLabel") then
		if newText then label.Text = newText end
		
		local gradient = label:FindFirstChildOfClass("UIGradient")
		if gradient then gradient:Destroy() end
		
		gradient = Instance.new("UIGradient")
		gradient.Parent = label
		
		if newColors and #newColors >= 2 then
			local colorSequence = {}
			for i, color in ipairs(newColors) do
				table.insert(colorSequence, ColorSequenceKeypoint.new((i - 1) / (#newColors - 1), color))
			end
			gradient.Color = ColorSequence.new(colorSequence)
		end
		
		if newRotation then gradient.Rotation = newRotation end
	end
end

-- IMPROVED MOB HEIGHT & BRING SYSTEM
_G.MobHeight = _G.MobHeight or 20
_B = false
PosMon = nil
_G.BringRange = _G.BringRange or 235
_G.MaxBringMobs = _G.MaxBringMobs or 18

local BRING_TWEEN_SPEED = 180
local lastSimulationRadiusAt = 0
local function TweenInfoBringFor(dist)
	return TweenInfo.new(math.max(0.05, dist / BRING_TWEEN_SPEED), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
end
local function zeroVelocity(part)
	if not part then return end
	pcall(function()
		part.AssemblyLinearVelocity = Vector3.zero
		part.AssemblyAngularVelocity = Vector3.zero
	end)
end

-- restores it once travel finishes. Cache the state so heartbeat/tween
-- callers do not rescan every character descendant on every update.
local noclipStates = setmetatable({}, {__mode = "k"})
local function setCharacterNoclip(char, on)
	if not char then return end
	local state = noclipStates[char]
	if not state then
		state = {Enabled = nil, Connection = nil}
		noclipStates[char] = state
	end
	if state.Enabled == on and char.Parent then return end
	state.Enabled = on
	if state.Connection then
		pcall(function() state.Connection:Disconnect() end)
		state.Connection = nil
	end
	pcall(function()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = not on end
		end
	end)
	if on then
		state.Connection = char.DescendantAdded:Connect(function(part)
			if state.Enabled and part:IsA("BasePart") then
				part.CanCollide = false
			end
		end)
	end
end

local function IsRaidMob(mob)
	local n = mob.Name:lower()
	if n:find("raid") or n:find("microchip") or n:find("island") then return true end
	if mob:GetAttribute("IsRaid") or mob:GetAttribute("RaidMob") or mob:GetAttribute("IsBoss") then return true end
	local hum = mob:FindFirstChild("Humanoid")
	if hum and hum.WalkSpeed == 0 then return true end
	if mob.Parent and tostring(mob.Parent):lower():find("_worldorigin") then return true end
	return false
end

BringEnemy = function()
	if not _B then return end
	local char = plr.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	pcall(function() sethiddenproperty(plr, "SimulationRadius", math.huge) end)
	
	local targetPos = PosMon or hrp.Position
	local enemies = workspace.Enemies:GetChildren()
	local count = 0
	
	for _, mob in ipairs(enemies) do
		if count >= _G.MaxBringMobs then break end
		local hum = mob:FindFirstChild("Humanoid")
		local root = mob:FindFirstChild("HumanoidRootPart")
		
		if hum and root and hum.Health > 0 and not IsRaidMob(mob) then
			local dist = (root.Position - targetPos).Magnitude
			if dist <= _G.BringRange and not root:GetAttribute("Tweening") then
				count = count + 1
				root:SetAttribute("Tweening", true)
				local tween = w:Create(root, TweenInfoBringFor(dist), { CFrame = CFrame.new(targetPos) })
				tween:Play()
				tween.Completed:Once(function()
					if root then
						zeroVelocity(root)
						root:SetAttribute("Tweening", false)
					end
				end)
			end
		end
	end
end

(function()
if World1 then
	U = {
			"The Gorilla King",
			"Bobby",
			"The Saw",
			"Yeti",
			"Mob Leader",
			"Vice Admiral",
			"Saber Expert",
			"Warden",
			"Chief Warden",
			"Swan",
			"Magma Admiral",
			"Fishman Lord",
			"Wysper",
			"Thunder God",
			"Cyborg",
			"Ice Admiral",
			"Greybeard",
		};
elseif World2 then
	U = {
			"Diamond",
			"Jeremy",
			"Fajita",
			"Don Swan",
			"Smoke Admiral",
			"Awakened Ice Admiral",
			"Tide Keeper",
			"Darkbeard",
			"Cursed Captain",
			"Order",
		};
elseif World3 then
	U = {
			"Stone",
			"Hydra Leader",
			"Kilo Admiral",
			"Captain Elephant",
			"Beautiful Pirate",
			"Cake Queen",
			"Longma",
			"Soul Reaper",
		};
end;
end)();
(function()
if World1 then
	v = {
			"Leather + Scrap Metal",
			"Angel Wings",
			"Magma Ore",
			"Fish Tail",
		};
elseif World2 then
	v = {
			"Leather + Scrap Metal",
			"Radioactive Material",
			"Ectoplasm",
			"Mystic Droplet",
			"Magma Ore",
			"Vampire Fang",
		};
elseif World3 then
	v = {
			"Scrap Metal",
			"Demonic Wisp",
			"Conjured Cocoa",
			"Dragon Scale",
			"Gunpowder",
			"Fish Tail",
			"Mini Tusk",
		};
end;
end)();
local j = {
		"Flame",
		"Ice",
		"Quake",
		"Light",
		"Dark",
		"String",
		"Rumble",
		"Magma",
		"Human: Buddha",
		"Sand",
		"Bird: Phoenix",
		"Dough",
	};
local G = {
		"Snow Lurker",
		"Arctic Warrior",
		"Hidden Key",
		"Awakened Ice Admiral",
	};
local q = {
		Mob = "Mythological Pirate",
		Mob2 = "Cursed Skeleton",
		"Hell\'s Messenger",
		Mob3 = "Cursed Skeleton",
		"Heaven\'s Guardian",
	};
local t = {
		"Part",
		"SpawnLocation",
		"Terrain",
		"WedgePart",
		"MeshPart",
	};
local X = { "Swan Pirate", "Jeremy" };
local h = { "Forest Pirate", "Captain Elephant" };
local B = { "Fajita", "Jeremy", "Diamond" };
local l = {
		"Beast Hunter",
		"Lantern",
		"Guardian",
		"Grand Brigade",
		"Dinghy",
		"Sloop",
		"The Sentinel",
	};
local p = { "Cookie Crafter" };
local E = { "Reborn Skeleton" };
local e = {
		["Pirate Millionaire"] = CFrame.new(-712.82727050, 98.57704925, 5711.95410156),
		["Pistol Billionaire"] = CFrame.new(-723.43316650, 147.42906188, 5931.99316406),
		["Dragon Crew Warrior"] = CFrame.new(7021.50439453, 55.76270294, -730.12908935),
		["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),
		["Female Islander"] = CFrame.new(4692.79394531, 797.97668457, 858.84802246),
		["Venomous Assailant"] = CFrame.new(4902, 670, 39),
		["Marine Commodore"] = CFrame.new(2401, 123, -7589),
		["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),
		["Fishman Raider"] = CFrame.new(-10941, 332, -8760),
		["Fishman Captain"] = CFrame.new(-11035, 332, -9087),
		["Forest Pirate"] = CFrame.new(-13446, 413, -7760),
		["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),
		["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),
		["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),
		["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),
		["Living Zombie"] = CFrame.new(-10227, 421, 6161),
		["Demonic Soul"] = CFrame.new(-9579, 6, 6194),
		["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),
		["Peanut Scout"] = CFrame.new(-1993, 187, -10103),
		["Peanut President"] = CFrame.new(-2215, 159, -10474),
		["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),
		["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),
		["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),
		["Cake Guard"] = CFrame.new(-2024, 38, -12026),
		["Baking Staff"] = CFrame.new(-1932, 38, -12848),
		["Head Baker"] = CFrame.new(-1932, 38, -12848),
		["Cocoa Warrior"] = CFrame.new(95, 73, -12309),
		["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),
		["Sweet Thief"] = CFrame.new(116, 36, -12478),
		["Candy Rebel"] = CFrame.new(47, 61, -12889),
		Ghost = CFrame.new(5251, 5, 1111),
	};
EquipWeapon = function(Y)
		if not Y then
			return;
		end;
		if d.Backpack:FindFirstChild(Y) then
			d.Character.Humanoid:EquipTool(d.Backpack:FindFirstChild(Y));
		end;
	end;
weaponSc = function(Y)
		for d, R in pairs(d.Backpack:GetChildren()) do
			if R:IsA("Tool") then
				if R.ToolTip == Y then
					EquipWeapon(R.Name);
				end;
			end;
		end;
	end;
local O = workspace:FindFirstChild("Rocks");
if O then
	O:Destroy();
end;
gay = (function()
		local Y = game:GetService("Lighting");
		local d = Y:FindFirstChild("LightingLayers");
		if d and (game:GetService("Lighting") and game:GetService("Lighting")) then
			local Y = d:FindFirstChild("DarkFog");
			if Y then
				Y:Destroy();
			end;
		end;
		local R = workspace:FindFirstChild("_WorldOrigin");
		R = R and R:FindFirstChild("Foam;");
		if R then
			R:Destroy();
		end;
	end)();
local f = {};
f.__index = f;
f.Alive = function(Y)
		if not Y then
			return;
		end;
		local d = Y:FindFirstChild("Humanoid");
		return d and d.Health > 0;
	end;
f.Pos = function(Y, d)
		return (R.Position - Y.Position).Magnitude <= d;
	end;
f.Dist = function(Y, d)
		return (R.Position - (Y:FindFirstChild("HumanoidRootPart")).Position).Magnitude <= d;
	end;
f.DistH = function(Y, d)
		return (R.Position - (Y:FindFirstChild("HumanoidRootPart")).Position).Magnitude > d;
	end;
f.LastActivate = 0;
f.Activate = function()
	local now = os.clock()
	if now - f.LastActivate < .16 then return false end
	local character = d.Character
	local tool = character and character:FindFirstChildOfClass("Tool")
	if not tool and _G.SelectWeapon then
		pcall(function() EquipWeapon(_G.SelectWeapon) end)
		tool = character and character:FindFirstChildOfClass("Tool")
	end
	if not tool then return false end
	f.LastActivate = now
	return pcall(function() tool:Activate() end)
end;
local function VoidCombatTween(target, isFruit)
	local root = target and target:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	local height = isFruit and 12 or (tonumber(_G.MobHeight) or 30)
	local destination = (root.CFrame * CFrame.new(0, height, 0)) * CFrame.Angles(0, math.rad(isFruit and 90 or 180), 0)
	local ok = _tp(destination, math.clamp(tonumber(getgenv().FarmTweenTolerance) or 12, 10, 80))
	return ok ~= false
end;
f.Kill = function(Y, d)
		if Y and d then
			if not Y:GetAttribute("Locked") then
				Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame);
			end;
			PosMon = (Y:GetAttribute("Locked")).Position;
			BringEnemy();
			EquipWeapon(_G.SelectWeapon);
			local d = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool");
			local R = d and d.ToolTip or "";
			VoidCombatTween(Y, R == "Blox Fruit");
			if RandomCFrame then
				task.wait(.5);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				task.wait(.5);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0));
				task.wait(.5);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
				task.wait(.5);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				task.wait(.5);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
			end;
			f.Activate();
		end;
	end;
f.Kill2 = function(Y, d)
		if Y and d then
			if not Y:GetAttribute("Locked") then
				Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame);
			end;
			PosMon = (Y:GetAttribute("Locked")).Position;
			BringEnemy();
			EquipWeapon(_G.SelectWeapon);
			local d = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool");
			local R = d and d.ToolTip or "";
			if R == "Blox Fruit" then
				_tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0));
			else
				_tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 8)) * CFrame.Angles(0, math.rad(180), 0));
			end;
			if RandomCFrame then
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
			end;
		end;
	end;
f.KillSea = function(Y, d)
		if Y and d then
			if not Y:GetAttribute("Locked") then
				Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame);
			end;
			PosMon = (Y:GetAttribute("Locked")).Position;
			BringEnemy();
			EquipWeapon(_G.SelectWeapon);
			local d = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool");
			local R = d and d.ToolTip or "";
			if R == "Blox Fruit" then
				_tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0));
			else
				notween(Y.HumanoidRootPart.CFrame * CFrame.new(0, 50, 8));
				task.wait(.85);
				notween(Y.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0));
				task.wait(1);
			end;
		end;
	end;
f.Sword = function(Y, d)
		if Y and d then
			if not Y:GetAttribute("Locked") then
				Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame);
			end;
			PosMon = (Y:GetAttribute("Locked")).Position;
			BringEnemy();
			weaponSc("Sword");
			_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0));
			if RandomCFrame then
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				task.wait(.1);
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
			end;
		end;
	end;
f.Mas = function(Y, d)
		if Y and d then
			if not Y:GetAttribute("Locked") then
				Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame);
			end;
			PosMon = (Y:GetAttribute("Locked")).Position;
			BringEnemy();
			if Y.Humanoid.Health <= HealthM then
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0));
				Useskills("Blox Fruit", "Z");
				Useskills("Blox Fruit", "X");
				Useskills("Blox Fruit", "C");
			else
				weaponSc("Melee");
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0));
			end;
		end;
	end;
f.Masgun = function(Y, d)
		if Y and d then
			if not Y:GetAttribute("Locked") then
				Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame);
			end;
			PosMon = (Y:GetAttribute("Locked")).Position;
			BringEnemy();
			if Y.Humanoid.Health <= HealthM then
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8));
				Useskills("Gun", "Z");
				Useskills("Gun", "X");
			else
				weaponSc("Melee");
				_tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0));
			end;
		end;
	end;
statsSetings = function(Y, R)
		if Y == "Melee" then
			if d.Data.Points.Value ~= 0 then
				Q.Remotes.CommF_:InvokeServer("AddPoint", "Melee", R);
			end;
		elseif Y == "Defense" then
			if d.Data.Points.Value ~= 0 then
				Q.Remotes.CommF_:InvokeServer("AddPoint", "Defense", R);
			end;
		elseif Y == "Sword" then
			if d.Data.Points.Value ~= 0 then
				Q.Remotes.CommF_:InvokeServer("AddPoint", "Sword", R);
			end;
		elseif Y == "Gun" then
			if d.Data.Points.Value ~= 0 then
				Q.Remotes.CommF_:InvokeServer("AddPoint", "Gun", R);
			end;
		elseif Y == "Devil" then
			if d.Data.Points.Value ~= 0 then
				Q.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", R);
			end;
		end;
	end;
BringEnemy = function()
		if not _B then
			return;
		end;
		local moved = 0;
		local enemies = workspace:FindFirstChild("Enemies");
		for Y, R in pairs(enemies and enemies:GetChildren() or {}) do
			local primary = R.PrimaryPart or R:FindFirstChild("HumanoidRootPart");
			if primary and R:FindFirstChild("Humanoid") and R.Humanoid.Health > 0 then
				if moved < 18 and typeof(PosMon) == "Vector3" and (primary.Position - PosMon).Magnitude <= 350 then
					primary.CFrame = CFrame.new(PosMon + Vector3.new((moved % 3) * 1.5, 0, math.floor(moved / 3) * 1.5));
					primary.CanCollide = false;
					(R:FindFirstChild("Humanoid")).WalkSpeed = 0;
					(R:FindFirstChild("Humanoid")).JumpPower = 0;
					moved = moved + 1;
					if sethiddenproperty then pcall(sethiddenproperty, d, "SimulationRadius", math.huge); end;
				end;
			end;
		end;
	end;
Useskills = function(Y, d)
		if Y == "Melee" then
			weaponSc("Melee");
			if d == "Z" then
				K:SendKeyEvent(true, "Z", false, game);
				K:SendKeyEvent(false, "Z", false, game);
			elseif d == "X" then
				K:SendKeyEvent(true, "X", false, game);
				K:SendKeyEvent(false, "X", false, game);
			elseif d == "C" then
				K:SendKeyEvent(true, "C", false, game);
				K:SendKeyEvent(false, "C", false, game);
			end;
		elseif Y == "Sword" then
			weaponSc("Sword");
			if d == "Z" then
				K:SendKeyEvent(true, "Z", false, game);
				K:SendKeyEvent(false, "Z", false, game);
			elseif d == "X" then
				K:SendKeyEvent(true, "X", false, game);
				K:SendKeyEvent(false, "X", false, game);
			end;
		elseif Y == "Blox Fruit" then
			weaponSc("Blox Fruit");
			if d == "Z" then
				K:SendKeyEvent(true, "Z", false, game);
				K:SendKeyEvent(false, "Z", false, game);
			elseif d == "X" then
				K:SendKeyEvent(true, "X", false, game);
				K:SendKeyEvent(false, "X", false, game);
			elseif d == "C" then
				K:SendKeyEvent(true, "C", false, game);
				K:SendKeyEvent(false, "C", false, game);
			elseif d == "V" then
				K:SendKeyEvent(true, "V", false, game);
				K:SendKeyEvent(false, "V", false, game);
			end;
		elseif Y == "Gun" then
			weaponSc("Gun");
			if d == "Z" then
				K:SendKeyEvent(true, "Z", false, game);
				K:SendKeyEvent(false, "Z", false, game);
			elseif d == "X" then
				K:SendKeyEvent(true, "X", false, game);
				K:SendKeyEvent(false, "X", false, game);
			end;
		end;
		if Y == "nil" and d == "Y" then
			K:SendKeyEvent(true, "Y", false, game);
			K:SendKeyEvent(false, "Y", false, game);
		end;
	end;
local s = getrawmetatable(game);
local x = s.__namecall;
setreadonly(s, false);
s.__namecall = newcclosure(function(...)
		local method = getnamecallmethod();
		-- Avoid allocating an argument table for every remote call while the
		-- aim/mastery redirection features are disabled.
		local redirect = _G.FarmMastery_G and not b
			or _G.FarmMastery_Dev
			or _G.FarmBlazeEM
			or _G.Prehis_Skills
			or _G.SeaBeast1
			or _G.FishBoat
			or _G.PGB
			or _G.Leviathan1
			or _G.Complete_Trials
			or _G.AimMethod and ABmethod == "AimBots Skill"
			or _G.AimMethod and ABmethod == "Auto Aimbots";
		if method == "FireServer" and redirect then
			local args = { ... };
			if tostring(args[1]) == "RemoteEvent" and args[2] ~= true and args[2] ~= false then
				args[2] = MousePos;
				return x(unpack(args));
			end;
		end;
		return x(...);
	end);
GetConnectionEnemies = function(Y)
		local wanted = {};
		for _, name in ipairs(typeof(Y) == "table" and Y or {Y}) do wanted[string.lower(tostring(name))] = true end;
		local function matches(model)
			if not model:IsA("Model") then return false end;
			local lower = string.lower(model.Name);
			for name in pairs(wanted) do if lower == name or string.find(lower, name, 1, true) then return true end end;
			return false;
		end;
		-- Combat targets must come from live combat containers.  Searching
		-- ReplicatedStorage/Characters can return templates or quest NPCs with
		-- similar names, which breaks every feature using this helper.
		local folders = {game.Workspace:FindFirstChild("Enemies"), game.Workspace:FindFirstChild("SeaEvents")};
		local seen = {};
		for _, folder in ipairs(folders) do
			for _, R in ipairs(folder and folder:GetChildren() or {}) do
					if not seen[R] and matches(R) and R:FindFirstChild("HumanoidRootPart") and R:FindFirstChildOfClass("Humanoid") and R:FindFirstChildOfClass("Humanoid").Health > 0 then
					seen[R] = true;
					return R;
				end;
			end;
		end;
	end;
LowCpu = function()
		local Y = true;
		local d = game;
		local R = d.Workspace;
		local Q = d.Lighting;
		local r = R.Terrain;
		r.WaterWaveSize = 0;
		r.WaterWaveSpeed = 0;
		r.WaterReflectance = 0;
		r.WaterTransparency = 0;
		Q.GlobalShadows = false;
		Q.FogEnd = 9000000000.0;
		Q.Brightness = 0;
		(settings()).Rendering.QualityLevel = "Level01";
		for d, R in pairs(d:GetDescendants()) do
			if R:IsA("Part") or R:IsA("Union") or R:IsA("CornerWedgePart") or R:IsA("TrussPart") then
				R.Material = "Plastic";
				R.Reflectance = 0;
			elseif R:IsA("Decal") or R:IsA("Texture") and Y then
				R.Transparency = 1;
			elseif R:IsA("ParticleEmitter") or R:IsA("Trail") then
				R.Lifetime = NumberRange.new(0);
			elseif R:IsA("Explosion") then
				R.BlastPressure = 1;
				R.BlastRadius = 1;
			elseif R:IsA("Fire") or R:IsA("SpotLight") or R:IsA("Smoke") or R:IsA("Sparkles") then
				R.Enabled = false;
			elseif R:IsA("MeshPart") then
				R.Material = "Plastic";
				R.Reflectance = 0;
				R.TextureID = 10385902758728957;
			end;
		end;
		for Y, d in pairs(Q:GetChildren()) do
			if d:IsA("BlurEffect") or d:IsA("SunRaysEffect") or d:IsA("ColorCorrectionEffect") or d:IsA("BloomEffect") or d:IsA("DepthOfFieldEffect") then
				d.Enabled = false;
			end;
		end;
	end;
CheckF = function()
		if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then
			return true;
		end;
	end;
CheckBoat = function()
		for Y, R in pairs(workspace.Boats:GetChildren()) do
			if tostring(R.Owner.Value) == tostring(d.Name) then
				return R;
			end;
		end;
		return false;
	end;
CheckEnemiesBoat = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if d.Name == "FishBoat" and (d:FindFirstChild("Health")).Value > 0 then
				return true;
			end;
		end;
		return false;
	end;
CheckPirateGrandBrigade = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if (d.Name == "PirateGrandBrigade" or d.Name == "PirateBrigade") and (d:FindFirstChild("Health")).Value > 0 then
				return true;
			end;
		end;
		return false;
	end;
CheckShark = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if d.Name == "Shark" and f.Alive(d) then
				return true;
			end;
		end;
		return false;
	end;
CheckTerrorShark = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if d.Name == "Terrorshark" and f.Alive(d) then
				return true;
			end;
		end;
		return false;
	end;
CheckPiranha = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if d.Name == "Piranha" and f.Alive(d) then
				return true;
			end;
		end;
		return false;
	end;
CheckFishCrew = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if (d.Name == "Fish Crew Member" or d.Name == "Haunted Crew Member") and f.Alive(d) then
				return true;
			end;
		end;
		return false;
	end;
CheckHauntedCrew = function()
		for Y, d in pairs(workspace.Enemies:GetChildren()) do
			if d.Name == "Haunted Crew Member" and f.Alive(d) then
				return true;
			end;
		end;
		return false;
	end;
CheckSeaBeast = function()
		if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
			return true;
		end;
		return false;
	end;
CheckLeviathan = function()
		if workspace.SeaBeasts:FindFirstChild("Leviathan") then
			return true;
		end;
		return false;
	end;
UpdStFruit = function()
	local remotes = Q:FindFirstChild("Remotes")
	local comm = remotes and remotes:FindFirstChild("CommF_")
	if not comm then return 0 end
	local stored, seen = 0, {}
	local character = d.Character
	for _, container in ipairs({d.Backpack, character}) do
		for _, tool in ipairs(container and container:GetChildren() or {}) do
			if tool:IsA("Tool") and not seen[tool] then
				local eatRemote = tool:FindFirstChild("EatRemote", true)
				local originalName = tool:GetAttribute("OriginalName") or tool:GetAttribute("FruitName")
				if eatRemote or originalName or tostring(tool.Name):find("Fruit") then
					originalName = originalName or eatRemote and eatRemote.Parent:GetAttribute("OriginalName") or tool.Name
					if originalName and pcall(function() comm:InvokeServer("StoreFruit", tostring(originalName), tool) end) then
						stored = stored + 1
						task.wait(0.12)
					end
				end
				seen[tool] = true
			end
		end
	end
	return stored
end;
collectFruits = function(Y)
		if Y then
			local Y = d.Character;
			for d, R in pairs(workspace:GetChildren()) do
				if string.find(R.Name, "Fruit") then
					R.Handle.CFrame = Y.HumanoidRootPart.CFrame;
				end;
			end;
		end;
	end;
Getmoon = function()
		if World1 then
			return F.FantasySky.MoonTextureId;
		elseif World2 then
			return F.FantasySky.MoonTextureId;
		elseif World3 then
			return F.Sky.MoonTextureId;
		end;
	end;
DropFruits = function()
		for Y, R in next, d.Backpack:GetChildren() do
			if string.find(R.Name, "Fruit") then
				EquipWeapon(R.Name);
				task.wait(.1);
				if d.PlayerGui.Main.Dialogue.Visible == true then
					d.PlayerGui.Main.Dialogue.Visible = false;
				end;
				EquipWeapon(R.Name);
				(d.Character:FindFirstChild(R.Name)).EatRemote:InvokeServer("Drop");
			end;
		end;
		for Y, R in pairs(d.Character:GetChildren()) do
			if string.find(R.Name, "Fruit") then
				EquipWeapon(R.Name);
				task.wait(.1);
				if d.PlayerGui.Main.Dialogue.Visible == true then
					d.PlayerGui.Main.Dialogue.Visible = false;
				end;
				EquipWeapon(R.Name);
				(d.Character:FindFirstChild(R.Name)).EatRemote:InvokeServer("Drop");
			end;
		end;
	end;
GetBP = function(Y)
		return d.Backpack:FindFirstChild(Y) or d.Character:FindFirstChild(Y);
	end;
GetIn = function(Y)
		for R, Q in pairs(Q.Remotes.CommF_:InvokeServer("getInventory")) do
			if type(Q) == "table" then
				if Q.Name == Y or d.Character:FindFirstChild(Y) or d.Backpack:FindFirstChild(Y) then
					return true;
				end;
			end;
		end;
		return false;
	end;
GetM = function(Y)
		for d, R in pairs(Q.Remotes.CommF_:InvokeServer("getInventory")) do
			if type(R) == "table" then
				if R.Type == "Material" then
					if R.Name == Y then
						return R.Count;
					end;
				end;
			end;
		end;
		return 0;
	end;
GetWP = function(Y)
		local inv = Q.Remotes.CommF_:InvokeServer("getInventory");
		if type(inv) ~= "table" then
			return false;
		end;
		for R, Q in pairs(inv) do
			if type(Q) == "table" then
				if Q.Type == "Sword" then
					if Q.Name == Y or d.Character:FindFirstChild(Y) or d.Backpack:FindFirstChild(Y) then
						return true;
					end;
				end;
			end;
		end;
		return false;
	end;
getInfinity_Ability = function(Y, Q)
		if not R then
			return;
		end;
		if Y == "Soru" and Q then
			for Y, R in next, getgc() do
				if d.Character.Soru then
					if typeof(R) == "function" and (getfenv(R)).script == d.Character.Soru then
						for Y, R in next, getupvalues(R) do
							if typeof(R) == "table" then
								repeat
									task.wait(T);
									R.LastUse = 0;
								until not Q or d.Character.Humanoid.Health <= 0;
							end;
						end;
					end;
				end;
			end;
		elseif Y == "Energy" and Q then
			d.Character.Energy.Changed:connect(function()
				if Q then
					d.Character.Energy.Value = D;
				end;
			end);
		elseif Y == "Observation" and Q then
			local Y = d.VisionRadius;
			Y.Value = math.huge;
		end;
	end;
Hop = function()
		local placeId = game.PlaceId;
		local player = game.Players.LocalPlayer;
		local ts = game:GetService("TeleportService");
		local hs = game:GetService("HttpService");
		local CF_API = "https://job.idshowmeat.workers.dev";
		local httpReq = request or (syn and syn.request) or (http and http.request);
		local function cfRequest(url, method, body)
			if httpReq then
				local ok, res = pcall(httpReq, {
					Url = url, Method = method or "GET",
					Headers = { ["Content-Type"] = "application/json" },
					Body = body and hs:JSONEncode(body) or nil
				});
				if ok and res and res.StatusCode == 200 then
					return pcall(function() return hs:JSONDecode(res.Body) end);
				end;
			end;
			return false, nil;
		end;
		local function fetchAndPushJobs()
			local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=100", placeId);
			local ok, raw = pcall(function() return game:HttpGet(url) end);
			if not ok or not raw then return end;
			local ok2, data = pcall(function() return hs:JSONDecode(raw) end);
			if not ok2 or not data or not data.data then return end;
			local jobs = {};
			for _, s in ipairs(data.data) do
				if s.id and s.playing < (s.maxPlayers or 50) then
					table.insert(jobs, s.id);
				end;
			end;
			if #jobs > 0 then
				cfRequest(CF_API .. "/push", "POST", { place = tostring(placeId), jobs = jobs });
			end;
		end;
		local function hopViaAPI()
			local ok, res = cfRequest(CF_API .. "/pop?place=" .. tostring(placeId), "GET");
			if ok and res and res.job then
				pcall(function() ts:TeleportToPlaceInstance(placeId, res.job, player) end);
				return true;
			end;
			return false;
		end;
		if not hopViaAPI() then
			fetchAndPushJobs();
			task.wait(0.5);
			hopViaAPI();
		end;
	end;
local J = Instance.new("Part", workspace);
J.Size = Vector3.new(1, 1, 1);
J.Name = "Rip_Indra";
J.Anchored = true;
J.CanCollide = false;
J.CanTouch = false;
J.Transparency = 1;
local Yz = workspace:FindFirstChild(J.Name);
if Yz and Yz ~= J then
	Yz:Destroy();
end;
task.spawn(function()
	while task.wait(T) do
		if J and J.Parent == workspace then
			if y then
				(getgenv()).OnFarm = true;
			else
				(getgenv()).OnFarm = false;
			end;
		else
			(getgenv()).OnFarm = false;
		end;
	end;
end);
task.spawn(function()
	local Y = game.Players.LocalPlayer;
	repeat
		task.wait(.1);
	until Y.Character and Y.Character.PrimaryPart;
	J.CFrame = Y.Character.PrimaryPart.CFrame;
		while task.wait(T) do
			pcall(function()
				local travelActive = VoidTravel and VoidTravel.Active
				if travelActive then
					-- The legacy keep-player loop used to restore collisions every
					-- frame while the new segmented tween was crossing the map.
					-- Let the travel owner keep noclip until it finishes.
					setCharacterNoclip(Y.Character, true)
				elseif (getgenv()).OnFarm then
					if J and J.Parent == workspace then
						local d = Y.Character and Y.Character.PrimaryPart;
						if d and (d.Position - J.Position).Magnitude <= 200 then
						d.CFrame = J.CFrame;
					else
						J.CFrame = d.CFrame;
					end;
				end;
					setCharacterNoclip(Y.Character, true)
				else
					setCharacterNoclip(Y.Character, false)
				end;
			end);
	end;
end);
-- One owner for character movement: no stale root after respawn and no snap-back.
-- Long routes use one continuously updated BodyVelocity instead of segmented
-- CFrame writes, so direction is corrected without stopping between islands.
VoidTravel = VoidTravel or {
	Tween = nil, Proxy = nil, Driver = nil, Target = nil, Connection = nil,
	Character = nil, Token = 0, Active = false, Tolerance = 12, Speed = 180,
}
local function VoidRoot()
	local character = plr.Character
	return character and character:FindFirstChild("HumanoidRootPart"), character
end
local function VoidFinishTravel(token, character, root)
	if token and VoidTravel.Token ~= token then return end
	if VoidTravel.Connection then
		pcall(function() VoidTravel.Connection:Disconnect() end)
		VoidTravel.Connection = nil
	end
	if VoidTravel.Tween then
		pcall(function() VoidTravel.Tween:Cancel() end)
		VoidTravel.Tween = nil
	end
	if VoidTravel.Driver then
		pcall(function() VoidTravel.Driver:Destroy() end)
		VoidTravel.Driver = nil
	end
	if VoidTravel.Proxy then
		pcall(function() VoidTravel.Proxy:Destroy() end)
		VoidTravel.Proxy = nil
	end
	if root and root.Parent then zeroVelocity(root) end
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Parent then
		humanoid:Move(Vector3.zero)
		local stopPosition = root and root.Position
		if stopPosition then pcall(function() humanoid:MoveTo(stopPosition) end) end
		humanoid.AutoRotate = true
	end
	setCharacterNoclip(character, false)
	if not token or VoidTravel.Token == token then
		VoidTravel.Tween = nil
		VoidTravel.Proxy = nil
		VoidTravel.Driver = nil
		VoidTravel.Target = nil
		VoidTravel.Character = nil
		VoidTravel.LegTarget = nil
		VoidTravel.LegDeadline = 0
		VoidTravel.Active = false
		getgenv().OnFarm = true
	end
end

_tp = function(target, requestedTolerance)
	if typeof(target) ~= "CFrame" then return false, "invalid destination" end
	local root, character = VoidRoot()
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not character or not humanoid or humanoid.Health <= 0 then
		return false, "waiting for character"
	end
	if VoidTravel.Active
		and VoidTravel.Target and (VoidTravel.Target.Position - target.Position).Magnitude <= 16
		and VoidTravel.Character == character then
		return true, "travelling"
	end
	local distance = (target.Position - root.Position).Magnitude
	if distance <= 3 then return true, "already there" end
	local speed = math.clamp(
		tonumber(getgenv().TweenSpeedFar) or tonumber(getgenv().TweenSpeed) or VoidTravel.Speed,
		50,
		900
	)
	local tolerance = math.clamp(tonumber(requestedTolerance) or distance * .02, 10, 300)
	if VoidTravel.Active then
		VoidTravel.Token = (VoidTravel.Token or 0) + 1
		VoidFinishTravel(nil, VoidTravel.Character, nil)
	end
	VoidTravel.Token = (VoidTravel.Token or 0) + 1
	local token = VoidTravel.Token
	VoidTravel.Target = target
	VoidTravel.Character = character
	VoidTravel.Tolerance = tolerance
	VoidTravel.Active = true
	shouldTween, getgenv().OnFarm = true, false
	humanoid.AutoRotate = false
	setCharacterNoclip(character, true)
	local driver = Instance.new("BodyVelocity")
	driver.Name = "VoidVelocityTween"
	driver.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
	driver.P = math.max(1250, speed * 50)
	driver.Velocity = Vector3.zero
	driver.Parent = root
	VoidTravel.Driver = driver
	zeroVelocity(root)
	local runService = game:GetService("RunService")
	VoidTravel.Connection = runService.Heartbeat:Connect(function(deltaTime)
		if token ~= VoidTravel.Token or not VoidTravel.Active then return end
		local liveRoot = character:FindFirstChild("HumanoidRootPart")
		if not liveRoot or liveRoot.Parent ~= character then
			VoidFinishTravel(token, character, liveRoot)
			return
		end
		if not driver.Parent then driver.Parent = liveRoot end
		local offset = target.Position - liveRoot.Position
		local remaining = offset.Magnitude
		if remaining <= tolerance then
			driver.Velocity = Vector3.zero
			VoidFinishTravel(token, character, liveRoot)
			return
		end
		local direction = offset.Unit
		local frameDistance = speed * math.max(deltaTime, 1 / 240)
		local driveSpeed = speed
		if remaining <= tolerance + frameDistance * 2 then
			driveSpeed = math.max(50, math.min(speed, remaining / math.max(deltaTime, 1 / 60)))
		end
		driver.Velocity = direction * driveSpeed
		local stepDistance = math.min(remaining, driveSpeed * math.max(deltaTime, 1 / 240))
		pcall(function()
			liveRoot.CFrame = liveRoot.CFrame + direction * stepDistance
		end)
	end)
	task.spawn(function()
		local deadline = os.clock() + math.max(20, math.min(180, distance / speed * 2 + 15))
		while VoidTravel.Active
			and token == VoidTravel.Token
			and plr.Character == character
			and os.clock() < deadline do
			task.wait(.1)
		end
		if token == VoidTravel.Token and VoidTravel.Active then
			local liveRoot = character:FindFirstChild("HumanoidRootPart")
			VoidFinishTravel(token, character, liveRoot)
		end
	end)
	return true, "travelling"
end;

-- The current client accepts requestEntrance but may not move the character.
-- Always validate the result and fall back to a guarded segmented route.
VoidPortalPoints = {
	["Lower Sky"] = Vector3.new(-4607.82275, 872.54248, -1667.55688),
	-- Updated Sea 1 uses Workspace.Map.SkyArea2.EntrancePoint.  Keep the
	-- current coordinate as a fallback for servers that stream the map late.
	["Upper Sky"] = Vector3.new(-6023.5766601562, 5469.7197265625, 2203.3083496094),
	["UnderWater"] = Vector3.new(61163, 11, 1819),
	["SwanRoom"] = Vector3.new(2285, 15, 905),
	["Cursed Ship"] = Vector3.new(923, 126, 32852),
	["Castle On The Sea"] = Vector3.new(-5097.93164, 316.447021, -3142.66602),
	["Mansion Cafe"] = Vector3.new(-12471.16992187, 374.94024658, -7551.67773437),
	["Hydra Teleport"] = Vector3.new(5643.45263671, 1013.08581542, -340.51025390),
	["Canvendish Room"] = Vector3.new(5314.54638671, 22.56221961, -127.06755065),
	["Temple of Time"] = Vector3.new(28310.0234, 14895.1123, 109.456741),
}
-- The updated server corrects far CFrame writes, so portal travel must finish
-- close enough to the live entrance for the island resolver to take over.
VoidPortalLandingTolerance = 120

local function VoidLivePortalPoint(name, fallback)
	local map = workspace:FindFirstChild("Map")
	local point
	if name == "Upper Sky" then
		local sky = map and map:FindFirstChild("SkyArea2")
		point = sky and sky:FindFirstChild("EntrancePoint", true)
	elseif name == "UnderWater" then
		local teleportSpawn = map and map:FindFirstChild("TeleportSpawn")
		point = teleportSpawn and teleportSpawn:FindFirstChild("EntrancePoint", true)
	end
	if point and point:IsA("BasePart") then return point.Position end
	return fallback or VoidPortalPoints[name]
end

VoidRequestEntrance = function(point, fallback)
	if typeof(point) ~= "Vector3" then return false, "invalid entrance" end
	local root = select(1, VoidRoot())
	if not root then return false, "waiting for character" end
	local before = root.Position
	local remotes = Q:FindFirstChild("Remotes")
	local called = false
	for _, remoteName in ipairs({"CommF_", "CommF"}) do
		local remote = remotes and remotes:FindFirstChild(remoteName)
		if remote and remote:IsA("RemoteFunction") then
			local ok = pcall(remote.InvokeServer, remote, "requestEntrance", point)
			called = called or ok
			if (root.Position - before).Magnitude > 80 then break end
		end
	end
	task.wait(.35)
	root = select(1, VoidRoot()) or root
	if (root.Position - before).Magnitude > 80 then
		zeroVelocity(root)
		return true, called and "requestEntrance" or "entrance remote moved player"
	end
	-- Route to the entrance itself first.  Older callers passed an outdated
	-- quest CFrame as the fallback, which made a failed entrance request send
	-- the player across the sea toward a stale coordinate.
	local destination = CFrame.new(point)
	if typeof(fallback) == "CFrame" and (fallback.Position - point).Magnitude <= 250 then
		destination = fallback
	end
	if VoidTravel.Active
		and VoidTravel.Target and (VoidTravel.Target.Position - destination.Position).Magnitude <= 250 then
		return false, "entrance tweening"
	end
	if workspace.StreamingEnabled then
		pcall(function()
			plr:RequestStreamAroundAsync(destination.Position, 8)
		end)
	end
	-- A far CFrame write is rejected by the updated server.  Only use the
	-- direct fallback when already close; otherwise start the guarded tween.
	if (root.Position - destination.Position).Magnitude <= 800 then
		root.CFrame = destination
		zeroVelocity(root)
		task.wait(.25)
		root = select(1, VoidRoot()) or root
		if (root.Position - destination.Position).Magnitude <= 250 then
			return true, called and "direct entrance fallback" or "direct entrance"
		end
	end
	_tp(destination, VoidPortalLandingTolerance)
	return false, "entrance fallback tween"
end

VoidRequestPortal = function(name, fallback)
	local selected = tostring(name)
	local point = VoidLivePortalPoint(selected, VoidPortalPoints[selected])
	if not point then return false, "unknown portal" end
	return VoidRequestEntrance(point, fallback or CFrame.new(point))
end

TeleportToTarget = function(I)
_tp(I)
end;

notween = function(I)
	return _tp(I)
end;


function BTP(I)
	local e = game.Players.LocalPlayer;
	local K = e.Character.HumanoidRootPart;
	local n = e.Character.Humanoid;
	local d = e.PlayerGui.Main;
	local z = I.Position;
	local H = K.Position;

	repeat
		K.CFrame = I;
		d.Quest.Visible = false;

		if (K.Position - H).Magnitude > 1 then
			H = K.Position;
			K.CFrame = I;
		end;

		task.wait(.5);
	until (I.Position - K.Position).Magnitude <= 2000;
end;

function TeleportConditional(hrp, targetCFrame, threshold)
	if not hrp or not targetCFrame then return end
	
	local dist = (targetCFrame.Position - hrp.Position).Magnitude  
	if dist > threshold then  
		_tp(targetCFrame)  
	end
end;

task.spawn(function()
	while task.wait(T) do
		pcall(function()
			if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or (getgenv()).AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S then
				shouldTween = true;
				if not d.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local Y = Instance.new("BodyVelocity");
					Y.Name = "BodyClip";
					Y.Parent = d.Character.HumanoidRootPart;
					Y.MaxForce = Vector3.new(100000, 100000, 100000);
					Y.Velocity = Vector3.new(0, 0, 0);
				end;
				if not d.Character:FindFirstChild("highlight") then
					local Y = Instance.new("Highlight");
					Y.Name = "highlight";
					Y.Enabled = true;
					Y.FillColor = Color3.fromRGB(255, 255, 255);
					Y.OutlineColor = Color3.fromRGB(255, 255, 255);
					Y.FillTransparency = .5;
					Y.OutlineTransparency = .2;
					Y.Parent = d.Character;
				end;
				setCharacterNoclip(d.Character, true)
			else
				shouldTween = false;
				if d.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					(d.Character.HumanoidRootPart:FindFirstChild("BodyClip")):Destroy();
				end;
				if d.Character:FindFirstChild("highlight") then
					(d.Character:FindFirstChild("highlight")):Destroy();
				end;
			end;
		end);
	end;
end);
MaterialMon = function()
		local Y = game.Players.LocalPlayer;
		local d = Y.Character and Y.Character:FindFirstChild("HumanoidRootPart");
		if not d then
			return;
		end;
		shouldRequestEntrance = function(Y, R)
				local r = (d.Position - Y).Magnitude;
				if r >= R then
					VoidRequestEntrance(Y);
				end;
			end;
		if World1 then
			if SelectMaterial == "Angel Wings" then
				MMon = {
						"Shanda",
						"Royal Squad",
						"Royal Soldier",
						"Wysper",
						"Thunder God",
					};
				MPos = CFrame.new(-4698, 845, -1912);
				SP = "Default";
				local Y = Vector3.new(-4607.82275, 872.54248, -1667.55688);
				shouldRequestEntrance(Y, 10000);
			elseif SelectMaterial == "Leather + Scrap Metal" then
				MMon = { "Brute", "Pirate" };
				MPos = CFrame.new(-1145, 15, 4350);
				SP = "Default";
			elseif SelectMaterial == "Magma Ore" then
				MMon = { "Military Soldier", "Military Spy", "Magma Admiral" };
				MPos = CFrame.new(-5815, 84, 8820);
				SP = "Default";
			elseif SelectMaterial == "Fish Tail" then
				MMon = { "Fishman Warrior", "Fishman Commando", "Fishman Lord" };
				MPos = CFrame.new(61123, 19, 1569);
				SP = "Default";
				local Y = Vector3.new(61163.8515625, 5.34234237, 1819.78417968);
				shouldRequestEntrance(Y, 17000);
			end;
		elseif World2 then
			if SelectMaterial == "Leather + Scrap Metal" then
				MMon = { "Marine Captain" };
				MPos = CFrame.new(-2010.50598144, 73.00115966, -3326.62084960);
				SP = "Default";
			elseif SelectMaterial == "Magma Ore" then
				MMon = { "Magma Ninja", "Lava Pirate" };
				MPos = CFrame.new(-5428, 78, -5959);
				SP = "Default";
			elseif SelectMaterial == "Ectoplasm" then
				MMon = {
						"Ship Deckhand",
						"Ship Engineer",
						"Ship Steward",
						"Ship Officer",
					};
				MPos = CFrame.new(911.35827636, 125.95812988, 33159.5390625);
				SP = "Default";
				local Y = Vector3.new(61163.8515625, 5.34234237, 1819.78417968);
				shouldRequestEntrance(Y, 18000);
			elseif SelectMaterial == "Mystic Droplet" then
				MMon = { "Water Fighter" };
				MPos = CFrame.new(-3385, 239, -10542);
				SP = "Default";
			elseif SelectMaterial == "Radioactive Material" then
				MMon = { "Factory Staff" };
				MPos = CFrame.new(295, 73, -56);
				SP = "Default";
			elseif SelectMaterial == "Vampire Fang" then
				MMon = { "Vampire" };
				MPos = CFrame.new(-6033, 7, -1317);
				SP = "Default";
			end;
		elseif World3 then
			if SelectMaterial == "Scrap Metal" then
				MMon = { "Jungle Pirate", "Forest Pirate" };
				MPos = CFrame.new(-11975.78515625, 331.77340698, -10620.03027343);
				SP = "Default";
			elseif SelectMaterial == "Fish Tail" then
				MMon = { "Fishman Raider", "Fishman Captain" };
				MPos = CFrame.new(-10993, 332, -8940);
				SP = "Default";
			elseif SelectMaterial == "Conjured Cocoa" then
				MMon = { "Chocolate Bar Battler", "Cocoa Warrior" };
				MPos = CFrame.new(620.63446044, 78.93644714, -12581.36914062);
				SP = "Default";
			elseif SelectMaterial == "Dragon Scale" then
				MMon = { "Dragon Crew Archer", "Dragon Crew Warrior" };
				MPos = CFrame.new(6594, 383, 139);
				SP = "Default";
			elseif SelectMaterial == "Gunpowder" then
				MMon = { "Pistol Billionaire" };
				MPos = CFrame.new(-84.85569000, 85.62061309, 6132.00878906);
				SP = "Default";
			elseif SelectMaterial == "Mini Tusk" then
				MMon = { "Mythological Pirate" };
				MPos = CFrame.new(-13545, 470, -6917);
				SP = "Default";
			elseif SelectMaterial == "Demonic Wisp" then
				MMon = { "Demonic Soul" };
				MPos = CFrame.new(-9495.68066406, 453.58624267, 5977.34863281);
				SP = "Default";
			end;
	end;
end;

-- Sea 1 quest data is server-owned and changes with updates/streaming.  Keep
-- the legacy CheckQuest callers on the same live resolver as the new farm so
-- no Sea 1 NPC coordinate can come from the old level table.
function VoidResolveSea1Quest(playerLevel)
	if not World1 then return false, "not Sea 1" end
	playerLevel = tonumber(playerLevel) or 0
	local questsModule = Q:FindFirstChild("Quests")
	local loaded, quests = pcall(require, questsModule)
	if not loaded or type(quests) ~= "table" then return false, "live quest module unavailable" end

	local function normalize(value)
		local text = tostring(value or ""):lower():gsub("%b[]", "")
		return text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	end
	local function positionOf(instance)
		if typeof(instance) ~= "Instance" or not instance.Parent then return nil end
		if instance:IsA("BasePart") then return instance.Position end
		if instance:IsA("Model") then
			local ok, pivot = pcall(instance.GetPivot, instance)
			if ok and pivot then return pivot.Position end
		end
		local part = instance:FindFirstChildWhichIsA("BasePart", true)
		return part and part.Position or nil
	end
	local function spawnPoints(mobName)
		local origin = workspace:FindFirstChild("_WorldOrigin")
		local holder = origin and origin:FindFirstChild("EnemySpawns")
		local points = {}
		for _, spawn in ipairs(holder and holder:GetChildren() or {}) do
			if spawn:GetAttribute("Active") ~= false then
				local display = spawn:GetAttribute("DisplayName") or spawn.Name
				if normalize(display) == normalize(mobName) then
					local point = positionOf(spawn)
					if point then points[#points + 1] = point end
				end
			end
		end
		return points
	end

	local sea1Ids = {
		"BanditQuest1", "MarineQuest", "BuggyQuest1", "JungleQuest", "DesertQuest",
		"SnowQuest", "MarineQuest2", "PrisonerQuest", "ColosseumQuest", "MagmaQuest",
		"FishmanQuest", "SkyQuest", "SkyExp1Quest", "SkyExp2Quest", "FountainQuest",
	}
	local choices = {}
	for _, questId in ipairs(sea1Ids) do
		local tiers = quests[questId]
		for tier, entry in pairs(type(tiers) == "table" and tiers or {}) do
			if type(tier) == "number" and type(entry) == "table"
				and (tonumber(entry.LevelReq) or 0) <= playerLevel and type(entry.Task) == "table" then
				local mobName, kills = nil, 0
				for mob, count in pairs(entry.Task) do
					if not mobName then mobName = tostring(mob) end
					kills = kills + (tonumber(count) or 0)
				end
				local points = mobName and spawnPoints(mobName) or {}
				if mobName and kills > 1 and #points > 0 then
					local reward = type(entry.Reward) == "table" and entry.Reward or {}
					choices[#choices + 1] = {
						Id=questId, Tier=tier, LevelReq=tonumber(entry.LevelReq) or 0,
						Mob=mobName, Kills=kills, Exp=tonumber(reward.Exp) or 0, Points=points,
					}
				end
			end
		end
	end
	if #choices == 0 then return false, "Sea 1 quest/spawn data not streamed" end
	table.sort(choices, function(left, right)
		if left.LevelReq == right.LevelReq then return left.Exp > right.Exp end
		return left.LevelReq > right.LevelReq
	end)
	local choice = choices[1]

	local sum = Vector3.zero
	for _, point in ipairs(choice.Points) do sum = sum + point end
	local mobPosition = sum / #choice.Points
	local giverPosition, giverDistance
	local guideModule = Q:FindFirstChild("GuideModule")
	local guideOk, guide = pcall(require, guideModule)
	local npcList = guideOk and guide and guide.Data and guide.Data.NPCList
	for npc, entry in pairs(type(npcList) == "table" and npcList or {}) do
		if type(entry) == "table" and entry.InternalQuestName == choice.Id then
			local point = positionOf(npc)
			if not point and typeof(entry.Position) == "Vector3" then point = entry.Position end
			local distance = point and (point - mobPosition).Magnitude
			if point and (not giverPosition or distance < giverDistance) then
				giverPosition, giverDistance = point, distance
			end
		end
	end
	if not giverPosition then
		local aliases = {
			BanditQuest1="Bandit Quest Giver", MarineQuest="Marine Leader", MarineQuest2="Marine",
			BuggyQuest1="Pirate Adventurer", JungleQuest="Adventurer", DesertQuest="Desert Adventurer",
			SnowQuest="Villager", SkyQuest="Sky Adventurer", SkyExp1Quest="Mole", SkyExp2Quest="Sky Quest Giver 2",
			PrisonerQuest="Jail Keeper", ColosseumQuest="Colosseum Quest Giver", MagmaQuest="The Mayor",
			FishmanQuest="King Neptune", FountainQuest="Freezeburg Quest Giver",
		}
		for _, folder in ipairs({workspace:FindFirstChild("NPCs"), Q:FindFirstChild("NPCs")}) do
			local npc = folder and aliases[choice.Id] and folder:FindFirstChild(aliases[choice.Id])
			local point = positionOf(npc)
			if point then giverPosition = point; break end
		end
	end
	if not giverPosition then return false, "Sea 1 quest giver not streamed" end

	Mon, NameMon, NameQuest, LevelQuest = choice.Mob, choice.Mob, choice.Id, choice.Tier
	CFrameQuest = CFrame.new(giverPosition)
	CFrameMon = CFrame.new(mobPosition + Vector3.new(0, 25, 0))
	return true, choice
end

function CheckQuest()
	MyLevel = (game:GetService("Players")).LocalPlayer.Data.Level.Value;
	if World1 then
		if BetterFarm and BetterFarm.Apply then
			local applied, liveOk = pcall(BetterFarm.Apply, true)
			if applied and liveOk then return end
		end
		local liveOk = VoidResolveSea1Quest(MyLevel)
		if liveOk then return end
		Mon, NameMon, NameQuest, LevelQuest, CFrameQuest, CFrameMon = nil, nil, nil, nil, nil, nil
		return
	end
	if World2 then
		if MyLevel >= 700 and MyLevel <= 724 then
			Mon = "Raider";
			LevelQuest = 1;
			NameQuest = "Area1Quest";
			NameMon = "Raider";
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.97436809, 0, 1, 0, .974368095, 0, -0.22495985);
			CFrameMon = CFrame.new(-728.32672119, 52.77931976, 2345.77050781);
		elseif MyLevel >= 725 and MyLevel <= 774 then
			Mon = "Mercenary";
			LevelQuest = 2;
			NameQuest = "Area1Quest";
			NameMon = "Mercenary";
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.97436809, 0, 1, 0, .974368095, 0, -0.22495985);
			CFrameMon = CFrame.new(-1004.32440185, 80.15886688, 1424.61938476);
		elseif MyLevel >= 775 and MyLevel <= 799 then
			Mon = "Swan Pirate";
			LevelQuest = 1;
			NameQuest = "Area2Quest";
			NameMon = "Swan Pirate";
			CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, .139203906, 0, .99026376, 0, 1, 0, -0.99026376, 0, .139203906);
			CFrameMon = CFrame.new(1068.66430664, 137.61428833, 1322.10607910);
		elseif MyLevel >= 800 and MyLevel <= 874 then
			Mon = "Factory Staff";
			NameQuest = "Area2Quest";
			LevelQuest = 2;
			NameMon = "Factory Staff";
			CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.03197223, 8.96074881e-10, -0.99948877, 1.36326533e-10, 1, 8.92172336e-10, .999488771, -1.07732087e-10, -0.03197223);
			CFrameMon = CFrame.new(73.07867431, 81.86344146, -27.47067260);
		elseif MyLevel >= 875 and MyLevel <= 899 then
			Mon = "Marine Lieutenant";
			LevelQuest = 1;
			NameQuest = "MarineQuest3";
			NameMon = "Marine Lieutenant";
			CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, .866007268, 0, .500031412, 0, 1, 0, -0.50003141, 0, .866007268);
			CFrameMon = CFrame.new(-2821.37231445, 75.89727783, -3070.08911132);
		elseif MyLevel >= 900 and MyLevel <= 949 then
			Mon = "Marine Captain";
			LevelQuest = 2;
			NameQuest = "MarineQuest3";
			NameMon = "Marine Captain";
			CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, .866007268, 0, .500031412, 0, 1, 0, -0.50003141, 0, .866007268);
			CFrameMon = CFrame.new(-1861.23107910, 80.17658233, -3254.69750976);
		elseif MyLevel >= 950 and MyLevel <= 974 then
			Mon = "Zombie";
			LevelQuest = 1;
			NameQuest = "ZombieQuest";
			NameMon = "Zombie";
			CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, .95628953, 0, -0.29242146);
			CFrameMon = CFrame.new(-5657.77685546, 78.96973419, -928.68701171);
		elseif MyLevel >= 975 and MyLevel <= 999 then
			Mon = "Vampire";
			LevelQuest = 2;
			NameQuest = "ZombieQuest";
			NameMon = "Vampire";
			CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, .95628953, 0, -0.29242146);
			CFrameMon = CFrame.new(-6037.66796875, 32.18463897, -1340.65979003);
		elseif MyLevel >= 1000 and MyLevel <= 1049 then
			Mon = "Snow Trooper";
			LevelQuest = 1;
			NameQuest = "SnowMountainQuest";
			NameMon = "Snow Trooper";
			CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.37460410, 0, .92718488, 0, 1, 0, -0.92718488, 0, -0.37460410);
			CFrameMon = CFrame.new(549.14733886, 427.38705444, -5563.69873046);
		elseif MyLevel >= 1050 and MyLevel <= 1099 then
			Mon = "Winter Warrior";
			LevelQuest = 2;
			NameQuest = "SnowMountainQuest";
			NameMon = "Winter Warrior";
			CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.37460410, 0, .92718488, 0, 1, 0, -0.92718488, 0, -0.37460410);
			CFrameMon = CFrame.new(1142.74511718, 475.63980102, -5199.41650390);
		elseif MyLevel >= 1100 and MyLevel <= 1124 then
			Mon = "Lab Subordinate";
			LevelQuest = 1;
			NameQuest = "IceSideQuest";
			NameMon = "Lab Subordinate";
			CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, .453972578, 0, -0.89101564, 0, 1, 0, .891015649, 0, .453972578);
			CFrameMon = CFrame.new(-5707.47167968, 15.95170974, -4513.39208984);
		elseif MyLevel >= 1125 and MyLevel <= 1174 then
			Mon = "Horned Warrior";
			LevelQuest = 2;
			NameQuest = "IceSideQuest";
			NameMon = "Horned Warrior";
			CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, .453972578, 0, -0.89101564, 0, 1, 0, .891015649, 0, .453972578);
			CFrameMon = CFrame.new(-6341.36669921, 15.95177078, -5723.16210937);
		elseif MyLevel >= 1175 and MyLevel <= 1199 then
			Mon = "Magma Ninja";
			LevelQuest = 1;
			NameQuest = "FireSideQuest";
			NameMon = "Magma Ninja";
			CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.88295221, 0, .469463557, 0, 1, 0, -0.46946355, 0, -0.88295221);
			CFrameMon = CFrame.new(-5449.67285156, 76.65874481, -5808.20068359);
		elseif MyLevel >= 1200 and MyLevel <= 1249 then
			Mon = "Lava Pirate";
			LevelQuest = 2;
			NameQuest = "FireSideQuest";
			NameMon = "Lava Pirate";
			CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.88295221, 0, .469463557, 0, 1, 0, -0.46946355, 0, -0.88295221);
			CFrameMon = CFrame.new(-5213.33154296, 49.73788070, -4701.45117187);
		elseif MyLevel >= 1250 and MyLevel <= 1274 then
			Mon = "Ship Deckhand";
			LevelQuest = 1;
			NameQuest = "ShipQuest1";
			NameMon = "Ship Deckhand";
			CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016);
			CFrameMon = CFrame.new(1212.01110839, 150.79205322, 33059.24609375);
			if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				(game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441, 126.97600555, 32852.83203125));
			end;
		elseif MyLevel >= 1275 and MyLevel <= 1299 then
			Mon = "Ship Engineer";
			LevelQuest = 2;
			NameQuest = "ShipQuest1";
			NameMon = "Ship Engineer";
			CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016);
			CFrameMon = CFrame.new(919.47863769, 43.54401397, 32779.96875);
			if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				(game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441, 126.97600555, 32852.83203125));
			end;
		elseif MyLevel >= 1300 and MyLevel <= 1324 then
			Mon = "Ship Steward";
			LevelQuest = 1;
			NameQuest = "ShipQuest2";
			NameMon = "Ship Steward";
			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125);
			CFrameMon = CFrame.new(919.43853759, 129.55599975, 33436.03515625);
			if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				(game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441, 126.97600555, 32852.83203125));
			end;
		elseif MyLevel >= 1325 and MyLevel <= 1349 then
			Mon = "Ship Officer";
			LevelQuest = 2;
			NameQuest = "ShipQuest2";
			NameMon = "Ship Officer";
			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125);
			CFrameMon = CFrame.new(1036.01794433, 181.43904113, 33315.7265625);
			if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				(game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441, 126.97600555, 32852.83203125));
			end;
		elseif MyLevel >= 1350 and MyLevel <= 1374 then
			Mon = "Arctic Warrior";
			LevelQuest = 1;
			NameQuest = "FrostQuest";
			NameMon = "Arctic Warrior";
			CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.93358790, 0, -0.35834950, 0, 1, 0, .358349502, 0, -0.93358790);
			CFrameMon = CFrame.new(5966.24609375, 62.97002029, -6179.3828125);
			if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				(game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-6508.55810546, 5000.03499603, -132.83953857));
			end;
		elseif MyLevel >= 1375 and MyLevel <= 1424 then
			Mon = "Snow Lurker";
			LevelQuest = 2;
			NameQuest = "FrostQuest";
			NameMon = "Snow Lurker";
			CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.93358790, 0, -0.35834950, 0, 1, 0, .358349502, 0, -0.93358790);
			CFrameMon = CFrame.new(5407.07373046, 69.19437408, -6880.88037109);
		elseif MyLevel >= 1425 and MyLevel <= 1449 then
			Mon = "Sea Soldier";
			LevelQuest = 1;
			NameQuest = "ForgottenQuest";
			NameMon = "Sea Soldier";
			CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, .990270376, 0, -0.13915664, 0, 1, 0, .13915664, 0, .990270376);
			CFrameMon = CFrame.new(-3028.22363281, 64.67451477, -9775.42675781);
		elseif MyLevel >= 1450 then
			Mon = "Water Fighter";
			LevelQuest = 2;
			NameQuest = "ForgottenQuest";
			NameMon = "Water Fighter";
			CFrameQuest = CFrame.new(-3054, 240, -10146);
			CFrameMon = CFrame.new(-3291, 252, -10501);
		end;
	elseif World3 then
		if MyLevel >= 1500 and MyLevel <= 1524 then
			Mon = "Pirate Millionaire";
			LevelQuest = 1;
			NameQuest = "PiratePortQuest";
			NameMon = "Pirate Millionaire";
			CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, .965929627, 0, -0.25880479, 0, 1, 0, .258804798, 0, .965929627);
			CFrameMon = CFrame.new(-245.99638366, 47.30615234, 5584.10058593);
		elseif MyLevel >= 1525 and MyLevel <= 1574 then
			Mon = "Pistol Billionaire";
			LevelQuest = 2;
			NameQuest = "PiratePortQuest";
			NameMon = "Pistol Billionaire";
			CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, .965929627, 0, -0.25880479, 0, 1, 0, .258804798, 0, .965929627);
			CFrameMon = CFrame.new(-187.33015441, 86.23987579, 6013.51367187);
		elseif MyLevel >= 1575 and MyLevel <= 1599 then
			Mon = "Dragon Crew Warrior";
			LevelQuest = 1;
			NameQuest = "DragonCrewQuest";
			NameMon = "Dragon Crew Warrior";
			CFrameQuest = CFrame.new(6738.96142578, 127.81645965, -713.51147460);
			CFrameMon = CFrame.new(6920.71435546, 56.15597152, -942.50445556);
		elseif MyLevel >= 1600 and MyLevel <= 1624 then
			Mon = "Dragon Crew Archer";
			NameQuest = "DragonCrewQuest";
			LevelQuest = 2;
			NameMon = "Dragon Crew Archer";
			CFrameQuest = CFrame.new(6738.96142578, 127.81645965, -713.51147460);
			CFrameMon = CFrame.new(6817.91259765, 484.80444335, 513.41412353);
		elseif MyLevel >= 1625 and MyLevel <= 1649 then
			Mon = "Hydra Enforcer";
			NameQuest = "VenomCrewQuest";
			LevelQuest = 1;
			NameMon = "Hydra Enforcer";
			CFrameQuest = CFrame.new(5213.87402343, 1004.50427246, 758.69445800);
			CFrameMon = CFrame.new(4584.69287109, 1002.64355468, 705.79589843);
		elseif MyLevel >= 1650 and MyLevel <= 1699 then
			Mon = "Venomous Assailant";
			NameQuest = "VenomCrewQuest";
			LevelQuest = 2;
			NameMon = "Venomous Assailant";
			CFrameQuest = CFrame.new(5213.87402343, 1004.50427246, 758.69445800);
			CFrameMon = CFrame.new(4638.78564453, 1078.94091796, 881.80023193);
		elseif MyLevel >= 1700 and MyLevel <= 1724 then
			Mon = "Marine Commodore";
			LevelQuest = 1;
			NameQuest = "MarineTreeIsland";
			NameMon = "Marine Commodore";
			CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.96592974, 0, .258804798, 0, 1, 0, -0.25880479, 0, -0.96592974);
			CFrameMon = CFrame.new(2286.0078125, 73.13391876, -7159.80908203);
		elseif MyLevel >= 1725 and MyLevel <= 1774 then
			Mon = "Marine Rear Admiral";
			NameMon = "Marine Rear Admiral";
			NameQuest = "MarineTreeIsland";
			LevelQuest = 2;
			CFrameQuest = CFrame.new(2179.98828125, 28.73123931, -6740.05517578);
			CFrameMon = CFrame.new(3656.77368164, 160.52406311, -7001.59863281);
		elseif MyLevel >= 1775 and MyLevel <= 1799 then
			Mon = "Fishman Raider";
			LevelQuest = 1;
			NameQuest = "DeepForestIsland3";
			NameMon = "Fishman Raider";
			CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.88295221, 0, .469463557, 0, 1, 0, -0.46946355, 0, -0.88295221);
			CFrameMon = CFrame.new(-10407.52636718, 331.76263427, -8368.51660156);
		elseif MyLevel >= 1800 and MyLevel <= 1824 then
			Mon = "Fishman Captain";
			LevelQuest = 2;
			NameQuest = "DeepForestIsland3";
			NameMon = "Fishman Captain";
			CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.88295221, 0, .469463557, 0, 1, 0, -0.46946355, 0, -0.88295221);
			CFrameMon = CFrame.new(-10994.70117187, 352.38140869, -9002.11035156);
		elseif MyLevel >= 1825 and MyLevel <= 1849 then
			Mon = "Forest Pirate";
			LevelQuest = 1;
			NameQuest = "DeepForestIsland";
			NameMon = "Forest Pirate";
			CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, .707134247, 0, -0.70707929, 0, 1, 0, .707079291, 0, .707134247);
			CFrameMon = CFrame.new(-13274.47851562, 332.37814331, -7769.58056640);
		elseif MyLevel >= 1850 and MyLevel <= 1899 then
			Mon = "Mythological Pirate";
			LevelQuest = 2;
			NameQuest = "DeepForestIsland";
			NameMon = "Mythological Pirate";
			CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, .707134247, 0, -0.70707929, 0, 1, 0, .707079291, 0, .707134247);
			CFrameMon = CFrame.new(-13680.60742187, 501.08154296, -6991.18945312);
		elseif MyLevel >= 1900 and MyLevel <= 1924 then
			Mon = "Jungle Pirate";
			LevelQuest = 1;
			NameQuest = "DeepForestIsland2";
			NameMon = "Jungle Pirate";
			CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.08713150, 0, .996196866, 0, 1, 0, -0.99619686, 0, -0.08713150);
			CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.83691406);
		elseif MyLevel >= 1925 and MyLevel <= 1974 then
			Mon = "Musketeer Pirate";
			LevelQuest = 2;
			NameQuest = "DeepForestIsland2";
			NameMon = "Musketeer Pirate";
			CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.08713150, 0, .996196866, 0, 1, 0, -0.99619686, 0, -0.08713150);
			CFrameMon = CFrame.new(-13457.90429687, 391.54565429, -9859.17773437);
		elseif MyLevel >= 1975 and MyLevel <= 1999 then
			Mon = "Reborn Skeleton";
			LevelQuest = 1;
			NameQuest = "HauntedQuest1";
			NameMon = "Reborn Skeleton";
			CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0);
			CFrameMon = CFrame.new(-8763.72363281, 165.72299194, 6159.86181640);
		elseif MyLevel >= 2000 and MyLevel <= 2024 then
			Mon = "Living Zombie";
			LevelQuest = 2;
			NameQuest = "HauntedQuest1";
			NameMon = "Living Zombie";
			CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0);
			CFrameMon = CFrame.new(-10144.13183593, 138.62667846, 5838.08886718);
		elseif MyLevel >= 2025 and MyLevel <= 2049 then
			Mon = "Demonic Soul";
			LevelQuest = 1;
			NameQuest = "HauntedQuest2";
			NameMon = "Demonic Soul";
			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0);
			CFrameMon = CFrame.new(-9505.87207031, 172.10482788, 6158.99316406);
		elseif MyLevel >= 2050 and MyLevel <= 2074 then
			Mon = "Posessed Mummy";
			LevelQuest = 2;
			NameQuest = "HauntedQuest2";
			NameMon = "Posessed Mummy";
			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0);
			CFrameMon = CFrame.new(-9582.02246093, 6.25152730, 6205.47851562);
		elseif MyLevel >= 2075 and MyLevel <= 2099 then
			Mon = "Peanut Scout";
			LevelQuest = 1;
			NameQuest = "NutsIslandQuest";
			NameMon = "Peanut Scout";
			CFrameQuest = CFrame.new(-2104.39086914, 38.10416793, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0);
			CFrameMon = CFrame.new(-2143.24194335, 47.72198486, -10029.99511718);
		elseif MyLevel >= 2100 and MyLevel <= 2124 then
			Mon = "Peanut President";
			LevelQuest = 2;
			NameQuest = "NutsIslandQuest";
			NameMon = "Peanut President";
			CFrameQuest = CFrame.new(-2104.39086914, 38.10416793, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0);
			CFrameMon = CFrame.new(-1859.35400390, 38.10316848, -10422.4296875);
		elseif MyLevel >= 2125 and MyLevel <= 2149 then
			Mon = "Ice Cream Chef";
			LevelQuest = 1;
			NameQuest = "IceCreamIslandQuest";
			NameMon = "Ice Cream Chef";
			CFrameQuest = CFrame.new(-820.64825439, 65.81952667, -10965.79589843, 0, 0, -1, 0, 1, 0, 1, 0, 0);
			CFrameMon = CFrame.new(-872.24658203, 65.81957244, -10919.95703125);
		elseif MyLevel >= 2150 and MyLevel <= 2199 then
			Mon = "Ice Cream Commander";
			LevelQuest = 2;
			NameQuest = "IceCreamIslandQuest";
			NameMon = "Ice Cream Commander";
			CFrameQuest = CFrame.new(-820.64825439, 65.81952667, -10965.79589843, 0, 0, -1, 0, 1, 0, 1, 0, 0);
			CFrameMon = CFrame.new(-558.06103515, 112.04895782, -11290.77441406);
		elseif MyLevel >= 2200 and MyLevel <= 2224 then
			Mon = "Cookie Crafter";
			LevelQuest = 1;
			NameQuest = "CakeQuest1";
			NameMon = "Cookie Crafter";
			CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, .957576931, -8.80302053e-08, .288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.28817781, -5.2032135e-08, .957576931);
			CFrameMon = CFrame.new(-2374.13671875, 37.79826354, -12125.30859375);
		elseif MyLevel >= 2225 and MyLevel <= 2249 then
			Mon = "Cake Guard";
			LevelQuest = 2;
			NameQuest = "CakeQuest1";
			NameMon = "Cake Guard";
			CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, .957576931, -8.80302053e-08, .288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.28817781, -5.2032135e-08, .957576931);
			CFrameMon = CFrame.new(-1598.30700683, 43.77319717, -12244.58105468);
		elseif MyLevel >= 2250 and MyLevel <= 2274 then
			Mon = "Baking Staff";
			LevelQuest = 1;
			NameQuest = "CakeQuest2";
			NameMon = "Baking Staff";
			CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, .250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.25077858, 2.64211941e-08, -0.96804446);
			CFrameMon = CFrame.new(-1887.80993652, 77.61850738, -12998.35058593);
		elseif MyLevel >= 2275 and MyLevel <= 2299 then
			Mon = "Head Baker";
			LevelQuest = 2;
			NameQuest = "CakeQuest2";
			NameMon = "Head Baker";
			CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, .250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.25077858, 2.64211941e-08, -0.96804446);
			CFrameMon = CFrame.new(-2216.18823242, 82.88452148, -12869.29394531);
		elseif MyLevel >= 2300 and MyLevel <= 2324 then
			Mon = "Cocoa Warrior";
			LevelQuest = 1;
			NameQuest = "ChocQuest1";
			NameMon = "Cocoa Warrior";
			CFrameQuest = CFrame.new(233.22836303, 29.87600135, -12201.23339843);
			CFrameMon = CFrame.new(-21.55328369, 80.57499694, -12352.38769531);
		elseif MyLevel >= 2325 and MyLevel <= 2349 then
			Mon = "Chocolate Bar Battler";
			LevelQuest = 2;
			NameQuest = "ChocQuest1";
			NameMon = "Chocolate Bar Battler";
			CFrameQuest = CFrame.new(233.22836303, 29.87600135, -12201.23339843);
			CFrameMon = CFrame.new(582.59057617, 77.18809509, -12463.16210937);
		elseif MyLevel >= 2350 and MyLevel <= 2374 then
			Mon = "Sweet Thief";
			LevelQuest = 1;
			NameQuest = "ChocQuest2";
			NameMon = "Sweet Thief";
			CFrameQuest = CFrame.new(150.50663757, 30.69369316, -12774.50292968);
			CFrameMon = CFrame.new(165.18847656, 76.05885314, -12600.83691406);
		elseif MyLevel >= 2375 and MyLevel <= 2399 then
			Mon = "Candy Rebel";
			LevelQuest = 2;
			NameQuest = "ChocQuest2";
			NameMon = "Candy Rebel";
			CFrameQuest = CFrame.new(150.50663757, 30.69369316, -12774.50292968);
			CFrameMon = CFrame.new(134.86563110, 77.24768066, -12876.54785156);
		elseif MyLevel >= 2400 and MyLevel <= 2424 then
			Mon = "Candy Pirate";
			LevelQuest = 1;
			NameQuest = "CandyQuest1";
			NameMon = "Candy Pirate";
			CFrameQuest = CFrame.new(-1150.04003906, 20.37893486, -14446.33496093);
			CFrameMon = CFrame.new(-1310.50036621, 26.01652336, -14562.40429687);
		elseif MyLevel >= 2425 and MyLevel <= 2449 then
			Mon = "Snow Demon";
			LevelQuest = 2;
			NameQuest = "CandyQuest1";
			NameMon = "Snow Demon";
			CFrameQuest = CFrame.new(-1150.04003906, 20.37893486, -14446.33496093);
			CFrameMon = CFrame.new(-880.20062255, 71.24776458, -14538.609375);
		elseif MyLevel >= 2450 and MyLevel <= 2474 then
			Mon = "Isle Outlaw";
			LevelQuest = 1;
			NameQuest = "TikiQuest1";
			NameMon = "Isle Outlaw";
			CFrameQuest = CFrame.new(-16547.74804687, 61.13533401, -173.41360473);
			CFrameMon = CFrame.new(-16442.81445312, 116.13899993, -264.46377563);
		elseif MyLevel >= 2475 and MyLevel <= 2524 then
			Mon = "Island Boy";
			LevelQuest = 2;
			NameQuest = "TikiQuest1";
			NameMon = "Island Boy";
			CFrameQuest = CFrame.new(-16547.74804687, 61.13533401, -173.41360473);
			CFrameMon = CFrame.new(-16901.26171875, 84.06756591, -192.88906860);
		elseif MyLevel >= 2525 and MyLevel <= 2549 then
			Mon = "Isle Champion";
			LevelQuest = 2;
			NameQuest = "TikiQuest2";
			NameMon = "Isle Champion";
			CFrameQuest = CFrame.new(-16539.078125, 55.68632888, 1051.57385253);
			CFrameMon = CFrame.new(-16641.6796875, 235.78254699, 1031.28295898);
		elseif MyLevel >= 2550 and MyLevel <= 2574 then
			Mon = "Serpent Hunter";
			LevelQuest = 1;
			NameQuest = "TikiQuest3";
			NameMon = "Serpent Hunter";
			CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, .951068401, 0, -0.30898046, 0, 1, 0, .308980465, 0, .951068401);
			CFrameMon = CFrame.new(-16521.0625, 106.09285, 1488.78467, .469467044, 0, .882950008, 0, 1, 0, -0.88295000, 0, .469467044);
		elseif MyLevel >= 2575 and MyLevel <= 2599 then
			Mon = "Skull Slayer";
			LevelQuest = 2;
			NameQuest = "TikiQuest3";
			NameMon = "Skull Slayer";
			CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, .951068401, 0, -0.30898046, 0, 1, 0, .308980465, 0, .951068401);
			CFrameMon = CFrame.new(-16855.043, 122.457253, 1478.15308, -0.99939227, 0, -0.03486879, 0, 1, 0, .0348687991, 0, -0.99939227);
		elseif MyLevel >= 2600 and MyLevel <= 2624 then
			CFrameQuest = CFrame.new(10780.10742187, -2087.72143554, 9261.86523437);
			if ((getgenv()).AutoFarm or _G.Level) and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.99739098, 1.47309942e-09, -0.07218909, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.07218908, 5.75363091e-10, 0.99739092));
				task.wait(2);
				Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-16269.7041, 25.2288494, 1373.65955));
				task.wait(1);
				local args = {"TravelToSubmergedIsland"};
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args));
				return;
			end;
			Mon = "Reef Bandit";
			LevelQuest = 1;
			NameQuest = "SubmergedQuest1";
			NameMon = "Reef Bandit";
			CFrameMon = CFrame.new(10943.0811, -2083.03516, 9177.33691, -0.99871325, -0.04612046, .021090759, -0.04515713, .998007238, .0440727882, -0.02308138, .0430636741, -0.99880564);
		elseif MyLevel >= 2625 and MyLevel <= 2649 then
			CFrameQuest = CFrame.new(10780.10742187, -2087.72143554, 9261.86523437);
			if ((getgenv()).AutoFarm or _G.Level) and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.99739098, 1.47309942e-09, -0.07218909, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.07218908, 5.75363091e-10, 0.99739092));
				task.wait(2);
				Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-16269.7041, 25.2288494, 1373.65955));
				task.wait(1);
				local args = {"TravelToSubmergedIsland"};
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args));
				return;
			end;
			Mon = "Coral Pirate";
			LevelQuest = 2;
			NameQuest = "SubmergedQuest1";
			NameMon = "Coral Pirate";
			CFrameMon = CFrame.new(10713.4473, -2093.04517, 9307.14844, .325602472, 7.02769976e-05, .945506752, -7.02769976e-05, 1, -5.01261711e-05, -0.94550675, -5.01261711e-05, .325602472);
		elseif MyLevel >= 2650 and MyLevel <= 2674 then
			CFrameQuest = CFrame.new(10883.58789062, -2086.19702148, 10032.19628906);
			if ((getgenv()).AutoFarm or _G.Level) and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.99739098, 1.47309942e-09, -0.07218909, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.07218908, 5.75363091e-10, 0.99739092));
				task.wait(2);
				Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-16269.7041, 25.2288494, 1373.65955));
				task.wait(1);
				local args = {"TravelToSubmergedIsland"};
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args));
				return;
			end;
			Mon = "Sea Chanter";
			LevelQuest = 1;
			NameQuest = "SubmergedQuest2";
			NameMon = "Sea Chanter";
			CFrameMon = CFrame.new(10647.60644531, -2077.62573242, 10079.96289062);
		elseif MyLevel >= 2675 and MyLevel <= 2699 then
			CFrameQuest = CFrame.new(9635.87011718, -1992.44812011, 9614.39355468);
			if ((getgenv()).AutoFarm or _G.Level) and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.99739098, 1.47309942e-09, -0.07218909, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.07218908, 5.75363091e-10, 0.99739092));
				task.wait(2);
				Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-16269.7041, 25.2288494, 1373.65955));
				task.wait(1);
				local args = {"TravelToSubmergedIsland"};
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args));
				return;
			end;
			Mon = "High Disciple";
			LevelQuest = 1;
			NameQuest = "SubmergedQuest3";
			NameMon = "High Disciple";
			CFrameMon = CFrame.new(9843.578125, -1993.45593261, 9696.48046875);
		elseif MyLevel >= 2700 then
			CFrameQuest = CFrame.new(9635.87011718, -1992.44812011, 9614.39355468);
			if ((getgenv()).AutoFarm or _G.Level) and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.99739098, 1.47309942e-09, -0.07218909, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.07218908, 5.75363091e-10, 0.99739092));
				task.wait(2);
				Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-16269.7041, 25.2288494, 1373.65955));
				task.wait(1);
				local args = {"TravelToSubmergedIsland"};
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args));
				return;
			end;
			Mon = "Grand Devotee";
			LevelQuest = 2;
			NameQuest = "SubmergedQuest3";
			NameMon = "Grand Devotee";
			CFrameMon = CFrame.new(9591.0546875, -1993.47424316, 9808.70507812);
		end;
	end;
end;
-- ============================================================
-- MELLENIUM UI
-- ============================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/mellenium-ui-/main/Millenium/Library.lua"))()
local icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/mellenium-ui-/main/Icons.lua"))()

local win = library:window({
    name = "VoidHub",
    subtitle = "BloxFruits",
    icon = icons.sword,
    closeMode = "hide",
    mobileToggle = true,
})

-- TAB 1: FARM
local af, mastery, special = win:tab({name="Farm", icon=icons.sword, tabs={"Auto Farm","Mastery","Special"}})

-- Auto Farm subtab
local af_boxes = af:groupboxes({boxes={"Core Farm","Travel","Quest","Mob Options"}})
local core = af_boxes.top_left
local travel_box = af_boxes.top_right
local quest_box = af_boxes.bottom_left
local mob_opts = af_boxes.bottom_right

core:toggle({name="Auto Farm", flag="AutoFarm", def=false, callback=function(v) _G.AutoFarm = v end})
core:toggle({name="Auto Quest", flag="AutoQuest", def=false, callback=function(v) _G.AutoQuest = v end})
core:toggle({name="Bring Mobs", flag="BringEnemy_G", def=false, callback=function(v) _B = v end})
core:toggle({name="Auto Attack", flag="AutoAttack_G", def=false, callback=function(v) _G.AutoAttack_G = v end})
core:toggle({name="Accept Quests", flag="AcceptQuest", def=false, callback=function(v) _G.AcceptQuest = v end})
core:toggle({name="Use Skills", flag="UseSkills_G", def=false, callback=function(v) _G.UseSkills_G = v end})

travel_box:toggle({name="Auto Teleport", flag="VoidTravelEnabled", def=false, callback=function(v) _G.VoidTravelEnabled = v end})
travel_box:toggle({name="Smooth Tween TP", flag="SmoothTween", def=true, callback=function(v) _G.SmoothTween = v end})
travel_box:slider({name="Tween Speed", flag="TweenSpeed", min=50, max=500, def=200, suffix="", callback=function(v) _G.TweenSpeed = v end})
travel_box:slider({name="Mob Height", flag="MobHeight", min=0, max=100, def=20, suffix="", callback=function(v) _G.MobHeight = v end})
travel_box:toggle({name="Random CFrame", flag="RandomCFrame", def=false, callback=function(v) RandomCFrame = v end})

quest_box:dropdown({name="Select Boss", flag="SelectedBoss", options=U, def=U[1] or "", callback=function(v) _G.SelectedBoss = v end})
quest_box:toggle({name="Auto Accept Quest", flag="Quest_Accept", def=false, callback=function(v) _G.Quest_Accept = v end})
quest_box:toggle({name="Use Bosses", flag="UseBoss", def=false, callback=function(v) _G.UseBoss = v end})

mob_opts:dropdown({name="Select Weapon", flag="SelectWeapon_D", options={"None"}, def="None", callback=function(v) _G.SelectWeapon = v ~= "None" and v or nil end})
mob_opts:slider({name="Bring Range", flag="BringRange", min=50, max=500, def=235, suffix="", callback=function(v) _G.BringRange = v end})
mob_opts:slider({name="Max Bring Mobs", flag="MaxBringMobs", min=1, max=30, def=18, suffix="", callback=function(v) _G.MaxBringMobs = v end})
mob_opts:toggle({name="Low CPU Mode", flag="LowCpuMode", def=false, callback=function(v) if v then LowCpu() end end})

-- Mastery subtab
local mas_boxes = mastery:groupboxes({boxes={"Mastery Farm","Mastery Options","Health Options","Skill Settings"}})
local mas_core = mas_boxes.top_left
local mas_opts = mas_boxes.top_right
local health_opts = mas_boxes.bottom_left
local skill_set = mas_boxes.bottom_right

mas_core:toggle({name="Farm Mastery", flag="FarmMastery_G", def=false, callback=function(v) _G.FarmMastery_G = v end})
mas_core:toggle({name="Farm Mastery Dev", flag="FarmMastery_Dev", def=false, callback=function(v) _G.FarmMastery_Dev = v end})
mas_core:toggle({name="Farm Blaze EM", flag="FarmBlazeEM", def=false, callback=function(v) _G.FarmBlazeEM = v end})

mas_opts:dropdown({name="Mastery Method", flag="MasteryMethod", options={"Auto","Fruit","Sword","Gun"}, def="Auto", callback=function(v) _G.MasteryMethod = v end})
mas_opts:slider({name="Health Limit", flag="HealthM", min=0, max=5000, def=500, suffix="HP", callback=function(v) HealthM = v end})

health_opts:toggle({name="Auto Eat Fruit", flag="AutoEatFruit", def=false, callback=function(v) _G.AutoEatFruit = v end})
health_opts:toggle({name="Infinity Energy", flag="InfinityEnergy", def=false, callback=function(v) _G.InfinityEnergy = v; if v then getInfinity_Ability("Energy", true) end end})
health_opts:toggle({name="Infinity Soru", flag="InfinitySoru", def=false, callback=function(v) _G.InfinitySoru = v; if v then getInfinity_Ability("Soru", true) end end})
health_opts:toggle({name="Observation Haki", flag="ObservationHaki", def=false, callback=function(v) if v then getInfinity_Ability("Observation", true) end end})

skill_set:toggle({name="Use Z Skill", flag="UseZ", def=true, callback=function(v) _G.UseZ = v end})
skill_set:toggle({name="Use X Skill", flag="UseX", def=true, callback=function(v) _G.UseX = v end})
skill_set:toggle({name="Use C Skill", flag="UseC", def=false, callback=function(v) _G.UseC = v end})
skill_set:toggle({name="Prehis Skills", flag="Prehis_Skills", def=false, callback=function(v) _G.Prehis_Skills = v end})

-- Special subtab
local sp_boxes = special:groupboxes({boxes={"Auto Stats","Stat Options","Collect & Drop","Misc Options"}})
local stats_box = sp_boxes.top_left
local stat_opts = sp_boxes.top_right
local collect_box = sp_boxes.bottom_left
local misc_sp = sp_boxes.bottom_right

stats_box:toggle({name="Auto Stats", flag="AutoStats", def=false, callback=function(v) _G.AutoStats = v end})
stats_box:dropdown({name="Stat Type", flag="StatType", options={"Melee","Defense","Sword","Gun","Devil"}, def="Melee", callback=function(v) _G.StatType = v end})
stats_box:slider({name="Stat Amount", flag="StatAmount", min=1, max=50, def=10, suffix="", callback=function(v) _G.StatAmount = v end})

stat_opts:toggle({name="Auto Assign Points", flag="AutoPoints", def=false, callback=function(v) _G.AutoPoints = v end})
stat_opts:dropdown({name="Point Preference", flag="PointPref", options={"Melee","Defense","Sword","Gun","Devil"}, def="Melee", callback=function(v) _G.PointPref = v end})

collect_box:toggle({name="Collect Fruits", flag="CollectFruits", def=false, callback=function(v) _G.CollectFruits = v; collectFruits(v) end})
collect_box:toggle({name="Store Fruits", flag="StoreFruits", def=false, callback=function(v) _G.StoreFruits = v end})
collect_box:button({name="Store Fruit Now", callback=function() UpdStFruit() end})
collect_box:button({name="Drop All Fruits", callback=function() DropFruits() end})

misc_sp:toggle({name="Team Pirates", flag="TeamPirates", def=false, callback=function(v) if v then Pirates() end end})
misc_sp:toggle({name="Team Marines", flag="TeamMarines", def=false, callback=function(v) if v then Marines() end end})
misc_sp:toggle({name="Server Hop", flag="ServerHop", def=false, callback=function(v) _G.ServerHop = v end})
misc_sp:button({name="Hop Server Now", callback=function() Hop() end})

-- TAB 2: SEA & WORLD
local sea, kitsune, mirage = win:tab({name="Sea & World", icon=icons.shield, tabs={"Sea Events","Kitsune","Mirage & Race"}})

-- Sea Events subtab
local sea_boxes = sea:groupboxes({boxes={"Sea Beast","Sea Quest","Boat Options","Sea Checks"}})
local beast_box = sea_boxes.top_left
local sea_quest = sea_boxes.top_right
local boat_box = sea_boxes.bottom_left
local sea_checks = sea_boxes.bottom_right

beast_box:toggle({name="Sea Beast Farm", flag="SeaBeast1", def=false, callback=function(v) _G.SeaBeast1 = v end})
beast_box:toggle({name="Leviathan Farm", flag="Leviathan1", def=false, callback=function(v) _G.Leviathan1 = v end})
beast_box:toggle({name="PirateGrand Brigade", flag="PGB", def=false, callback=function(v) _G.PGB = v end})
beast_box:toggle({name="Fish Boat", flag="FishBoat", def=false, callback=function(v) _G.FishBoat = v end})

sea_quest:toggle({name="Complete Sea Trials", flag="Complete_Trials", def=false, callback=function(v) _G.Complete_Trials = v end})
sea_quest:toggle({name="Resolve Sea Quest", flag="VoidSea1Quest", def=false, callback=function(v) _G.VoidSea1Quest = v end})
sea_quest:toggle({name="Auto Buy Boat", flag="AutoBuyBoat", def=false, callback=function(v) _G.AutoBuyBoat = v end})

boat_box:toggle({name="Spawn Boat", flag="SpawnBoat", def=false, callback=function(v) _G.SpawnBoat = v end})
boat_box:toggle({name="Protect Boat", flag="ProtectBoat", def=false, callback=function(v) _G.ProtectBoat = v end})

sea_checks:toggle({name="Check Sea Beast", flag="CheckSeaBeast", def=false, callback=function(v) _G.CheckSeaBeast = v end})
sea_checks:toggle({name="Check Leviathan", flag="CheckLeviathan", def=false, callback=function(v) _G.CheckLeviathan = v end})
sea_checks:toggle({name="Check Piranhas", flag="CheckPiranha", def=false, callback=function(v) _G.CheckPiranha = v end})
sea_checks:toggle({name="Check Fish Crew", flag="CheckFishCrew", def=false, callback=function(v) _G.CheckFishCrew = v end})

-- Kitsune subtab
local kit_boxes = kitsune:groupboxes({boxes={"Kitsune Farm","Kitsune Options","Material Farm","Ghost Options"}})
local kit_core = kit_boxes.top_left
local kit_opts = kit_boxes.top_right
local mat_farm = kit_boxes.bottom_left
local ghost_opts = kit_boxes.bottom_right

kit_core:toggle({name="Kitsune Farm", flag="KitsuneFarm", def=false, callback=function(v) _G.KitsuneFarm = v end})
kit_core:toggle({name="Kitsune Shrine", flag="KitsuneShrine", def=false, callback=function(v) _G.KitsuneShrine = v end})
kit_opts:toggle({name="Auto Revive", flag="KitsuneRevive", def=false, callback=function(v) _G.KitsuneRevive = v end})
kit_opts:toggle({name="Kitsune Skills", flag="KitsuneSkills", def=false, callback=function(v) _G.KitsuneSkills = v end})

mat_farm:toggle({name="Material Farm", flag="MaterialFarm", def=false, callback=function(v) _G.MaterialFarm = v end})
mat_farm:dropdown({name="Select Material", flag="SelectedMaterial", options=#v > 0 and v or {"None"}, def=#v > 0 and v[1] or "None", callback=function(val) _G.SelectedMaterial = val end})

ghost_opts:toggle({name="Ghost Farm", flag="GhostFarm", def=false, callback=function(v) _G.GhostFarm = v end})
ghost_opts:toggle({name="Auto Ghost Quest", flag="GhostQuest", def=false, callback=function(v) _G.GhostQuest = v end})

-- Mirage & Race subtab
local mir_boxes = mirage:groupboxes({boxes={"Mirage Island","Race Options","Race V3","Misc Sea"}})
local mir_core = mir_boxes.top_left
local race_opts = mir_boxes.top_right
local race_v3 = mir_boxes.bottom_left
local misc_sea = mir_boxes.bottom_right

mir_core:toggle({name="Mirage Island", flag="MirageIsland", def=false, callback=function(v) _G.MirageIsland = v end})
mir_core:toggle({name="Auto Find Mirage", flag="AutoMirage", def=false, callback=function(v) _G.AutoMirage = v end})

race_opts:toggle({name="Race V3 Awakening", flag="RaceV3", def=false, callback=function(v) _G.RaceV3 = v end})
race_opts:dropdown({name="Select Race", flag="SelectedRace", options={"Human","Mink","Shark","Sky","Cyborg"}, def="Human", callback=function(v) _G.SelectedRace = v end})

race_v3:toggle({name="Complete Race Trials", flag="CompleteRaceTrials", def=false, callback=function(v) _G.CompleteRaceTrials = v end})
race_v3:toggle({name="Auto Race Quest", flag="AutoRaceQuest", def=false, callback=function(v) _G.AutoRaceQuest = v end})

misc_sea:toggle({name="Snow Island", flag="SnowIsland", def=false, callback=function(v) _G.SnowIsland = v end})
misc_sea:toggle({name="Submerged Island", flag="SubmergedIsland", def=false, callback=function(v) _G.SubmergedIsland = v end})

-- TAB 3: ITEMS & STYLES
local styles, swords, cdk = win:tab({name="Items & Styles", icon=icons.zap, tabs={"Fighting Styles","Swords","Elite & CDK"}})

-- Fighting Styles subtab
local fs_boxes = styles:groupboxes({boxes={"Style Mastery","Sharkman Karate","Dragon Talon","Electric Claw"}})
local fs_core = fs_boxes.top_left
local shark_box = fs_boxes.top_right
local dragon_box = fs_boxes.bottom_left
local electric_box = fs_boxes.bottom_right

fs_core:toggle({name="Farm Fighting Style", flag="FarmFightingStyle", def=false, callback=function(v) _G.FarmFightingStyle = v end})
fs_core:dropdown({name="Select Style", flag="SelectedStyle", options={"Sharkman Karate","Dragon Talon","Electric Claw","Death Step","Superhuman"}, def="Sharkman Karate", callback=function(v) _G.SelectedStyle = v end})

shark_box:toggle({name="Sharkman Karate", flag="SharkmanKarate", def=false, callback=function(v) _G.SharkmanKarate = v end})
shark_box:toggle({name="Auto Buy Sharkman", flag="BuySharkman", def=false, callback=function(v) _G.BuySharkman = v end})

dragon_box:toggle({name="Dragon Talon", flag="DragonTalon", def=false, callback=function(v) _G.DragonTalon = v end})
dragon_box:toggle({name="Auto Buy Dragon", flag="BuyDragon", def=false, callback=function(v) _G.BuyDragon = v end})

electric_box:toggle({name="Electric Claw", flag="ElectricClaw", def=false, callback=function(v) _G.ElectricClaw = v end})
electric_box:toggle({name="Death Step", flag="DeathStep", def=false, callback=function(v) _G.DeathStep = v end})

-- Swords subtab
local sw_boxes = swords:groupboxes({boxes={"Sword Mastery","Sword Obtain","Sword Upgrade","Sword Skills"}})
local sw_core = sw_boxes.top_left
local sw_obtain = sw_boxes.top_right
local sw_upgrade = sw_boxes.bottom_left
local sw_skills = sw_boxes.bottom_right

sw_core:toggle({name="Farm Sword Mastery", flag="FarmSwordMas", def=false, callback=function(v) _G.FarmSwordMas = v end})
sw_core:toggle({name="Auto Equip Sword", flag="AutoEquipSword", def=false, callback=function(v) _G.AutoEquipSword = v end})
sw_core:dropdown({name="Select Sword", flag="SelectedSword", options={"Saber","Cutlass","Sword","Katana","Pole","Trident","Dark Blade","Bisento"}, def="Saber", callback=function(v) _G.SelectedSword = v end})

sw_obtain:toggle({name="Get Dark Blade", flag="GetDarkBlade", def=false, callback=function(v) _G.GetDarkBlade = v end})
sw_obtain:toggle({name="Get Bisento", flag="GetBisento", def=false, callback=function(v) _G.GetBisento = v end})
sw_obtain:toggle({name="Get True Triple Katana", flag="GetTTK", def=false, callback=function(v) _G.GetTTK = v end})

sw_upgrade:toggle({name="Upgrade Sword", flag="UpgradeSword", def=false, callback=function(v) _G.UpgradeSword = v end})
sw_upgrade:dropdown({name="Upgrade Target", flag="UpgradeTarget", options={"Yoru","Saber","Bisento","Dark Blade"}, def="Saber", callback=function(v) _G.UpgradeTarget = v end})

sw_skills:toggle({name="Use Sword Z", flag="SwordZ", def=true, callback=function(v) _G.SwordZ = v end})
sw_skills:toggle({name="Use Sword X", flag="SwordX", def=true, callback=function(v) _G.SwordX = v end})

-- Elite & CDK subtab
local cdk_boxes = cdk:groupboxes({boxes={"CDK Farm","Elite Hunter","Elite Raid","Hallow Scythe"}})
local cdk_core = cdk_boxes.top_left
local elite_box = cdk_boxes.top_right
local elite_raid = cdk_boxes.bottom_left
local hallow_box = cdk_boxes.bottom_right

cdk_core:toggle({name="CDK Farm", flag="CDK_Farm", def=false, callback=function(v) _G.CDK_Farm = v end})
cdk_core:toggle({name="Auto CDK Quest", flag="CDK_Quest", def=false, callback=function(v) _G.CDK_Quest = v end})
cdk_core:toggle({name="CDK Material Farm", flag="CDK_Material", def=false, callback=function(v) _G.CDK_Material = v end})

elite_box:toggle({name="Elite Hunter", flag="EliteHunter", def=false, callback=function(v) _G.EliteHunter = v end})
elite_box:toggle({name="Auto Elite Quest", flag="AutoEliteQuest", def=false, callback=function(v) _G.AutoEliteQuest = v end})
elite_box:toggle({name="Spawn Elite", flag="SpawnElite", def=false, callback=function(v) _G.SpawnElite = v end})

elite_raid:toggle({name="Elite Raid", flag="EliteRaid", def=false, callback=function(v) _G.EliteRaid = v end})
elite_raid:toggle({name="Auto Join Elite Raid", flag="AutoJoinEliteRaid", def=false, callback=function(v) _G.AutoJoinEliteRaid = v end})

hallow_box:toggle({name="Hallow Scythe", flag="HallowScythe", def=false, callback=function(v) _G.HallowScythe = v end})
hallow_box:toggle({name="Auto Hallow Quest", flag="HallowQuest", def=false, callback=function(v) _G.HallowQuest = v end})

-- TAB 4: RAIDS & SPECIAL
local raids, dojo, prehis = win:tab({name="Raids & Special", icon=icons.target, tabs={"Raids","Drago Dojo","Prehistoric"}})

-- Raids subtab
local raid_boxes = raids:groupboxes({boxes={"Raid Farm","Raid Settings","Chip Farm","Island Options"}})
local raid_core = raid_boxes.top_left
local raid_set = raid_boxes.top_right
local chip_farm = raid_boxes.bottom_left
local island_opts = raid_boxes.bottom_right

raid_core:toggle({name="Auto Raid", flag="AutoRaid", def=false, callback=function(v) _G.AutoRaid = v end})
raid_core:toggle({name="Auto Use Chip", flag="AutoUseChip", def=false, callback=function(v) _G.AutoUseChip = v end})
raid_core:dropdown({name="Select Raid Fruit", flag="RaidFruit", options=j, def=j[1] or "Flame", callback=function(v) _G.RaidFruit = v end})

raid_set:toggle({name="Skip Cutscene", flag="SkipCutscene", def=true, callback=function(v) _G.SkipCutscene = v end})
raid_set:toggle({name="Auto Collect Chips", flag="AutoCollectChips", def=false, callback=function(v) _G.AutoCollectChips = v end})
raid_set:slider({name="Raid HP Limit", flag="RaidHPLimit", min=0, max=5000, def=100, suffix="HP", callback=function(v) _G.RaidHPLimit = v end})

chip_farm:toggle({name="Microchip Farm", flag="MicrochipFarm", def=false, callback=function(v) _G.MicrochipFarm = v end})
chip_farm:toggle({name="Island Farm", flag="IslandFarm", def=false, callback=function(v) _G.IslandFarm = v end})

island_opts:toggle({name="God's Island", flag="GodsIsland", def=false, callback=function(v) _G.GodsIsland = v end})
island_opts:toggle({name="Tiki Island", flag="TikiIsland", def=false, callback=function(v) _G.TikiIsland = v end})

-- Drago Dojo subtab
local dojo_boxes = dojo:groupboxes({boxes={"Dojo Farm","Drago Options","Drago Skills","Drago Quest"}})
local dojo_core = dojo_boxes.top_left
local drago_opts = dojo_boxes.top_right
local drago_skills = dojo_boxes.bottom_left
local drago_quest = dojo_boxes.bottom_right

dojo_core:toggle({name="Drago Dojo Farm", flag="DragoDojo", def=false, callback=function(v) _G.DragoDojo = v end})
dojo_core:toggle({name="Auto Dojo Quest", flag="AutoDojoQuest", def=false, callback=function(v) _G.AutoDojoQuest = v end})
dojo_core:toggle({name="Auto Dojo Win", flag="AutoDojoWin", def=false, callback=function(v) _G.AutoDojoWin = v end})

drago_opts:toggle({name="Spawn Drago NPC", flag="SpawnDrago", def=false, callback=function(v) _G.SpawnDrago = v end})
drago_opts:toggle({name="Drago Boss Farm", flag="DragoBoss", def=false, callback=function(v) _G.DragoBoss = v end})

drago_skills:toggle({name="Drago Z Skill", flag="DragoZ", def=true, callback=function(v) _G.DragoZ = v end})
drago_skills:toggle({name="Drago X Skill", flag="DragoX", def=true, callback=function(v) _G.DragoX = v end})

drago_quest:toggle({name="Complete Dojo Trials", flag="DojoTrials", def=false, callback=function(v) _G.DojoTrials = v end})
drago_quest:toggle({name="Dojo Material Farm", flag="DojoMaterials", def=false, callback=function(v) _G.DojoMaterials = v end})

-- Prehistoric subtab
local pre_boxes = prehis:groupboxes({boxes={"Prehistoric Farm","T-Rex Options","Bone Farm","Prehistoric Quest"}})
local pre_core = pre_boxes.top_left
local trex_opts = pre_boxes.top_right
local bone_farm = pre_boxes.bottom_left
local pre_quest = pre_boxes.bottom_right

pre_core:toggle({name="Prehistoric Farm", flag="Prehistoric", def=false, callback=function(v) _G.Prehistoric = v end})
pre_core:toggle({name="Auto Prehis Quest", flag="AutoPrehisQuest", def=false, callback=function(v) _G.AutoPrehisQuest = v end})

trex_opts:toggle({name="T-Rex Farm", flag="TRexFarm", def=false, callback=function(v) _G.TRexFarm = v end})
trex_opts:toggle({name="T-Rex Boss", flag="TRexBoss", def=false, callback=function(v) _G.TRexBoss = v end})

bone_farm:toggle({name="Bone Farm", flag="BoneFarm", def=false, callback=function(v) _G.BoneFarm = v end})
bone_farm:toggle({name="Fossil Farm", flag="FossilFarm", def=false, callback=function(v) _G.FossilFarm = v end})

pre_quest:toggle({name="Prehis Skills", flag="Prehis_Skills_Tab", def=false, callback=function(v) _G.Prehis_Skills = v end})
pre_quest:toggle({name="Complete Prehis Trials", flag="PrehisTrials", def=false, callback=function(v) _G.PrehisTrials = v end})

-- TAB 5: PLAYER
local combat, config_tab, teleport_tab = win:tab({name="Player", icon=icons.user, tabs={"Combat/PVP","Config","Teleport"}})

-- Combat/PVP subtab
local pvp_boxes = combat:groupboxes({boxes={"Aim Settings","PVP Options","AimBot","Anti-AFK"}})
local aim_box = pvp_boxes.top_left
local pvp_opts = pvp_boxes.top_right
local aimbot_box = pvp_boxes.bottom_left
local anti_afk = pvp_boxes.bottom_right

aim_box:toggle({name="Aim Method", flag="AimMethod", def=false, callback=function(v) _G.AimMethod = v end})
aim_box:dropdown({name="AB Method", flag="ABMethod", options={"AimBots Skill","Auto Aimbots","Manual"}, def="Manual", callback=function(v) ABmethod = v end})
aim_box:toggle({name="Silent Aim", flag="SilentAim", def=false, callback=function(v) _G.SilentAim = v end})

pvp_opts:toggle({name="Kill Players", flag="KillPlayers", def=false, callback=function(v) _G.KillPlayers = v end})
pvp_opts:toggle({name="Auto Farm Players", flag="AutoFarmPlayers", def=false, callback=function(v) _G.AutoFarmPlayers = v end})
pvp_opts:toggle({name="Noclip", flag="Noclip", def=false, callback=function(v) _G.Noclip = v end})
pvp_opts:toggle({name="Infinite Jump", flag="InfJump", def=false, callback=function(v) _G.InfJump = v end})

aimbot_box:toggle({name="Auto Dodge", flag="AutoDodge", def=false, callback=function(v) _G.AutoDodge = v end})
aimbot_box:toggle({name="Fast Attack", flag="FastAttack", def=false, callback=function(v) _G.FastAttack = v end})
aimbot_box:toggle({name="Superhuman Speed", flag="SuperSpeed", def=false, callback=function(v) _G.SuperSpeed = v end})

anti_afk:toggle({name="Anti-AFK", flag="AntiAFK", def=false, callback=function(v) _G.AntiAFK = v end})
anti_afk:toggle({name="Anti-AFK Click", flag="AntiAFKClick", def=false, callback=function(v) _G.AntiAFKClick = v end})
anti_afk:button({name="Enable Anti-AFK", callback=function() n:ClickButton2(Vector2.new()) end})

-- Config subtab (player preferences)
local cfg_boxes = config_tab:groupboxes({boxes={"Visual Settings","Farm Config","Notification","Reset"}})
local vis_cfg = cfg_boxes.top_left
local farm_cfg = cfg_boxes.top_right
local notif_cfg = cfg_boxes.bottom_left
local reset_cfg = cfg_boxes.bottom_right

vis_cfg:toggle({name="Show Highlights", flag="ShowHighlights", def=true, callback=function(v) _G.ShowHighlights = v end})
vis_cfg:toggle({name="ESP Players", flag="ESP_Players", def=false, callback=function(v) _G.ESP_Players = v end})
vis_cfg:toggle({name="ESP Mobs", flag="ESP_Mobs", def=false, callback=function(v) _G.ESP_Mobs = v end})

farm_cfg:slider({name="Farm Delay", flag="FarmDelay", min=0, max=2, def=0.2, suffix="s", callback=function(v) T = v end})
farm_cfg:toggle({name="Auto Respawn", flag="AutoRespawn", def=true, callback=function(v) _G.AutoRespawn = v end})
farm_cfg:toggle({name="Safe Zone Farm", flag="SafeZoneFarm", def=false, callback=function(v) _G.SafeZoneFarm = v end})

notif_cfg:toggle({name="Level Up Notif", flag="LvlUpNotif", def=true, callback=function(v) _G.LvlUpNotif = v end})
notif_cfg:toggle({name="Quest Complete", flag="QuestNotif", def=true, callback=function(v) _G.QuestNotif = v end})

reset_cfg:button({name="Reset Character", callback=function() d.Character.Humanoid.Health = 0 end})
reset_cfg:button({name="Rejoin Server", callback=function() game:GetService("TeleportService"):Teleport(game.PlaceId) end})

-- Teleport subtab
local tp_boxes = teleport_tab:groupboxes({boxes={"World 1 TPs","World 2 TPs","World 3 TPs","Custom TP"}})
local w1_tp = tp_boxes.top_left
local w2_tp = tp_boxes.top_right
local w3_tp = tp_boxes.bottom_left
local custom_tp = tp_boxes.bottom_right

w1_tp:label({text="=== World 1 ==="})
w1_tp:button({name="Marine Starter", callback=function() _tp(CFrame.new(976.8, 124.4, 1817.4)) end})
w1_tp:button({name="Middle Town", callback=function() _tp(CFrame.new(386.1, 174.4, 836.9)) end})
w1_tp:button({name="Jungle", callback=function() _tp(CFrame.new(-1184.3, 24, 385.3)) end})
w1_tp:button({name="Pirate Village", callback=function() _tp(CFrame.new(-1404, 65, 3340)) end})
w1_tp:button({name="Desert", callback=function() _tp(CFrame.new(940, 127, 4360)) end})

w2_tp:label({text="=== World 2 ==="})
w2_tp:button({name="Kingdom of Rose", callback=function() _tp(CFrame.new(-679, 98, 5739)) end})
w2_tp:button({name="Green Zone", callback=function() _tp(CFrame.new(-3011, 872, 4203)) end})
w2_tp:button({name="Graveyard", callback=function() _tp(CFrame.new(-8236, 42, 5761)) end})
w2_tp:button({name="Snow Mountain", callback=function() _tp(CFrame.new(1086, 870, -3440)) end})

w3_tp:label({text="=== World 3 ==="})
w3_tp:button({name="Port Town", callback=function() _tp(CFrame.new(-3007, 4, 1953)) end})
w3_tp:button({name="Ussop Island", callback=function() _tp(CFrame.new(-4789, 23, 3803)) end})
w3_tp:button({name="Floating Turtle", callback=function() _tp(CFrame.new(-8044, 2352, 1983)) end})
w3_tp:button({name="Sea of Treats", callback=function() _tp(CFrame.new(-877, 118, -11032)) end})

custom_tp:label({text="=== Special ==="})
custom_tp:button({name="Mirage Island", callback=function() _tp(CFrame.new(-13946, 5, -7200)) end})
custom_tp:button({name="Castle on the Sea", callback=function() _tp(CFrame.new(-11952, 927, -12600)) end})
custom_tp:button({name="Tiki Outpost", callback=function() _tp(CFrame.new(-16269, 25, 1373)) end})

-- TAB 6: SHOP & MISC
local shop, fruits, server = win:tab({name="Shop & Misc", icon=icons.settings, tabs={"Shop","Fruits","Server"}})

-- Shop subtab
local shop_boxes = shop:groupboxes({boxes={"Auto Buy","Beli Farm","Flower Farm","Gem Options"}})
local buy_box = shop_boxes.top_left
local beli_box = shop_boxes.top_right
local flower_box = shop_boxes.bottom_left
local gem_box = shop_boxes.bottom_right

buy_box:toggle({name="Auto Buy Fruit", flag="AutoBuyFruit", def=false, callback=function(v) _G.AutoBuyFruit = v end})
buy_box:dropdown({name="Buy Fruit", flag="BuyFruitName", options=j, def=j[1] or "Flame", callback=function(v) _G.BuyFruitName = v end})
buy_box:toggle({name="Auto Buy Devil Fruit", flag="AutoBuyDevil", def=false, callback=function(v) _G.AutoBuyDevil = v end})
buy_box:toggle({name="Auto Restock", flag="AutoRestock", def=false, callback=function(v) _G.AutoRestock = v end})

beli_box:toggle({name="Auto Farm Beli", flag="AutoFarmBeli", def=false, callback=function(v) _G.AutoFarmBeli = v end})
beli_box:toggle({name="Beli Material Sell", flag="BeliMaterialSell", def=false, callback=function(v) _G.BeliMaterialSell = v end})
beli_box:button({name="Sell All Materials", callback=function() pcall(function() Q.Remotes.CommF_:InvokeServer("SellAllMaterials") end) end})

flower_box:toggle({name="Flower Farm", flag="FlowerFarm", def=false, callback=function(v) _G.FlowerFarm = v end})
flower_box:toggle({name="Auto Collect Flowers", flag="AutoFlowers", def=false, callback=function(v) _G.AutoFlowers = v end})

gem_box:toggle({name="Gem Farm", flag="GemFarm", def=false, callback=function(v) _G.GemFarm = v end})
gem_box:toggle({name="Auto Buy Gems", flag="AutoBuyGems", def=false, callback=function(v) _G.AutoBuyGems = v end})

-- Fruits subtab
local fr_boxes = fruits:groupboxes({boxes={"Fruit Sniper","Fruit Options","Fruit Notify","Fruit List"}})
local sniper_box = fr_boxes.top_left
local fr_opts = fr_boxes.top_right
local fr_notify = fr_boxes.bottom_left
local fr_list = fr_boxes.bottom_right

sniper_box:toggle({name="Fruit Sniper", flag="FruitSniper", def=false, callback=function(v) _G.FruitSniper = v end})
sniper_box:toggle({name="Auto Eat Spawned", flag="AutoEatSpawned", def=false, callback=function(v) _G.AutoEatSpawned = v end})
sniper_box:toggle({name="Fruit ESP", flag="FruitESP", def=false, callback=function(v) _G.FruitESP = v end})

fr_opts:toggle({name="Auto Collect Fruits", flag="AutoCollectFruits", def=false, callback=function(v) _G.AutoCollectFruits = v end})
fr_opts:toggle({name="Ignore Devil Fruit", flag="IgnoreDevil", def=false, callback=function(v) _G.IgnoreDevil = v end})
fr_opts:button({name="Store All Fruits", callback=function() UpdStFruit() end})

fr_notify:toggle({name="Notify On Spawn", flag="FruitNotify", def=true, callback=function(v) _G.FruitNotify = v end})
fr_notify:dropdown({name="Notif Sound", flag="NotifSound", options={"Default","None","Custom"}, def="Default", callback=function(v) _G.NotifSound = v end})

fr_list:dropdown({name="Fruit Priority", flag="FruitPriority", options=j, def=j[1] or "Flame", callback=function(v) _G.FruitPriority = v end})
fr_list:toggle({name="Only Priority Fruit", flag="OnlyPriority", def=false, callback=function(v) _G.OnlyPriority = v end})

-- Server subtab
local srv_boxes = server:groupboxes({boxes={"Server Hop","Player List","Server Info","Anti Options"}})
local hop_box = srv_boxes.top_left
local player_box = srv_boxes.top_right
local info_box = srv_boxes.bottom_left
local anti_box = srv_boxes.bottom_right

hop_box:toggle({name="Auto Server Hop", flag="AutoServerHop", def=false, callback=function(v) _G.AutoServerHop = v end})
hop_box:toggle({name="Hop On Boss Dead", flag="HopOnBossDead", def=false, callback=function(v) _G.HopOnBossDead = v end})
hop_box:button({name="Hop Now", callback=function() Hop() end})
hop_box:slider({name="Hop Delay", flag="HopDelay", min=1, max=60, def=5, suffix="s", callback=function(v) _G.HopDelay = v end})

player_box:label({text="Players in Server:"})
player_box:toggle({name="Show Players", flag="ShowPlayers", def=false, callback=function(v) _G.ShowPlayers = v end})
player_box:toggle({name="Copy Player TP", flag="CopyPlayerTP", def=false, callback=function(v) _G.CopyPlayerTP = v end})

info_box:label({text="Server Info"})
info_box:button({name="Refresh Info", callback=function()
    local level = r or 0
    local world = World1 and "World 1" or World2 and "World 2" or World3 and "World 3" or "Unknown"
    print("Level: " .. level .. " | World: " .. world)
end})

anti_box:toggle({name="Anti-Ban", flag="AntiBan", def=false, callback=function(v) _G.AntiBan = v end})
anti_box:toggle({name="Anti-Cheat Bypass", flag="AntiCheat", def=false, callback=function(v) _G.AntiCheat = v end})
anti_box:toggle({name="Private Server", flag="PrivateServer", def=false, callback=function(v) _G.PrivateServer = v end})

-- ============================================================
-- TASK.SPAWN LOOPS (preserved from original script logic)
-- ============================================================

-- Auto Farm loop
task.spawn(function()
    while task.wait(T) do
        if _G.AutoFarm then
            local char = d.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then task.wait(3) end
                if _G.AutoQuest then
                    pcall(function() CheckQuest() end)
                end
                local target = GetConnectionEnemies(_G.SelectedBoss or "")
                if target and f.Alive(target) then
                    f.Kill(target, true)
                end
            end
        end
    end
end)

-- Auto Attack loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoAttack_G then
            f.Activate()
        end
    end
end)

-- Bring Enemy loop
task.spawn(function()
    while task.wait(0.3) do
        if _B then
            BringEnemy()
        end
    end
end)

-- Mastery farm loop
task.spawn(function()
    while task.wait(T) do
        if _G.FarmMastery_G then
            local char = d.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local target = GetConnectionEnemies(_G.SelectedBoss or "")
                if target and f.Alive(target) then
                    f.Mas(target, true)
                end
            end
        end
    end
end)

-- Anti-AFK loop
task.spawn(function()
    while task.wait(60) do
        if _G.AntiAFK then
            pcall(function() n:ClickButton2(Vector2.new()) end)
        end
    end
end)

-- Material Farm loop
task.spawn(function()
    while task.wait(T) do
        if _G.MaterialFarm and _G.SelectedMaterial then
            pcall(function() MaterialMon(_G.SelectedMaterial) end)
        end
    end
end)

-- Auto Quest loop
task.spawn(function()
    while task.wait(1) do
        if _G.AutoQuest or _G.AcceptQuest then
            pcall(function() CheckQuest() end)
        end
    end
end)

-- VoidTravel loop
task.spawn(function()
    while task.wait(T) do
        if _G.VoidTravelEnabled then
            pcall(function()
                local char = d.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- travel logic handled by VoidTravel system
                    end
                end
            end)
        end
    end
end)

-- Sea Beast farm
task.spawn(function()
    while task.wait(T) do
        if _G.SeaBeast1 then
            local sb = workspace.SeaBeasts:FindFirstChild("SeaBeast1")
            if sb then
                local root = sb:FindFirstChild("HumanoidRootPart")
                if root then
                    f.KillSea(sb, true)
                end
            end
        end
    end
end)

-- Leviathan farm
task.spawn(function()
    while task.wait(T) do
        if _G.Leviathan1 then
            local lev = workspace.SeaBeasts:FindFirstChild("Leviathan")
            if lev then
                local root = lev:FindFirstChild("HumanoidRootPart")
                if root then
                    f.KillSea(lev, true)
                end
            end
        end
    end
end)

-- Noclip loop
task.spawn(function()
    W.Heartbeat:Connect(function()
        if _G.Noclip then
            local char = d.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- Infinite Jump
local UIS = game:GetService("UserInputService")
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        local char = d.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Collect Fruits loop
task.spawn(function()
    while task.wait(1) do
        if _G.CollectFruits then
            collectFruits(true)
        end
    end
end)

-- Store Fruits loop
task.spawn(function()
    while task.wait(5) do
        if _G.StoreFruits then
            UpdStFruit()
        end
    end
end)

-- Use Skills loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.UseSkills_G then
            if _G.UseZ then Useskills("Blox Fruit", "Z") end
            if _G.UseX then Useskills("Blox Fruit", "X") end
            if _G.UseC then Useskills("Blox Fruit", "C") end
        end
    end
end)

-- Sword Skills loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.FarmSwordMas then
            if _G.SwordZ then Useskills("Sword", "Z") end
            if _G.SwordX then Useskills("Sword", "X") end
        end
    end
end)

-- Init config page (saves/loads settings)
library:init_config(win)

-- ============================================================
-- MELLENIUM UI
-- ============================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/mellenium-ui-/main/Millenium/Library.lua"))()
local icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/mellenium-ui-/main/Icons.lua"))()

local win = library:window({
    name = "VoidHub",
    subtitle = "BloxFruits",
    icon = icons.sword,
    closeMode = "hide",
    mobileToggle = true,
})

-- TAB 1: FARM
local af, mastery, special = win:tab({name="Farm", icon=icons.sword, tabs={"Auto Farm","Mastery","Special"}})

-- Auto Farm subtab
local af_boxes = af:groupboxes({boxes={"Core Farm","Travel","Quest","Mob Options"}})
local core = af_boxes.top_left
local travel_box = af_boxes.top_right
local quest_box = af_boxes.bottom_left
local mob_opts = af_boxes.bottom_right

core:toggle({name="Auto Farm", flag="AutoFarm", def=false, callback=function(v) _G.AutoFarm = v end})
core:toggle({name="Auto Quest", flag="AutoQuest", def=false, callback=function(v) _G.AutoQuest = v end})
core:toggle({name="Bring Mobs", flag="BringEnemy_G", def=false, callback=function(v) _B = v end})
core:toggle({name="Auto Attack", flag="AutoAttack_G", def=false, callback=function(v) _G.AutoAttack_G = v end})
core:toggle({name="Accept Quests", flag="AcceptQuest", def=false, callback=function(v) _G.AcceptQuest = v end})
core:toggle({name="Use Skills", flag="UseSkills_G", def=false, callback=function(v) _G.UseSkills_G = v end})

travel_box:toggle({name="Auto Teleport", flag="VoidTravelEnabled", def=false, callback=function(v) _G.VoidTravelEnabled = v end})
travel_box:toggle({name="Smooth Tween TP", flag="SmoothTween", def=true, callback=function(v) _G.SmoothTween = v end})
travel_box:slider({name="Tween Speed", flag="TweenSpeed", min=50, max=500, def=200, suffix="", callback=function(v) _G.TweenSpeed = v end})
travel_box:slider({name="Mob Height", flag="MobHeight", min=0, max=100, def=20, suffix="", callback=function(v) _G.MobHeight = v end})
travel_box:toggle({name="Random CFrame", flag="RandomCFrame", def=false, callback=function(v) RandomCFrame = v end})

quest_box:dropdown({name="Select Boss", flag="SelectedBoss", options=U, def=U[1] or "", callback=function(v) _G.SelectedBoss = v end})
quest_box:toggle({name="Auto Accept Quest", flag="Quest_Accept", def=false, callback=function(v) _G.Quest_Accept = v end})
quest_box:toggle({name="Use Bosses", flag="UseBoss", def=false, callback=function(v) _G.UseBoss = v end})

mob_opts:dropdown({name="Select Weapon", flag="SelectWeapon_D", options={"None"}, def="None", callback=function(v) _G.SelectWeapon = v ~= "None" and v or nil end})
mob_opts:slider({name="Bring Range", flag="BringRange", min=50, max=500, def=235, suffix="", callback=function(v) _G.BringRange = v end})
mob_opts:slider({name="Max Bring Mobs", flag="MaxBringMobs", min=1, max=30, def=18, suffix="", callback=function(v) _G.MaxBringMobs = v end})
mob_opts:toggle({name="Low CPU Mode", flag="LowCpuMode", def=false, callback=function(v) if v then LowCpu() end end})

-- Mastery subtab
local mas_boxes = mastery:groupboxes({boxes={"Mastery Farm","Mastery Options","Health Options","Skill Settings"}})
local mas_core = mas_boxes.top_left
local mas_opts = mas_boxes.top_right
local health_opts = mas_boxes.bottom_left
local skill_set = mas_boxes.bottom_right

mas_core:toggle({name="Farm Mastery", flag="FarmMastery_G", def=false, callback=function(v) _G.FarmMastery_G = v end})
mas_core:toggle({name="Farm Mastery Dev", flag="FarmMastery_Dev", def=false, callback=function(v) _G.FarmMastery_Dev = v end})
mas_core:toggle({name="Farm Blaze EM", flag="FarmBlazeEM", def=false, callback=function(v) _G.FarmBlazeEM = v end})

mas_opts:dropdown({name="Mastery Method", flag="MasteryMethod", options={"Auto","Fruit","Sword","Gun"}, def="Auto", callback=function(v) _G.MasteryMethod = v end})
mas_opts:slider({name="Health Limit", flag="HealthM", min=0, max=5000, def=500, suffix="HP", callback=function(v) HealthM = v end})

health_opts:toggle({name="Auto Eat Fruit", flag="AutoEatFruit", def=false, callback=function(v) _G.AutoEatFruit = v end})
health_opts:toggle({name="Infinity Energy", flag="InfinityEnergy", def=false, callback=function(v) _G.InfinityEnergy = v; if v then getInfinity_Ability("Energy", true) end end})
health_opts:toggle({name="Infinity Soru", flag="InfinitySoru", def=false, callback=function(v) _G.InfinitySoru = v; if v then getInfinity_Ability("Soru", true) end end})
health_opts:toggle({name="Observation Haki", flag="ObservationHaki", def=false, callback=function(v) if v then getInfinity_Ability("Observation", true) end end})

skill_set:toggle({name="Use Z Skill", flag="UseZ", def=true, callback=function(v) _G.UseZ = v end})
skill_set:toggle({name="Use X Skill", flag="UseX", def=true, callback=function(v) _G.UseX = v end})
skill_set:toggle({name="Use C Skill", flag="UseC", def=false, callback=function(v) _G.UseC = v end})
skill_set:toggle({name="Prehis Skills", flag="Prehis_Skills", def=false, callback=function(v) _G.Prehis_Skills = v end})

-- Special subtab
local sp_boxes = special:groupboxes({boxes={"Auto Stats","Stat Options","Collect & Drop","Misc Options"}})
local stats_box = sp_boxes.top_left
local stat_opts = sp_boxes.top_right
local collect_box = sp_boxes.bottom_left
local misc_sp = sp_boxes.bottom_right

stats_box:toggle({name="Auto Stats", flag="AutoStats", def=false, callback=function(v) _G.AutoStats = v end})
stats_box:dropdown({name="Stat Type", flag="StatType", options={"Melee","Defense","Sword","Gun","Devil"}, def="Melee", callback=function(v) _G.StatType = v end})
stats_box:slider({name="Stat Amount", flag="StatAmount", min=1, max=50, def=10, suffix="", callback=function(v) _G.StatAmount = v end})

stat_opts:toggle({name="Auto Assign Points", flag="AutoPoints", def=false, callback=function(v) _G.AutoPoints = v end})
stat_opts:dropdown({name="Point Preference", flag="PointPref", options={"Melee","Defense","Sword","Gun","Devil"}, def="Melee", callback=function(v) _G.PointPref = v end})

collect_box:toggle({name="Collect Fruits", flag="CollectFruits", def=false, callback=function(v) _G.CollectFruits = v; collectFruits(v) end})
collect_box:toggle({name="Store Fruits", flag="StoreFruits", def=false, callback=function(v) _G.StoreFruits = v end})
collect_box:button({name="Store Fruit Now", callback=function() UpdStFruit() end})
collect_box:button({name="Drop All Fruits", callback=function() DropFruits() end})

misc_sp:toggle({name="Team Pirates", flag="TeamPirates", def=false, callback=function(v) if v then Pirates() end end})
misc_sp:toggle({name="Team Marines", flag="TeamMarines", def=false, callback=function(v) if v then Marines() end end})
misc_sp:toggle({name="Server Hop", flag="ServerHop", def=false, callback=function(v) _G.ServerHop = v end})
misc_sp:button({name="Hop Server Now", callback=function() Hop() end})

-- TAB 2: SEA & WORLD
local sea, kitsune, mirage = win:tab({name="Sea & World", icon=icons.shield, tabs={"Sea Events","Kitsune","Mirage & Race"}})

-- Sea Events subtab
local sea_boxes = sea:groupboxes({boxes={"Sea Beast","Sea Quest","Boat Options","Sea Checks"}})
local beast_box = sea_boxes.top_left
local sea_quest = sea_boxes.top_right
local boat_box = sea_boxes.bottom_left
local sea_checks = sea_boxes.bottom_right

beast_box:toggle({name="Sea Beast Farm", flag="SeaBeast1", def=false, callback=function(v) _G.SeaBeast1 = v end})
beast_box:toggle({name="Leviathan Farm", flag="Leviathan1", def=false, callback=function(v) _G.Leviathan1 = v end})
beast_box:toggle({name="PirateGrand Brigade", flag="PGB", def=false, callback=function(v) _G.PGB = v end})
beast_box:toggle({name="Fish Boat", flag="FishBoat", def=false, callback=function(v) _G.FishBoat = v end})

sea_quest:toggle({name="Complete Sea Trials", flag="Complete_Trials", def=false, callback=function(v) _G.Complete_Trials = v end})
sea_quest:toggle({name="Resolve Sea Quest", flag="VoidSea1Quest", def=false, callback=function(v) _G.VoidSea1Quest = v end})
sea_quest:toggle({name="Auto Buy Boat", flag="AutoBuyBoat", def=false, callback=function(v) _G.AutoBuyBoat = v end})

boat_box:toggle({name="Spawn Boat", flag="SpawnBoat", def=false, callback=function(v) _G.SpawnBoat = v end})
boat_box:toggle({name="Protect Boat", flag="ProtectBoat", def=false, callback=function(v) _G.ProtectBoat = v end})

sea_checks:toggle({name="Check Sea Beast", flag="CheckSeaBeast", def=false, callback=function(v) _G.CheckSeaBeast = v end})
sea_checks:toggle({name="Check Leviathan", flag="CheckLeviathan", def=false, callback=function(v) _G.CheckLeviathan = v end})
sea_checks:toggle({name="Check Piranhas", flag="CheckPiranha", def=false, callback=function(v) _G.CheckPiranha = v end})
sea_checks:toggle({name="Check Fish Crew", flag="CheckFishCrew", def=false, callback=function(v) _G.CheckFishCrew = v end})

-- Kitsune subtab
local kit_boxes = kitsune:groupboxes({boxes={"Kitsune Farm","Kitsune Options","Material Farm","Ghost Options"}})
local kit_core = kit_boxes.top_left
local kit_opts = kit_boxes.top_right
local mat_farm = kit_boxes.bottom_left
local ghost_opts = kit_boxes.bottom_right

kit_core:toggle({name="Kitsune Farm", flag="KitsuneFarm", def=false, callback=function(v) _G.KitsuneFarm = v end})
kit_core:toggle({name="Kitsune Shrine", flag="KitsuneShrine", def=false, callback=function(v) _G.KitsuneShrine = v end})
kit_opts:toggle({name="Auto Revive", flag="KitsuneRevive", def=false, callback=function(v) _G.KitsuneRevive = v end})
kit_opts:toggle({name="Kitsune Skills", flag="KitsuneSkills", def=false, callback=function(v) _G.KitsuneSkills = v end})

mat_farm:toggle({name="Material Farm", flag="MaterialFarm", def=false, callback=function(v) _G.MaterialFarm = v end})
mat_farm:dropdown({name="Select Material", flag="SelectedMaterial", options=#v > 0 and v or {"None"}, def=#v > 0 and v[1] or "None", callback=function(val) _G.SelectedMaterial = val end})

ghost_opts:toggle({name="Ghost Farm", flag="GhostFarm", def=false, callback=function(v) _G.GhostFarm = v end})
ghost_opts:toggle({name="Auto Ghost Quest", flag="GhostQuest", def=false, callback=function(v) _G.GhostQuest = v end})

-- Mirage & Race subtab
local mir_boxes = mirage:groupboxes({boxes={"Mirage Island","Race Options","Race V3","Misc Sea"}})
local mir_core = mir_boxes.top_left
local race_opts = mir_boxes.top_right
local race_v3 = mir_boxes.bottom_left
local misc_sea = mir_boxes.bottom_right

mir_core:toggle({name="Mirage Island", flag="MirageIsland", def=false, callback=function(v) _G.MirageIsland = v end})
mir_core:toggle({name="Auto Find Mirage", flag="AutoMirage", def=false, callback=function(v) _G.AutoMirage = v end})

race_opts:toggle({name="Race V3 Awakening", flag="RaceV3", def=false, callback=function(v) _G.RaceV3 = v end})
race_opts:dropdown({name="Select Race", flag="SelectedRace", options={"Human","Mink","Shark","Sky","Cyborg"}, def="Human", callback=function(v) _G.SelectedRace = v end})

race_v3:toggle({name="Complete Race Trials", flag="CompleteRaceTrials", def=false, callback=function(v) _G.CompleteRaceTrials = v end})
race_v3:toggle({name="Auto Race Quest", flag="AutoRaceQuest", def=false, callback=function(v) _G.AutoRaceQuest = v end})

misc_sea:toggle({name="Snow Island", flag="SnowIsland", def=false, callback=function(v) _G.SnowIsland = v end})
misc_sea:toggle({name="Submerged Island", flag="SubmergedIsland", def=false, callback=function(v) _G.SubmergedIsland = v end})

-- TAB 3: ITEMS & STYLES
local styles, swords, cdk = win:tab({name="Items & Styles", icon=icons.zap, tabs={"Fighting Styles","Swords","Elite & CDK"}})

-- Fighting Styles subtab
local fs_boxes = styles:groupboxes({boxes={"Style Mastery","Sharkman Karate","Dragon Talon","Electric Claw"}})
local fs_core = fs_boxes.top_left
local shark_box = fs_boxes.top_right
local dragon_box = fs_boxes.bottom_left
local electric_box = fs_boxes.bottom_right

fs_core:toggle({name="Farm Fighting Style", flag="FarmFightingStyle", def=false, callback=function(v) _G.FarmFightingStyle = v end})
fs_core:dropdown({name="Select Style", flag="SelectedStyle", options={"Sharkman Karate","Dragon Talon","Electric Claw","Death Step","Superhuman"}, def="Sharkman Karate", callback=function(v) _G.SelectedStyle = v end})

shark_box:toggle({name="Sharkman Karate", flag="SharkmanKarate", def=false, callback=function(v) _G.SharkmanKarate = v end})
shark_box:toggle({name="Auto Buy Sharkman", flag="BuySharkman", def=false, callback=function(v) _G.BuySharkman = v end})

dragon_box:toggle({name="Dragon Talon", flag="DragonTalon", def=false, callback=function(v) _G.DragonTalon = v end})
dragon_box:toggle({name="Auto Buy Dragon", flag="BuyDragon", def=false, callback=function(v) _G.BuyDragon = v end})

electric_box:toggle({name="Electric Claw", flag="ElectricClaw", def=false, callback=function(v) _G.ElectricClaw = v end})
electric_box:toggle({name="Death Step", flag="DeathStep", def=false, callback=function(v) _G.DeathStep = v end})

-- Swords subtab
local sw_boxes = swords:groupboxes({boxes={"Sword Mastery","Sword Obtain","Sword Upgrade","Sword Skills"}})
local sw_core = sw_boxes.top_left
local sw_obtain = sw_boxes.top_right
local sw_upgrade = sw_boxes.bottom_left
local sw_skills = sw_boxes.bottom_right

sw_core:toggle({name="Farm Sword Mastery", flag="FarmSwordMas", def=false, callback=function(v) _G.FarmSwordMas = v end})
sw_core:toggle({name="Auto Equip Sword", flag="AutoEquipSword", def=false, callback=function(v) _G.AutoEquipSword = v end})
sw_core:dropdown({name="Select Sword", flag="SelectedSword", options={"Saber","Cutlass","Sword","Katana","Pole","Trident","Dark Blade","Bisento"}, def="Saber", callback=function(v) _G.SelectedSword = v end})

sw_obtain:toggle({name="Get Dark Blade", flag="GetDarkBlade", def=false, callback=function(v) _G.GetDarkBlade = v end})
sw_obtain:toggle({name="Get Bisento", flag="GetBisento", def=false, callback=function(v) _G.GetBisento = v end})
sw_obtain:toggle({name="Get True Triple Katana", flag="GetTTK", def=false, callback=function(v) _G.GetTTK = v end})

sw_upgrade:toggle({name="Upgrade Sword", flag="UpgradeSword", def=false, callback=function(v) _G.UpgradeSword = v end})
sw_upgrade:dropdown({name="Upgrade Target", flag="UpgradeTarget", options={"Yoru","Saber","Bisento","Dark Blade"}, def="Saber", callback=function(v) _G.UpgradeTarget = v end})

sw_skills:toggle({name="Use Sword Z", flag="SwordZ", def=true, callback=function(v) _G.SwordZ = v end})
sw_skills:toggle({name="Use Sword X", flag="SwordX", def=true, callback=function(v) _G.SwordX = v end})

-- Elite & CDK subtab
local cdk_boxes = cdk:groupboxes({boxes={"CDK Farm","Elite Hunter","Elite Raid","Hallow Scythe"}})
local cdk_core = cdk_boxes.top_left
local elite_box = cdk_boxes.top_right
local elite_raid = cdk_boxes.bottom_left
local hallow_box = cdk_boxes.bottom_right

cdk_core:toggle({name="CDK Farm", flag="CDK_Farm", def=false, callback=function(v) _G.CDK_Farm = v end})
cdk_core:toggle({name="Auto CDK Quest", flag="CDK_Quest", def=false, callback=function(v) _G.CDK_Quest = v end})
cdk_core:toggle({name="CDK Material Farm", flag="CDK_Material", def=false, callback=function(v) _G.CDK_Material = v end})

elite_box:toggle({name="Elite Hunter", flag="EliteHunter", def=false, callback=function(v) _G.EliteHunter = v end})
elite_box:toggle({name="Auto Elite Quest", flag="AutoEliteQuest", def=false, callback=function(v) _G.AutoEliteQuest = v end})
elite_box:toggle({name="Spawn Elite", flag="SpawnElite", def=false, callback=function(v) _G.SpawnElite = v end})

elite_raid:toggle({name="Elite Raid", flag="EliteRaid", def=false, callback=function(v) _G.EliteRaid = v end})
elite_raid:toggle({name="Auto Join Elite Raid", flag="AutoJoinEliteRaid", def=false, callback=function(v) _G.AutoJoinEliteRaid = v end})

hallow_box:toggle({name="Hallow Scythe", flag="HallowScythe", def=false, callback=function(v) _G.HallowScythe = v end})
hallow_box:toggle({name="Auto Hallow Quest", flag="HallowQuest", def=false, callback=function(v) _G.HallowQuest = v end})

-- TAB 4: RAIDS & SPECIAL
local raids, dojo, prehis = win:tab({name="Raids & Special", icon=icons.target, tabs={"Raids","Drago Dojo","Prehistoric"}})

-- Raids subtab
local raid_boxes = raids:groupboxes({boxes={"Raid Farm","Raid Settings","Chip Farm","Island Options"}})
local raid_core = raid_boxes.top_left
local raid_set = raid_boxes.top_right
local chip_farm = raid_boxes.bottom_left
local island_opts = raid_boxes.bottom_right

raid_core:toggle({name="Auto Raid", flag="AutoRaid", def=false, callback=function(v) _G.AutoRaid = v end})
raid_core:toggle({name="Auto Use Chip", flag="AutoUseChip", def=false, callback=function(v) _G.AutoUseChip = v end})
raid_core:dropdown({name="Select Raid Fruit", flag="RaidFruit", options=j, def=j[1] or "Flame", callback=function(v) _G.RaidFruit = v end})

raid_set:toggle({name="Skip Cutscene", flag="SkipCutscene", def=true, callback=function(v) _G.SkipCutscene = v end})
raid_set:toggle({name="Auto Collect Chips", flag="AutoCollectChips", def=false, callback=function(v) _G.AutoCollectChips = v end})
raid_set:slider({name="Raid HP Limit", flag="RaidHPLimit", min=0, max=5000, def=100, suffix="HP", callback=function(v) _G.RaidHPLimit = v end})

chip_farm:toggle({name="Microchip Farm", flag="MicrochipFarm", def=false, callback=function(v) _G.MicrochipFarm = v end})
chip_farm:toggle({name="Island Farm", flag="IslandFarm", def=false, callback=function(v) _G.IslandFarm = v end})

island_opts:toggle({name="God's Island", flag="GodsIsland", def=false, callback=function(v) _G.GodsIsland = v end})
island_opts:toggle({name="Tiki Island", flag="TikiIsland", def=false, callback=function(v) _G.TikiIsland = v end})

-- Drago Dojo subtab
local dojo_boxes = dojo:groupboxes({boxes={"Dojo Farm","Drago Options","Drago Skills","Drago Quest"}})
local dojo_core = dojo_boxes.top_left
local drago_opts = dojo_boxes.top_right
local drago_skills = dojo_boxes.bottom_left
local drago_quest = dojo_boxes.bottom_right

dojo_core:toggle({name="Drago Dojo Farm", flag="DragoDojo", def=false, callback=function(v) _G.DragoDojo = v end})
dojo_core:toggle({name="Auto Dojo Quest", flag="AutoDojoQuest", def=false, callback=function(v) _G.AutoDojoQuest = v end})
dojo_core:toggle({name="Auto Dojo Win", flag="AutoDojoWin", def=false, callback=function(v) _G.AutoDojoWin = v end})

drago_opts:toggle({name="Spawn Drago NPC", flag="SpawnDrago", def=false, callback=function(v) _G.SpawnDrago = v end})
drago_opts:toggle({name="Drago Boss Farm", flag="DragoBoss", def=false, callback=function(v) _G.DragoBoss = v end})

drago_skills:toggle({name="Drago Z Skill", flag="DragoZ", def=true, callback=function(v) _G.DragoZ = v end})
drago_skills:toggle({name="Drago X Skill", flag="DragoX", def=true, callback=function(v) _G.DragoX = v end})

drago_quest:toggle({name="Complete Dojo Trials", flag="DojoTrials", def=false, callback=function(v) _G.DojoTrials = v end})
drago_quest:toggle({name="Dojo Material Farm", flag="DojoMaterials", def=false, callback=function(v) _G.DojoMaterials = v end})

-- Prehistoric subtab
local pre_boxes = prehis:groupboxes({boxes={"Prehistoric Farm","T-Rex Options","Bone Farm","Prehistoric Quest"}})
local pre_core = pre_boxes.top_left
local trex_opts = pre_boxes.top_right
local bone_farm = pre_boxes.bottom_left
local pre_quest = pre_boxes.bottom_right

pre_core:toggle({name="Prehistoric Farm", flag="Prehistoric", def=false, callback=function(v) _G.Prehistoric = v end})
pre_core:toggle({name="Auto Prehis Quest", flag="AutoPrehisQuest", def=false, callback=function(v) _G.AutoPrehisQuest = v end})

trex_opts:toggle({name="T-Rex Farm", flag="TRexFarm", def=false, callback=function(v) _G.TRexFarm = v end})
trex_opts:toggle({name="T-Rex Boss", flag="TRexBoss", def=false, callback=function(v) _G.TRexBoss = v end})

bone_farm:toggle({name="Bone Farm", flag="BoneFarm", def=false, callback=function(v) _G.BoneFarm = v end})
bone_farm:toggle({name="Fossil Farm", flag="FossilFarm", def=false, callback=function(v) _G.FossilFarm = v end})

pre_quest:toggle({name="Prehis Skills", flag="Prehis_Skills_Tab", def=false, callback=function(v) _G.Prehis_Skills = v end})
pre_quest:toggle({name="Complete Prehis Trials", flag="PrehisTrials", def=false, callback=function(v) _G.PrehisTrials = v end})

-- TAB 5: PLAYER
local combat, config_tab, teleport_tab = win:tab({name="Player", icon=icons.user, tabs={"Combat/PVP","Config","Teleport"}})

-- Combat/PVP subtab
local pvp_boxes = combat:groupboxes({boxes={"Aim Settings","PVP Options","AimBot","Anti-AFK"}})
local aim_box = pvp_boxes.top_left
local pvp_opts = pvp_boxes.top_right
local aimbot_box = pvp_boxes.bottom_left
local anti_afk = pvp_boxes.bottom_right

aim_box:toggle({name="Aim Method", flag="AimMethod", def=false, callback=function(v) _G.AimMethod = v end})
aim_box:dropdown({name="AB Method", flag="ABMethod", options={"AimBots Skill","Auto Aimbots","Manual"}, def="Manual", callback=function(v) ABmethod = v end})
aim_box:toggle({name="Silent Aim", flag="SilentAim", def=false, callback=function(v) _G.SilentAim = v end})

pvp_opts:toggle({name="Kill Players", flag="KillPlayers", def=false, callback=function(v) _G.KillPlayers = v end})
pvp_opts:toggle({name="Auto Farm Players", flag="AutoFarmPlayers", def=false, callback=function(v) _G.AutoFarmPlayers = v end})
pvp_opts:toggle({name="Noclip", flag="Noclip", def=false, callback=function(v) _G.Noclip = v end})
pvp_opts:toggle({name="Infinite Jump", flag="InfJump", def=false, callback=function(v) _G.InfJump = v end})

aimbot_box:toggle({name="Auto Dodge", flag="AutoDodge", def=false, callback=function(v) _G.AutoDodge = v end})
aimbot_box:toggle({name="Fast Attack", flag="FastAttack", def=false, callback=function(v) _G.FastAttack = v end})
aimbot_box:toggle({name="Superhuman Speed", flag="SuperSpeed", def=false, callback=function(v) _G.SuperSpeed = v end})

anti_afk:toggle({name="Anti-AFK", flag="AntiAFK", def=false, callback=function(v) _G.AntiAFK = v end})
anti_afk:toggle({name="Anti-AFK Click", flag="AntiAFKClick", def=false, callback=function(v) _G.AntiAFKClick = v end})
anti_afk:button({name="Enable Anti-AFK", callback=function() n:ClickButton2(Vector2.new()) end})

-- Config subtab
local cfg_boxes = config_tab:groupboxes({boxes={"Visual Settings","Farm Config","Notifications","Reset"}})
local vis_cfg = cfg_boxes.top_left
local farm_cfg = cfg_boxes.top_right
local notif_cfg = cfg_boxes.bottom_left
local reset_cfg = cfg_boxes.bottom_right

vis_cfg:toggle({name="Show Highlights", flag="ShowHighlights", def=true, callback=function(v) _G.ShowHighlights = v end})
vis_cfg:toggle({name="ESP Players", flag="ESP_Players", def=false, callback=function(v) _G.ESP_Players = v end})
vis_cfg:toggle({name="ESP Mobs", flag="ESP_Mobs", def=false, callback=function(v) _G.ESP_Mobs = v end})

farm_cfg:slider({name="Farm Delay", flag="FarmDelay", min=0, max=2, def=0.2, suffix="s", callback=function(v) T = v end})
farm_cfg:toggle({name="Auto Respawn", flag="AutoRespawn", def=true, callback=function(v) _G.AutoRespawn = v end})
farm_cfg:toggle({name="Safe Zone Farm", flag="SafeZoneFarm", def=false, callback=function(v) _G.SafeZoneFarm = v end})

notif_cfg:toggle({name="Level Up Notif", flag="LvlUpNotif", def=true, callback=function(v) _G.LvlUpNotif = v end})
notif_cfg:toggle({name="Quest Complete", flag="QuestNotif", def=true, callback=function(v) _G.QuestNotif = v end})

reset_cfg:button({name="Reset Character", callback=function() d.Character.Humanoid.Health = 0 end})
reset_cfg:button({name="Rejoin Server", callback=function() game:GetService("TeleportService"):Teleport(game.PlaceId) end})

-- Teleport subtab
local tp_boxes = teleport_tab:groupboxes({boxes={"World 1 TPs","World 2 TPs","World 3 TPs","Special TPs"}})
local w1_tp = tp_boxes.top_left
local w2_tp = tp_boxes.top_right
local w3_tp = tp_boxes.bottom_left
local special_tp = tp_boxes.bottom_right

w1_tp:label({text="=== World 1 ==="})
w1_tp:button({name="Marine Starter", callback=function() _tp(CFrame.new(976.8, 124.4, 1817.4)) end})
w1_tp:button({name="Middle Town", callback=function() _tp(CFrame.new(386.1, 174.4, 836.9)) end})
w1_tp:button({name="Jungle", callback=function() _tp(CFrame.new(-1184.3, 24, 385.3)) end})
w1_tp:button({name="Pirate Village", callback=function() _tp(CFrame.new(-1404, 65, 3340)) end})
w1_tp:button({name="Desert", callback=function() _tp(CFrame.new(940, 127, 4360)) end})

w2_tp:label({text="=== World 2 ==="})
w2_tp:button({name="Kingdom of Rose", callback=function() _tp(CFrame.new(-679, 98, 5739)) end})
w2_tp:button({name="Green Zone", callback=function() _tp(CFrame.new(-3011, 872, 4203)) end})
w2_tp:button({name="Graveyard", callback=function() _tp(CFrame.new(-8236, 42, 5761)) end})
w2_tp:button({name="Snow Mountain", callback=function() _tp(CFrame.new(1086, 870, -3440)) end})

w3_tp:label({text="=== World 3 ==="})
w3_tp:button({name="Port Town", callback=function() _tp(CFrame.new(-3007, 4, 1953)) end})
w3_tp:button({name="Ussop Island", callback=function() _tp(CFrame.new(-4789, 23, 3803)) end})
w3_tp:button({name="Floating Turtle", callback=function() _tp(CFrame.new(-8044, 2352, 1983)) end})
w3_tp:button({name="Sea of Treats", callback=function() _tp(CFrame.new(-877, 118, -11032)) end})

special_tp:label({text="=== Special ==="})
special_tp:button({name="Mirage Island", callback=function() _tp(CFrame.new(-13946, 5, -7200)) end})
special_tp:button({name="Castle on the Sea", callback=function() _tp(CFrame.new(-11952, 927, -12600)) end})
special_tp:button({name="Tiki Outpost", callback=function() _tp(CFrame.new(-16269, 25, 1373)) end})

-- TAB 6: SHOP & MISC
local shop, fruits, server = win:tab({name="Shop & Misc", icon=icons.settings, tabs={"Shop","Fruits","Server"}})

-- Shop subtab
local shop_boxes = shop:groupboxes({boxes={"Auto Buy","Beli Farm","Flower Farm","Gem Options"}})
local buy_box = shop_boxes.top_left
local beli_box = shop_boxes.top_right
local flower_box = shop_boxes.bottom_left
local gem_box = shop_boxes.bottom_right

buy_box:toggle({name="Auto Buy Fruit", flag="AutoBuyFruit", def=false, callback=function(v) _G.AutoBuyFruit = v end})
buy_box:dropdown({name="Buy Fruit", flag="BuyFruitName", options=j, def=j[1] or "Flame", callback=function(v) _G.BuyFruitName = v end})
buy_box:toggle({name="Auto Buy Devil Fruit", flag="AutoBuyDevil", def=false, callback=function(v) _G.AutoBuyDevil = v end})
buy_box:toggle({name="Auto Restock", flag="AutoRestock", def=false, callback=function(v) _G.AutoRestock = v end})

beli_box:toggle({name="Auto Farm Beli", flag="AutoFarmBeli", def=false, callback=function(v) _G.AutoFarmBeli = v end})
beli_box:toggle({name="Material Sell", flag="BeliMaterialSell", def=false, callback=function(v) _G.BeliMaterialSell = v end})
beli_box:button({name="Sell All Materials", callback=function() pcall(function() Q.Remotes.CommF_:InvokeServer("SellAllMaterials") end) end})

flower_box:toggle({name="Flower Farm", flag="FlowerFarm", def=false, callback=function(v) _G.FlowerFarm = v end})
flower_box:toggle({name="Auto Collect Flowers", flag="AutoFlowers", def=false, callback=function(v) _G.AutoFlowers = v end})

gem_box:toggle({name="Gem Farm", flag="GemFarm", def=false, callback=function(v) _G.GemFarm = v end})
gem_box:toggle({name="Auto Buy Gems", flag="AutoBuyGems", def=false, callback=function(v) _G.AutoBuyGems = v end})

-- Fruits subtab
local fr_boxes = fruits:groupboxes({boxes={"Fruit Sniper","Fruit Options","Fruit Notify","Fruit Priority"}})
local sniper_box = fr_boxes.top_left
local fr_opts = fr_boxes.top_right
local fr_notify = fr_boxes.bottom_left
local fr_list = fr_boxes.bottom_right

sniper_box:toggle({name="Fruit Sniper", flag="FruitSniper", def=false, callback=function(v) _G.FruitSniper = v end})
sniper_box:toggle({name="Auto Eat Spawned", flag="AutoEatSpawned", def=false, callback=function(v) _G.AutoEatSpawned = v end})
sniper_box:toggle({name="Fruit ESP", flag="FruitESP", def=false, callback=function(v) _G.FruitESP = v end})

fr_opts:toggle({name="Auto Collect Fruits", flag="AutoCollectFruits", def=false, callback=function(v) _G.AutoCollectFruits = v end})
fr_opts:toggle({name="Ignore Devil Fruit", flag="IgnoreDevil", def=false, callback=function(v) _G.IgnoreDevil = v end})
fr_opts:button({name="Store All Fruits", callback=function() UpdStFruit() end})

fr_notify:toggle({name="Notify On Spawn", flag="FruitNotify", def=true, callback=function(v) _G.FruitNotify = v end})
fr_notify:dropdown({name="Notif Sound", flag="NotifSound", options={"Default","None","Custom"}, def="Default", callback=function(v) _G.NotifSound = v end})

fr_list:dropdown({name="Fruit Priority", flag="FruitPriority", options=j, def=j[1] or "Flame", callback=function(v) _G.FruitPriority = v end})
fr_list:toggle({name="Only Priority Fruit", flag="OnlyPriority", def=false, callback=function(v) _G.OnlyPriority = v end})

-- Server subtab
local srv_boxes = server:groupboxes({boxes={"Server Hop","Player Options","Server Info","Anti Options"}})
local hop_box = srv_boxes.top_left
local player_box = srv_boxes.top_right
local info_box = srv_boxes.bottom_left
local anti_box = srv_boxes.bottom_right

hop_box:toggle({name="Auto Server Hop", flag="AutoServerHop", def=false, callback=function(v) _G.AutoServerHop = v end})
hop_box:toggle({name="Hop On Boss Dead", flag="HopOnBossDead", def=false, callback=function(v) _G.HopOnBossDead = v end})
hop_box:button({name="Hop Now", callback=function() Hop() end})
hop_box:slider({name="Hop Delay", flag="HopDelay", min=1, max=60, def=5, suffix="s", callback=function(v) _G.HopDelay = v end})

player_box:toggle({name="Show Players", flag="ShowPlayers", def=false, callback=function(v) _G.ShowPlayers = v end})
player_box:toggle({name="Copy Player TP", flag="CopyPlayerTP", def=false, callback=function(v) _G.CopyPlayerTP = v end})

info_box:button({name="Print Server Info", callback=function()
    local world = World1 and "World 1" or World2 and "World 2" or World3 and "World 3" or "Unknown"
    print("Level: " .. (r or 0) .. " | World: " .. world)
end})

anti_box:toggle({name="Anti-Ban", flag="AntiBan", def=false, callback=function(v) _G.AntiBan = v end})
anti_box:toggle({name="Anti-Cheat Bypass", flag="AntiCheat", def=false, callback=function(v) _G.AntiCheat = v end})
anti_box:toggle({name="Private Server", flag="PrivateServer", def=false, callback=function(v) _G.PrivateServer = v end})

-- ============================================================
-- TASK.SPAWN LOOPS
-- ============================================================

task.spawn(function()
    while task.wait(T) do
        if _G.AutoFarm then
            pcall(function()
                local char = d.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum and hum.Health <= 0 then task.wait(3) end
                    if _G.AutoQuest or _G.AcceptQuest then
                        CheckQuest()
                    end
                    local target = GetConnectionEnemies(_G.SelectedBoss or "")
                    if target and f.Alive(target) then
                        f.Kill(target, true)
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoAttack_G then f.Activate() end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if _B then BringEnemy() end
    end
end)

task.spawn(function()
    while task.wait(T) do
        if _G.FarmMastery_G then
            pcall(function()
                local target = GetConnectionEnemies(_G.SelectedBoss or "")
                if target and f.Alive(target) then
                    f.Mas(target, true)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(60) do
        if _G.AntiAFK then
            pcall(function() n:ClickButton2(Vector2.new()) end)
        end
    end
end)

task.spawn(function()
    while task.wait(T) do
        if _G.MaterialFarm and _G.SelectedMaterial then
            pcall(function() MaterialMon(_G.SelectedMaterial) end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.UseSkills_G then
            if _G.UseZ then pcall(function() Useskills("Blox Fruit", "Z") end) end
            if _G.UseX then pcall(function() Useskills("Blox Fruit", "X") end) end
            if _G.UseC then pcall(function() Useskills("Blox Fruit", "C") end) end
        end
        if _G.FarmSwordMas then
            if _G.SwordZ then pcall(function() Useskills("Sword", "Z") end) end
            if _G.SwordX then pcall(function() Useskills("Sword", "X") end) end
        end
    end
end)

task.spawn(function()
    while task.wait(T) do
        if _G.SeaBeast1 then
            pcall(function()
                local sb = workspace.SeaBeasts:FindFirstChild("SeaBeast1")
                if sb then f.KillSea(sb, true) end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(T) do
        if _G.Leviathan1 then
            pcall(function()
                local lev = workspace.SeaBeasts:FindFirstChild("Leviathan")
                if lev then f.KillSea(lev, true) end
            end)
        end
    end
end)

task.spawn(function()
    W.Heartbeat:Connect(function()
        if _G.Noclip then
            pcall(function()
                local char = d.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
    end)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        pcall(function()
            local hum = d.Character and d.Character:FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.CollectFruits then collectFruits(true) end
        if _G.StoreFruits then UpdStFruit() end
    end
end)

-- Init config (saves/loads all flagged settings)
library:init_config(win)
