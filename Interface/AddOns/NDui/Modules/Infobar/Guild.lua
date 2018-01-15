local B, C, L, DB = unpack(select(2, ...))
if not C.Infobar.Guild then return end

local module = NDui:GetModule("Infobar")
local info = module:RegisterInfobar(C.Infobar.GuildPos)

local r, g, b = DB.cc.r, DB.cc.g, DB.cc.b
local infoFrame = CreateFrame("Frame", "NDuiGuildInfobar", info)
infoFrame:SetSize(335, 540)
infoFrame:SetPoint("TOPLEFT", UIParent, 15, -30)
infoFrame:SetClampedToScreen(true)
infoFrame:SetFrameStrata("TOOLTIP")
B.CreateBD(infoFrame, .7)
B.CreateTex(infoFrame)
infoFrame:Hide()

local gName = B.CreateFS(infoFrame, 18, "Guild", true, "TOPLEFT", 15, -10)
local gOnline = B.CreateFS(infoFrame, 12, "Online", false, "TOPLEFT", 15, -35)
local gApps = B.CreateFS(infoFrame, 12, "Applications", false, "TOPRIGHT", -15, -35)
local gRank = B.CreateFS(infoFrame, 12, "Rank", false, "TOPLEFT", 15, -55)

local bu = {}
local width = {30, 35, 126, 115}
for i = 1, 4 do
	bu[i] = CreateFrame("Button", nil, infoFrame)
	bu[i]:SetSize(width[i], 22)
	bu[i]:SetFrameLevel(infoFrame:GetFrameLevel() + 3)
	if i == 1 then
		bu[i]:SetPoint("TOPLEFT", 18, -75)
	else
		bu[i]:SetPoint("LEFT", bu[i-1], "RIGHT", -2, 0)
	end
	bu[i].HL = bu[i]:CreateTexture(nil, "HIGHLIGHT")
	bu[i].HL:SetAllPoints(bu[i])
	bu[i].HL:SetColorTexture(r, g, b, .2)
end
B.CreateFS(bu[1], 12, LEVEL_ABBR)
B.CreateFS(bu[2], 12, CLASS_ABBR)
B.CreateFS(bu[3], 12, NAME, false, "LEFT", 10, 0)
B.CreateFS(bu[4], 12, ZONE, false, "RIGHT", -10, 0)

local whspInfo = DB.InfoColor..DB.RightButton..L["Whisper"]
B.CreateFS(infoFrame, 12, whspInfo, false, "BOTTOMRIGHT", -15, 50)
local copyInfo = DB.InfoColor.."ALT+"..DB.LeftButton..L["Copy Name"]
B.CreateFS(infoFrame, 12, copyInfo, false, "BOTTOMRIGHT", -15, 30)
local invtInfo = DB.InfoColor.."ALT+"..DB.RightButton..L["Invite"]
B.CreateFS(infoFrame, 12, invtInfo, false, "BOTTOMRIGHT", -15, 10)

local scrollFrame = CreateFrame("ScrollFrame", nil, infoFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(300, 375)
scrollFrame:SetPoint("CENTER", 0, -15)
scrollFrame.ScrollBar:Hide()
scrollFrame.ScrollBar.Show = B.Dummy
scrollFrame:SetScript("OnMouseWheel", function(self, delta)
	local scrollBar = scrollFrame.ScrollBar
	scrollBar:SetValue(scrollBar:GetValue() - delta*50)
end)
local roster = CreateFrame("Frame", nil, scrollFrame)
roster:SetSize(300, 1)
scrollFrame:SetScrollChild(roster)

local guildTable, frames, previous = {}, {}, 0
local function createRoster(i)
	local button = CreateFrame("Button", nil, roster)
	button:SetSize(300, 25)
	button.HL = button:CreateTexture(nil, "HIGHLIGHT")
	button.HL:SetAllPoints(button)
	button.HL:SetColorTexture(r, g, b, .2)

	button.level = B.CreateFS(button, 12, "Level", false)
	button.level:SetPoint("TOP", button, "TOPLEFT", 18, -6)
	button.class = button:CreateTexture(nil, "ARTWORK")
	button.class:SetPoint("LEFT", 35, 0)
	button.class:SetSize(18, 18)
	button.class:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
	button.status = B.CreateFS(button, 12, "Status", false, "LEFT", 60, 0)
	button.name = B.CreateFS(button, 12, "Name", false, "LEFT", 75, 0)
	button.name:SetPoint("RIGHT", button, "LEFT", 185, 0)
	button.name:SetJustifyH("LEFT")
	button.zone = B.CreateFS(button, 12, "Zone", false, "RIGHT", -5, 0)
	button.zone:SetPoint("LEFT", button, "RIGHT", -110, 0)
	button.zone:SetJustifyH("RIGHT")

	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", function(_, btn)
		local name = guildTable[i][3]
		if IsAltKeyDown() then
			if btn == "LeftButton" then
				local editBox = ChatEdit_ChooseBoxForSend()
				if editBox:HasFocus() then
					editBox:Insert(name)
				else
					ChatEdit_ActivateChat(editBox)
					editBox:SetText(name)
					editBox:HighlightText()
				end
			else
				InviteToGroup(name)
			end
		else
			if btn == "LeftButton" then return end
			ChatFrame_OpenChat("/w "..name.." ", chatFrame)
		end
	end)
	return button
