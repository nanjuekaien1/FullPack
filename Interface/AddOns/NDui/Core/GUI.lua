local _, ns = ...
local B, C, L, DB = unpack(ns)

-- Default Settings
local defaultSettings = {
	BFA = false,
	Mover = {},
	AuraWatchList = {},
	InternalCD = {},
	AuraWatchMover = {},
	RaidClickSets = {},
	Actionbar = {
		Enable = true,
		Hotkeys = true,
		Macro = true,
		Count = true,
		Classcolor = false,
		Cooldown = true,
		DecimalCD = true,
		Style = 1,
		Bar4Fade = false,
		Bar5Fade = true,
		Scale = 1,
	},
	Bags = {
		Enable = true,
		BagsScale = 1,
		IconSize = 34,
		BagsWidth = 12,
		BankWidth = 14,
		BagsiLvl = true,
		Artifact = true,
		ReverseSort = false,
		ItemFilter = true,
		ItemSetFilter = false,
	},
	Auras = {
		Reminder = true,
		Totems = true,
		DestroyTotems = true,
		Statue = true,
		ClassAuras = true,
	},
	AuraWatch = {
		Enable = true,
		ClickThrough = false,
		IconScale = 1,
	},
	UFs = {
		Enable = true,
		Portrait = true,
		ClassColor = false,
		SmoothColor = false,
		PlayerDebuff = true,
		ToTAuras = false,
		Boss = true,
		Arena = true,
		Castbars = true,
		StealableBuff = true,
		SwingBar = false,
		SwingTimer = false,
		RaidFrame = true,
		AutoRes = true,
		NumGroups = 6,
		SimpleMode = false,
		Dispellable = false,
		InstanceAuras = true,
		DebuffBorder = true,
		SpecRaidPos = false,
		RaidClassColor = false,
		HorizonRaid = false,
		ReverseRaid = false,
		RaidScale = 1,
		HealthPerc = false,
		AurasClickThrough = false,
		CombatText = true,
		HotsDots = true,
		AutoAttack = true,
		FCTOverHealing = false,
		PetCombatText = true,
		RaidClickSets = false,
		ShowTeamIndex = false,
		HeightScale = 1,
	},
	Chat = {
		Sticky = false,
		Lock = false,
		Invite = true,
		Freedom = true,
		Keyword = "raid",
		Oldname = false,
		GuildInvite = true,
		EnableFilter = true,
		Matches = 1,
		BlockAddonAlert = true,
		ChatMenu = true,
		WhisperColor = true,
	},
	Map = {
		Coord = true,
		Invite = true,
		Clock = false,
		CombatPulse = true,
		MapScale = 1,
		MinmapScale = 1.4,
		ShowRecycleBin = true,
		WhoPings = true,
		MapReveal = true,
	},
	Nameplate = {
		Enable = true,
		ColorBorder = false,
		maxAuras = 5,
		AuraSize = 22,
		FriendlyCC = false,
		HostileCC = true,
		TankMode = false,
		Arrow = true,
		InsideView = true,
		QuestIcon = true,
		MinAlpha = .7,
		Distance = 42,
		Width = 100,
		Height = 5,
		CustomUnitColor = true,
		CustomColor = {r=0, g=.8, b=.3},
		UnitList = "",
		ShowPowerList = "",
		VerticalSpacing = .7,
		ShowPlayerPlate = false,
		PPHeight = 5,
		PPPHeight = 5,
		PPPowerText = false,
		FullHealth = false,
		HighlightIndicator = true,
		SecureColor = {r=1, g=0, b=1},
		TransColor = {r=1, g=.8, b=0},
		InsecureColor = {r=1, g=0, b=0},
		DPSRevertThreat = false,
	},
	Skins = {
		DBM = true,
		MicroMenu = true,
		Skada = true,
		Bigwigs = true,
		RM = true,
		RMRune = false,
		DBMCount = "10",
		EasyMarking = true,
		TMW = true,
		PetBattle = true,
		WeakAuras = true,
		BarLine = true,
		InfobarLine = true,
		ChatLine = true,
		MenuLine = true,
		ClassLine = true,
		Details = true,
	},
	Tooltip = {
		CombatHide = false,
		Cursor = false,
		ClassColor = false,
		HideRank = false,
		HidePVP = true,
		HideFaction = true,
		FactionIcon = true,
		LFDRole = false,
		TargetBy = true,
		Scale = 1,
		AzeriteArmor = true,
	},
	Misc = {
		Mail = true,
		ItemLevel = true,
		MissingStats = true,
		HideErrors = true,
		SoloInfo = true,
		RareAlerter = true,
		AlertinChat = false,
		Focuser = true,
		ExpRep = true,
		Screenshot = false,
		TradeTab = true,
		Interrupt = false,
		OwnInterrupt = true,
		AlertInInstance = true,
		BrokenSpell = false,
		FasterLoot = true,
		AutoQuest = false,
		HideTalking = true,
		HideBanner = true,
		PetFilter = true,
		QuestNotifier = false,
		QuestProgress = false,
		OnlyCompleteRing = false,
	},
	Tutorial = {
		Complete = false,
	},
}

