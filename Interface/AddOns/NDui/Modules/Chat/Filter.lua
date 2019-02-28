local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("Chat")

local strmatch, strfind, format, gsub = string.match, string.find, string.format, string.gsub
local pairs, ipairs, tonumber = pairs, ipairs, tonumber
local min, max, tremove = math.min, math.max, table.remove

-- Filter Chat symbols
local msgSymbols = {"`", "～", "＠", "＃", "^", "＊", "！", "？", "。", "|", " ", "—", "——", "￥", "’", "‘", "“", "”", "【", "】", "『", "』", "《", "》", "〈", "〉", "（", "）", "〔", "〕", "、", "，", "：", ",", "_", "/", "~", "%-", "%."}

local FilterList = {}
function B:GenFilterList()
	B.SplitList(FilterList, NDuiADB["ChatFilterList"], true)
end

-- ECF strings compare
local last, this = {}, {}
local function strDiff(sA, sB) -- arrays of bytes
	local len_a, len_b = #sA, #sB
	for j = 0, len_b do
		last[j+1] = j
	end
	for i = 1, len_a do
		this[1] = i
		for j = 1, len_b do
			this[j+1] = (sA[i] == sB[j]) and last[j] or (min(last[j+1], this[j], last[j]) + 1)
		end
		for j = 0, len_b do
			last[j+1] = this[j+1]
		end
	end
	return (this[len_b+1] or 100) / max(len_a, len_b)
end

local chatLines = {}
local function genChatFilter(_, event, msg, author, _, _, _, flag, _, _, _, _, _, guid)
	local name = Ambiguate(author, "none")

	if UnitIsUnit(name, "player") or (event == "CHAT_MSG_WHISPER" and flag == "GM") or flag == "DEV" then
		return
	elseif guid and (IsGuildMember(guid) or BNGetGameAccountInfoByGUID(guid) or IsCharacterFriend(guid) or IsGUIDInGroup(guid)) then
		return
	end

	local filterMsg = msg:gsub("|H.-|h(.-)|h", "%1"):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")

	-- Trash Filter
	for _, symbol in ipairs(msgSymbols) do
		filterMsg = gsub(filterMsg, symbol, "")
	end

	local match = 0
	for keyword in pairs(FilterList) do
		if keyword ~= "" then
			local _, count = gsub(filterMsg, keyword, "")
			if count > 0 then
				match = match + 1
			end
		end
	end

	if match >= NDuiDB["Chat"]["Matches"] then
		return true
	end

	-- ECF Repeat Filter
	local msgTable = {name, {}, GetTime()}
	for i = 1, #filterMsg do
		msgTable[2][i] = filterMsg:byte(i)
	end
	local chatLinesSize = #chatLines
	chatLines[chatLinesSize+1] = msgTable
	for i = 1, chatLinesSize do
		local line = chatLines[i]
		if line[1] == msgTable[1] and ((msgTable[3] - line[3] < .6) or strDiff(line[2], msgTable[2]) <= .1) then
			tremove(chatLines, i)
			return true
		end
	end
	if chatLinesSize >= 30 then tremove(chatLines, 1) end
end

local addonBlockList = {
	"任务进度提示", "%[接受任务%]", "%(任务完成%)", "<大脚", "【爱不易】", "EUI[:_]", "打断:.+|Hspell", "PS 死亡: .+>", "%*%*.+%*%*", "<iLvl>", ("%-"):rep(20),
	"<小队物品等级:.+>", "<LFG>", "进度:", "属性通报", "汐寒", "wow.+兑换码", "wow.+验证码"
}

local cvar
local function toggleCVar(value)
	value = tonumber(value) or 1
	SetCVar(cvar, value)
end

local function toggleBubble(party)
	cvar = "chatBubbles"..(party and "Party" or "")
	if not GetCVarBool(cvar) then return end
	toggleCVar(0)
	C_Timer.After(.01, toggleCVar)
end

local function genAddonBlock(_, event, msg, author)
	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") then return end

	for _, word in ipairs(addonBlockList) do
		if strfind(msg, word) then
			if event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" then
				toggleBubble()
			elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
				toggleBubble(true)
			end
			return true
		end
	end
end

--[[
	公会频道有人提到你时通知你
]]
local chatAtList, at = {}, {}
function B:GenChatAtList()
	B.SplitList(chatAtList, NDuiADB["ChatAtList"], true)

	chatAtList[DB.MyName] = true
end

local function chatAtMe(_, _, ...)
	local msg, author, _, _, _, _, _, _, _, _, _, guid = ...
	author = Ambiguate(author, "short")
	if author == DB.MyName then return end

	for word in pairs(chatAtList) do
		if word ~= "" then
			if strmatch(msg:lower(), word:lower()) then
				at.checker = true
				at.author = author
				at.class = select(2, GetPlayerInfoByGUID(guid))
				BNToastFrame:AddToast(BN_TOAST_TYPE_NEW_INVITE)
			end
		end
	end
end

hooksecurefunc(BNToastFrame, "ShowToast", function(self)
	if at.checker == true then
		self:SetHeight(50)
		self.IconTexture:SetTexCoord(.75, 1, 0, .5)
		self.TopLine:Hide()
		self.MiddleLine:Hide()
		self.BottomLine:Hide()
		self.DoubleLine:Show()

		local hexColor = B.HexRGB(B.ClassColor(at.class))
		self.DoubleLine:SetText(format(L["Mention You"], hexColor..at.author..DB.InfoColor))
		at.checker = false
	end
end)

-- 过滤海岛探险中艾泽里特的获取信息
local azerite = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub("%%d/%%d ", "")
local function filterAzeriteGain(_, _, msg)
	if strfind(msg, azerite) then
		return true
	end
end

local function isPlayerOnIslands()
	local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
	if instanceType == "scenario" and maxPlayers == 3 then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterAzeriteGain)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", filterAzeriteGain)
	end
end

function module:ChatFilter()
	if NDuiDB["Chat"]["EnableFilter"] then
		B:GenFilterList()
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", genChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", genChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", genChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", genChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", genChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", genChatFilter)
	end

	if NDuiDB["Chat"]["BlockAddonAlert"] then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", genAddonBlock)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", genAddonBlock)
	end

	B:GenChatAtList()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", chatAtMe)

	B:RegisterEvent("PLAYER_ENTERING_WORLD", isPlayerOnIslands)
end