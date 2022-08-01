local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LocalPlayer = Players.LocalPlayer

local maxDistance = 30

getgenv().auraEnabled = not getgenv().auraEnabled

local function findTool()
	local tool = LocalPlayer.Backpack:FindFirstChildOfClass('Tool')

	if not tool then
		local character = LocalPlayer.Character

		if character then
			tool = character:FindFirstChildOfClass('Tool')
		end
	end

	return tool
end

local function getToolHitRemote()
	local tool = findTool()

	if tool and tool ~= getgenv().lastTool then
		getgenv().lastTool = tool

		local scr = tool:FindFirstChild('LocalScript')

		if scr then
			for _, o in pairs(getgc()) do
				if type(o) == 'function' and getfenv(o).script == scr then
					local c = debug.getconstants(o)
					
					for _, p in pairs(c) do
						if p == 'isInArena' then
							for _, p2 in pairs(c) do
								for _, j in pairs(ReplicatedStorage:GetChildren()) do
									if j:IsA('RemoteEvent') and j.Name == p2 then
										getgenv().hitRemote = j
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

while getgenv().auraEnabled do
	getToolHitRemote()

	if getgenv().hitRemote then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character

				if char then
					local part = char:FindFirstChildWhichIsA('BasePart')

					if LocalPlayer:DistanceFromCharacter(part.Position) <= maxDistance then
						hitRemote:FireServer(part)
					end
				end
			end
		end
	end

	wait()
end