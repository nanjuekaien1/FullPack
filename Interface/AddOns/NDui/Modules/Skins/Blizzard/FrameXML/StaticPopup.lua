local _, ns = ...
local B, C, L, DB = unpack(ns)
local r, g, b = DB.r, DB.g, DB.b

local function colorMinimize(f)
	if f:IsEnabled() then
		f.minimize:SetVertexColor(r, g, b)
	end
end

local function clearMinimize(f)
	f.minimize:SetVertexColor(1, 1, 1)
end

tinsert(C.defaultThemes, function()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	for i = 1, 4 do
		local frame = _G["StaticPopup"..i]
		local bu = _G["StaticPopup"..i.."ItemFrame"]
		local icon = _G["StaticPopup"..i.."ItemFrameIconTexture"]
		local close = _G["StaticPopup"..i.."CloseButton"]

		local gold = _G["StaticPopup"..i.."MoneyInputFrameGold"]
		local silver = _G["StaticPopup"..i.."MoneyInputFrameSilver"]
		local copper = _G["StaticPopup"..i.."MoneyInputFrameCopper"]

		_G["StaticPopup"..i.."ItemFrameNameFrame"]:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")
		bu:SetPushedTexture("")
		bu.bg = B.ReskinIcon(icon)
		B.ReskinIconBorder(bu.IconBorder)

		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		copper:SetPoint("LEFT", silver, "RIGHT", 1, 0)

		frame.Border:Hide()
		B.SetBD(frame)
		for j = 1, 4 do
			B.Reskin(frame["button"..j])
		end
		B.Reskin(frame.extraButton)
		B.ReskinClose(close)

		close.minimize = close:CreateTexture(nil, "OVERLAY")
		close.minimize:SetSize(9, C.mult)
		close.minimize:SetPoint("CENTER")
		close.minimize:SetTexture(DB.bdTex)
		close.minimize:SetVertexColor(1, 1, 1)
		close:HookScript("OnEnter", colorMinimize)
		close:HookScript("OnLeave", clearMinimize)

		B.ReskinInput(_G["StaticPopup"..i.."EditBox"], 20)
		B.ReskinInput(gold)
		B.ReskinInput(silver)
		B.ReskinInput(copper)
	end

	hooksecurefunc("StaticPopup_Show", function(which, _, _, data)
		local info = StaticPopupDialogs[which]

		if not info then return end

		local dialog = nil
		dialog = StaticPopup_FindVisible(which, data)

		if not dialog then
			local index = 1
			if info.preferredIndex then
				index = info.preferredIndex
			end
			for i = index, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if not frame:IsShown() then
					dialog = frame
					break
				end
			end

			if not dialog and info.preferredIndex then
				for i = 1, info.preferredIndex do
					local frame = _G["StaticPopup"..i]
					if not frame:IsShown() then
						dialog = frame
						break
					end
				end
			end
		end

		if not dialog then return end

		if info.closeButton then
			local closeButton = _G[dialog:GetName().."CloseButton"]

			closeButton:SetNormalTexture("")
			closeButton:SetPushedTexture("")

			if info.closeButtonIsHide then
				closeButton.__texture:Hide()
				closeButton.minimize:Show()
			else
				closeButton.__texture:Show()
				closeButton.minimize:Hide()
			end
		end
	end)

	-- Pet battle queue popup

	B.SetBD(PetBattleQueueReadyFrame)
	B.CreateBDFrame(PetBattleQueueReadyFrame.Art)
	PetBattleQueueReadyFrame.Border:Hide()
	B.Reskin(PetBattleQueueReadyFrame.AcceptButton)
	B.Reskin(PetBattleQueueReadyFrame.DeclineButton)

	-- PlayerReportFrame
	PlayerReportFrame:HookScript("OnShow", function(self)
		if not self.styled then
			B.StripTextures(self)
			B.SetBD(self)
			B.StripTextures(self.Comment)
			B.ReskinInput(self.Comment)
			B.Reskin(self.ReportButton)
			B.Reskin(self.CancelButton)

			self.styled = true
		end
	end)
end)