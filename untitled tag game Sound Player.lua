local soundsList = require(game:GetService('ReplicatedFirst').Sounds)

-- getgenv().id = soundsList.Emotes.TPose
-- getgenv().volume = 10
-- getgenv().playSpeed = 0.7

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local function play()

	ReplicatedStorage.RemoteEvents.ReplicateSound:FireServer(id, workspace, Vector3.new(0, 0, 0), playSpeed, volume, math.huge)

	local sound = Instance.new('Sound', workspace)

	sound.SoundId = getgenv().id
	sound.Volume = getgenv().volume
	sound.PlaybackSpeed = getgenv().playSpeed
	sound.RollOffMaxDistance = math.huge

	sound:Play()

	sound.Ended:Wait()

	sound:Destroy()
end

play()