end

local function refreshData()
	if not NDuiDB["Misc"].Sortby then NDuiDB["Misc"].Sortby = 1 end

	wipe(guildTable)
	GuildRoster()
	local count = 0
	local total, _, online = GetNumGuildMembers()
	local guildName, guildRank = GetGuildInfo("player")

	gName:SetText("|cff0099ff<"..(guildName or "")..">")
	gOnline:SetText(format(DB.InfoColor.."%s:".." %d/%d", GUILD_ONLINE_LABEL, online, total))
	gApps:SetText(format(DB.InfoColor..GUILDINFOTAB_APPLICANTS, GetNumGuildApplicants()))
	gRank:SetText(DB.InfoColor..RANK..": "..(guildRank or ""))

	for i = 1, total do
		local name, _, rank, level, _, zone, _, _, connected, status, class, _, _, mobile = GetGuildRosterInfo(i)
		if connected or mobile then
			if mobile and not connected then
				zone = REMOTE_CHAT
				if status == 1 then
					status = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:-2:-2:16:16:0:16:0:16|t"
				elseif status == 2 then
					status = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:-2:-2:16:16:0:16:0:16|t"
				else
					status = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255)
				end
			else
				if status == 1 then
					status = "|T"..FRIENDS_TEXTURE_AFK..":14:14:-2:-2:16:16:0:16:0:16|t"
				elseif status == 2 then
					status = "|T"..FRIENDS_TEXTURE_DND..":14:14:-2:-2:16:16:0:16:0:16|t"
				else
					status = " "
				end
			end
			if not zone then zone = UNKNOWN end

			count = count + 1
			guildTable[count] = {level, class, name, zone, rank, status}
		end
	end

	if count > previous then
		for i = previous+1, count do
			if not frames[i] then
				frames[i] = createRoster(i)
			end
		end
	elseif count < previous then
		for i = count+1, previous do
			frames[i]:Hide()
		end
	end
	previous = count
end

local function setPosition()
	for i = 1, previous do
		if i == 1 then
			frames[i]:SetPoint("TOPLEFT")
		else
			frames[i]:SetPoint("TOP", frames[i-1], "BOTTOM")
		end
		frames[i]:Show()
	end
end

local function applyData()
	sort(guildTable, function(a, b)
		if a and b then
			if NDuiDB["Misc"].SortOrder then
				return a[NDuiDB["Misc"].Sortby] < b[NDuiDB["Misc"].Sortby]
			else
				return a[NDuiDB["Misc"].Sortby] > b[NDuiDB["Misc"].Sortby]
			end
		end
	end)

	for i = 1, previous do
		local level, class, name, zone, rank, status = unpack(guildTable[i])

		local levelcolor = B.HexRGB(GetQuestDifficultyColor(level))
		frames[i].level:SetText(levelcolor..level)

		local tcoords = CLASS_ICON_TCOORDS[class]
		frames[i].class:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)

		local namecolor = B.HexRGB(B.ClassColor(class))
		frames[i].name:SetText(namecolor..Ambiguate(name, "guild"))
		frames[i].status:SetText(status)

		local zonecolor = "|cffa6a6a6"
		if GetRealZoneText() == zone then zonecolor = "|cff4cff4c" end
		frames[i].zone:SetText(zonecolor..zone)
	end
end

for i = 1, 4 do
	bu[i]:SetScript("OnClick", function()
		NDuiDB["Misc"].Sortby = i
		NDuiDB["Misc"].SortOrder = not NDuiDB["Misc"].SortOrder
		applyData()
	end)
end

info.eventList = {
	"PLAYER_ENTERING_WORLD",
	"GUILD_ROSTER_UPDATE",
	"PLAYER_GUILD_UPDATE",
}

info.onEvent = function(self)
	if not IsInGuild() then
		self.text:SetText(GUILD..": "..DB.MyColor..NONE)
		return
	end

	GuildRoster()
	local _, _, online = GetNumGuildMembers()
	self.text:SetText(GUILD..": "..DB.MyColor..online)

	if infoFrame:IsShown() then
		refreshData()
		setPosition()
		applyData()
	end
end

info.onEnter = function()
	if not IsInGuild() then return end
	refreshData()
	setPosition()
	applyData()
	infoFrame:Show()
end

info.onLeave = function()
	C_Timer.After(.1, function()
		if MouseIsOver(infoFrame) then return end
		infoFrame:Hide()
	end)
end

info.onMouseUp = function()
	infoFrame:Hide()
	ToggleGuildFrame()
end

infoFrame:SetScript("OnLeave", function(self)
	self:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed
		if self.timer > .1 then
			if not infoFrame:IsMouseOver() then
				self:Hide()
				self:SetScript("OnUpdate", nil)
			end

			self.timer = 0 
		end
	end)
end)