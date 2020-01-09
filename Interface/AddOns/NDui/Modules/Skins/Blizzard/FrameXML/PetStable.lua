local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.themes["AuroraClassic"], function()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	local class = select(2, UnitClass("player"))
	if class ~= "HUNTER" then return end

	PetStableBottomInset:Hide()
	PetStableLeftInset:Hide()
	PetStableModelShadow:Hide()
	PetStableModelRotateLeftButton:Hide()
	PetStableModelRotateRightButton:Hide()
	PetStableFrameModelBg:Hide()
	PetStablePrevPageButtonIcon:SetTexture("")
	PetStableNextPageButtonIcon:SetTexture("")

	B.ReskinPortraitFrame(PetStableFrame)
	B.ReskinArrow(PetStablePrevPageButton, "left")
	B.ReskinArrow(PetStableNextPageButton, "right")
	B.ReskinIcon(PetStableSelectedPetIcon)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		local bu = _G["PetStableActivePet"..i]
		bu.Background:Hide()
		bu.Border:Hide()
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu.Checked:SetTexture(DB.textures.checked)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		B.CreateBDFrame(bu, .25)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		local bu = _G["PetStableStabledPet"..i]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu.Checked:SetTexture(DB.textures.checked)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:DisableDrawLayer("BACKGROUND")

		_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		B.CreateBDFrame(bu, .25)
	end
end)