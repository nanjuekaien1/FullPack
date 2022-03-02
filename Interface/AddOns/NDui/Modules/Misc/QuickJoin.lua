local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")
local TT = B:GetModule("Tooltip")

--[[
	QuickJoin 优化系统自带的预创建功能
	1.双击搜索结果，快速申请
	2.自动隐藏部分窗口
	3.美化LFG的相关职业图标
	4.自动邀请申请
	5.显示队长分数，并简写集市钥石
]]
local select, wipe, sort, gsub = select, wipe, sort, gsub
local StaticPopup_Hide, HideUIPanel, GetTime = StaticPopup_Hide, HideUIPanel, GetTime
local UnitIsGroupLeader, UnitClass, UnitGroupRolesAssigned = UnitIsGroupLeader, UnitClass, UnitGroupRolesAssigned
local C_Timer_After, IsAltKeyDown = C_Timer.After, IsAltKeyDown
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local LE_PARTY_CATEGORY_HOME = _G.LE_PARTY_CATEGORY_HOME or 1
local ApplicationViewerFrame = _G.LFGListFrame.ApplicationViewer
local LFG_LIST_GROUP_DATA_ATLASES = _G.LFG_LIST_GROUP_DATA_ATLASES
local scoreFormat = DB.GreyColor.."(%s) |r%s"

function M:HookApplicationClick()
	if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
		LFGListFrame.SearchPanel.SignUpButton:Click()
	end
	if (not IsAltKeyDown()) and LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
		LFGListApplicationDialog.SignUpButton:Click()
	end
end

local pendingFrame
function M:DialogHideInSecond()
	if not pendingFrame then return end

	if pendingFrame.informational then
		StaticPopupSpecial_Hide(pendingFrame)
	elseif pendingFrame == "LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS" then
		StaticPopup_Hide(pendingFrame)
	end
	pendingFrame = nil
end

function M:HookDialogOnShow()
	pendingFrame = self
	C_Timer_After(1, M.DialogHideInSecond)
end

local roleCache = {}
local roleOrder = {
	["TANK"] = 1,
	["HEALER"] = 2,
	["DAMAGER"] = 3,
}
local roleAtlas = {
	[1] = "groupfinder-icon-role-large-tank",
	[2] = "groupfinder-icon-role-large-heal",
	[3] = "groupfinder-icon-role-large-dps",
}

local function sortRoleOrder(a, b)
	if a and b then
		return a[1] < b[1]
	end
end

local function GetPartyMemberInfo(index)
	local unit = "player"
	if index > 1 then unit = "party"..(index-1) end

	local class = select(2, UnitClass(unit))
	if not class then return end
	local role = UnitGroupRolesAssigned(unit)
	if role == "NONE" then role = "DAMAGER" end
	return role, class
end

local function GetCorrectRoleInfo(frame, i)
	if frame.resultID then
		return C_LFGList_GetSearchResultMemberInfo(frame.resultID, i)
	elseif frame == ApplicationViewerFrame then
		return GetPartyMemberInfo(i)
	end
end

local function UpdateGroupRoles(self)
	wipe(roleCache)

	if not self.__owner then
		self.__owner = self:GetParent():GetParent()
	end

	local count = 0
	for i = 1, 5 do
		local role, class = GetCorrectRoleInfo(self.__owner, i)
		local roleIndex = role and roleOrder[role]
		if roleIndex then
			count = count + 1
			if not roleCache[count] then roleCache[count] = {} end
			roleCache[count][1] = roleIndex
			roleCache[count][2] = class
		end
	end

	sort(roleCache, sortRoleOrder)
end

function M:ReplaceGroupRoles(numPlayers, _, disabled)
	UpdateGroupRoles(self)

	for i = 1, 5 do
		local icon = self.Icons[i]
		if not icon.role then
			if i == 1 then
				icon:SetPoint("RIGHT", -5, -2)
			else
				icon:ClearAllPoints()
				icon:SetPoint("RIGHT", self.Icons[i-1], "LEFT", 2, 0)
			end
			icon:SetSize(26, 26)

			icon.role = self:CreateTexture(nil, "OVERLAY")
			icon.role:SetSize(17, 17)
			icon.role:SetPoint("TOPLEFT", icon, -4, 5)
		end

		if i > numPlayers then
			icon.role:Hide()
		else
			icon.role:Show()
			icon.role:SetDesaturated(disabled)
			icon.role:SetAlpha(disabled and .5 or 1)
		end
	end

	local iconIndex = numPlayers
	for i = 1, #roleCache do
		local roleInfo = roleCache[i]
		if roleInfo then
			local icon = self.Icons[iconIndex]
			icon:SetAtlas(LFG_LIST_GROUP_DATA_ATLASES[roleInfo[2]])
			icon.role:SetAtlas(roleAtlas[roleInfo[1]])
			iconIndex = iconIndex - 1
		end
	end

	for i = 1, iconIndex do
		self.Icons[i].role:SetAtlas(nil)
	end
