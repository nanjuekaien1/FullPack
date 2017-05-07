local B, C, L, DB = unpack(select(2, ...))

-- Default Settings
local defaultSettings = {
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
	},
	Bags = {
		Enable = true,
		BagsScale = 1,
		IconSize = 34,
		BagsWidth = 12,
		BankWidth = 14,
		BagsiLvl = true,
		Artifact = true,
		NewItemGlow = true,
		ReverseSort = false,
	},
	Auras = {
		Familiar = true,
		Reminder = true,
		Stagger = true,
		BloodyHell = true,
		Totems = true,
		DestroyTotems = true,
		Marksman = true,
		Statue = true,
	},
	AuraWatch = {
		Enable = true,
		Hint = true,
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
		ExpRep = false,
		Totems = false,
		ResourceBar = true,
		Castbars = true,
		AddPower = true,
		StealableBuff = true,
		SwingBar = false,
		SwingTimer = false,
		RaidFrame = false,
		AutoRes = true,
		NumGroups = 6,
		SimpleMode = false,
		Dispellable = false,
		InstanceAuras = true,
		DebuffBorder = true,
		SpecRaidPos = false,
		RaidClassColor = false,
		HorizonRaid = false,
		RaidScale = 1,
		HealthPerc = false,
		NoTooltip = false,
		CombatText = true,
		HotsDots = true,
		PetCombatText = true,
	},
	Chat = {
		Sticky = false,
		Lock = false,
		Invite = true,
		Freedom = true,
		Keyword = "raid",
		Oldname = false,
		GuildInvite = true,
		NoFade = false,
		EasyResize = true,
		EnableFilter = true,
		Matches = 1,
	},
	Map = {
		Coord = true,
		Invite = true,
		Clock = false,
		CombatPulse = true,
		HideFog = true,
		MapScale = 1.1,
		MinmapScale = 1.4,
		ShowRecycleBin = true,
	},
	Nameplate = {
		Enable = true,
		ColorBorder = false,
		PlayerAura = false,
		maxAuras = 5,
		AuraSize = 20,
		AuraFilter = 2,
		OtherFilter = 2,
		FriendlyCC = false,
		HostileCC = true,
		TankMode = false,
		Arrow = true,
		InsideView = false,
		MinAlpha = .7,
		Distance = 42,
		Width = 100,
		Height = 5,
		CustomUnitColor = true,
		UnitList = "",
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
		FontFlag = true,
		PetBattle = true,
		RCLC = true,
		ExtraCD = true,
		WeakAuras = true,
	},
	Tooltip = {
		CombatHide = false,
		Cursor = false,
		ClassColor = false,
		Scale = 1,
		HideTitle = false,
		HideRealm = false,
		HideRank = false,
		HidePVP = true,
		HideFaction = true,
		FactionIcon = true,
		LFDRole = false,
		TargetBy = true,
	},
	Misc = {
		Mail = true,
		Durability = true,
		HideErrors = true,
		SoloInfo = true,
		RareAlerter = true,
		AlertinChat = false,
		Focuser = true,
		Autoequip = true,
		ExpRep = true,
		Screenshot = false,
		TradeTab = true,
		Interrupt = false,
		FasterLoot = true,
		AutoQuest = false,
		HideTalking = true,
		HideBanner = true,
		PetFilter = true,
	},
	Settings = {
		LockUIScale = false,
		SetScale = .8,
		GUIScale = 1,
		Format = 1,
	},
	Tutorial = {
		Complete = false,
	},
}

NDui:EventFrame("ADDON_LOADED"):SetScript("OnEvent", function(self, event, addon)
	if addon ~= "NDui" then return end
	self:UnregisterEvent("ADDON_LOADED")
	if not NDuiDB["LEGION"] then
		NDuiDB = {}
		NDuiDB["LEGION"] = true
	end

	for i, j in pairs(defaultSettings) do
		if type(j) == "table" then
			if NDuiDB[i] == nil then NDuiDB[i] = {} end
			for k, v in pairs(j) do
				if NDuiDB[i][k] == nil then
					NDuiDB[i][k] = v
				end
			end
		else
			if NDuiDB[i] == nil then NDuiDB[i] = j end
		end
	end
end)