local accountSettings = {
	ChatFilterList = "%*",
	ChatAtList = "",
	Timestamp = false,
	NameplateFilter = {[1]={}, [2]={}},
	RaidDebuffs = {},
	Changelog = {},
	totalGold = {},
	RepairType = 1,
	AutoSell = true,
	GuildSortBy = 1,
	GuildSortOrder = true,
	ShowFPS = false,
	DetectVersion = DB.Version,
	ResetDetails = true,
	LockUIScale = false,
	UIScale = .8,
	GUIScale = 1,
	NumberFormat = 1,
	VersionCheck = true,
	DBMRequest = false,
	SkadaRequest = false,
	BWRequest = false,
}

local function InitialSettings(source, target)
	for i, j in pairs(source) do
		if type(j) == "table" then
			if target[i] == nil then target[i] = {} end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then target[i] = j end
		end
	end

	for i in pairs(target) do
		if source[i] == nil then
			target[i] = nil
		end
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "NDui" then return end
	if not NDuiDB["BFA"] then
		NDuiDB = {}
		NDuiDB["BFA"] = true
	end

	InitialSettings(defaultSettings, NDuiDB)
	InitialSettings(accountSettings, NDuiADB)

	self:UnregisterAllEvents()
end)

-- Config
local tabList = {
	L["Actionbar"],
	L["Bags"],
	L["Unitframes"],
	L["RaidFrame"],
	L["Nameplate"],
	L["Auras"],
	L["Raid Tools"],
	L["ChatFrame"],
	L["Maps"],
	L["Skins"],
	L["Tooltip"],
	L["Misc"],
	L["UI Settings"],
}