end

function M:QuickJoin_ShowTips()
	local quickJoinInfo = {
		text = L["QuickJoinInfo"],
		buttonStyle = HelpTip.ButtonStyle.GotIt,
		targetPoint = HelpTip.Point.RightEdgeCenter,
		onAcknowledgeCallback = B.HelpInfoAcknowledge,
		callbackArg = "QuickJoin",
	}
	LFGListFrame.SearchPanel.SignUpButton:HookScript("OnShow", function()
		if not NDuiADB["Help"]["QuickJoin"] then
			HelpTip:Show(PVEFrame, quickJoinInfo)
		end
	end)
end

function M:AddAutoAcceptButton()
	local bu = B.CreateCheckBox(ApplicationViewerFrame)
	bu:SetSize(24, 24)
	bu:SetHitRectInsets(0, -130, 0, 0)
	bu:SetPoint("BOTTOMLEFT", ApplicationViewerFrame.InfoBackground, 12, 5)
	B.CreateFS(bu, 14, _G.LFG_LIST_AUTO_ACCEPT, "system", "LEFT", 24, 0)

	local lastTime = 0
	B:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED", function()
		if not bu:GetChecked() then return end
		if not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) then return end

		local buttons = ApplicationViewerFrame.ScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			if button.applicantID and button.InviteButton:IsEnabled() then
				button.InviteButton:Click()
			end
		end

		if ApplicationViewerFrame:IsShown() then
			local now = GetTime()
			if now - lastTime > 1 then
				lastTime = now
				ApplicationViewerFrame.RefreshButton:Click()
			end
		end
	end)

	hooksecurefunc("LFGListApplicationViewer_UpdateInfo", function(self)
		bu:SetShown(UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) and not self.AutoAcceptButton:IsShown())
	end)
end

function M:ShowLeaderOverallScore()
	local resultID = self.resultID
	local searchResultInfo = resultID and C_LFGList_GetSearchResultInfo(resultID)
	if searchResultInfo then
		local activityInfo = C_LFGList_GetActivityInfoTable(searchResultInfo.activityID, nil, searchResultInfo.isWarMode)
		local leaderOverallScore = searchResultInfo.leaderOverallDungeonScore
		if activityInfo and activityInfo.isMythicPlusActivity and leaderOverallScore then
			local oldName = self.ActivityName:GetText() 
			oldName = gsub(oldName, ".-"..HEADER_COLON, "") -- Tazavesh
			self.ActivityName:SetFormattedText(scoreFormat, TT.GetDungeonScore(leaderOverallScore), oldName)
		end
	end
end

function M:QuickJoin()
	for i = 1, 10 do
		local bu = _G["LFGListSearchPanelScrollFrameButton"..i]
		if bu then
			bu.Name:SetFontObject(Game14Font)
			bu.ActivityName:SetFontObject(Game13Font)
			bu:HookScript("OnDoubleClick", M.HookApplicationClick)
		end
	end
	M:QuickJoin_ShowTips()

	hooksecurefunc("LFGListInviteDialog_Accept", function()
		if PVEFrame:IsShown() then HideUIPanel(PVEFrame) end
	end)

	hooksecurefunc("StaticPopup_Show", M.HookDialogOnShow)
	hooksecurefunc("LFGListInviteDialog_Show", M.HookDialogOnShow)

	hooksecurefunc("LFGListGroupDataDisplayEnumerate_Update", M.ReplaceGroupRoles)
	hooksecurefunc("LFGListSearchEntry_Update", M.ShowLeaderOverallScore)

	M:AddAutoAcceptButton()
end
M:RegisterMisc("QuickJoin", M.QuickJoin)