-- Config
local tabList = {
	L["Actionbar"],
	L["Bags"],
	L["Unitframes"],
	L["RaidFrame"],
	L["Auras"],
	L["Nameplate"],
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
		{1, "Actionbar", "Enable", L["Enable Actionbar"]},
		{},--blank
		{1, "Actionbar", "Bar4Fade", L["Bar4 Fade"]},
		{1, "Actionbar", "Bar5Fade", L["Bar5 Fade"]},
		{4, "Actionbar", "Style", L["Actionbar Style"], true, {L["BarStyle1"], L["BarStyle2"], L["BarStyle3"], L["BarStyle4"]}},
		{},--blank
		{1, "Actionbar", "Hotkeys", L["Actionbar Hotkey"]},
		{1, "Actionbar", "Macro", L["Actionbar Macro"]},
		{1, "Actionbar", "Count", L["Actionbar Item Counts"]},
		{1, "Actionbar", "Classcolor", L["ClassColor BG"]},
		{1, "Actionbar", "Cooldown", L["Show Cooldown"]},
		{1, "Actionbar", "DecimalCD", L["Decimal Cooldown"], true},
	},
	[2] = {
		{1, "Bags", "Enable", L["Enable Bags"]},
		{},--blank
		{1, "Bags", "BagsiLvl", L["Bags Itemlevel"]},
		{1, "Bags", "Artifact", L["Bags Artifact"], true},
		{1, "Bags", "NewItemGlow", L["Bags NewItemGlow"]},
		{1, "Bags", "ReverseSort", L["Bags ReverseSort"], true},
		{},--blank
		{3, "Bags", "BagsScale", L["Bags Scale"], false, {.5, 1.5, 1}},
		{3, "Bags", "IconSize", L["Bags IconSize"], true, {30, 42, 0}},
		{3, "Bags", "BagsWidth", L["Bags Width"], false, {10, 20, 0}},
		{3, "Bags", "BankWidth", L["Bank Width"], true, {10, 20, 0}},
	},
	[3] = {
		{1, "UFs", "Enable", L["Enable UFs"]},
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
		{1, "UFs", "ToTAuras", L["ToT Debuff"], true},
		{},--blank
		{1, "UFs", "ExpRep", L["UFs Expbar"]},
		{1, "UFs", "Totems", L["UFs Totems"], true},
		{1, "UFs", "ResourceBar", L["UFs Resource"]},
		{1, "UFs", "AddPower", L["UFs ExtraMana"], true},
		{},--blank
		{1, "UFs", "CombatText", L["UFs CombatText"]},
		{1, "UFs", "HotsDots", L["CombatText HotsDots"]},
		{1, "UFs", "PetCombatText", L["CombatText ShowPets"], true},
	},
	[4] = {
		{1, "UFs", "RaidFrame", L["UFs RaidFrame"]},
		{},--blank
		{1, "UFs", "SpecRaidPos", L["Spec RaidPos"]},
		{1, "UFs", "RaidClassColor", L["ClassColor RaidFrame"], true},
		{1, "UFs", "HorizonRaid", L["Horizon RaidFrame"]},
		{1, "UFs", "HealthPerc", L["Show HealthPerc"], true},
		{3, "UFs", "NumGroups", L["Num Groups"], false, {4, 8, 0}},
		{3, "UFs", "RaidScale", L["RaidFrame Scale"], true, {.8, 1.5, 2}},
		{1, "UFs", "SimpleMode", "|cff00cc4c"..L["Simple RaidFrame"]},
		{},--blank
		{1, "UFs", "AutoRes", L["UFs AutoRes"]},
		{1, "UFs", "DebuffBorder", L["Auras Border"], true},
		{1, "UFs", "Dispellable", L["Dispellable Only"]},
		{1, "UFs", "InstanceAuras", L["Instance Auras"], true},
		{1, "UFs", "NoTooltip", L["NoTooltip Auras"]},
	},
	[5] = {
		{1, "AuraWatch", "Enable", L["Enable AuraWatch"]},
		{1, "AuraWatch", "Hint", L["AuraWatch Tooltip"]},
		{},--blank
		{1, "Auras", "Reminder", L["Enable Reminder"]},
		{1, "Auras", "Familiar", L["Enable Familiar"]},
		{1, "Auras", "BloodyHell", L["Enable BloodyHell"]},
		{1, "Auras", "Stagger", L["Enable Stagger"]},
		{1, "Auras", "Statue", L["Enable Statue"]},
		{1, "Auras", "Totems", L["Enable Totems"]},
		{1, "Auras", "DestroyTotems", L["Destroy Totems"], true},
		{1, "Auras", "Marksman", L["Enable Marksman"]},
	},
	[6] = {
		{1, "Nameplate", "Enable", L["Enable Nameplate"]},
		{},--blank
		{1, "Nameplate", "ColorBorder", L["Auras Border"]},
		{1, "Nameplate", "PlayerAura", L["PlayerPlate Aura"], true},
		{3, "Nameplate", "maxAuras", L["Max Auras"], false, {0, 10, 0}},
		{3, "Nameplate", "AuraSize", L["Auras Size"], true, {18, 40, 0}},
		{4, "Nameplate", "AuraFilter", L["My Filter"], false, {L["Block All"], L["Show All"], L["Aura Whitelist"], L["Aura Blacklist"], L["Aura Debufflist"]}},
		{4, "Nameplate", "OtherFilter", L["Other Filter"], true, {L["Block All"], L["Aura Whitelist"]}},
		{},--blank
		{1, "Nameplate", "FriendlyCC", L["Friendly CC"]},
		{1, "Nameplate", "HostileCC", L["Hostile CC"], true},
		{1, "Nameplate", "TankMode", L["Tank Mode"]},
		{1, "Nameplate", "CustomUnitColor", "|cff00cc4c"..L["CustomUnitColor"], true},
		{1, "Nameplate", "Arrow", L["Show Arrow"]},
		{1, "Nameplate", "InsideView", L["Nameplate InsideView"]},
		{2, "Nameplate", "UnitList", L["UnitColor List"], true},
		{3, "Nameplate", "MinAlpha", L["Nameplate MinAlpha"], false, {0, 1, 1}},
		{3, "Nameplate", "Distance", L["Nameplate Distance"], true, {20, 100, 0}},
		{3, "Nameplate", "Width", L["NP Width"], false, {50, 150, 0}},
		{3, "Nameplate", "Height", L["NP Height"], true, {5, 15, 0}},
	},
	[7] = {
		{1, "Skins", "RM", L["Raid Manger"]},
		{},--blank
		{1, "Skins", "RMRune", L["Runes Check"]},
		{1, "Skins", "EasyMarking", L["Easy Mark"], true},
		{1, "Misc", "Interrupt", L["Interrupt Alert"]},
		{2, "Skins", "DBMCount", L["Countdown Sec"]},
		{},--blank
		{1, "Chat", "Invite", L["Whisper Invite"]},
		{1, "Chat", "GuildInvite", L["Guild Invite Only"], true},
		{2, "Chat", "Keyword", L["Whisper Keyword"]},
	},
	[8] = {
		{1, "Chat", "Lock", L["Lock Chat"]},
		{},--blank
		{1, "Chat", "Freedom", L["Language Filter"]},
		{1, "Chat", "Sticky", L["Chat Sticky"], true},
		{1, "Chat", "Oldname", L["Default Channel"]},
		{1, "Chat", "NoFade", L["Chat Nofade"], true},
		{1, "Chat", "Timestamp", L["Timestamp"]},
		{1, "Chat", "EasyResize", L["Resizing"], true},
		{2, "Chat", "AtList", L["@List"]},
		{},--blank
		{1, "Chat", "EnableFilter", L["Enable Chatfilter"]},
		{3, "Chat", "Matches", L["Keyword Match"], false, {1, 3, 0}},
		{2, "Chat", "FilterList", L["Filter List"], true},
	},
	[9] = {
		{1, "Map", "Coord", L["Map Coords"]},
		{1, "Map", "Invite", L["Calendar Reminder"]},
		{1, "Map", "Clock", L["Minimap Clock"]},
		{1, "Map", "CombatPulse", L["Minimap Pulse"]},
		{1, "Map", "ShowRecycleBin", L["Show RecycleBin"]},
		{1, "Misc", "ExpRep", L["Show Expbar"]},
		{},--blank
		{3, "Map", "MapScale", L["Map Scale"], false, {1, 2, 1}},
		{3, "Map", "MinmapScale", L["Minimap Scale"], true, {1, 2, 1}},
	},
	[10] = {
		{1, "Skins", "MicroMenu", L["Micromenu"]},
		{1, "Skins", "FontFlag", L["Global FontStyle"]},
		{1, "Skins", "PetBattle", L["PetBattle Skin"]},
		{1, "Skins", "DBM", L["DBM Skin"]},
		{1, "Skins", "Skada", L["Skada Skin"]},
		{1, "Skins", "Bigwigs", L["Bigwigs Skin"]},
		{1, "Skins", "TMW", L["TMW Skin"]},
		{1, "Skins", "RCLC", L["RCLC Skin"]},
		{1, "Skins", "ExtraCD", L["ExtraCD Skin"]},
		{1, "Skins", "WeakAuras", L["WeakAuras Skin"]},
	},
	[11] = {
		{1, "Tooltip", "CombatHide", L["Hide Tooltip"]},
		{1, "Tooltip", "Cursor", L["Follow Cursor"]},
		{1, "Tooltip", "ClassColor", L["Classcolor Border"], true},
		{3, "Tooltip", "Scale", L["Tooltip Scale"], false, {.5, 1.5, 1}},
		{},--blank
		{1, "Tooltip", "HideTitle", L["Hide Title"]},
		{1, "Tooltip", "HideRealm", L["Hide Realm"], true},
		{1, "Tooltip", "HideRank", L["Hide Rank"]},
		{1, "Tooltip", "HidePVP", L["Hide PVP"], true},
		{1, "Tooltip", "HideFaction", L["Hide Faction"]},
		{1, "Tooltip", "FactionIcon", L["FactionIcon"], true},
		{1, "Tooltip", "LFDRole", L["Group Roles"]},
		{1, "Tooltip", "TargetBy", L["Show TargetedBy"], true},
	},
	[12] = {
		{1, "Misc", "Mail", L["Mail Tool"]},
		{1, "Misc", "Durability", L["Show Durability"]},
		{1, "Misc", "HideErrors", L["Hide Error"]},
		{1, "Misc", "SoloInfo", L["SoloInfo"]},
		{1, "Misc", "RareAlerter", L["Rare Alert"]},
		{1, "Misc", "AlertinChat", L["Alert In Chat"], true},
		{1, "Misc", "Focuser", L["Easy Focus"]},
		{1, "Misc", "Autoequip", L["Auto Equip"]},
		{1, "Misc", "Screenshot", L["Auto ScreenShot"]},
		{1, "Misc", "TradeTab", L["TradeTabs"]},
		{1, "Misc", "FasterLoot", L["Faster Loot"]},
		{1, "Misc", "HideTalking", L["No Talking"]},
		{1, "Misc", "HideBanner", L["Hide Bossbanner"]},
		{1, "Misc", "PetFilter", L["Show PetFilter"]},
	},
	[13] = {
		{3, "Settings", "SetScale", L["Setup UIScale"], false, {.5, 1.1, 2}},
		{1, "Settings", "LockUIScale", L["Lock UIScale"], true},
		{},--blank
		{3, "Settings", "GUIScale", L["GUI Scale"], false, {.5, 1.5, 1}},
		{},--blank
		{4, "Settings", "Format", L["Numberize"], false, {L["Number Type1"], L["Number Type2"], L["Number Type3"]}},
	},
}

