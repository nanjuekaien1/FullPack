local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")

--[[
	一个工具条用来替代系统的经验条、声望条、神器经验等等
]]
local format, pairs, select = string.format, pairs, select
local min, mod, floor = math.min, mod, math.floor
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL
local MAX_REPUTATION_REACTION = MAX_REPUTATION_REACTION
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local NUM_FACTIONS_DISPLAYED = NUM_FACTIONS_DISPLAYED
local REPUTATION_PROGRESS_FORMAT = REPUTATION_PROGRESS_FORMAT
local HONOR, LEVEL, TUTORIAL_TITLE26, SPELLBOOK_AVAILABLE_AT = HONOR, LEVEL, TUTORIAL_TITLE26, SPELLBOOK_AVAILABLE_AT
local ARTIFACT_POWER, ARTIFACT_RETIRED = ARTIFACT_POWER, ARTIFACT_RETIRED
local PVP_CONQUEST, CONQUEST_BAR_REWARD_DONE, ARENA_THIS_WEEK = PVP_CONQUEST, CONQUEST_BAR_REWARD_DONE, ARENA_THIS_WEEK

local UnitLevel, UnitXP, UnitXPMax, GetXPExhaustion, IsXPUserDisabled = UnitLevel, UnitXP, UnitXPMax, GetXPExhaustion, IsXPUserDisabled
local GetText, UnitSex, BreakUpLargeNumbers, GetNumFactions, GetFactionInfo = GetText, UnitSex, BreakUpLargeNumbers, GetNumFactions, GetFactionInfo
local GetWatchedFactionInfo, GetFriendshipReputation, GetFriendshipReputationRanks = GetWatchedFactionInfo, GetFriendshipReputation, GetFriendshipReputationRanks
local HasArtifactEquipped, ArtifactBarGetNumArtifactTraitsPurchasableFromXP = HasArtifactEquipped, ArtifactBarGetNumArtifactTraitsPurchasableFromXP
local IsWatchingHonorAsXP, UnitHonor, UnitHonorMax, UnitHonorLevel, IsPlayerAtEffectiveMaxLevel = IsWatchingHonorAsXP, UnitHonor, UnitHonorMax, UnitHonorLevel, IsPlayerAtEffectiveMaxLevel
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_AzeriteItem_HasActiveAzeriteItem = C_AzeriteItem.HasActiveAzeriteItem
local C_AzeriteItem_IsAzeriteItemAtMaxLevel = C_AzeriteItem.IsAzeriteItemAtMaxLevel
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo
local C_AzeriteItem_GetPowerLevel = C_AzeriteItem.GetPowerLevel
local C_ArtifactUI_IsEquippedArtifactDisabled = C_ArtifactUI.IsEquippedArtifactDisabled
local C_ArtifactUI_GetEquippedArtifactInfo = C_ArtifactUI.GetEquippedArtifactInfo

function M:ExpBar_Update()
	local rest = self.restBar
	if rest then rest:Hide() end

	if UnitLevel("player") < MAX_PLAYER_LEVEL then
		local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		self:SetStatusBarColor(0, .7, 1)
		self:SetMinMaxValues(0, mxp)
		self:SetValue(xp)
		self:Show()
		if rxp then
			rest:SetMinMaxValues(0, mxp)
			rest:SetValue(min(xp + rxp, mxp))
			rest:Show()
		end
		if IsXPUserDisabled() then self:SetStatusBarColor(.7, 0, 0) end
	elseif GetWatchedFactionInfo() then
		local _, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
		local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
		if friendID then
			if nextFriendThreshold then
				barMin, barMax, value = friendThreshold, nextFriendThreshold, friendRep
			else
				barMin, barMax, value = 0, 1, 1
			end
			standing = 5
		elseif C_Reputation_IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation_GetFactionParagonInfo(factionID)
			currentValue = mod(currentValue, threshold)
			barMin, barMax, value = 0, threshold, currentValue
		else
			if standing == MAX_REPUTATION_REACTION then barMin, barMax, value = 0, 1, 1 end
		end
		self:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, .85)
		self:SetMinMaxValues(barMin, barMax)
		self:SetValue(value)
		self:Show()
	elseif IsWatchingHonorAsXP() then
		local current, barMax = UnitHonor("player"), UnitHonorMax("player")
		self:SetStatusBarColor(1, .24, 0)
		self:SetMinMaxValues(0, barMax)
		self:SetValue(current)
		self:Show()
	elseif C_AzeriteItem_HasActiveAzeriteItem() then
		local isMaxLevel = C_AzeriteItem_IsAzeriteItemAtMaxLevel()
		if isMaxLevel then
			self:SetStatusBarColor(.6, .6, .6)
			self:SetMinMaxValues(0, 1)
			self:SetValue(1)
		else
			local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
			local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
			self:SetStatusBarColor(.9, .8, .6)
			self:SetMinMaxValues(0, totalLevelXP)
			self:SetValue(xp)
		end
		self:Show()
	elseif HasArtifactEquipped() then
		if C_ArtifactUI_IsEquippedArtifactDisabled() then
			self:SetStatusBarColor(.6, .6, .6)
			self:SetMinMaxValues(0, 1)
			self:SetValue(1)
		else
			local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI_GetEquippedArtifactInfo()
			local _, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
			xp = xpForNextPoint == 0 and 0 or xp
			self:SetStatusBarColor(.9, .8, .6)
			self:SetMinMaxValues(0, xpForNextPoint)
			self:SetValue(xp)
		end
		self:Show()
	else
		self:Hide()
	end
