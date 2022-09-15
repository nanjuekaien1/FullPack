local _, ns = ...
local B, C, L, DB = unpack(ns)
local cr, cg, cb = DB.r, DB.g, DB.b

tinsert(C.defaultThemes, function()
	if not DB.isNewPatch then return end
	if not C.db["Skins"]["BlizzardSkins"] then return end

	local frame = SettingsPanel

	B.StripTextures(frame)
	B.SetBD(frame)
	B.ReskinClose(frame.ClosePanelButton)
	B.ReskinEditBox(frame.SearchBox)
	B.Reskin(frame.ApplyButton)
	B.Reskin(frame.CloseButton)

	B.CreateBDFrame(frame.CategoryList, .25):SetInside()
	hooksecurefunc(frame.CategoryList.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				if child.Background then
					child.Background:SetAlpha(0)
					local bg = B.CreateBDFrame(child.Background, .25)
					bg:SetPoint("TOPLEFT", 5, -5)
					bg:SetPoint("BOTTOMRIGHT", -5, 0)
				end
				child.styled = true
			end
		end
	end)

	B.CreateBDFrame(frame.Container, .25):SetInside()
	B.Reskin(frame.Container.SettingsList.Header.DefaultsButton)

	local function ReskinDropDownArrow(button, direction)
		button.NormalTexture:SetAlpha(0)
		button.PushedTexture:SetAlpha(0)
		button:GetHighlightTexture():SetAlpha(0)

		local dis = button:GetDisabledTexture()
		B.SetupArrow(dis, direction)
		dis:SetVertexColor(0, 0, 0, .7)
		dis:SetDrawLayer("OVERLAY")
		dis:SetInside(button, 4, 4)

		local tex = button:CreateTexture(nil, "ARTWORK")
		tex:SetInside(button, 4, 4)
		B.SetupArrow(tex, direction)
		button.__texture = tex
		button:HookScript("OnEnter", B.Texture_OnEnter)
		button:HookScript("OnLeave", B.Texture_OnLeave)
	end

	local function ReskinOptionDropDown(option)
		local button = option.Button
		B.Reskin(button)
		button.__bg:SetInside(button, 6, 6)
		button.NormalTexture:SetAlpha(0)
		button.HighlightTexture:SetAlpha(0)

		ReskinDropDownArrow(option.DecrementButton, "left")
		ReskinDropDownArrow(option.IncrementButton, "right")
	end

	local function UpdateHeaderExpand(self, expanded)
		local atlas = expanded and "Soulbinds_Collection_CategoryHeader_Collapse" or "Soulbinds_Collection_CategoryHeader_Expand"
		self.__texture:SetAtlas(atlas, true)
	end

	local function forceSaturation(self)
		self.CheckBox:DesaturateHierarchy(1)
	end

	hooksecurefunc(frame.Container.SettingsList.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				if child.CheckBox then
					B.ReskinCheck(child.CheckBox)
					child.CheckBox.bg:SetInside(nil, 6, 6)
					hooksecurefunc(child, "DesaturateHierarchy", forceSaturation)
				end
				if child.DropDown then
					ReskinOptionDropDown(child.DropDown)
				end
				if child.ColorBlindFilterDropDown then
					ReskinOptionDropDown(child.ColorBlindFilterDropDown)
				end
				for j = 1, 13 do
					local control = child["Control"..j]
					if control then
						if control.DropDown then
							ReskinOptionDropDown(control.DropDown)
						end
					end
				end
				if child.Button then
					if child.Button:GetWidth() < 250 then
						B.Reskin(child.Button)
					else
						B.StripTextures(child.Button)
						child.Button.Right:SetAlpha(0)
						local bg = B.CreateBDFrame(child.Button, .25)
						bg:SetPoint("TOPLEFT", 2, -1)
						bg:SetPoint("BOTTOMRIGHT", -2, 3)
						local hl = child.Button:CreateTexture(nil, "HIGHLIGHT")
						hl:SetColorTexture(cr, cg, cb, .25)
						hl:SetInside(bg)
						hl:SetBlendMode("ADD")

						child.__texture = bg:CreateTexture(nil, "OVERLAY")
						child.__texture:SetPoint("RIGHT", -10, 0)
						UpdateHeaderExpand(child, false)
						hooksecurefunc(child, "EvaluateVisibility", UpdateHeaderExpand)
					end
				end
				if child.ToggleTest then
					B.Reskin(child.ToggleTest)
					B.StripTextures(child.VUMeter)
					local bg = B.CreateBDFrame(child.VUMeter, .3)
					bg:SetInside(nil, 4, 4)
					child.VUMeter.Status:SetStatusBarTexture(DB.bdTex)
					child.VUMeter.Status:SetInside(bg)
				end
				if child.PushToTalkKeybindButton then
					B.Reskin(child.PushToTalkKeybindButton)
				end

				child.styled = true
			end
		end
	end)

	hooksecurefunc(KeyBindingFrameBindingTemplateMixin, "Init", function(self)
		if self.styled then return end

		B.Reskin(self.Button1)
		B.Reskin(self.Button2)
		self.styled = true
	end)

	local CUFPanels = {
		"CompactUnitFrameProfiles",
		"CompactUnitFrameProfilesGeneralOptionsFrame",
	}
	for _, name in pairs(CUFPanels) do
		local frame = _G[name]
		if frame then
			for i = 1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child:IsObjectType("CheckButton") then
					B.ReskinCheck(child)
				elseif child:IsObjectType("Button") then
					B.Reskin(child)
				elseif child:IsObjectType("Frame") and child.Left and child.Middle and child.Right then
					B.ReskinDropDown(child)
				end
			end
		end
	end
	if CompactUnitFrameProfilesSeparator then
		CompactUnitFrameProfilesSeparator:SetAtlas("Options_HorizontalDivider")
	end
	if CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG then
		CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()
		B.CreateBDFrame(CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG, .25)
	end
end)