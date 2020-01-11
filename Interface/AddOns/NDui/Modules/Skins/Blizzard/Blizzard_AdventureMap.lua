local _, ns = ...
local B, C, L, DB = unpack(ns)

C.themes["Blizzard_AdventureMap"] = function()
	local dialog = AdventureMapQuestChoiceDialog

	B.StripTextures(dialog)
	B.CreateBD(dialog)
	B.CreateSD(dialog)
	B.Reskin(dialog.AcceptButton)
	B.Reskin(dialog.DeclineButton)
	B.ReskinClose(dialog.CloseButton)
	B.ReskinScroll(dialog.Details.ScrollBar)

	dialog:HookScript("OnShow", function(self)
		if self.styled then return end

		for i = 6, 7 do
			local bu = select(i, dialog:GetChildren())
			if bu then
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				B.CreateBDFrame(bu.Icon)
				local bg = B.CreateBDFrame(bu.Icon, .25)
				bg:SetPoint("BOTTOMRIGHT")
				bu.ItemNameBG:Hide()
			end
		end
		dialog.Details.Child.TitleHeader:SetTextColor(1, .8, 0)
		dialog.Details.Child.ObjectivesHeader:SetTextColor(1, .8, 0)

		self.styled = true
	end)
end