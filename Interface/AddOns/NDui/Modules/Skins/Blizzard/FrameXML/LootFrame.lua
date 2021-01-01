local _, ns = ...
local B, C, L, DB = unpack(ns)

local function HideIconBG(anim)
	anim.__owner.IconHitBox.bg:SetAlpha(0)
end

local function ShowIconBG(anim)
	anim.__owner.IconHitBox.bg:SetAlpha(1)
end

tinsert(C.defaultThemes, function()
	if not C.db["Skins"]["BlizzardSkins"] then return end
	if not C.db["Skins"]["Loot"] then return end

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		local ic = _G["LootButton"..index.."IconTexture"]
		if not ic then return end

		if not ic.bg then
			local bu = _G["LootButton"..index]

			_G["LootButton"..index.."IconQuestTexture"]:SetAlpha(0)
			_G["LootButton"..index.."NameFrame"]:Hide()

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			bu.IconBorder:SetAlpha(0)

			local bd = B.CreateBDFrame(bu, .25)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT", 114, 0)

			ic.bg = B.ReskinIcon(ic)
		end

		if select(7, GetLootSlotInfo(index)) then
			ic.bg:SetBackdropBorderColor(1, 1, 0)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	LootFrameDownButton:ClearAllPoints()
	LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
	LootFramePrev:ClearAllPoints()
	LootFramePrev:SetPoint("LEFT", LootFrameUpButton, "RIGHT", 4, 0)
	LootFrameNext:ClearAllPoints()
	LootFrameNext:SetPoint("RIGHT", LootFrameDownButton, "LEFT", -4, 0)

	B.ReskinPortraitFrame(LootFrame)
	B.ReskinArrow(LootFrameUpButton, "up")
	B.ReskinArrow(LootFrameDownButton, "down")
	LootFramePortraitOverlay:Hide()

	-- Bonus roll
	BonusRollFrame.Background:SetAlpha(0)
	BonusRollFrame.IconBorder:Hide()
	BonusRollFrame.BlackBackgroundHoist.Background:Hide()
	BonusRollFrame.SpecRing:SetAlpha(0)
	B.SetBD(BonusRollFrame)

	local specIcon = BonusRollFrame.SpecIcon
	specIcon:ClearAllPoints()
	specIcon:SetPoint("TOPRIGHT", -90, -18)
	local bg = B.ReskinIcon(specIcon)
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		bg:SetShown(specIcon:IsShown())
	end)

	local promptFrame = BonusRollFrame.PromptFrame
	B.ReskinIcon(promptFrame.Icon)
	promptFrame.Timer.Bar:SetTexture(DB.normTex)
	B.CreateBDFrame(promptFrame.Timer, .25)

	local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
	BONUS_ROLL_COST = BONUS_ROLL_COST:gsub(from, to)
	BONUS_ROLL_CURRENT_COUNT = BONUS_ROLL_CURRENT_COUNT:gsub(from, to)

	-- Loot Roll Frame
	hooksecurefunc("GroupLootFrame_OpenNewFrame", function()
		for i = 1, NUM_GROUP_LOOT_FRAMES do
			local frame = _G["GroupLootFrame"..i]
			if not frame.styled then
				frame.Border:SetAlpha(0)
				frame.Background:SetAlpha(0)
				frame.bg = B.SetBD(frame)

				frame.Timer.Bar:SetTexture(DB.bdTex)
				frame.Timer.Bar:SetVertexColor(1, .8, 0)
				frame.Timer.Background:SetAlpha(0)
				B.CreateBDFrame(frame.Timer, .25)

				frame.IconFrame.Border:SetAlpha(0)
				B.ReskinIcon(frame.IconFrame.Icon)

				local bg = B.CreateBDFrame(frame, .25)
				bg:SetPoint("TOPLEFT", frame.IconFrame.Icon, "TOPRIGHT", 0, 1)
				bg:SetPoint("BOTTOMRIGHT", frame.IconFrame.Icon, "BOTTOMRIGHT", 150, -1)

				frame.styled = true
			end

			if frame:IsShown() then
				local _, _, _, quality = GetLootRollItemInfo(frame.rollID)
				local color = DB.QualityColors[quality]
				frame.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end)

	-- Bossbanner
	hooksecurefunc("BossBanner_ConfigureLootFrame", function(lootFrame)
		if not lootFrame.bg then
			local iconHitBox = lootFrame.IconHitBox
			iconHitBox.bg = B.ReskinIcon(lootFrame.Icon)
			iconHitBox.bg:SetAlpha(0)
			iconHitBox.IconBorder:SetTexture(nil)
			B.ReskinIconBorder(iconHitBox.IconBorder, true)

			lootFrame.Anim.__owner = lootFrame
			lootFrame.Anim:HookScript("OnPlay", HideIconBG)
			lootFrame.Anim:HookScript("OnFinished", ShowIconBG)
		end
	end)
end)