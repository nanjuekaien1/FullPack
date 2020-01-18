local _, ns = ...
local B, C, L, DB = unpack(ns)

C.themes["Blizzard_LookingForGuildUI"] = function()
	local r, g, b = DB.r, DB.g, DB.b

	local styled
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then return end

		B.ReskinPortraitFrame(LookingForGuildFrame)
		B.CreateBD(LookingForGuildInterestFrame, .25)
		LookingForGuildInterestFrameBg:Hide()
		B.CreateBD(LookingForGuildAvailabilityFrame, .25)
		LookingForGuildAvailabilityFrameBg:Hide()
		B.CreateBD(LookingForGuildRolesFrame, .25)
		LookingForGuildRolesFrameBg:Hide()
		B.CreateBD(LookingForGuildCommentFrame, .25)
		LookingForGuildCommentFrameBg:Hide()
		B.CreateBD(LookingForGuildCommentInputFrame, .12)
		B.SetBD(GuildFinderRequestMembershipFrame)
		for i = 1, 9 do
			select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
		end
		for i = 1, 3 do
			for j = 1, 6 do
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
				select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = B.Dummy
			end
		end
		for i = 1, 6 do
			select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
		end
		LookingForGuildFrameTabardBackground:Hide()
		LookingForGuildFrameTabardEmblem:Hide()
		LookingForGuildFrameTabardBorder:Hide()

		B.Reskin(LookingForGuildBrowseButton)
		B.Reskin(GuildFinderRequestMembershipFrameAcceptButton)
		B.Reskin(GuildFinderRequestMembershipFrameCancelButton)
		B.ReskinCheck(LookingForGuildQuestButton)
		B.ReskinCheck(LookingForGuildDungeonButton)
		B.ReskinCheck(LookingForGuildRaidButton)
		B.ReskinCheck(LookingForGuildPvPButton)
		B.ReskinCheck(LookingForGuildRPButton)
		B.ReskinCheck(LookingForGuildWeekdaysButton)
		B.ReskinCheck(LookingForGuildWeekendsButton)
		B.ReskinInput(GuildFinderRequestMembershipFrameInputFrame)

		-- [[ Browse frame ]]

		B.Reskin(LookingForGuildRequestButton)
		B.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

		for i = 1, 5 do
			local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]

			bu:SetBackdrop(nil)
			bu:SetHighlightTexture("")

			-- my client crashes if I put this in a var? :x
			bu:GetRegions():SetTexture(DB.bdTex)
			bu:GetRegions():SetVertexColor(r, g, b, .2)
			bu:GetRegions():SetInside()

			local bg = B.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
		end

		-- [[ Role buttons ]]
		B.ReskinRole(LookingForGuildTankButton, "TANK")
		B.ReskinRole(LookingForGuildHealerButton, "HEALER")
		B.ReskinRole(LookingForGuildDamagerButton, "DPS")

		styled = true
	end)
end