local optionList = {		-- type, key, value, name, horizon, doubleline
	[1] = {
		{1, "Actionbar", "Enable", "|cff00cc4c"..L["Enable Actionbar"]},
		{},--blank
		{1, "Actionbar", "Bar4Fade", L["Bar4 Fade"]},
		{1, "Actionbar", "Bar5Fade", L["Bar5 Fade"], true},
		{4, "Actionbar", "Style", L["Actionbar Style"], false, {L["BarStyle1"], L["BarStyle2"], L["BarStyle3"], L["BarStyle4"], L["BarStyle5"]}},
		{3, "Actionbar", "Scale", L["Actionbar Scale"], true, {.8, 1.5, 1}},
		{},--blank
		{1, "Actionbar", "Hotkeys", L["Actionbar Hotkey"]},
		{1, "Actionbar", "Macro", L["Actionbar Macro"], true},
		{1, "Actionbar", "Count", L["Actionbar Item Counts"]},
		{1, "Actionbar", "Classcolor", L["ClassColor BG"], true},
		{},--blank
		{1, "Actionbar", "Cooldown", L["Show Cooldown"]},
		{1, "Actionbar", "DecimalCD", L["Decimal Cooldown"], true},
	},
	[2] = {
		{1, "Bags", "Enable", "|cff00cc4c"..L["Enable Bags"]},
		{},--blank
		{1, "Bags", "BagsiLvl", L["Bags Itemlevel"]},
		{1, "Bags", "Artifact", L["Bags Artifact"], true},
		{1, "Bags", "ItemFilter", L["Bags ItemFilter"]},
		{1, "Bags", "ItemSetFilter", L["Use ItemSetFilter"], true},
		{1, "Bags", "ReverseSort", L["Bags ReverseSort"]},
		{},--blank
		{3, "Bags", "BagsScale", L["Bags Scale"], false, {.5, 1.5, 1}},
		{3, "Bags", "IconSize", L["Bags IconSize"], true, {30, 42, 0}},
		{3, "Bags", "BagsWidth", L["Bags Width"], false, {10, 20, 0}},
		{3, "Bags", "BankWidth", L["Bank Width"], true, {10, 20, 0}},
	},
	[3] = {
		{1, "UFs", "Enable", "|cff00cc4c"..L["Enable UFs"]},
		{},--blank
		{1, "UFs", "Castbars", L["UFs Castbar"]},
		{1, "UFs", "SwingBar", L["UFs SwingBar"]},
		{1, "UFs", "SwingTimer", L["UFs SwingTimer"], true},
		{},--blank
		{1, "UFs", "Boss", L["Boss Frame"]},
		{1, "UFs", "Arena", L["Arena Frame"], true},
		{1, "UFs", "Portrait", L["UFs Portrait"]},
		{1, "UFs", "StealableBuff", L["Stealable Buff"], true},
		{1, "UFs", "ClassColor", L["Classcolor HpBar"]},
		{1, "UFs", "SmoothColor", L["Smoothcolor HpBar"], true},
		{1, "UFs", "PlayerDebuff", L["Player Debuff"]},
		{1, "UFs", "ToTAuras", L["ToT Debuff"]},
		{3, "UFs", "HeightScale", L["UFs HeightScale"], true, {.8, 1.5, 1}},
		{},--blank
		{1, "UFs", "CombatText", "|cff00cc4c"..L["UFs CombatText"]},
		{1, "UFs", "HotsDots", L["CombatText HotsDots"]},
		{1, "UFs", "FCTOverHealing", L["CombatText OverHealing"], true},
		{1, "UFs", "AutoAttack", L["CombatText AutoAttack"]},
		{1, "UFs", "PetCombatText", L["CombatText ShowPets"], true},
	},
	[4] = {
		{1, "UFs", "RaidFrame", "|cff00cc4c"..L["UFs RaidFrame"]},
		{1, "UFs", "SimpleMode", L["Simple RaidFrame"], true},
		{},--blank
		{1, "UFs", "ShowTeamIndex", L["RaidFrame TeamIndex"]},
		{1, "UFs", "HealthPerc", L["Show HealthPerc"], true},
		{1, "UFs", "HorizonRaid", L["Horizon RaidFrame"]},
		{1, "UFs", "ReverseRaid", L["Reverse RaidFrame"], true},
		{1, "UFs", "SpecRaidPos", L["Spec RaidPos"]},
		{1, "UFs", "RaidClassColor", L["ClassColor RaidFrame"], true},
		{3, "UFs", "NumGroups", L["Num Groups"], false, {4, 8, 0}},
		{3, "UFs", "RaidScale", L["RaidFrame Scale"], true, {.8, 1.5, 2}},
		{},--blank
		{1, "UFs", "AurasClickThrough", L["RaidAuras ClickThrough"]},
		{1, "UFs", "DebuffBorder", L["Auras Border"], true},
		{1, "UFs", "Dispellable", L["Dispellable Only"]},
		{1, "UFs", "InstanceAuras", L["Instance Auras"], true},
		{},--blank
		{1, "UFs", "RaidClickSets", L["Enable ClickSets"]},
		{1, "UFs", "AutoRes", L["UFs AutoRes"], true},
	},
	[5] = {
		{1, "Nameplate", "Enable", "|cff00cc4c"..L["Enable Nameplate"]},
		{},--blank
		{1, "Nameplate", "CustomUnitColor", "|cff00cc4c"..L["CustomUnitColor"]},
		{5, "Nameplate", "CustomColor", L["Custom Color"], 2},
		{2, "Nameplate", "UnitList", L["UnitColor List"]},
		{2, "Nameplate", "ShowPowerList", L["ShowPowerList"], true},
		{},--blank
		{1, "Nameplate", "TankMode", "|cff00cc4c"..L["Tank Mode"]},
		{1, "Nameplate", "DPSRevertThreat", L["DPS Revert Threat"], true},
		{5, "Nameplate", "SecureColor", L["Secure Color"]},
		{5, "Nameplate", "TransColor", L["Trans Color"], 1},
		{5, "Nameplate", "InsecureColor", L["Insecure Color"], 2},
		{},--blank
		{1, "Nameplate", "FriendlyCC", L["Friendly CC"]},
		{1, "Nameplate", "HostileCC", L["Hostile CC"], true},
		{1, "Nameplate", "Arrow", L["Show Arrow"]},
		{1, "Nameplate", "HighlightIndicator", L["Show HighlightIndicator"], true},
		{1, "Nameplate", "QuestIcon", L["Nameplate QuestIcon"]},
		{1, "Nameplate", "ColorBorder", L["Auras Border"], true},
		{1, "Nameplate", "InsideView", L["Nameplate InsideView"]},
		{1, "Nameplate", "FullHealth", L["Show FullHealth"], true},
		{3, "Nameplate", "maxAuras", L["Max Auras"], false, {0, 10, 0}},
		{3, "Nameplate", "AuraSize", L["Auras Size"], true, {18, 40, 0}},
		{3, "Nameplate", "VerticalSpacing", L["NP VerticalSpacing"], false, {.5, 1.5, 1}},
		{3, "Nameplate", "Distance", L["Nameplate Distance"], true, {20, 100, 0}},
		{3, "Nameplate", "Width", L["NP Width"], false, {50, 150, 0}},
		{3, "Nameplate", "Height", L["NP Height"], true, {5, 15, 0}},
		{3, "Nameplate", "MinAlpha", L["Nameplate MinAlpha"], false, {0, 1, 1}},
	},
	[6] = {
		{1, "AuraWatch", "Enable", "|cff00cc4c"..L["Enable AuraWatch"]},
		{1, "AuraWatch", "ClickThrough", L["AuraWatch ClickThrough"]},
		{3, "AuraWatch", "IconScale", L["AuraWatch IconScale"], false, {.8, 2, 1}},
		{},--blank
		{1, "Auras", "Statue", L["Enable Statue"]},
		{1, "Auras", "Totems", L["Enable Totems"], true},
		{1, "Auras", "Reminder", L["Enable Reminder"]},
		{},--blank
		{1, "Nameplate", "ShowPlayerPlate", "|cff00cc4c"..L["Enable PlayerPlate"]},
		{1, "Auras", "ClassAuras", L["Enable ClassAuras"]},
		{1, "Nameplate", "PPPowerText", L["PlayerPlate PowerText"], true},
		{3, "Nameplate", "PPHeight", L["PlayerPlate HPHeight"], false, {5, 15, 0}},
		{3, "Nameplate", "PPPHeight", L["PlayerPlate MPHeight"], true, {5, 15, 0}},
	},
	[7] = {
		{1, "Skins", "RM", "|cff00cc4c"..L["Raid Manger"]},
		{1, "Skins", "RMRune", L["Runes Check"]},
		{1, "Skins", "EasyMarking", L["Easy Mark"]},
		{2, "Skins", "DBMCount", L["Countdown Sec"], true},
		{},--blank
		{1, "Chat", "Invite", "|cff00cc4c"..L["Whisper Invite"]},
		{1, "Chat", "GuildInvite", L["Guild Invite Only"]},
		{2, "Chat", "Keyword", L["Whisper Keyword"], true},
		{},--blank
		{1, "Misc", "QuestNotifier", "|cff00cc4c"..L["QuestNotifier"]},
		{1, "Misc", "QuestProgress", L["QuestProgress"]},
		{1, "Misc", "OnlyCompleteRing", L["OnlyCompleteRing"], true},
		{},--blank
		{1, "Misc", "Interrupt", "|cff00cc4c"..L["Interrupt Alert"]},
		{1, "Misc", "BrokenSpell", L["Broken Spell"], true},
		{1, "Misc", "OwnInterrupt", L["Own Interrupt"]},
		{1, "Misc", "AlertInInstance", L["Alert In Instance"], true},
		{},--blank
		{1, "Misc", "RareAlerter", "|cff00cc4c"..L["Rare Alert"]},
		{1, "Misc", "AlertinChat", L["Alert In Chat"], true},
	},
	[8] = {
		{1, "Chat", "Lock", L["Lock Chat"]},
		{},--blank
		{1, "Chat", "Freedom", L["Language Filter"]},
		{1, "Chat", "Sticky", L["Chat Sticky"], true},
		{1, "Chat", "Oldname", L["Default Channel"]},
		{1, "Chat", "WhisperColor", L["Differ WhipserColor"], true},
		{1, "ACCOUNT", "Timestamp", L["Timestamp"], false, nil, function() B.UpdateTimestamp() end},
		{},--blank
		{1, "Chat", "EnableFilter", L["Enable Chatfilter"]},
		{1, "Chat", "BlockAddonAlert", L["Block Addon Alert"], true},
		{3, "Chat", "Matches", L["Keyword Match"], false, {1, 3, 0}},
		{2, "ACCOUNT", "ChatFilterList", L["Filter List"], true, nil, function() B.genFilterList() end},
		{2, "ACCOUNT", "ChatAtList", L["@List"], false, nil, function() B.genChatAtList() end},
	},
	[9] = {
		{1, "Map", "Coord", L["Map Coords"]},
		{},--blank
		{1, "Map", "Invite", L["Calendar Reminder"]},
		{1, "Map", "Clock", L["Minimap Clock"], true},
		{1, "Map", "CombatPulse", L["Minimap Pulse"]},
		{1, "Map", "ShowRecycleBin", L["Show RecycleBin"], true},
		{1, "Map", "WhoPings", L["Show WhoPings"]},
		{1, "Misc", "ExpRep", L["Show Expbar"], true},
		{},--blank
		{3, "Map", "MapScale", L["Map Scale"], false, {1, 2, 1}},
		{3, "Map", "MinmapScale", L["Minimap Scale"], true, {1, 2, 1}},
	},
	[10] = {
		{1, "Skins", "BarLine", L["Bar Line"]},
		{1, "Skins", "InfobarLine", L["Infobar Line"], true},
		{1, "Skins", "ChatLine", L["Chat Line"]},
		{1, "Skins", "MenuLine", L["Menu Line"], true},
		{1, "Skins", "ClassLine", L["ClassColor Line"]},
		{},--blank
		{1, "Skins", "MicroMenu", L["Micromenu"]},
		{1, "Skins", "PetBattle", L["PetBattle Skin"], true},
		{},--blank
		{1, "Skins", "DBM", L["DBM Skin"]},
		{1, "Skins", "Skada", L["Skada Skin"], true},
		{1, "Skins", "Bigwigs", L["Bigwigs Skin"]},
		{1, "Skins", "TMW", L["TMW Skin"], true},
		{1, "Skins", "WeakAuras", L["WeakAuras Skin"]},
		{1, "Skins", "Details", L["Details Skin"], true},
	},
	[11] = {
		{1, "Tooltip", "CombatHide", L["Hide Tooltip"]},
		{1, "Tooltip", "Cursor", L["Follow Cursor"]},
		{1, "Tooltip", "ClassColor", L["Classcolor Border"]},
		{3, "Tooltip", "Scale", L["Tooltip Scale"], true, {.5, 1.5, 1}},
		{},--blank
		{1, "Tooltip", "HideRank", L["Hide Rank"]},
		{1, "Tooltip", "HidePVP", L["Hide PVP"], true},
		{1, "Tooltip", "HideFaction", L["Hide Faction"]},
		{1, "Tooltip", "FactionIcon", L["FactionIcon"], true},
		{1, "Tooltip", "LFDRole", L["Group Roles"]},
		{1, "Tooltip", "TargetBy", L["Show TargetedBy"], true},
		{1, "Tooltip", "AzeriteArmor", L["Show AzeriteArmor"]},
	},
	[12] = {
		{1, "Misc", "Mail", L["Mail Tool"]},
		{1, "Misc", "Focuser", L["Easy Focus"], true},
		{1, "Misc", "TradeTab", L["TradeTabs"]},
		{1, "Misc", "PetFilter", L["Show PetFilter"], true},
		{},--blank
		{1, "Misc", "ItemLevel", L["Show ItemLevel"]},
		{1, "Misc", "MissingStats", L["Show MissingStats"], true},
		{1, "Misc", "Screenshot", L["Auto ScreenShot"]},
		{1, "Misc", "FasterLoot", L["Faster Loot"], true},
		{},--blank
		{1, "Misc", "HideTalking", L["No Talking"]},
		{1, "Misc", "HideBanner", L["Hide Bossbanner"], true},
		{1, "Misc", "HideErrors", L["Hide Error"]},
		{1, "Misc", "SoloInfo", L["SoloInfo"], true},
	},
	[13] = {
		{1, "ACCOUNT", "VersionCheck", L["Version Check"]},
		{},--blank
		{3, "ACCOUNT", "UIScale", L["Setup UIScale"], false, {.5, 1.1, 2}},
		{1, "ACCOUNT", "LockUIScale", "|cff00cc4c"..L["Lock UIScale"], true},
		{},--blank
		{3, "ACCOUNT", "GUIScale", L["GUI Scale"], false, {.5, 1.5, 1}},
		{4, "ACCOUNT", "NumberFormat", L["Numberize"], true, {L["Number Type1"], L["Number Type2"], L["Number Type3"]}},
	},
}