local r, g, b = DB.cc.r, DB.cc.g, DB.cc.b
local guiTab, guiPage, f, x, y = {}, {}

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

local function CreateTab(i, name)
	local tab = CreateFrame("Button", nil, NDuiGUI)
	tab:SetPoint("TOPLEFT", 20, -30*i - 20)
	tab:SetSize(130, 30)
	B.CreateBD(tab, .3)
	local label = B.CreateFS(tab, 15, name, false, "LEFT", 10, 0)
	label:SetTextColor(1, .8, 0)

	tab:SetScript("OnClick", function(self)
		PlaySound("gsTitleOptionOK")
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

local function CreateOption(i)
	local parent, offset = guiPage[i].child, 20

	for _, option in pairs(optionList[i]) do
		local type, key, value, name, horizon, data = unpack(option)
		-- Checkboxes
		if type == 1 then
			local cb = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
			if horizon then
				cb:SetPoint("TOPLEFT", 330, -offset + 35)
			else
				cb:SetPoint("TOPLEFT", 20, -offset)
				offset = offset + 35
			end
			B.CreateCB(cb)
			B.CreateFS(cb, 14, name, false, "LEFT", 30, 0)
			cb:SetChecked(NDuiDB[key][value])
			cb:SetScript("OnClick", function()
				NDuiDB[key][value] = cb:GetChecked()
			end)
		-- Ediebox
		elseif type == 2 then
			local e = CreateFrame("EditBox", nil, parent)
			e:SetAutoFocus(false)
			e:SetSize(200, 30)
			e:SetMaxLetters(200)
			e:SetTextInsets(10, 10, 0, 0)
			e:SetFontObject(GameFontHighlight)
			if horizon then
				e:SetPoint("TOPLEFT", 345, -offset + 50)
			else
				e:SetPoint("TOPLEFT", 35, -offset - 20)
				offset = offset + 70
			end
			e:SetText(NDuiDB[key][value])
			B.CreateBD(e, .3)
			e:SetScript("OnEscapePressed", function()
				e:ClearFocus()
				e:SetText(NDuiDB[key][value])
			end)
			e:SetScript("OnEnterPressed", function()
				e:ClearFocus()
				NDuiDB[key][value] = e:GetText()
			end)
			e:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L["Tips"])
				GameTooltip:AddLine(L["EdieBox Tip"], .6,.8,1)
				GameTooltip:Show()
			end)
			e:SetScript("OnLeave", GameTooltip_Hide)

			local label = B.CreateFS(e, 14, name, false, "CENTER", 0, 25)
			label:SetTextColor(1, .8, 0)
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
			s:SetValue(NDuiDB[key][value])
			s:SetScript("OnValueChanged", function(self, v)
				local current = tonumber(format("%."..step.."f", v))
				NDuiDB[key][value] = current
				_G[s:GetName().."Text"]:SetText(current)
			end)

			local label = B.CreateFS(s, 14, name, false, "CENTER", 0, 25)
			label:SetTextColor(1, .8, 0)
			_G[s:GetName().."Low"]:SetText(min)
			_G[s:GetName().."High"]:SetText(max)
			_G[s:GetName().."Text"]:ClearAllPoints()
			_G[s:GetName().."Text"]:SetPoint("TOP", s, "BOTTOM", 0, 3)
			_G[s:GetName().."Text"]:SetText(format("%."..step.."f", NDuiDB[key][value]))
			s:SetBackdrop(nil)
			s.SetBackdrop = B.Dummy
			local bd = CreateFrame("Frame", nil, s)
			bd:SetPoint("TOPLEFT", 14, -2)
			bd:SetPoint("BOTTOMRIGHT", -15, 3)
			bd:SetFrameStrata("BACKGROUND")
			B.CreateBD(bd, .3)
			local slider = select(4, s:GetRegions())
			slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			slider:SetBlendMode("ADD")
		-- Dropdown
		elseif type == 4 then
			local drop = CreateFrame("Frame", nil, parent)
			if horizon then
				drop:SetPoint("TOPLEFT", 345, -offset + 50)
			else
				drop:SetPoint("TOPLEFT", 35, -offset - 20)
				offset = offset + 70
			end
			drop:SetSize(200, 30)
			B.CreateBD(drop, .3)		
			local t = B.CreateFS(drop, 14, data[NDuiDB[key][value]])
			local b = CreateFrame("Button", nil, drop)
			b:SetPoint("LEFT", drop, "RIGHT")
			b:SetSize(22, 22)
			b.Icon = b:CreateTexture(nil, "ARTWORK")
			b.Icon:SetAllPoints()
			b.Icon:SetTexture(DB.gearTex)
			b.Icon:SetTexCoord(0, .5, 0, .5)
			b:SetHighlightTexture(DB.gearTex)
			b:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)
			local l = CreateFrame("Frame", nil, drop)
			l:SetPoint("TOP", drop, "BOTTOM")
			B.CreateBD(l, .7)
			b:SetScript("OnShow", function() l:Hide() end)
			local label = B.CreateFS(drop, 14, name, false, "CENTER", 0, 25)
			label:SetTextColor(1, .8, 0)

			local opt = {}
			local function selectOpt(i)
				for num = 1, #data do
					if num == i then
						opt[num]:SetBackdropColor(1, .8, 0, .3)
						opt[num].checked = true
					else
						opt[num]:SetBackdropColor(0, 0, 0, .3)
						opt[num].checked = false
					end
				end
				NDuiDB[key][value] = i
				t:SetText(data[i])
			end
			for i, j in pairs(data) do
				opt[i] = CreateFrame("Button", nil, l)
				opt[i]:SetPoint("TOPLEFT", 5, -5 - (i-1)*30)
				opt[i]:SetSize(190, 30)
				B.CreateBD(opt[i], .1)
				B.CreateFS(opt[i], 14, j, false, "LEFT", 8, 0)
				opt[i]:SetScript("OnClick", function(self)
					PlaySound("gsTitleOptionOK")
					selectOpt(i)
					l:Hide()
				end)
				opt[i]:SetScript("OnEnter", function(self)
					if self.checked then return end
					self:SetBackdropColor(1, 1, 1, .3)
				end)
				opt[i]:SetScript("OnLeave", function(self)
					if self.checked then return end
					self:SetBackdropColor(0, 0, 0, .3)
				end)
				b:SetScript("OnClick", function()
					PlaySound("gsTitleOptionOK")
					ToggleFrame(l)
					selectOpt(NDuiDB[key][value])
				end)
				l:SetSize(200, i*30 + 10)
			end
		-- String
		elseif type == 5 then
			local fs = parent:CreateFontString(nil, "OVERLAY")
			fs:SetFont(DB.Font[1], 14, DB.Font[3])
			fs:SetText(name)
			fs:SetTextColor(1, .8, 0)
			if horizon then
				fs:SetPoint("TOPLEFT", 335, -offset + 30)
			else
				fs:SetPoint("TOPLEFT", 25, -offset - 5)
				offset = offset + 35
			end
		-- Blank, no type
		else
			local l = CreateFrame("Frame", nil, parent)
			l:SetPoint("TOPLEFT", 25, -offset - 12)
			B.CreateGF(l, 550, .5, "Horizontal", .7, .7, .7, .7, 0)
			offset = offset + 35
		end
	end