end

function M:ExpBar_UpdateTooltip()
	local myLevel = UnitLevel("player")
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(LEVEL.." "..myLevel, 0,.6,1)

	if myLevel < MAX_PLAYER_LEVEL then
		local xp, mxp, rxp = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		GameTooltip:AddDoubleLine(XP..":", xp.." / "..mxp.." ("..floor(xp/mxp*100).."%)", .6,.8,1, 1,1,1)
		if rxp then
			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26..":", "+"..rxp.." ("..floor(rxp/mxp*100).."%)", .6,.8,1, 1,1,1)
		end
		if IsXPUserDisabled() then GameTooltip:AddLine("|cffff0000"..XP..LOCKED) end
	end

	if GetWatchedFactionInfo() then
		local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
		local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
		local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
		local standingtext
		if friendID then
			if maxRank > 0 then
				name = name.." ("..currentRank.." / "..maxRank..")"
			end
			if not nextFriendThreshold then
				value = barMax - 1
			end
			standingtext = friendTextLevel
		else
			if standing == MAX_REPUTATION_REACTION then
				barMax = barMin + 1e3
				value = barMax - 1
			end
			standingtext = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(name, 0,.6,1)
		GameTooltip:AddDoubleLine(standingtext, value - barMin.." / "..barMax - barMin.." ("..floor((value - barMin)/(barMax - barMin)*100).."%)", .6,.8,1, 1,1,1)

		if C_Reputation_IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation_GetFactionParagonInfo(factionID)
			local paraCount = floor(currentValue/threshold)
			currentValue = mod(currentValue, threshold)
			GameTooltip:AddDoubleLine(L["Paragon"]..paraCount, currentValue.." / "..threshold.." ("..floor(currentValue/threshold*100).."%)", .6,.8,1, 1,1,1)
		end
	end

	if IsWatchingHonorAsXP() then
		local current, barMax, level = UnitHonor("player"), UnitHonorMax("player"), UnitHonorLevel("player")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(HONOR, 0,.6,1)
		GameTooltip:AddDoubleLine(LEVEL.." "..level, current.." / "..barMax, .6,.8,1, 1,1,1)

		local locked = not IsPlayerAtEffectiveMaxLevel()
		local currentValue, maxValue, questID = PVPGetConquestLevelInfo()
		local questDone = questID and questID == 0
		if not locked then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(PVP_CONQUEST, 0,.6,1)
			if questDone then
				GameTooltip:AddLine(CONQUEST_BAR_REWARD_DONE, .6,.8,1, 1)
			else
				GameTooltip:AddDoubleLine(ARENA_THIS_WEEK, currentValue.." / "..maxValue, .6,.8,1, 1,1,1)
			end
		end
	end

	if C_AzeriteItem_HasActiveAzeriteItem() then
		local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
		local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)
		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		local currentLevel = C_AzeriteItem_GetPowerLevel(azeriteItemLocation)
		local isMaxLevel = C_AzeriteItem_IsAzeriteItemAtMaxLevel()

		azeriteItem:ContinueWithCancelOnItemLoad(function()
			local azeriteItemName = azeriteItem:GetItemName()
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(azeriteItemName.." ("..format(SPELLBOOK_AVAILABLE_AT, currentLevel)..")", 0,.6,1)
			if isMaxLevel then
				GameTooltip:AddDoubleLine(ARTIFACT_POWER, "100%", .6,.8,1, 1,1,1)
			else
				GameTooltip:AddDoubleLine(ARTIFACT_POWER, BreakUpLargeNumbers(xp).." / "..BreakUpLargeNumbers(totalLevelXP).." ("..floor(xp/totalLevelXP*100).."%)", .6,.8,1, 1,1,1)
			end
		end)
	end

	if HasArtifactEquipped() then
		local _, _, name, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI_GetEquippedArtifactInfo()
		local num, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
		GameTooltip:AddLine(" ")
		if C_ArtifactUI_IsEquippedArtifactDisabled() then
			GameTooltip:AddLine(name, 0,.6,1)
			GameTooltip:AddLine(ARTIFACT_RETIRED, .6,.8,1, 1)
		else
			GameTooltip:AddLine(name.." ("..format(SPELLBOOK_AVAILABLE_AT, pointsSpent)..")", 0,.6,1)
			local numText = num > 0 and " ("..num..")" or ""
			GameTooltip:AddDoubleLine(ARTIFACT_POWER, BreakUpLargeNumbers(totalXP)..numText, .6,.8,1, 1,1,1)
			if xpForNextPoint ~= 0 then
				local perc = " ("..floor(xp/xpForNextPoint*100).."%)"
				GameTooltip:AddDoubleLine(L["Next Trait"], BreakUpLargeNumbers(xp).." / "..BreakUpLargeNumbers(xpForNextPoint)..perc, .6,.8,1, 1,1,1)
			end
		end
	end
	GameTooltip:Show()