local r, g, b = DB.cc.r, DB.cc.g, DB.cc.b
local guiTab, guiPage, f = {}, {}

local function SelectTab(i)
	for num = 1, #tabList do
		if num == i then
			guiTab[num]:SetBackdropColor(r, g, b, .3)
			guiTab[num].checked = true
			guiPage[num]:Show()
		else
			guiTab[num]:SetBackdropColor(0, 0, 0, .3)
			guiTab[num].checked = false
			guiPage[num]:Hide()
		end
	end
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame("Button", nil, parent)
	tab:SetPoint("TOPLEFT", 20, -30*i - 20)
	tab:SetSize(130, 28)
	B.CreateBD(tab, .3)
	B.CreateFS(tab, 15, name, "system", "LEFT", 10, 0)

	tab:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		SelectTab(i)
	end)
	tab:SetScript("OnEnter", function(self)
		if self.checked then return end
		self:SetBackdropColor(r, g, b, .3)
	end)
	tab:SetScript("OnLeave", function(self)
		if self.checked then return end
		self:SetBackdropColor(0, 0, 0, .3)
	end)
	return tab
end

local function NDUI_VARIABLE(key, value, newValue)
	if key == "ACCOUNT" then
		if newValue ~= nil then
			NDuiADB[value] = newValue
		else
			return NDuiADB[value]
		end
	else
		if newValue ~= nil then
			NDuiDB[key][value] = newValue
		else
			return NDuiDB[key][value]
		end
	end
