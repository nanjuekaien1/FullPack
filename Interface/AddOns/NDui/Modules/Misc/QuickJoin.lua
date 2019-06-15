local _, ns = ...
local B, C, L, DB = unpack(ns)
local M = B:GetModule("Misc")

--[[
	QuickJoin 优化系统自带的预创建功能
	1.修复简中语系的一个报错
	2.中键点击世界任务搜索可用任务
	3.双击搜索结果，快速申请
	4.自动隐藏部分窗口
]]

function M:HookTrackerOnBlockClick(button)
	if self.M.ShowWorldQuests then
		if button == "MiddleButton" then
			LFGListUtil_FindQuestGroup(self.TrackedQuest.questID)
		end
	end
end

function M:HookApplicationClick()
	if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
		LFGListFrame.SearchPanel.SignUpButton:Click()
	end
	if LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
		LFGListApplicationDialog.SignUpButton:Click()
	end
end

local pendingFrame
function M:HookDialogOnShow()
	pendingFrame = self
	C_Timer.After(1, M.DialogHideInSecond)
end

function M:DialogHideInSecond()
	if not pendingFrame then return end

	if pendingFrame.informational then
		StaticPopupSpecial_Hide(pendingFrame)
	elseif pendingFrame == "LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS" then
		StaticPopup_Hide(pendingFrame)
	end
end

function M:QuickJoin()
	if DB.Client == "zhCN" then
		StaticPopupDialogs["LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS"] = {
			text = "针对此项活动，你的队伍人数已满，将被移出列表。",
			button1 = OKAY,
			timeout = 0,
			whileDead = 1,
		}
	end

	hooksecurefunc("BonusObjectiveTracker_OnBlockClick", self.HookTrackerOnBlockClick)

	for i = 1, 10 do
		local bu = _G["LFGListSearchPanelScrollFrameButton"..i]
		if bu then
			bu:HookScript("OnDoubleClick", M.HookApplicationClick)
		end
	end

	hooksecurefunc("LFGListInviteDialog_Accept", function()
		if PVEFrame:IsShown() then ToggleFrame(PVEFrame) end
	end)

	hooksecurefunc("StaticPopup_Show", self.HookDialogOnShow)
	hooksecurefunc("LFGListInviteDialog_Show", self.HookDialogOnShow)
end