end

function M:SetupScript(bar)
	bar.eventList = {
		"PLAYER_XP_UPDATE",
		"PLAYER_LEVEL_UP",
		"UPDATE_EXHAUSTION",
		"PLAYER_ENTERING_WORLD",
		"UPDATE_FACTION",
		"ARTIFACT_XP_UPDATE",
		"UNIT_INVENTORY_CHANGED",
		"ENABLE_XP_GAIN",
		"DISABLE_XP_GAIN",
		"AZERITE_ITEM_EXPERIENCE_CHANGED",
		"HONOR_XP_UPDATE",
	}
	for _, event in pairs(bar.eventList) do
		bar:RegisterEvent(event)
	end
	bar:SetScript("OnEvent", M.ExpBar_Update)
	bar:SetScript("OnEnter", M.ExpBar_UpdateTooltip)
	bar:SetScript("OnLeave", B.HideTooltip)
	bar:SetScript("OnMouseUp", function(_, btn)
		if not HasArtifactEquipped() or btn ~= "LeftButton" then return end
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
			SocketInventoryItem(16)
		else
			ToggleFrame(ArtifactFrame)
		end
	end)
	hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", function()
		M.ExpBar_Update(bar)
	end)
end

function M:Expbar()
	if not NDuiDB["Misc"]["ExpRep"] then return end

	local bar = CreateFrame("StatusBar", nil, Minimap)
	bar:SetPoint("TOP", Minimap, "BOTTOM", 0, -5)
	bar:SetSize(Minimap:GetWidth() - 10, 4)
	bar:SetHitRectInsets(0, 0, 0, -10)
	B.CreateSB(bar)

	local rest = CreateFrame("StatusBar", nil, bar)
	rest:SetAllPoints()
	rest:SetStatusBarTexture(DB.normTex)
	rest:SetStatusBarColor(0, .4, 1, .6)
	rest:SetFrameLevel(bar:GetFrameLevel() - 1)
	bar.restBar = rest

	self:SetupScript(bar)
end

function M:HookParagonRep()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]

		if factionIndex <= numFactions then
			local factionID = select(14, GetFactionInfo(factionIndex))
			if factionID and C_Reputation_IsFactionParagon(factionID) then
				local currentValue, threshold = C_Reputation_GetFactionParagonInfo(factionID)
				if currentValue then
					local barValue = mod(currentValue, threshold)
					local factionStandingtext = L["Paragon"]..floor(currentValue/threshold)

					factionBar:SetMinMaxValues(0, threshold)
					factionBar:SetValue(barValue)
					factionStanding:SetText(factionStandingtext)
					factionRow.standingText = factionStandingtext
					factionRow.rolloverText = format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(threshold))
				end
			end
		end
	end
end

function M:ParagonReputationSetup()
	if not NDuiDB["Misc"]["ParagonRep"] then return end
	hooksecurefunc("ReputationFrame_Update", self.HookParagonRep)
end