end

local function OpenGUI()
	if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
	if f then f:Show() return end

	-- Main Frame
	f = CreateFrame("Frame", "NDuiGUI", UIParent)
	tinsert(UISpecialFrames, "NDuiGUI")
	f:SetScale(NDuiDB["Settings"]["GUIScale"])
	f:SetSize(800, 600)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	B.CreateMF(f)
	B.CreateBD(f)
	B.CreateTex(f)
	B.CreateFS(f, 18, L["NDui Console"], true, "TOP", 0, -10)
	B.CreateFS(f, 16, DB.Version, false, "TOP", 0, -30)

	local close = CreateFrame("Button", nil, f)
	close:SetPoint("BOTTOMRIGHT", -20, 15)
	close:SetSize(80, 20)
	close:SetFrameLevel(3)
	B.CreateBD(close, .3)
	B.CreateBC(close)
	B.CreateFS(close, 14, CLOSE, true)
	close:SetScript("OnClick", function(self)
		f:Hide()
	end)
	local ok = CreateFrame("Button", nil, f)
	ok:SetPoint("RIGHT", close, "LEFT", -10, 0)
	ok:SetSize(80, 20)
	ok:SetFrameLevel(3)
	B.CreateBD(ok, .3)
	B.CreateBC(ok)
	B.CreateFS(ok, 14, OKAY, true)
	ok:SetScript("OnClick", function(self)
		local scale = NDuiDB["Settings"]["SetScale"]
		if scale < .65 then
			UIParent:SetScale(scale)
		else
			SetCVar("uiScale", scale)
		end
		f:Hide()
		StaticPopup_Show("RELOAD_NDUI")
	end)

	for i, name in pairs(tabList) do
		guiTab[i] = CreateTab(i, name)

		guiPage[i] = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		guiPage[i]:SetPoint("TOPLEFT", 160, -50)
		guiPage[i]:SetSize(610, 500)
		B.CreateBD(guiPage[i], .3)
		guiPage[i]:Hide()
		guiPage[i].child = CreateFrame("Frame", nil, guiPage[i])
		guiPage[i].child:SetSize(610, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		if IsAddOnLoaded("Aurora") then
			local F = unpack(Aurora)
			F.ReskinScroll(guiPage[i].ScrollBar)
		end

		CreateOption(i)
	end

	local reset = CreateFrame("Button", nil, f)
	reset:SetPoint("BOTTOMLEFT", 25, 15)
	reset:SetSize(120, 20)
	B.CreateBD(reset, .3)
	B.CreateBC(reset)
	B.CreateFS(reset, 14, L["NDui Reset"], true)
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
	reset:SetScript("OnClick", function(self)
		StaticPopup_Show("RESET_NDUI")
	end)

	NDui:EventFrame("PLAYER_REGEN_DISABLED"):SetScript("OnEvent", function(self, event)
		if event == "PLAYER_REGEN_DISABLED" then
			if f:IsShown() then
				f:Hide()
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			end
		else
			f:Show()
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end
	end)

	-- Toggle AuraWatch Console
	local aura = CreateFrame("Button", nil, guiPage[5])
	aura:SetSize(150, 30)
	aura:SetPoint("TOPLEFT", 340, -50)
	B.CreateBD(aura, .3)
	B.CreateBC(aura)
	B.CreateFS(aura, 14, L["Add AuraWatch"], true)
	aura:SetScript("OnClick", function()
		f:Hide()
		SlashCmdList["NDUI_AWCONFIG"]()
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
	PlaySound("igMainMenuOption")
end)

-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	F.Reskin(gui)
end