end

local function CreateOption(i)
	local parent, offset = guiPage[i].child, 20

	for _, option in pairs(optionList[i]) do
		local type, key, value, name, horizon, data, callBack = unpack(option)
		-- Checkboxes
		if type == 1 then
			local cb = B.CreateCheckBox(parent)
			if horizon then
				cb:SetPoint("TOPLEFT", 330, -offset + 35)
			else
				cb:SetPoint("TOPLEFT", 20, -offset)
				offset = offset + 35
			end
			B.CreateFS(cb, 14, name, false, "LEFT", 30, 0)
			cb:SetChecked(NDUI_VARIABLE(key, value))
			cb:SetScript("OnClick", function()
				NDUI_VARIABLE(key, value, cb:GetChecked())
				if callBack then callBack() end
			end)
		-- Editbox
		elseif type == 2 then
			local eb = B.CreateEditBox(parent, 200, 28)
			eb:SetMaxLetters(200)
			if horizon then
				eb:SetPoint("TOPLEFT", 345, -offset + 50)
			else
				eb:SetPoint("TOPLEFT", 35, -offset - 20)
				offset = offset + 70
			end
			eb:SetText(NDUI_VARIABLE(key, value))
			eb:HookScript("OnEscapePressed", function()
				eb:SetText(NDUI_VARIABLE(key, value))
			end)
			eb:HookScript("OnEnterPressed", function()
				NDUI_VARIABLE(key, value, eb:GetText())
				if callBack then callBack() end
			end)
			eb:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L["Tips"])
				GameTooltip:AddLine(L["EdieBox Tip"], .6,.8,1)
				GameTooltip:Show()
			end)
			eb:SetScript("OnLeave", GameTooltip_Hide)

			B.CreateFS(eb, 14, name, "system", "CENTER", 0, 25)
		-- Slider
		elseif type == 3 then
			local min, max, step = unpack(data)
			local s = CreateFrame("Slider", key..value.."Slider", parent, "OptionsSliderTemplate")
			if horizon then
				s:SetPoint("TOPLEFT", 350, -offset + 40)
			else
				s:SetPoint("TOPLEFT", 40, -offset - 30)
				offset = offset + 70
			end
			s:SetWidth(190)
			s:SetMinMaxValues(min, max)
			s:SetValue(NDUI_VARIABLE(key, value))
			s:SetScript("OnValueChanged", function(_, v)
				local current = tonumber(format("%."..step.."f", v))
				NDUI_VARIABLE(key, value, current)
				_G[s:GetName().."Text"]:SetText(current)
			end)

			B.CreateFS(s, 14, name, "system", "CENTER", 0, 25)
			_G[s:GetName().."Low"]:SetText(min)
			_G[s:GetName().."High"]:SetText(max)
			_G[s:GetName().."Text"]:ClearAllPoints()
			_G[s:GetName().."Text"]:SetPoint("TOP", s, "BOTTOM", 0, 3)
			_G[s:GetName().."Text"]:SetText(format("%."..step.."f", NDUI_VARIABLE(key, value)))
			s:SetBackdrop(nil)
			local bd = CreateFrame("Frame", nil, s)
			bd:SetPoint("TOPLEFT", 14, -2)
			bd:SetPoint("BOTTOMRIGHT", -15, 3)
			bd:SetFrameStrata("BACKGROUND")
			B.CreateBD(bd, .3)
			local thumb = _G[s:GetName().."Thumb"]
			thumb:SetTexture(DB.sparkTex)
			thumb:SetBlendMode("ADD")
		-- Dropdown
		elseif type == 4 then
			local dd = B.CreateDropDown(parent, 200, 28, data)
			if horizon then
				dd:SetPoint("TOPLEFT", 345, -offset + 50)
			else
				dd:SetPoint("TOPLEFT", 35, -offset - 20)
				offset = offset + 70
			end
			dd.Text:SetText(data[NDUI_VARIABLE(key, value)])

			local opt = dd.options
			dd.button:HookScript("OnClick", function()
				for num = 1, #data do
					if num == NDUI_VARIABLE(key, value) then
						opt[num]:SetBackdropColor(1, .8, 0, .3)
						opt[num].selected = true
					else
						opt[num]:SetBackdropColor(0, 0, 0, .3)
						opt[num].selected = false
					end
				end
			end)
			for i in pairs(data) do
				opt[i]:HookScript("OnClick", function()
					NDUI_VARIABLE(key, value, i)
				end)
			end

			B.CreateFS(dd, 14, name, "system", "CENTER", 0, 25)
		-- Colorswatch
		elseif type == 5 then
			local f = CreateFrame("Button", nil, parent)
			local width = 25 + (horizon or 0)*155
			if horizon then
				f:SetPoint("TOPLEFT", width, -offset + 30)
			else
				f:SetPoint("TOPLEFT", width, -offset - 5)
				offset = offset + 35
			end
			f:SetSize(18, 18)
			B.CreateBD(f, 1)
			B.CreateFS(f, 14, name, false, "LEFT", 26, 0)

			local tex = f:CreateTexture()
			tex:SetPoint("TOPLEFT", 2, -2)
			tex:SetPoint("BOTTOMRIGHT", -2, 2)
			tex:SetColorTexture(NDUI_VARIABLE(key, value).r, NDUI_VARIABLE(key, value).g, NDUI_VARIABLE(key, value).b)

			local function onUpdate()
				local r, g, b = ColorPickerFrame:GetColorRGB()
				tex:SetColorTexture(r, g, b)
				NDUI_VARIABLE(key, value).r, NDUI_VARIABLE(key, value).g, NDUI_VARIABLE(key, value).b = r, g, b
			end

			local function onCancel()
				local r, g, b = ColorPicker_GetPreviousValues()
				tex:SetColorTexture(r, g, b)
				NDUI_VARIABLE(key, value).r, NDUI_VARIABLE(key, value).g, NDUI_VARIABLE(key, value).b = r, g, b
			end

			f:SetScript("OnClick", function()
				local r, g, b = NDUI_VARIABLE(key, value).r, NDUI_VARIABLE(key, value).g, NDUI_VARIABLE(key, value).b
				ColorPickerFrame.func = onUpdate
				ColorPickerFrame.previousValues = {r = r, g = g, b = b}
				ColorPickerFrame.cancelFunc = onCancel
				ColorPickerFrame:SetColorRGB(r, g, b)
				ColorPickerFrame:Show()
			end)
		-- Blank, no type
		else
			local l = CreateFrame("Frame", nil, parent)
			l:SetPoint("TOPLEFT", 25, -offset - 12)
			B.CreateGF(l, 550, 2, "Horizontal", .7, .7, .7, .7, 0)
			offset = offset + 35
		end
	end
