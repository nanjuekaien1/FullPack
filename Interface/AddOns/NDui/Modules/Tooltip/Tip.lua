local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Tooltip")

function module:OnLogin()
	self:ExtraTipInfo()
	self:TargetedInfo()
	self:AzeriteArmor()
end

local classification = {
	elite = " |cffcc8800"..ELITE.."|r",
	rare = " |cffff99cc"..L["Rare"].."|r",
	rareelite = " |cffff99cc"..L["Rare"].."|r ".."|cffcc8800"..ELITE.."|r",
	worldboss = " |cffff0000"..BOSS.."|r",
}

local strfind, format, strupper, strsplit = string.find, string.format, string.upper, string.split
local strlen, pairs = string.len, pairs

function module:GetUnit(self)
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))) or "mouseover"
	end
	return unit
end

function module:HideLines(self)
    for i = 3, self:NumLines() do
        local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext then
			if linetext == PVP then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif linetext == FACTION_HORDE then
				if NDuiDB["Tooltip"]["FactionIcon"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040"..linetext.."|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if NDuiDB["Tooltip"]["FactionIcon"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff"..linetext.."|r")
				end
			end
		end
    end
end

function module:GetLevelLine(self)
	for i = 2, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext and strfind(linetext, LEVEL) then
			return tiptext
		end
	end
end

function module:GetTarget(unit)
	if UnitIsUnit(unit, "player") then
		return format("|cffff0000%s|r", ">"..strupper(YOU).."<")
	else
		return B.HexRGB(B.UnitColor(unit))..UnitName(unit).."|r"
	end
end

function module:InsertFactionFrame(self, faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", 0, -5)
		f:SetBlendMode("ADD")
		self.factionFrame = f
	end
	self.factionFrame:SetTexture("Interface\\FriendsFrame\\PlusManz-"..faction)
	self.factionFrame:SetAlpha(.5)
end

local roleTex = {
	["HEALER"] = {.066, .222, .133, .445},
	["TANK"] = {.375, .532, .133, .445},
	["DAMAGER"] = {.66, .813, .133, .445},
}

function module:InsertRoleFrame(self, role)
	if not self.roleFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, -2)
		f:SetSize(20, 20)
		f:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
		B.CreateSD(f, 3, 3)
		self.roleFrame = f
	end
	self.roleFrame:SetTexCoord(unpack(roleTex[role]))
	self.roleFrame:SetAlpha(1)
	self.roleFrame.Shadow:SetAlpha(1)
end

GameTooltip:HookScript("OnTooltipCleared", function(self)
	if self.factionFrame and self.factionFrame:GetAlpha() ~= 0 then
		self.factionFrame:SetAlpha(0)
	end
	if self.roleFrame and self.roleFrame:GetAlpha() ~= 0 then
		self.roleFrame:SetAlpha(0)
		self.roleFrame.Shadow:SetAlpha(0)
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if NDuiDB["Tooltip"]["CombatHide"] and InCombatLockdown() then
		return self:Hide()
	end
	module:HideLines(self)

	local unit = module:GetUnit(self)
	local isShiftKeyDown = IsShiftKeyDown()
	if UnitExists(unit) then
		local hexColor = B.HexRGB(B.UnitColor(unit))
		local ricon = GetRaidTargetIndex(unit)
		if ricon and ricon > 8 then ricon = nil end
		if ricon then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."18|t", text)
		end

		local isPlayer = UnitIsPlayer(unit)
		if isPlayer then
			local name, realm = UnitName(unit)
			local pvpName = UnitPVPName(unit)
			local relationship = UnitRealmRelationship(unit)
			if not NDuiDB["Tooltip"]["HideTitle"] and pvpName then
				name = pvpName
			end
			if realm and realm ~= "" then
				if isShiftKeyDown or not NDuiDB["Tooltip"]["HideRealm"] then
					name = name.."-"..realm
				elseif relationship == LE_REALM_RELATION_COALESCED then
					name = name..FOREIGN_SERVER_LABEL
				elseif relationship == LE_REALM_RELATION_VIRTUAL then
					name = name..INTERACTIVE_SERVER_LABEL
				end
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				status = format(" |cffffcc00[%s]|r", status)
			end
			GameTooltipTextLeft1:SetFormattedText("%s", name..(status or ""))

			if NDuiDB["Tooltip"]["FactionIcon"] then
				local faction = UnitFactionGroup(unit)
				if faction and faction ~= "Neutral" then
					module:InsertFactionFrame(self, faction)
				end
			end

			if NDuiDB["Tooltip"]["LFDRole"] then
				local role = UnitGroupRolesAssigned(unit)
				if role ~= "NONE" then
					module:InsertRoleFrame(self, role)
				end
			end

			local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
			local hasText = GameTooltipTextLeft2:GetText()
			if guildName and hasText then
				local myGuild, _, _, myGuildRealm = GetGuildInfo("player")
				if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
					GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
				else
					GameTooltipTextLeft2:SetTextColor(.6, .8, 1)
				end

				rankIndex = rankIndex + 1
				if NDuiDB["Tooltip"]["HideRank"] then rank = "" end
				if guildRealm and isShiftKeyDown then
					guildName = guildName.."-"..guildRealm
				end
				if NDuiDB["Tooltip"]["HideJunkGuild"] and not isShiftKeyDown then
					if strlen(guildName) > 31 then guildName = "..." end
				end
				GameTooltipTextLeft2:SetText("<"..guildName.."> "..rank.."("..rankIndex..")")
			end
		end

		local line1 = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText("%s", hexColor..line1)

		local alive = not UnitIsDeadOrGhost(unit)
		local level
		if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
			level = UnitBattlePetLevel(unit)
		else
			level = UnitLevel(unit)
		end

		if level then
			local boss
			if level == -1 then boss = "|cffff0000??|r" end

			local diff = GetCreatureDifficultyColor(level)
			local classify = UnitClassification(unit)
			local textLevel = format("%s%s%s|r", B.HexRGB(diff), boss or format("%d", level), classification[classify] or "")
			local tiptextLevel = module:GetLevelLine(self)
			if tiptextLevel then
				local pvpFlag = isPlayer and UnitIsPVP(unit) and format(" |cffff0000%s|r", PVP) or ""
				local unitClass = isPlayer and format("%s %s", UnitRace(unit) or "", hexColor..(UnitClass(unit) or "").."|r") or UnitCreatureType(unit) or ""
				tiptextLevel:SetFormattedText(("%s%s %s %s"), textLevel, pvpFlag, unitClass, (not alive and "|cffCCCCCC"..DEAD.."|r" or ""))
			end
		end

		if UnitExists(unit.."target") then
			local tarRicon = GetRaidTargetIndex(unit.."target")
			if tarRicon and tarRicon > 8 then tarRicon = nil end
			local tar = format("%s%s", (tarRicon and ICON_LIST[tarRicon].."10|t") or "", module:GetTarget(unit.."target"))
			self:AddLine(TARGET..": "..tar)
		end

		if alive then
			GameTooltipStatusBar:SetStatusBarColor(B.UnitColor(unit))
		else
			GameTooltipStatusBar:Hide()
		end
	else
		GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
	end

	if GameTooltipStatusBar:IsShown() and C.mult and not GameTooltipStatusBar.bg then
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", C.mult, 3)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -C.mult, 3)
		GameTooltipStatusBar:SetStatusBarTexture(DB.normTex)
		GameTooltipStatusBar:SetHeight(5)
		local bg = B.CreateBG(GameTooltipStatusBar)
		B.CreateBD(bg, .7)
		B.CreateSD(bg)
		B.CreateTex(bg)
		GameTooltipStatusBar.bg = bg
	end
end)

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
	if not value then return end
	local min, max = self:GetMinMaxValues()
	if (value < min) or (value > max) then return end

	local unit = module:GetUnit(GameTooltip)
	if UnitExists(unit) then
		min, max = UnitHealth(unit), UnitHealthMax(unit)
		if not self.text then
			self.text = B.CreateFS(self, 12, "")
		end
		self.text:Show()
		local hp = B.Numb(min).." / "..B.Numb(max)
		self.text:SetText(hp)
	end
end)

