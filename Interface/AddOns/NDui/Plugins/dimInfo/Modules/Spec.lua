﻿local addon, ns = ...
local cfg = ns.cfg
local init = ns.init

if cfg.Spec == true then
	local Stat = CreateFrame("Frame", nil, UIParent)
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)
	Stat:SetHitRectInsets(0, 0, -10, 0)
	local Text = Stat:CreateFontString(nil, "OVERLAY")
	Text:SetFont(unpack(cfg.Fonts))
	Text:SetPoint(unpack(cfg.SpecPoint))
	Stat:SetAllPoints(Text)

	local function addIcon(texture)
		texture = texture and "|T"..texture..":13:15:0:0:50:50:4:46:4:46|t" or ""
		return texture
	end

	local menuFrame = CreateFrame("Frame", "SpecSwitchMenu", Stat, "UIDropDownMenuTemplate")
	local menuList = {
		{text = CHOOSE_SPECIALIZATION, isTitle = true, notCheckable = true},
		{text = SPECIALIZATION, hasArrow = true, notCheckable = true},
		{text = SELECT_LOOT_SPECIALIZATION, hasArrow = true, notCheckable = true},
	}

	local function UpdateText()
		if GetSpecialization() then
			local _, name, _, icon = GetSpecializationInfo(GetSpecialization())
			if not name then return end
			local specID = GetLootSpecialization()
			if specID == 0 then
				icon = addIcon(icon)
			else
				icon = addIcon(select(4, GetSpecializationInfoByID(specID)))
			end
			Text:SetText(init.Colored..name..icon)
		else
			Text:SetText(SPECIALIZATION..": "..init.Colored..NONE)
		end
	end

	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	Stat:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
	Stat:SetScript("OnEvent", UpdateText)
	Stat:SetScript("OnEnter", function(self)
		if not GetSpecialization() then return end
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 15)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TALENTS_BUTTON, 0,.6,1)
		GameTooltip:AddLine(" ")

		local _, specName, _, specIcon = GetSpecializationInfo(GetSpecialization())
		GameTooltip:AddLine(addIcon(specIcon).." "..specName, 1,1,1)
		local spec = {}
		for t = 1, MAX_TALENT_TIERS do
			for c = 1, 3 do
				local _, name, icon, selected = GetTalentInfo(t, c, 1)
				if selected then
					table.insert(spec, name.." "..addIcon(icon))
				end
			end
		end
		for i = 1, #spec do
			GameTooltip:AddDoubleLine(" ", init.Colored..spec[i])
		end

		if UnitLevel("player") == 110 then
			local _, _, texture = GetCurrencyInfo(104)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(addIcon(texture).." "..PVP_TALENTS, 1,1,1)
			local pvp = {}
			for t = 1, MAX_PVP_TALENT_TIERS do
				for c = 1, 3 do
					local _, name, icon, selected, _, _, unlocked = GetPvpTalentInfo(t, c, 1)
					if selected and unlocked then
						table.insert(pvp, name.." "..addIcon(icon))
					end
				end
			end
			for i = 1, #pvp do
				GameTooltip:AddDoubleLine(" ", init.Colored..pvp[i])
			end
		end

		GameTooltip:AddDoubleLine(" ", "--------------", 1,1,1, .5,.5,.5)
		GameTooltip:AddDoubleLine(" ", init.LeftButton..infoL["SpecPanel"], 1,1,1, .6,.8,1)
		GameTooltip:AddDoubleLine(" ", init.RightButton..infoL["Change Spec"], 1,1,1, .6,.8,1)
		GameTooltip:Show()
	end)
	Stat:SetScript("OnLeave", GameTooltip_Hide)

	local function clickFunc(i, isLoot, isPet)
		if not i then return end
		if isLoot then
			SetLootSpecialization(i)
		else
			SetSpecialization(i, isPet)
		end
		DropDownList1:Hide()
	end

	Stat:SetScript("OnMouseUp", function(self, btn)
		if not GetSpecialization() then return end
		if btn == "LeftButton" then
			ToggleTalentFrame(2)
		else
			menuList[2].menuList = {{}, {}, {}, {}}
			menuList[3].menuList = {{}, {}, {}, {}, {}}
			local specList, lootList = menuList[2].menuList, menuList[3].menuList

			local spec, specName = GetSpecializationInfo(GetSpecialization())
			local lootSpec = GetLootSpecialization()
			lootList[1] = {text = format(LOOT_SPECIALIZATION_DEFAULT, specName), func = function() clickFunc(0, true) end, checked = lootSpec == 0 and true or false}

			for i = 1, 4 do
				local id, name = GetSpecializationInfo(i)
				if id then
					specList[i].text = name
					if id == spec then
						specList[i].func = function() clickFunc() end
						specList[i].checked = true
					else
						specList[i].func = function() clickFunc(i) end
						specList[i].checked = false
					end
					lootList[i+1] = {text = name, func = function() clickFunc(id, true) end, checked = id == lootSpec and true or false}
				else
					specList[i] = nil
					lootList[i+1] = nil
				end
			end

			do
				local _, myclass = UnitClass("player")
				if myclass == "HUNTER" and IsPetActive() then
					menuList[4] = {text = PET..SPECIALIZATION, hasArrow = true, notCheckable = true}
					menuList[4].menuList = {{}, {}, {}}
					local petList = menuList[4].menuList
					local spec = GetSpecializationInfo(GetSpecialization(false, true), false, true)
					for i = 1, 3 do
						local id, name = GetSpecializationInfo(i, false, true)
						petList[i].text = name
						if id == spec then
							petList[i].func = function() clickFunc() end
							petList[i].checked = true
						else
							petList[i].func = function() clickFunc(i, false, true) end
							petList[i].checked = false
						end
					end
				else
					menuList[4] = nil
				end
			end

			EasyMenu(menuList, menuFrame, self, -80, 100, "MENU", 1)
			GameTooltip:Hide()
		end
	end)
end