end

local plateGUI
local function SetupPlateAura()
	if plateGUI then ToggleFrame(plateGUI) return end

	plateGUI = CreateFrame("Frame", nil, guiPage[5])
	plateGUI:SetSize(300, 600)
	plateGUI:SetPoint("TOPLEFT", f, "TOPRIGHT", 2, 0)
	B.CreateBD(plateGUI)
	B.CreateSD(plateGUI)
	B.CreateTex(plateGUI)
	guiPage[5]:HookScript("OnHide", function()
		plateGUI:Hide()
	end)

	local frameData = {
		[1] = {text = L["WhiteList"], offset = -25, barList = {}},
		[2] = {text = L["BlackList"], offset = -315, barList = {}},
	}

	local function sortBars(index)
		local num = 1
		for _, bar in pairs(frameData[index].barList) do
			if num == 1 then
				bar:SetPoint("TOPLEFT", 10, -10)
			else
				bar:SetPoint("TOPLEFT", 10, -10 - 35*(num-1))
			end
			num = num + 1
		end
	end

	local function createBar(parent, index, spellID)
		local name, _, texture = GetSpellInfo(spellID)
		local bar = CreateFrame("Frame", nil, parent)
		bar:SetSize(220, 30)
		B.CreateBD(bar, .3)
		frameData[index].barList[spellID] = bar

		local icon = CreateFrame("Frame", nil, bar)
		icon:SetSize(20, 20)
		icon:SetPoint("LEFT", 5, 0)
		B.CreateIF(icon, true)
		icon.Icon:SetTexture(texture)
		B.AddTooltip(icon, "ANCHOR_RIGHT", spellID)

		local close = CreateFrame("Button", nil, bar)
		close:SetSize(20, 20)
		close:SetPoint("RIGHT", -5, 0)
		close.Icon = close:CreateTexture(nil, "ARTWORK")
		close.Icon:SetAllPoints()
		close.Icon:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
		close:SetHighlightTexture(close.Icon:GetTexture())
		close:SetScript("OnClick", function()
			bar:Hide()
			frameData[index].barList[spellID] = nil
			NDuiADB["NameplateFilter"][index][spellID] = nil
			sortBars(index)
		end)

		local spellName = B.CreateFS(bar, 14, name, false, "LEFT", 30, 0)
		spellName:SetWidth(180)
		spellName:SetJustifyH("LEFT")
		if index == 2 then spellName:SetTextColor(1, 0, 0) end

		sortBars(index)
	end

	local function addClick(parent, index)
		local spellID = tonumber(parent.box:GetText())
		if not spellID or not GetSpellInfo(spellID) then UIErrorsFrame:AddMessage(DB.InfoColor..L["Incorrect SpellID"]) return end
		if NDuiADB["NameplateFilter"][index][spellID] then UIErrorsFrame:AddMessage(DB.InfoColor..L["Existing ID"]) return end

		NDuiADB["NameplateFilter"][index][spellID] = true
		createBar(parent.child, index, spellID)
		parent.box:SetText("")
	end

	for index, value in ipairs(frameData) do
		B.CreateFS(plateGUI, 14, value.text, "system", "TOPLEFT", 20, value.offset)
		local frame = CreateFrame("Frame", "frame"..index, plateGUI)
		frame:SetSize(280, 250)
		frame:SetPoint("TOPLEFT", 10, value.offset - 25)
		B.CreateBD(frame, .3)

		local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
		scroll:SetSize(240, 200)
		scroll:SetPoint("BOTTOMLEFT", 10, 10)
		B.CreateBD(scroll, .3)
		scroll.child = CreateFrame("Frame", nil, scroll)
		scroll.child:SetSize(240, 1)
		scroll:SetScrollChild(scroll.child)
		if IsAddOnLoaded("AuroraClassic") then
			local F = unpack(AuroraClassic)
			F.ReskinScroll(scroll.ScrollBar)
		end

		scroll.box = B.CreateEditBox(frame, 185, 25)
		scroll.box:SetPoint("TOPLEFT", 10, -10)

		scroll.add = B.CreateButton(frame, 70, 25, ADD)
		scroll.add:SetPoint("TOPRIGHT", -8, -10)
		scroll.add:SetScript("OnClick", function()
			addClick(scroll, index)
		end)

		for spellID in pairs(NDuiADB["NameplateFilter"][index]) do
			createBar(scroll.child, index, spellID)
		end
	end