hooksecurefunc("GameTooltip_ShowStatusBar", function(self)
	if self.statusBarPool then
		local bar = self.statusBarPool:Acquire()
		if bar and not bar.styled then
			local _, bd, tex = bar:GetRegions()
			tex:SetTexture(DB.normTex)
			bd:Hide()
			local bg = B.CreateBG(bd, 0)
			B.CreateBD(bg, .25)

			bar.styled = true
		end
	end
end)

hooksecurefunc("GameTooltip_ShowProgressBar", function(self)
	if self.progressBarPool then
		local bar = self.progressBarPool:Acquire()
		if bar and not bar.styled then
			B.StripTextures(bar.Bar, true)
			bar.Bar:SetStatusBarTexture(DB.normTex)
			B.CreateBD(bar, .25)
			bar:SetSize(216, 18)

			bar.styled = true
		end
	end
end)

-- Anchor and mover
local mover
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	if NDuiDB["Tooltip"]["Cursor"] then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
	else
		if not mover then
			mover = B.Mover(tooltip, L["Tooltip"], "GameTooltip", C.Tooltips.TipPos, 240, 120)
		end
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT", mover)
	end
end)

-- Tooltip skin
local function getBackdrop(self) return self.bg:GetBackdrop() end
local function getBackdropColor() return 0, 0, 0, .7 end
local function getBackdropBorderColor() return 0, 0, 0 end

