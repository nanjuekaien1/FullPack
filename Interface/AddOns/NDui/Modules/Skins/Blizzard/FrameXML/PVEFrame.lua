local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	local r, g, b = DB.r, DB.g, DB.b

	PVEFrameLeftInset:SetAlpha(0)
	PVEFrameBlueBg:SetAlpha(0)
	PVEFrame.shadows:SetAlpha(0)

	PVEFrameTab2:SetPoint("LEFT", PVEFrameTab1, "RIGHT", -15, 0)
	PVEFrameTab3:SetPoint("LEFT", PVEFrameTab2, "RIGHT", -15, 0)

	GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
	GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
	GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\inv_helmet_06")

	local iconSize = 60-2*C.mult
	for i = 1, 4 do
		local bu = GroupFinderFrame["groupButton"..i]

		bu.ring:Hide()
		B.Reskin(bu, true)
		bu.bg:SetTexture(DB.bdTex)
		bu.bg:SetVertexColor(r, g, b, .2)
		bu.bg:SetAllPoints(bu.bgTex)

		bu.icon:SetPoint("LEFT", bu, "LEFT")
		bu.icon:SetSize(iconSize, iconSize)
		B.ReskinIcon(bu.icon)
	end

	hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
		local self = GroupFinderFrame
		for i = 1, 4 do
			local button = self["groupButton"..i]
			if i == index then
				button.bg:Show()
			else
				button.bg:Hide()
			end
		end
	end)

	B.ReskinPortraitFrame(PVEFrame)
	B.ReskinTab(PVEFrameTab1)
	B.ReskinTab(PVEFrameTab2)
	B.ReskinTab(PVEFrameTab3)
	B.ReskinClose(PremadeGroupsPvETutorialAlert.CloseButton)
end)