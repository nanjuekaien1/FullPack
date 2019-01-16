local F, C = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	-- Talent Frame
	local OrderHallTalentFrame = OrderHallTalentFrame

	F.ReskinPortraitFrame(OrderHallTalentFrame)
	OrderHallTalentFrame.Background:SetAlpha(0)
	F.Reskin(OrderHallTalentFrame.BackButton)
	F.ReskinIcon(OrderHallTalentFrame.Currency.Icon)
	OrderHallTalentFrame.OverlayElements:SetAlpha(0)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function()
		local closeButton = OrderHallTalentFrameCloseButton
		closeButton:ClearAllPoints()
		closeButton:SetPoint("TOPRIGHT", OrderHallTalentFrame)
		if closeButton.Border then closeButton.Border:SetAlpha(0) end
		OrderHallTalentFrame.CurrencyBG:SetAlpha(0)

		for i = 15, OrderHallTalentFrame:GetNumRegions() do
			select(i, OrderHallTalentFrame:GetRegions()):SetAlpha(0)
		end

		for i = 1, OrderHallTalentFrame:GetNumChildren() do
			local bu = select(i, OrderHallTalentFrame:GetChildren())
			if bu and bu.talent then
				bu.Border:SetAlpha(0)
				if not bu.bg then
					bu.Icon:SetTexCoord(.08, .92, .08, .92)
					bu.Highlight:SetColorTexture(1, 1, 1, .25)
					bu.bg = F.CreateBDFrame(bu.Icon)
				end

				if bu.talent.selected then
					bu.bg:SetBackdropBorderColor(1, 1, 0)
				else
					bu.bg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
end