function B:ReskinTooltip()
	if not self then
		if DB.isDeveloper then print("Unknown tooltip spotted.") end
		return
	end
	self:SetScale(NDuiDB["Tooltip"]["Scale"])

	if not self.tipStyled then
		self:SetBackdrop(nil)
		self:DisableDrawLayer("BACKGROUND")
		local bg = B.CreateBG(self, 0)
		bg:SetFrameLevel(self:GetFrameLevel())
		B.CreateBD(bg, .7)
		B.CreateSD(bg)
		B.CreateTex(bg)
		self.bg = bg

		-- other gametooltip-like support
		self.GetBackdrop = getBackdrop
		self.GetBackdropColor = getBackdropColor
		self.GetBackdropBorderColor = getBackdropBorderColor

		self.tipStyled = true
	end

	self.bg.Shadow:SetBackdropBorderColor(0, 0, 0)
	if NDuiDB["Tooltip"]["ClassColor"] and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			if color then
				self.bg.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end

	if self.NumLines and self:NumLines() > 0 then
		for index = 1, self:NumLines() do
			if index == 1 then
				_G[self:GetName().."TextLeft"..index]:SetFont(DB.TipFont[1], DB.TipFont[2] + 2, DB.TipFont[3])
			else
				_G[self:GetName().."TextLeft"..index]:SetFont(unpack(DB.TipFont))
			end
			_G[self:GetName().."TextRight"..index]:SetFont(unpack(DB.TipFont))
		end
	end
end

hooksecurefunc("GameTooltip_SetBackdropStyle", function(self)
	if not self.tipStyled then return end
	self:SetBackdrop(nil)
end)

local tipTable = {}
function module:RegisterTooltips(addon, func)
	tipTable[addon] = func
end
local function addonStyled(_, addon)
	if tipTable[addon] then
		tipTable[addon]()
		tipTable[addon] = nil
	end
end
B:RegisterEvent("ADDON_LOADED", addonStyled)

module:RegisterTooltips("NDui", function()
	if IsAddOnLoaded("AuroraClassic") then
		local F = unpack(AuroraClassic)
		F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
		F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
		F.ReskinClose(FloatingGarrisonMissionTooltip.CloseButton)
		AuroraOptionstooltips:SetAlpha(0)
		AuroraOptionstooltips:Disable()
		AuroraConfig.tooltips = false
	end

	local tooltips = {
		ChatMenu,
		EmoteMenu,
		LanguageMenu,
		VoiceMacroMenu,
		GameTooltip,
		EmbeddedItemTooltip,
		ItemRefTooltip,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ShoppingTooltip1,
		ShoppingTooltip2,
		AutoCompleteBox,
		FriendsTooltip,
		QuestScrollFrame.StoryTooltip,
		GeneralDockManagerOverflowButtonList,
		ReputationParagonTooltip,
		QuestScrollFrame.WarCampaignTooltip,
		NamePlateTooltip,
		QueueStatusFrame,
		FloatingGarrisonFollowerTooltip,
		FloatingGarrisonFollowerAbilityTooltip,
		FloatingGarrisonMissionTooltip,
		GarrisonFollowerAbilityTooltip,
		GarrisonFollowerTooltip,
		FloatingGarrisonShipyardFollowerTooltip,
		GarrisonShipyardFollowerTooltip,
		BattlePetTooltip,
		PetBattlePrimaryAbilityTooltip,
		PetBattlePrimaryUnitTooltip,
		FloatingBattlePetTooltip,
		FloatingPetBattleAbilityTooltip,
		IMECandidatesFrame
	}
	if not DB.isNewPatch then
		tinsert(tooltips, WorldMapTooltip)
		tinsert(tooltips, WorldMapCompareTooltip1)
		tinsert(tooltips, WorldMapCompareTooltip2)
	end
	for _, f in pairs(tooltips) do
		f:HookScript("OnShow", B.ReskinTooltip)
	end

	-- DropdownMenu
	local function reskinDropdown()
		for _, name in next, {"DropDownList", "L_DropDownList", "Lib_DropDownList"} do
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G[name..i.."MenuBackdrop"]
				if menu and not menu.styled then
					menu:HookScript("OnShow", B.ReskinTooltip)
					menu.styled = true
				end
			end
		end
	end
	hooksecurefunc("UIDropDownMenu_CreateFrames", reskinDropdown)

	-- IME
	local r, g, b = DB.r, DB.g, DB.b
	IMECandidatesFrame.selection:SetVertexColor(r, g, b)

	-- Pet Tooltip
	PetBattlePrimaryUnitTooltip:HookScript("OnShow", function(self)
		self.Border:SetAlpha(0)
		if not self.iconStyled then
			if self.glow then self.glow:Hide() end
			self.Icon:SetTexCoord(unpack(DB.TexCoord))
			self.iconStyled = true
		end
	end)

	hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", function(self)
		local nextBuff, nextDebuff = 1, 1
		for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
			local _, _, _, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
			if isBuff and self.Buffs then
				local frame = self.Buffs.frames[nextBuff]
				if frame and frame.Icon then
					frame.Icon:SetTexCoord(unpack(DB.TexCoord))
				end
				nextBuff = nextBuff + 1
			elseif (not isBuff) and self.Debuffs then
				local frame = self.Debuffs.frames[nextDebuff]
				if frame and frame.Icon then
					frame.DebuffBorder:Hide()
					frame.Icon:SetTexCoord(unpack(DB.TexCoord))
				end
				nextDebuff = nextDebuff + 1
			end
		end
	end)

	-- Others
	C_Timer.After(5, function()
		if LibDBIconTooltip then
			B.ReskinTooltip(LibDBIconTooltip)
		end
	end)

	if IsAddOnLoaded("BattlePetBreedID") then
		hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
			if parent == FloatingBattlePetTooltip then
				B.ReskinTooltip(BPBID_BreedTooltip2)
			else
				B.ReskinTooltip(BPBID_BreedTooltip)
			end
		end)
	end

	if IsAddOnLoaded("MethodDungeonTools") then
		local styledMDT
		hooksecurefunc(MethodDungeonTools, "ShowInterface", function()
			if not styledMDT then
				B.ReskinTooltip(MethodDungeonTools.tooltip)
				B.ReskinTooltip(MethodDungeonTools.pullTooltip)
				styledMDT = true
			end
		end)
	end

	if IsAddOnLoaded("MeetingStone") then B.ReskinTooltip(NetEaseGUI20_Tooltip51) end
