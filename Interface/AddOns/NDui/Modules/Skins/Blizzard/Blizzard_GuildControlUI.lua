local _, ns = ...
local B, C, L, DB = unpack(ns)

C.themes["Blizzard_GuildControlUI"] = function()
	local r, g, b = DB.r, DB.g, DB.b

	B.CreateBD(GuildControlUI)
	B.CreateSD(GuildControlUI)

	for i = 1, 9 do
		select(i, GuildControlUI:GetRegions()):Hide()
	end

	for i = 1, 8 do
		select(i, GuildControlUIRankBankFrameInset:GetRegions()):Hide()
	end

	GuildControlUIRankSettingsFrameOfficerBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
	GuildControlUITopBg:Hide()
	GuildControlUIHbar:Hide()
	GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
	GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

	do
		local function updateGuildRanks()
			for i = 1, GuildControlGetNumRanks() do
				local rank = _G["GuildControlUIRankOrderFrameRank"..i]
				if not rank.styled then
					rank.upButton.icon:Hide()
					rank.downButton.icon:Hide()
					rank.deleteButton.icon:Hide()

					B.ReskinArrow(rank.upButton, "up")
					B.ReskinArrow(rank.downButton, "down")
					B.ReskinClose(rank.deleteButton)

					B.ReskinInput(rank.nameBox, 20)

					rank.styled = true
				end
			end
		end

		local f = CreateFrame("Frame")
		f:RegisterEvent("GUILD_RANKS_UPDATE")
		f:SetScript("OnEvent", updateGuildRanks)
		hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)
	end

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs() + 1 do
			local tab = "GuildControlBankTab"..i
			local bu = _G[tab]
			if bu and not bu.styled then
				local ownedTab = bu.owned

				_G[tab.."Bg"]:Hide()
				B.ReskinIcon(ownedTab.tabIcon)
				B.CreateBD(bu, .25)
				B.Reskin(bu.buy.button)
				B.ReskinInput(ownedTab.editBox)

				for _, ch in pairs({ownedTab.viewCB, ownedTab.depositCB, ownedTab.infoCB}) do
					-- can't get a backdrop frame to appear behind the checked texture for some reason
					ch:SetNormalTexture("")
					ch:SetPushedTexture("")
					ch:SetHighlightTexture(DB.bdTex)

					local hl = ch:GetHighlightTexture()
					hl:SetPoint("TOPLEFT", 5, -5)
					hl:SetPoint("BOTTOMRIGHT", -5, 5)
					hl:SetVertexColor(r, g, b, .2)

					local check = ch:GetCheckedTexture()
					check:SetDesaturated(true)
					check:SetVertexColor(r, g, b)

					local tex = B.CreateGradient(ch)
					tex:SetPoint("TOPLEFT", 5, -5)
					tex:SetPoint("BOTTOMRIGHT", -5, 5)

					local bg = B.CreateBDFrame(ch, 1)
					bg:SetOutside(tex)
				end

				bu.styled = true
			end
		end
	end)

	B.ReskinCheck(GuildControlUIRankSettingsFrameOfficerCheckbox)
	for i = 1, 20 do
		local checbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if checbox then
			B.ReskinCheck(checbox)
		end
	end

	B.Reskin(GuildControlUIRankOrderFrameNewButton)
	B.ReskinClose(GuildControlUICloseButton)
	B.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	B.ReskinDropDown(GuildControlUINavigationDropDown)
	B.ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
	B.ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
	B.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
end