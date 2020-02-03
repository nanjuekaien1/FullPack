------------------------
-- WidgetXPBar, ElvUI
------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)
local oUF = ns.oUF or oUF

local tonumber, format = tonumber, format
local UnitIsOwnerOrControllerOfUnit = UnitIsOwnerOrControllerOfUnit
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_UIWidgetManager_GetStatusBarWidgetVisualizationInfo = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo

local NPCIDToWidgetIDMap = {
	[154304] = 1940, -- Farseer Ori
	[150202] = 1613, -- Hunter Akana
	[154297] = 1966, -- Bladesman Inowari
	[151300] = 1621, -- Neri Sharpfin
	[151310] = 1622, -- Poen Gillbrack
	[151309] = 1920 -- Vim Brineheart
}

local CampfireNPCIDToWidgetIDMap = {
	[149805] = 1940, -- Farseer Ori
	[149804] = 1613, -- Hunter Akana
	[149803] = 1966, -- Bladesman Inowari
	[149904] = 1621, -- Neri Sharpfin
	[149902] = 1622, -- Poen Gillbrack
	[149906] = 1920 -- Vim Brineheart,
}

local NeededQuestIDs = {
	["Horde"] = 55500,
	["Alliance"] = 56156
}

local VoidtouchedEggQuestID = 58802

local VoidtouchedEggNPCIDToWidgetIDMap = {
	[163541] = 2342, -- Voidtouched Egg
	[163592] = 2342, -- Yu'gaz
	[163593] = 2342, -- Bitey McStabface
	[163595] = 2342, -- Reginald
	[163596] = 2342, -- Picco
}

local function GetWidgetInfoBase(widgetID, overrideProc)
	local widget = widgetID and C_UIWidgetManager_GetStatusBarWidgetVisualizationInfo(widgetID)
	if not widget then return end

	local extra
	if ( overrideProc ) then
		extra =	overrideProc(widget.overrideBarText)
	end

	local cur = widget.barValue - widget.barMin
	local toNext = widget.barMax - widget.barMin
	local total = widget.barValue

	return cur, toNext, total, extra
end

local MaxNazjatarBodyguardRank = 30
local function parseRank(text)
	return tonumber(strmatch(text, "%d+"))
end

local function GetNazjatarBodyguardXP(widgetID)
	local cur, toNext, total, rank = GetWidgetInfoBase(widgetID, parseRank)
	if not rank then return end

	local isMax = rank == MaxNazjatarBodyguardRank

	return rank, cur, toNext, total, isMax
end

local function Update(self)
	local element = self.WidgetXPBar
	if not element then
		return
	end

	local npcID, questID = tonumber(self.npcID), NeededQuestIDs[DB.MyFaction]
	if VoidtouchedEggNPCIDToWidgetIDMap[npcID] then
		questID = VoidtouchedEggQuestID
	end
	local hasQuestCompleted = questID and C_QuestLog_IsQuestFlaggedCompleted(questID)
	local isProperNPC =
		npcID and (NPCIDToWidgetIDMap[npcID] and self.unit and UnitIsOwnerOrControllerOfUnit("player", self.unit)) or
		CampfireNPCIDToWidgetIDMap[npcID] or
		VoidtouchedEggNPCIDToWidgetIDMap[npcID]
	if (not hasQuestCompleted or not isProperNPC) then
		element:Hide()
		if element.Rank then
			element.Rank:Hide()
		end
		if element.ProgressText then
			element.ProgressText:Hide()
		end

		return
	end

	if element.PreUpdate then
		element:PreUpdate()
	end

	local widgetID =
		NPCIDToWidgetIDMap[npcID] or CampfireNPCIDToWidgetIDMap[npcID] or VoidtouchedEggNPCIDToWidgetIDMap[npcID]
	if not widgetID then
		element:Hide()
		if element.Rank then
			element.Rank:Hide()
		end
		if element.ProgressText then
			element.ProgressText:Hide()
		end
		return
	end

	local rank, cur, toNext, total, isMax
	if VoidtouchedEggNPCIDToWidgetIDMap[npcID] then
		cur, toNext, total = GetWidgetInfoBase(widgetID)
	else
		rank, cur, toNext, total, isMax = GetNazjatarBodyguardXP(widgetID)
	end

	element:SetMinMaxValues(0, (isMax and 1) or toNext)
	element:SetValue(isMax and 1 or cur)

	if rank and element.Rank then
		element.Rank:SetText(rank)
		element.Rank:Show()
	end

	if element.ProgressText then
		element.ProgressText:SetText((isMax and L["Max Rank"]) or format("Lv%d %d / %d", rank, cur, toNext))
		element.ProgressText:Show()
	end

	element:Show()

	if element.PostUpdate then
		element:PostUpdate(rank, cur, toNext, total)
	end
end

local function Path(self, ...)
	return (self.WidgetXPBar.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.WidgetXPBar
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UPDATE_UI_WIDGET", Path, true)
		self:RegisterEvent("QUEST_LOG_UPDATE", Path, true)
		return true
	end
end

local function Disable(self)
	local element = self.WidgetXPBar
	if (element) then
		element:Hide()
		if element.Rank then
			element.Rank:Hide()
		end
		if element.ProgressText then
			element.ProgressText:Hide()
		end

		self:UnregisterEvent("UPDATE_UI_WIDGET", Path)
		self:UnregisterEvent("QUEST_LOG_UPDATE", Path)
	end
end

oUF:AddElement("WidgetXPBar", Path, Enable, Disable)