end)

module:RegisterTooltips("Blizzard_DebugTools", function()
	B.ReskinTooltip(FrameStackTooltip)
	B.ReskinTooltip(EventTraceTooltip)
	FrameStackTooltip:SetScale(UIParent:GetScale())
	EventTraceTooltip:SetParent(UIParent)
	EventTraceTooltip:SetFrameStrata("TOOLTIP")
end)

module:RegisterTooltips("Blizzard_Collections", function()
	PetJournalPrimaryAbilityTooltip:HookScript("OnShow", B.ReskinTooltip)
	PetJournalSecondaryAbilityTooltip:HookScript("OnShow", B.ReskinTooltip)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
end)

module:RegisterTooltips("Blizzard_GarrisonUI", function()
	local gt = {
		GarrisonMissionMechanicTooltip,
		GarrisonMissionMechanicFollowerCounterTooltip,
		GarrisonShipyardMapMissionTooltip,
		GarrisonBonusAreaTooltip,
		GarrisonBuildingFrame.BuildingLevelTooltip,
		GarrisonFollowerAbilityWithoutCountersTooltip,
		GarrisonFollowerMissionAbilityWithoutCountersTooltip
	}
	for _, f in pairs(gt) do
		f:HookScript("OnShow", B.ReskinTooltip)
	end
end)

module:RegisterTooltips("Blizzard_PVPUI", function()
	ConquestTooltip:HookScript("OnShow", B.ReskinTooltip)
end)

module:RegisterTooltips("Blizzard_Contribution", function()
	ContributionBuffTooltip:HookScript("OnShow", B.ReskinTooltip)
	ContributionBuffTooltip.Icon:SetTexCoord(unpack(DB.TexCoord))
	ContributionBuffTooltip.Border:SetAlpha(0)
end)

module:RegisterTooltips("Blizzard_EncounterJournal", function()
	EncounterJournalTooltip:HookScript("OnShow", B.ReskinTooltip)
	EncounterJournalTooltip.Item1.icon:SetTexCoord(unpack(DB.TexCoord))
	EncounterJournalTooltip.Item2.icon:SetTexCoord(unpack(DB.TexCoord))
end)

module:RegisterTooltips("Blizzard_Calendar", function()
	CalendarContextMenu:HookScript("OnShow", B.ReskinTooltip)
	CalendarInviteStatusContextMenu:HookScript("OnShow", B.ReskinTooltip)
end)

module:RegisterTooltips("Blizzard_IslandsQueueUI", function()
	local tooltip = IslandsQueueFrameTooltip:GetParent()
	tooltip.IconBorder:SetAlpha(0)
	tooltip.Icon:SetTexCoord(unpack(DB.TexCoord))
	tooltip:GetParent():HookScript("OnShow", B.ReskinTooltip)
end)