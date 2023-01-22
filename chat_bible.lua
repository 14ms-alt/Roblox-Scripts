-- SelectedBible = 'English1'
-- SayDelay = 2.7

getgenv().bible_toggled = not getgenv().bible_toggled

if not getgenv().bible_toggled then
	return
end

local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild('DefaultChatSystemChatEvents')

if not DefaultChatSystemChatEvents then
	error('This game probably uses a custom chat system')
end

local SayMessageRequest = DefaultChatSystemChatEvents.SayMessageRequest

local Bibles = {
	Arabic = 'ar_svd',
	Chinese1 = 'zh_cuv',
	Chinese2 = 'zh_ncv',
	German = 'de_schlachter',
	Greek = 'el_greek',
	English1 = 'en_bbe',
	English2 = 'en_kjv',
	Esperanto = 'eo_esperanto',
	Spanish = 'es_rvr',
	Finnish1 = 'fi_finnish',
	Finnish2 = 'fi_pr',
	French = 'fr_apee',
	Korean = 'ko_ko',
	Portuguese1 = 'pt_aa',
	Portuguese2 = 'pt_acf',
	Portuguese3 = 'pt_nvi',
	Romanian = 'ro_cornilescu',
	Russian = 'ru_synodal',
	Vietnamese = 'vi_vietnamese'
}

if not Bibles[SelectedBible] then
	error('Invalid bible type')
end

local url = 'https://raw.githubusercontent.com/thiagobodruk/bible/master/json/' .. Bibles[SelectedBible] .. '.json'
local json_bible = HttpService:JSONDecode(game:HttpGet(url))

local sentences = {}
for _, part in pairs(json_bible) do
	for _, chapter in pairs(part.chapters) do
		for _, sentence in pairs(chapter) do
			if #sentence <= 200 then
				sentences[#sentences + 1] = sentence
			end
		end
	end
end

for _, sentence in pairs(sentences) do
	if not getgenv().bible_toggled then
		break
	end

	SayMessageRequest:FireServer(sentence, 'All')
	wait(SayDelay)
end