end

local function OpenGUI()
	if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
	if f then f:Show() return end

	-- Main Frame
	f = CreateFrame("Frame", "NDuiGUI", UIParent)
	tinsert(UISpecialFrames, "NDuiGUI")
	f:SetScale(NDuiADB["GUIScale"])
	f:SetSize(800, 600)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.CreateBD(f)
	B.CreateSD(f)
	B.CreateTex(f)
	B.CreateFS(f, 18, L["NDui Console"], true, "TOP", 0, -10)
	B.CreateFS(f, 16, DB.Version.." ("..DB.Support..")", false, "TOP", 0, -30)

	local close = B.CreateButton(f, 80, 20, CLOSE)
	close:SetPoint("BOTTOMRIGHT", -20, 15)
	close:SetFrameLevel(3)
	close:SetScript("OnClick", function() f:Hide() end)

	local scaleOld = NDuiADB["UIScale"]
	local ok = B.CreateButton(f, 80, 20, OKAY)
	ok:SetPoint("RIGHT", close, "LEFT", -10, 0)
	ok:SetFrameLevel(3)
	ok:SetScript("OnClick", function()
		local scale = NDuiADB["UIScale"]
		if scale ~= scaleOld then
			if scale < .64 then
				UIParent:SetScale(scale)
			else
				SetCVar("uiScale", scale)
			end
			if NDuiDB["Chat"]["Lock"] then
				ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 28)
			end
		end
		f:Hide()
		StaticPopup_Show("RELOAD_NDUI")
	end)

	for i, name in pairs(tabList) do
		guiTab[i] = CreateTab(f, i, name)

		guiPage[i] = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		guiPage[i]:SetPoint("TOPLEFT", 160, -50)
		guiPage[i]:SetSize(610, 500)
		B.CreateBD(guiPage[i], .3)
		guiPage[i]:Hide()
		guiPage[i].child = CreateFrame("Frame", nil, guiPage[i])
		guiPage[i].child:SetSize(610, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		if IsAddOnLoaded("AuroraClassic") then
			local F = unpack(AuroraClassic)
			F.ReskinScroll(guiPage[i].ScrollBar)
		end

		CreateOption(i)
	end

	local reset = B.CreateButton(f, 120, 20, L["NDui Reset"])
	reset:SetPoint("BOTTOMLEFT", 25, 15)
	StaticPopupDialogs["RESET_NDUI"] = {
		text = L["Reset NDui Check"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			NDuiDB = {}
			NDuiADB = {}
			ReloadUI()
		end,
		whileDead = 1,
	}
	reset:SetScript("OnClick", function()
		StaticPopup_Show("RESET_NDUI")
	end)

	local credit = CreateFrame("Button", nil, f)
	credit:SetPoint("TOPRIGHT", -20, -15)
	credit:SetSize(35, 35)
	credit.Icon = credit:CreateTexture(nil, "ARTWORK")
	credit.Icon:SetAllPoints()
	credit.Icon:SetTexture(DB.creditTex)
	credit:SetHighlightTexture(DB.creditTex)
	credit:SetScript("OnEnter", function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(f, "ANCHOR_TOPRIGHT", 0, 3)
		GameTooltip:AddLine("Credits:")
		GameTooltip:AddLine(GetAddOnMetadata("NDui", "X-Credits"), .6,.8,1, 1)
		GameTooltip:Show()
	end)
	credit:SetScript("OnLeave", GameTooltip_Hide)

	local function showLater(event)
		if event == "PLAYER_REGEN_DISABLED" then
			if f:IsShown() then
				f:Hide()
				B:RegisterEvent("PLAYER_REGEN_ENABLED", showLater)
			end
		else
			f:Show()
			B:UnregisterEvent(event, showLater)
		end
	end
	B:RegisterEvent("PLAYER_REGEN_DISABLED", showLater)

	-- Toggle RaidFrame ClickSets
	local clickSet = B.CreateButton(guiPage[4].child, 150, 30, L["Add ClickSets"])
	clickSet:SetPoint("TOPLEFT", 40, -440)
	clickSet.text:SetTextColor(.6, .8, 1)
	clickSet:SetScript("OnClick", function()
		f:Hide()
		SlashCmdList["NDUI_AWCONFIG"]()
		NDui_AWConfigTab12:Click()
	end)

	-- Toggle Nameplate aurafilter
	local plate = B.CreateButton(guiPage[5].child, 150, 30, L["Nameplate AuraFilter"])
	plate:SetPoint("TOPLEFT", 340, -20)
	plate.text:SetTextColor(.6, .8, 1)
	plate:SetScript("OnClick", SetupPlateAura)

	-- Toggle AuraWatch Console
	local aura = B.CreateButton(guiPage[6].child, 150, 30, L["Add AuraWatch"])
	aura:SetPoint("TOPLEFT", 340, -100)
	aura.text:SetTextColor(.6, .8, 1)
	aura:SetScript("OnClick", function()
		f:Hide()
		SlashCmdList["NDUI_AWCONFIG"]()
	end)

	-- Reset detail skin
	local detail = B.CreateButton(guiPage[10].child, 50, 25, RESET)
	detail:SetPoint("TOPLEFT", 480, -300)
	detail.text:SetTextColor(.6, .8, 1)
	detail:SetScript("OnClick", function()
		NDuiADB["ResetDetails"] = true
		StaticPopup_Show("RELOAD_NDUI")
	end)

	SelectTab(1)
end

local gui = CreateFrame("Button", "GameMenuFrameNDui", GameMenuFrame, "GameMenuButtonTemplate")
gui:SetText(L["NDui Console"])
gui:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -21)
GameMenuFrame:HookScript("OnShow", function(self)
	GameMenuButtonLogout:SetPoint("TOP", gui, "BOTTOM", 0, -21)
	self:SetHeight(self:GetHeight() + gui:GetHeight() + 22)
end)

gui:SetScript("OnClick", function()
	OpenGUI()
	HideUIPanel(GameMenuFrame)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
end)

-- Aurora Reskin
if IsAddOnLoaded("AuroraClassic") then
	local F = unpack(AuroraClassic)
	F.Reskin(gui)
end