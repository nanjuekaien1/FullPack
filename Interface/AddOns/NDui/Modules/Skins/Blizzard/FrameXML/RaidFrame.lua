local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.themes["AuroraClassic"], function()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	B.StripTextures(RaidInfoFrame)
	B.CreateBD(RaidInfoFrame)
	B.CreateSD(RaidInfoFrame)
	B.ReskinCheck(RaidFrameAllAssistCheckButton)
	B.StripTextures(RaidInfoFrame.Header)

	RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
	RaidInfoDetailFooter:Hide()
	RaidInfoDetailHeader:Hide()
	RaidInfoDetailCorner:Hide()

	B.Reskin(RaidFrameRaidInfoButton)
	B.Reskin(RaidFrameConvertToRaidButton)
	B.Reskin(RaidInfoExtendButton)
	B.Reskin(RaidInfoCancelButton)
	B.ReskinClose(RaidInfoCloseButton)
	B.ReskinScroll(RaidInfoScrollFrameScrollBar)
	B.ReskinClose(RaidParentFrameCloseButton)

	B.ReskinPortraitFrame(RaidParentFrame)
	RaidInfoInstanceLabel:DisableDrawLayer("BACKGROUND")
	RaidInfoIDLabel:DisableDrawLayer("BACKGROUND")
end)